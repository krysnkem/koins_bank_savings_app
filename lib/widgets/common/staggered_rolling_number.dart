import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';

/// Type alias for developers referring to the staggered dial animation.
typedef StaggeredDialNumber = StaggeredRollingNumber;

/// A Moniepoint-style staggered, per-character vertical dial scrolling animation.
///
/// Each numeric character is rendered in an independent vertical dial reel
/// that scrolls through a sequence of digits and decelerates smoothly into its
/// target value. Non-numeric characters (currency symbol '₦', commas ',', decimals '.')
/// remain static.
///
/// Features:
/// - Independent per-character vertical scroll reel ([_DialReel]).
/// - Uniform tabular digit sizing so columns maintain steady width during spin.
/// - Native Flutter [Interval] and [CurvedAnimation] cascading from left to right.
/// - GPU-accelerated [Transform.translate] layer (zero re-layout during roll).
/// - Full accessibility semantics for screen readers.
class StaggeredRollingNumber extends StatefulWidget {
  final num amount;
  final bool isLoaded;
  final bool showDecimals;
  final TextStyle? style;
  final Duration duration;
  final Curve curve;

  const StaggeredRollingNumber({
    super.key,
    required this.amount,
    this.isLoaded = true,
    this.showDecimals = false,
    this.style,
    this.duration = const Duration(milliseconds: 2400),
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<StaggeredRollingNumber> createState() => _StaggeredRollingNumberState();
}

class _StaggeredRollingNumberState extends State<StaggeredRollingNumber>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final AnimationController _controller;
  num? _lastAnimatedAmount;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    if (widget.isLoaded) {
      _lastAnimatedAmount = widget.amount;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void didUpdateWidget(StaggeredRollingNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.isLoaded) {
      if (!oldWidget.isLoaded || widget.amount != _lastAnimatedAmount) {
        _lastAnimatedAmount = widget.amount;
        _controller.forward(from: 0.0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final effectiveStyle =
        widget.style ?? Theme.of(context).textTheme.headlineMedium ?? const TextStyle(fontSize: 28);

    final formatted = Formatters.naira(
      widget.isLoaded ? widget.amount : 0,
      showDecimals: widget.showDecimals,
    );

    // Compute uniform digit dimensions using '8' for tabular consistency
    final textScaler = MediaQuery.textScalerOf(context);
    final digitPainter = TextPainter(
      text: TextSpan(
        text: '8',
        style: effectiveStyle,
      ),
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
    )..layout();

    final digitHeight = digitPainter.height;
    final digitWidth = digitPainter.width;

    // Parse characters and count total digits
    final characters = formatted.split('');
    final totalDigits =
        characters.where((c) => int.tryParse(c) != null).length;

    int digitIndex = 0;

    return Semantics(
      label: formatted,
      value: formatted,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: characters.map((char) {
          final targetDigit = int.tryParse(char);
          if (targetDigit == null) {
            // Static non-digit character (symbol, comma, decimal point)
            return SizedBox(
              height: digitHeight,
              child: Center(
                child: Text(
                  char,
                  style: effectiveStyle,
                ),
              ),
            );
          }

          final currentDigitIdx = digitIndex++;
          return _DialReel(
            key: ValueKey('dial_reel_${currentDigitIdx}_$targetDigit'),
            targetDigit: targetDigit,
            digitIndex: currentDigitIdx,
            totalDigits: totalDigits,
            digitHeight: digitHeight,
            digitWidth: digitWidth,
            style: effectiveStyle,
            controller: _controller,
            curve: widget.curve,
          );
        }).toList(),
      ),
    );
  }
}

/// An individual vertical dial reel for a single digit column.
///
/// Spins vertically through multiple revolutions of digits 0-9 and decelerates
/// into its [targetDigit] along a staggered [Interval] driven by [controller].
class _DialReel extends StatefulWidget {
  final int targetDigit;
  final int digitIndex;
  final int totalDigits;
  final double digitHeight;
  final double digitWidth;
  final TextStyle style;
  final AnimationController controller;
  final Curve curve;

  const _DialReel({
    super.key,
    required this.targetDigit,
    required this.digitIndex,
    required this.totalDigits,
    required this.digitHeight,
    required this.digitWidth,
    required this.style,
    required this.controller,
    required this.curve,
  });

  @override
  State<_DialReel> createState() => _DialReelState();
}

class _DialReelState extends State<_DialReel> {
  late List<String> _digitSequence;
  late int _targetIndex;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initReel();
  }

  @override
  void didUpdateWidget(_DialReel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetDigit != oldWidget.targetDigit ||
        widget.digitIndex != oldWidget.digitIndex ||
        widget.totalDigits != oldWidget.totalDigits ||
        widget.controller != oldWidget.controller ||
        widget.curve != oldWidget.curve) {
      _initReel();
    }
  }

  void _initReel() {
    // 1. Calculate progressive spin cycles for this column
    final cycles = _calculateCycles(
      widget.digitIndex,
      widget.totalDigits,
    );

    // 2. Build continuous vertical number sequence: [0..9] x cycles + [0..targetDigit] + buffer
    final sequence = <String>[];
    for (int c = 0; c < cycles; c++) {
      for (int d = 0; d <= 9; d++) {
        sequence.add('$d');
      }
    }
    for (int d = 0; d <= widget.targetDigit; d++) {
      sequence.add('$d');
    }
    _targetIndex = (cycles * 10) + widget.targetDigit;

    // Safety buffer digits below target to prevent any clipping during deceleration
    for (int d = 0; d <= 9; d++) {
      sequence.add('$d');
    }
    _digitSequence = sequence;

    // 3. Staggered Interval: Leftmost reels lock first, cascading to rightmost
    final start = _calculateStart(
      widget.digitIndex,
      widget.totalDigits,
    );
    final end = _calculateEnd(
      widget.digitIndex,
      widget.totalDigits,
    );

    _animation = CurvedAnimation(
      parent: widget.controller,
      curve: Interval(
        start,
        end,
        curve: widget.curve,
      ),
    );
  }

  static int _calculateCycles(int digitIndex, int totalDigits) {
    if (totalDigits <= 1) return 2;
    // Progressive cycles: leftmost digits spin 2 full cycles (20+ digits),
    // deeper digits spin up to 5 full cycles (50+ digits) for physical speed-dial feel.
    final progressive = (digitIndex / (totalDigits - 1) * 3).round();
    return 2 + progressive;
  }

  static double _calculateStart(int digitIndex, int totalDigits) {
    if (totalDigits <= 1) return 0.0;
    // Micro-staggered start: all columns begin rolling within the first 8% of animation
    return (digitIndex * 0.02).clamp(0.0, 0.08);
  }

  static double _calculateEnd(int digitIndex, int totalDigits) {
    if (totalDigits <= 1) return 1.0;
    // Staggered finish: leftmost digit locks at ~58% (~1.4s), rightmost locks at 100% (2.4s)
    final ratio = digitIndex / (totalDigits - 1);
    return (0.58 + 0.42 * ratio).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        width: widget.digitWidth,
        height: widget.digitHeight,
        child: OverflowBox(
          alignment: Alignment.topCenter,
          maxHeight: double.infinity,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final offset =
                  -_animation.value * _targetIndex * widget.digitHeight;
              return Transform.translate(
                offset: Offset(0, offset),
                child: child,
              );
            },
            // Cache the Column so Flutter does not reconstruct or re-layout
            // the Text widgets on every animation tick!
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _digitSequence.map((digit) {
                return SizedBox(
                  width: widget.digitWidth,
                  height: widget.digitHeight,
                  child: Center(
                    child: Text(
                      digit,
                      style: widget.style,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
