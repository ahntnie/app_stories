import 'package:app_stories/constants/app_color.dart';
import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const TextFieldCustom(
      {super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColor.changeNameColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        // contentPadding:
        //     EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColor.extraColor),
      ),
      style: const TextStyle(color: AppColor.extraColor),
    );
  }
}
