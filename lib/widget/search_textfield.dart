import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController seatchController;
  VoidCallback onChanged;
  SearchTextField({
    super.key,
    required this.seatchController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF252044),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) {
          Future.delayed(const Duration(seconds: 1), () {
            onChanged();
          });
        },
        controller: seatchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Tìm kiếm',
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
