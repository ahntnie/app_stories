import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class GradientLoadingWidget extends StatefulWidget {
  final double size;
  const GradientLoadingWidget({super.key, this.size = 50.0});

  @override
  _GradientLoadingWidgetState createState() => _GradientLoadingWidgetState();
}

class _GradientLoadingWidgetState extends State<GradientLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(); // Lặp vô hạn
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * math.pi, // Xoay theo vòng tròn
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [
                    AppColors.blueberry100,
                    AppColors.watermelon60,
                    Colors.purpleAccent,
                    AppColors.rambutan90,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: const CircularProgressIndicator(
                strokeWidth: 6,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
