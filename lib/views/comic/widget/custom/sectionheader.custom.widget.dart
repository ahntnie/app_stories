import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  SectionHeader({super.key, required this.title});
  String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: AppFontSize.sizeMedium,
                fontWeight: AppFontWeight.bold,
                color: AppColor.extraColor),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Xem thêm',
                style: TextStyle(
                    color: AppColor.inwellColor,
                    fontSize: AppFontSize.sizeSmall)),
          ),
        ],
      ),
    );
  }
}
