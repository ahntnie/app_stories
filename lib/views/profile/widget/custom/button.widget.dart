import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  String nameButton;
  final Color color;
  CustomButton({super.key, required this.nameButton, required this.onPressed,required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(
        nameButton,
        style: TextStyle(
            fontSize: AppFontSize.sizeSmall, color: AppColor.extraColor),
        textAlign: TextAlign.center,
      ),
    );
  }
}
