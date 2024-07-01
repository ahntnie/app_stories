import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomMenuAccount extends StatelessWidget {
  final String text;
  final String text1;
  final VoidCallback onTap;

  const CustomMenuAccount({
    super.key,
    required this.text,
    required this.text1,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.buttonColor, // Màu nền của nút
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        onPressed: onTap,
        child: Row(
          children: [
            Text(
              text,
              style: TextStyle(
                color: AppColor.extraColor,
                fontSize: AppFontSize.sizeSmall,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text1,
                style: TextStyle(
                  color: AppColor.extraColor,
                  fontSize: AppFontSize.sizeSmall,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppColor.extraColor),
          ],
        ),
      ),
    );
  }
}
