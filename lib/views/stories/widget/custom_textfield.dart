import 'package:app_stories/constants/colors/app_theme.dart';
import 'package:app_stories/utils/build_context_extension.dart';
import 'package:app_stories/views/stories/widget/custom_paint.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final int maxLines;
  final bool enabled;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.maxLines = 5,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: UnderlinePainter(
            lines: maxLines,
            color: context.primaryTextColor,
          ),
          child: TextField(
            enabled: enabled,
            maxLines: maxLines,
            cursorColor: context.primaryTextColor,
            controller: controller,
            style:
                AppTheme.titleSmall16.copyWith(color: context.primaryTextColor),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
