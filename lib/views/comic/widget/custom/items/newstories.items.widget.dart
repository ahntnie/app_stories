import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/constants/colors/app_theme.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:flutter/material.dart';

class NewStoriesItems extends StatelessWidget {
  const NewStoriesItems({super.key, required this.data, required this.onTap});
  final Story data;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Image.network(
                data.coverImage!.first,
                // height: 300,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              data.title!,
              style: AppTheme.titleSmall16,
            ),
          ],
        ),
      ),
    );
  }
}
