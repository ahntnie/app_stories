import 'package:flutter/material.dart';

import '../../../widget/custom_button.dart';

class UploadButton extends StatelessWidget {
  const UploadButton({super.key, required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: CustomButton(
        title: const SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tải lên',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Icon(
                Icons.file_upload_outlined,
                color: Colors.white,
                size: 30,
              )
            ],
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
