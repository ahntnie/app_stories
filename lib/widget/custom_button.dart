import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';

import '../constants/app_color.dart';

class CustomButton extends StatefulWidget {
  final Widget title;
  final VoidCallback onPressed;
  final bool isLoading;
  bool enable;
  Color? color;
  double? width;
  double? height;
  CustomButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.isLoading = false,
      this.color,
      this.enable = true,
      this.height,
      this.width});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.enable ? widget.onPressed : null,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            color: widget.color ?? AppColors.watermelon100,
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: widget.isLoading ? const GradientLoadingWidget() : widget.title,
      ),
    );
  }
}
