import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';

/// A Moniepoint-style staggered, per-character vertical rolling number animation.
///
/// Features:
/// - Static non-digits (currency symbol '₦', commas ',', decimal points '.').
/// - Staggered vertical reel/speed-dial scrolling for every numeric digit.
/// - Each digit column rolls through a sequence of numbers with custom easing
///   and locks into place sequentially from left to right.
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.forward(from: 0.0);
        }
      });
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
        widget.style ?? Theme.of(context).textTheme.headlineMedium;
    final formatted = Formatters.naira(
      widget.isLoaded ? widget.amount : 0,
      showDecimals: widget.showDecimals,
    );

    // Calculate dimensions of digit and non-digit characters
    final textScaler = MediaQuery.textScalerOf(context);
    final digitPainter = TextPainter(
      text: TextSpan(text: '8', style: effectiveStyle),
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
            // Non-digit character (symbol, comma, decimal point)
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
          return _RollingDigitColumn(
            key: ValueKey('rolling_digit_${currentDigitIdx}_$targetDigit'),
            targetDigit: targetDigit,
            digitIndex: currentDigitIdx,
            totalDigits: totalDigits,
            digitHeight: digitHeight,
            digitWidth: digitWidth,
            style: effectiveStyle,
            animation: _controller,
            curve: widget.curve,
          );
        }).toList(),
      ),
    );
  }
}

class _RollingDigitColumn extends StatelessWidget {
  final int targetDigit;
  final int digitIndex;
  final int totalDigits;
  final double digitHeight;
  final double digitWidth;
  final TextStyle? style;
  final Animation<double> animation;
  final Curve curve;

  final List<String> digitSequence;
  final int targetIndex;
  final double start;
  final double end;

  _RollingDigitColumn({
    super.key,
    required this.targetDigit,
    required this.digitIndex,
    required this.totalDigits,
    required this.digitHeight,
    required this.digitWidth,
    required this.style,
    required this.animation,
    required this.curve,
  })  : digitSequence = _buildSequence(targetDigit, digitIndex, totalDigits),
        targetIndex = _calculateTargetIndex(targetDigit, digitIndex, totalDigits),
        start = _calculateStart(digitIndex, totalDigits),
        end = _calculateEnd(digitIndex, totalDigits);

  static int _calculateCycles(int digitIndex, int totalDigits) {
    if (totalDigits <= 1) return 2;
    // Progressive cycles: leftmost digits spin at least 2 full cycles (20+ numbers),
    // deeper digits spin up to 5 full cycles (50+ numbers) for high-speed reel feel.
    final progressive = (digitIndex / (totalDigits - 1) * 3).round();
    return 2 + progressive;
  }

  static List<String> _buildSequence(
    int targetDigit,
    int digitIndex,
    int totalDigits,
  ) {
    final cycles = _calculateCycles(digitIndex, totalDigits);
    final sequence = <String>[];
    for (int c = 0; c < cycles; c++) {
      for (int d = 0; d <= 9; d++) {
        sequence.add('$d');
      }
    }
    for (int d = 0; d <= targetDigit; d++) {
      sequence.add('$d');
    }
    // Safety buffer digits after target to prevent clipping or empty space
    for (int d = 0; d <= 9; d++) {
      sequence.add('$d');
    }
    return sequence;
  }

  static int _calculateTargetIndex(
    int targetDigit,
    int digitIndex,
    int totalDigits,
  ) {
    final cycles = _calculateCycles(digitIndex, totalDigits);
    return (cycles * 10) + targetDigit;
  }

  static double _calculateStart(int digitIndex, int totalDigits) {
    if (totalDigits <= 1) return 0.0;
    // Micro-staggered start: all columns begin rolling within the first 8% of animation
    return (digitIndex * 0.02).clamp(0.0, 0.08);
  }

  static double _calculateEnd(int digitIndex, int totalDigits) {
    if (totalDigits <= 1) return 1.0;
    // Staggered finish: left digits lock first (around 58% ~ 1.4s), right digits lock sequentially
    final ratio = digitIndex / (totalDigits - 1);
    return (0.58 + 0.42 * ratio).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final rawProgress = (animation.value - start) / (end - start);
        final clampedProgress = rawProgress.clamp(0.0, 1.0);
        final curvedProgress = curve.transform(clampedProgress);
        final currentOffset = -curvedProgress * targetIndex * digitHeight;

        return ClipRect(
          child: SizedBox(
            width: digitWidth,
            height: digitHeight,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  top: currentOffset,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: digitSequence.map((digitChar) {
                      return SizedBox(
                        width: digitWidth,
                        height: digitHeight,
                        child: Center(
                          child: Text(
                            digitChar,
                            style: style,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
