import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/utils/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:app_stories/constants/app_color.dart';

class SearchTextField extends StatefulWidget {
  final TextEditingController searchController;
  final VoidCallback onChanged;

  const SearchTextField({
    super.key,
    required this.searchController,
    required this.onChanged,
  });

  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.blueberry80, AppColors.watermelon80],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: widget.searchController,
        style: TextStyle(color: context.primaryTextColor),
        cursorColor: context.primaryTextColor,
        onChanged: (value) {
          Future.delayed(const Duration(milliseconds: 500), () {
            widget.onChanged();
          });
        },
        decoration: InputDecoration(
          hintText: 'Tìm kiếm...',
          hintStyle: TextStyle(
            color: context.primaryTextColor,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          prefixIcon: Icon(
            Icons.search,
            color: context.primaryTextColor,
          ),
          suffixIcon: widget.searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: context.primaryTextColor,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.searchController.clear();
                    });
                    widget.onChanged();
                  },
                )
              : null,
        ),
      ),
    );
  }
}
