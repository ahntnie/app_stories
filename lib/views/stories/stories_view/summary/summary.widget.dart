import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/constants/colors/app_theme.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  String text;
  ExpandableText(this.text);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.text,
          style: AppTheme.titleSmall16,
          maxLines: isExpanded ? null : 2,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Text(
                isExpanded ? 'Thu gọn' : 'Xem thêm',
                style: TextStyle(color: AppColor.inwellColor),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
