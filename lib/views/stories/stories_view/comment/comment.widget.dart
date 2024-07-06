import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/comment_model.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/styles/app_img.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentWidget extends StatefulWidget {
  Comment comment;
  Story story;
  CommentWidget({super.key, required this.comment, required this.story});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

String formatDateTime(String isoString) {
  if (isoString == null) return '';
  DateTime dateTime = DateTime.parse(isoString);
  return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColor.inwellColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                      Img.imgAVT // Thay thế bằng URL ảnh avatar thực tế
                      ),
                  radius: 20,
                ),
              ),
              Text(
                widget.comment.username,
                style: TextStyle(
                  color: AppColor.extraColor,
                  fontSize: AppFontSize.sizeMedium,
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 40.0,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  widget.comment.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: AppColor.extraColor,
                      fontSize: AppFontSize.sizeSmall,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.comment.chapterNumber != null
                  ? [
                      Text(
                        'Chapter ${widget.comment.chapterNumber}',
                        style: TextStyle(
                          color: AppColor.extraColor,
                          fontSize: AppFontSize.sizeSmall,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        formatDateTime(
                            widget.comment.createdAt.toIso8601String()),
                        style: TextStyle(
                          color: AppColor.extraColor,
                          fontSize: AppFontSize.sizeSmall,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ]
                  : [
                      Text(
                        '',
                        style: TextStyle(
                          color: AppColor.extraColor,
                          fontSize: AppFontSize.sizeSmall,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        formatDateTime(
                            widget.comment.createdAt.toIso8601String()),
                        style: TextStyle(
                          color: AppColor.extraColor,
                          fontSize: AppFontSize.sizeSmall,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 10),
          //   child: Text(
          //     formatDateTime(widget.comment.createdAt.toIso8601String()),
          //     style: TextStyle(
          //       color: AppColor.extraColor,
          //       fontSize: AppFontSize.sizeSmall,
          //       fontWeight: FontWeight.w300,
          //     ),
          //   ),
          // ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
