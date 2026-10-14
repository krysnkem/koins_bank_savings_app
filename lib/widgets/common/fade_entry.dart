import 'dart:async';
import 'package:flutter/material.dart';

/// A reusable opacity animation widget for smooth entry and data-load transitions.
///
/// Features:
/// - Smooth opacity fade on mount / entry so data doesn't suddenly show up.
/// - Optional staggered delay for sequential elements.
/// - Dynamic load-state handling via [isVisible] / [isLoaded].
/// - Optional subtle micro-translation offset.
/// - Zero rebuild overhead during animation via [AnimatedBuilder].
class FadeEntry extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final bool isVisible;
  final Offset? slideOffset;

  const FadeEntry({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
    this.delay = Duration.zero,
    this.curve = Curves.easeOut,
    this.isVisible = true,
    this.slideOffset,
  });

  /// Staggered entry factory based on an item index (e.g. in a list or column).
  factory FadeEntry.staggered({
    Key? key,
    required int index,
    required Widget child,
    Duration step = const Duration(milliseconds: 50),
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.easeOut,
    Offset? slideOffset,
  }) {
    return FadeEntry(
      key: key,
      delay: step * index.clamp(0, 10),
      duration: duration,
      curve: curve,
      slideOffset: slideOffset,
      child: child,
    );
  }

  /// Entry factory controlled by an asynchronous loading state.
  factory FadeEntry.loaded({
    Key? key,
    required bool isLoaded,
    required Widget child,
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.easeOut,
    Offset? slideOffset,
  }) {
    return FadeEntry(
      key: key,
      isVisible: isLoaded,
      duration: duration,
      curve: curve,
      slideOffset: slideOffset,
      child: child,
    );
  }

  @override
  State<FadeEntry> createState() => _FadeEntryState();
}

class _FadeEntryState extends State<FadeEntry>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _opacity;
  Animation<Offset>? _slide;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _initAnimations();

    if (widget.isVisible) {
      if (widget.delay == Duration.zero) {
        _controller.forward();
      } else {
        _delayTimer = Timer(widget.delay, () {
          if (mounted && widget.isVisible) {
            _controller.forward();
          }
        });
      }
    }
  }

  void _initAnimations() {
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
    if (widget.slideOffset != null) {
      _slide = Tween<Offset>(
        begin: widget.slideOffset!,
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: widget.curve,
        ),
      );
    } else {
      _slide = null;
    }
  }

  @override
  void didUpdateWidget(FadeEntry oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.curve != oldWidget.curve ||
        widget.slideOffset != oldWidget.slideOffset) {
      _initAnimations();
    }
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        Widget current = Opacity(
          opacity: _opacity.value.clamp(0.0, 1.0),
          child: child,
        );
        if (_slide != null) {
          current = FractionalTranslation(
            translation: _slide!.value,
            child: current,
          );
        }
        return current;
      },
      child: widget.child,
    );
  }
}
