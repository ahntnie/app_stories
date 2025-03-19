import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/constants/colors/app_theme.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/utils/build_context_extension.dart';
import 'package:app_stories/widget/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionHeader extends StatelessWidget {
  SectionHeader({super.key, required this.title, required this.onPressed});
  String title;
  VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTheme.titleMedium18,
          ),
          TextButton(
            onPressed: onPressed,
            child: Text('Xem thêm',
                style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: context.primaryTextColor)),
          ),
        ],
      ),
    );
  }
}
