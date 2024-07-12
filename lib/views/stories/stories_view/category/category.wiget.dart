import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/category_model.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatefulWidget {
  CategoryWidget({super.key, required this.category, required this.story});
  Category category;
  Story story;
  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 10,
      padding: EdgeInsets.all(2.0), // Khoảng cách từ chữ đến viền container
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.inwellColor),
          borderRadius: BorderRadius.circular(5)),
      child: Text(
        widget.category.name!,
        style: TextStyle(
            color: AppColor.extraColor, fontSize: AppFontSize.sizeSmall),
      ),
    );
  }
}
