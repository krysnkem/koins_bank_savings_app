import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/latency_constants.dart';
import '../models/auth_user.dart';

abstract class AuthLocalDataSource {
  Future<void> saveSession(AuthUser user);

  Future<AuthUser?> getSession();

  Future<void> clearSession();

  Future<bool> isLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({SharedPreferences? prefs, Duration? latency})
      : _prefs = prefs,
        _latency = latency;

  final SharedPreferences? _prefs;
  final Duration? _latency;

  Duration get _effectiveLatency => _latency ?? LatencyConstants.disk;

  Future<void> _simulateDiskLatency() async {
    final d = _effectiveLatency;
    if (d > Duration.zero) {
      await Future.delayed(d);
    }
  }

  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPhone = 'user_phone';

  Future<SharedPreferences> _getPrefs() async =>
      _prefs ?? await SharedPreferences.getInstance();

  @override
  Future<void> saveSession(AuthUser user) async {
    await _simulateDiskLatency();
    final prefs = await _getPrefs();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserName, user.fullName);
    await prefs.setString(_keyUserEmail, user.email);
    await prefs.setString(_keyUserPhone, user.phone);
  }

  @override
  Future<AuthUser?> getSession() async {
    await _simulateDiskLatency();
    final prefs = await _getPrefs();
    final loggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    if (!loggedIn) return null;

    final name = prefs.getString(_keyUserName);
    final email = prefs.getString(_keyUserEmail);
    final phone = prefs.getString(_keyUserPhone);

    if (name == null || email == null) return null;

    return AuthUser(
      fullName: name,
      email: email,
      phone: phone ?? '',
    );
  }

  @override
  Future<void> clearSession() async {
    await _simulateDiskLatency();
    final prefs = await _getPrefs();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserPhone);
  }

  @override
  Future<bool> isLoggedIn() async {
    await _simulateDiskLatency();
    final prefs = await _getPrefs();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }
}
