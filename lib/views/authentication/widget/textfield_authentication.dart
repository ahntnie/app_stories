import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/constants/colors/app_theme.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final String errorText;
  final Function(String) onChanged;
  final Function()? onSuffixIconTap;
  final bool hasSuffixIcon;

  CustomTextField({
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    required this.errorText,
    required this.onChanged,
    this.onSuffixIconTap,
    this.hasSuffixIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(labelText,
              style: AppTheme.titleLarge20.copyWith(color: AppColors.mono0)),
        ),
        const SizedBox(height: 8.0),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.mono40),
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
          ),
          child: TextField(
            controller: controller,
            style: AppTheme.titleSmall16.copyWith(color: AppColors.mono0),
            obscureText: obscureText,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintStyle:
                  AppTheme.titleSmall16.copyWith(color: AppColors.mono40),
              hintText: hintText,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              errorText: errorText.isNotEmpty ? errorText : null,
              suffixIcon: hasSuffixIcon
                  ? GestureDetector(
                      onTap: onSuffixIconTap,
                      child: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.mono100,
                      ),
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
