import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart' as sqflite;

import 'app_exception.dart';

/// Centralized error handler and user-friendly message formatter.
///
/// Ensures all exceptions—originating from network, database, disk,
/// formatters, or third-party packages—are cleanly mapped to polished,
/// human-readable messages without leaking raw system error codes or stack traces.
class ErrorHandler {
  const ErrorHandler._();

  /// Default user-friendly messages for different domains
  static const String defaultNetworkMessage =
      'Unable to connect to the internet. Please check your network connection and try again.';
  static const String defaultTimeoutMessage =
      'Connection timed out. Please check your internet connection and try again.';
  static const String defaultDatabaseMessage =
      'Unable to read or update local financial records. Please try again or restart the app.';
  static const String defaultDiskMessage =
      'Unable to access device storage. Please check available space and try again.';
  static const String defaultServerMessage =
      'The service is temporarily unavailable. Please try again shortly.';
  static const String defaultFormatMessage =
      'We encountered an unexpected data format. Please try again.';
  static const String defaultUnexpectedMessage =
      'An unexpected error occurred. Please try again.';

  /// Translates any error or exception into a clean, human-readable user message.
  static String getUserMessage(dynamic error) {
    if (error == null) return defaultUnexpectedMessage;

    // 1. Direct Network exceptions
    if (error is SocketException || error is http.ClientException) {
      return defaultNetworkMessage;
    }
    if (error is TimeoutException) {
      return defaultTimeoutMessage;
    }

    // 2. Database exceptions from SQLite / sqflite
    if (error is sqflite.DatabaseException || error is AppDatabaseException) {
      return defaultDatabaseMessage;
    }

    // 3. Disk / FileSystem / Storage exceptions
    if (error is FileSystemException || error is CacheException) {
      return defaultDiskMessage;
    }

    // 4. Format / parsing exceptions
    if (error is FormatException || error is TypeError) {
      return defaultFormatMessage;
    }

    // 5. Auth / Validation with clean messages
    if (error is AuthException) {
      return error.message.isNotEmpty
          ? error.message
          : 'Authentication failed. Please verify your credentials.';
    }

    if (error is ValidationException) {
      return error.message.isNotEmpty
          ? error.message
          : 'Please check your input and try again.';
    }

    // 6. Generic AppException inspection
    if (error is AppException) {
      final msg = error.message;
      if (_hasTechnicalKeywords(msg)) {
        return _sanitizeTechnicalString(msg);
      }
      return msg.isNotEmpty ? msg : defaultUnexpectedMessage;
    }

    // 7. Inspect string representation for raw technical traces
    final raw = error.toString();
    return _sanitizeTechnicalString(raw);
  }

  /// Maps any raw exception to a typed [AppException] with a sanitized message.
  static AppException toAppException(dynamic error) {
    if (error is AppException) {
      if (_hasTechnicalKeywords(error.message)) {
        final sanitized = _sanitizeTechnicalString(error.message);
        if (error is NetworkException) return NetworkException(sanitized);
        if (error is ServerException) return ServerException(sanitized);
        if (error is AppDatabaseException) return AppDatabaseException(sanitized);
        if (error is CacheException) return CacheException(sanitized);
        return ServerException(sanitized);
      }
      return error;
    }

    final raw = error.toString().toLowerCase();

    // Check for network errors
    if (error is SocketException ||
        error is http.ClientException ||
        error is TimeoutException ||
        raw.contains('socketexception') ||
        raw.contains('failed host lookup') ||
        raw.contains('no address associated') ||
        raw.contains('connection refused') ||
        raw.contains('connection timed out') ||
        raw.contains('network is unreachable') ||
        raw.contains('handshakeexception') ||
        raw.contains('errno = 7') ||
        raw.contains('clientexception')) {
      if (error is TimeoutException || raw.contains('timed out')) {
        return const NetworkException(defaultTimeoutMessage);
      }
      return const NetworkException(defaultNetworkMessage);
    }

    // Check for database errors
    if (error is sqflite.DatabaseException ||
        raw.contains('databaseexception') ||
        raw.contains('no such table') ||
        raw.contains('sqlite') ||
        raw.contains('disk i/o error') ||
        raw.contains('database is locked')) {
      return const AppDatabaseException(defaultDatabaseMessage);
    }

    // Check for disk/cache errors
    if (error is FileSystemException ||
        raw.contains('filesystemexception') ||
        raw.contains('no space left') ||
        raw.contains('disk full')) {
      return const CacheException(defaultDiskMessage);
    }

    // Check for format/JSON errors
    if (error is FormatException ||
        error is TypeError ||
        raw.contains('formatexception')) {
      return const ServerException(defaultFormatMessage);
    }

    return const ServerException(defaultServerMessage);
  }

  static bool _hasTechnicalKeywords(String text) {
    final lower = text.toLowerCase();
    return lower.contains('socketexception') ||
        lower.contains('clientexception') ||
        lower.contains('failed host lookup') ||
        lower.contains('no address associated') ||
        lower.contains('errno =') ||
        lower.contains('os error') ||
        lower.contains('sqlite') ||
        lower.contains('databaseexception') ||
        lower.contains('exception:') ||
        lower.contains('http://') ||
        lower.contains('https://') ||
        lower.contains('unhandled') ||
        lower.contains('stacktrace');
  }

  static String _sanitizeTechnicalString(String text) {
    final lower = text.toLowerCase();

    if (lower.contains('socketexception') ||
        lower.contains('clientexception') ||
        lower.contains('failed host lookup') ||
        lower.contains('no address associated') ||
        lower.contains('errno = 7') ||
        lower.contains('network is unreachable') ||
        lower.contains('connection refused')) {
      return defaultNetworkMessage;
    }

    if (lower.contains('timed out') || lower.contains('timeout')) {
      return defaultTimeoutMessage;
    }

    if (lower.contains('databaseexception') ||
        lower.contains('no such table') ||
        lower.contains('sqlite') ||
        lower.contains('disk i/o error')) {
      return defaultDatabaseMessage;
    }

    if (lower.contains('filesystemexception') ||
        lower.contains('no space left') ||
        lower.contains('disk full')) {
      return defaultDiskMessage;
    }

    if (lower.contains('formatexception') || lower.contains('typeerror')) {
      return defaultFormatMessage;
    }

    if (lower.contains('500') || lower.contains('502') || lower.contains('503')) {
      return defaultServerMessage;
    }

    // Clean up generic Exception prefix if text is otherwise normal
    final cleaned =
        text.replaceFirst(RegExp(r'^(App)?Exception:\s*'), '').trim();
    if (cleaned.isNotEmpty && !_hasTechnicalKeywords(cleaned)) {
      return cleaned;
    }

    return defaultUnexpectedMessage;
  }
}
