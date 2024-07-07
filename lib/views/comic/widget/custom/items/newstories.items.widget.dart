import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/view_model/browse_stories.vm.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.network(
              data.coverImage!.first,
              width: 100,
              height: 150,
            ),
            const SizedBox(height: 8),
            Text(data.title!,
                style: TextStyle(
                    fontWeight: AppFontWeight.bold,
                    fontSize: AppFontSize.sizeSmall,
                    color: AppColor.extraColor)),
          ],
        ),
      ),
    );
  }
}
