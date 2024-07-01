import 'package:flutter/material.dart';

import '../constants/app_color.dart';

class CustomButton extends StatefulWidget {
  final Widget title;
  final VoidCallback onPressed;
  final bool isLoading;
  const CustomButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.isLoading = false});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: AppColor.buttonColor,
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child:
            widget.isLoading ? const CircularProgressIndicator() : widget.title,
      ),
    );
  }
}
