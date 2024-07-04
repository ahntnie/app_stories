import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/chapter_model.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:flutter/material.dart';

class ChapterWidget extends StatelessWidget {
  Chapter chapter;
  final VoidCallback onTap;
  ChapterWidget({super.key, required this.chapter, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColor.diaglogColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Image.network(
              chapter.images.first,
              width: 80,
              // height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 10),
            Text(
              'Chapter ${chapter.chapterNumber}',
              style: TextStyle(
                  fontSize: AppFontSize.sizeSmall,
                  fontWeight: AppFontWeight.bold,
                  color: AppColor.extraColor),
            ),
          ],
        ),
      ),
    );
  }
}
