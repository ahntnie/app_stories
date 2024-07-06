import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/chapter_model.dart';
import 'package:app_stories/models/comment_model.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/styles/app_img.dart';
import 'package:app_stories/view_model/comic.vm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class TotalCommentCard extends StatefulWidget {
  TotalCommentCard({super.key, required this.comment});
  Comment comment;
  @override
  State<TotalCommentCard> createState() => __TotalCommentCardStateState();
}

String formatDateTime(String isoString) {
  if (isoString == null) return '';
  DateTime dateTime = DateTime.parse(isoString);
  return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
}

class __TotalCommentCardStateState extends State<TotalCommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: AppColor.inwellColor,
            borderRadius: BorderRadius.circular(10)),
        child: Flexible(
          child: Column(
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
                child: Text(
                  widget.comment.content,
                  style: TextStyle(
                    color: AppColor.extraColor,
                    fontSize: AppFontSize.sizeSmall,
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: widget.comment.chapterNumber != null
                      ? Text(
                          'Chapter ${widget.comment.chapterNumber}',
                          style: TextStyle(
                            color: AppColor.extraColor,
                            fontSize: AppFontSize.sizeSmall,
                            fontWeight: FontWeight.w300,
                          ),
                        )
                      : const Text('')),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  formatDateTime(widget.comment.createdAt.toIso8601String()),
                  style: TextStyle(
                    color: AppColor.extraColor,
                    fontSize: AppFontSize.sizeSmall,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ));
  }
}
