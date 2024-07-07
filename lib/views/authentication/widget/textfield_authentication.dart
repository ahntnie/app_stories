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
          child: Text(
            labelText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            onChanged: onChanged,
            decoration: InputDecoration(
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
                        color: Colors.black,
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
