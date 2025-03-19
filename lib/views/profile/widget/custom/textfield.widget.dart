import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/constants/colors/app_theme.dart';
import 'package:app_stories/utils/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:app_stories/constants/app_color.dart';

class TextFieldCustom extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final IconData? prefixIcon;

  const TextFieldCustom({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.prefixIcon,
  });

  @override
  _TextFieldCustomState createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      decoration: InputDecoration(
        filled: true,
        fillColor: context.primaryBackgroundColor, // Màu nền input
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Bo góc mượt hơn
          borderSide: BorderSide(color: context.primaryTextColor),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        hintText: widget.hintText,
        hintStyle: AppTheme.titleSmall16,
      ),
      style: TextStyle(color: context.primaryTextColor, fontSize: 14),
    );
  }
}
