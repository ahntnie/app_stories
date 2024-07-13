import 'package:app_stories/app/app_sp.dart';
import 'package:app_stories/app/app_sp_key.dart';
import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/chapter_model.dart';
import 'package:app_stories/models/comment_model.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/styles/app_img.dart';
import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/view_model/notification.vm.dart';
import 'package:app_stories/widget/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class CommentWidget extends StatefulWidget {
  Comment comment;
  Story story;
  Chapter? chapter;
  String currentUserID;
  CommentWidget({
    super.key,
    required this.comment,
    required this.story,
    required this.currentUserID,
    required this.chapter,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

String formatDateTime(String isoString) {
  if (isoString == null) return '';
  DateTime dateTime = DateTime.parse(isoString).add(const Duration(hours: 7));
  return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        disposeViewModel: false,
        viewModelBuilder: () => NotificationViewModel(),
        onViewModelReady: (viewModel) {
          viewModel.viewContext = context;
          viewModel.currentChapter = widget.chapter;
          viewModel.currentStory = widget.story;
          viewModel.comment = widget.comment;
        },
        builder: (context, viewModel, child) {
          return Container(
            width: 320,
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
                        backgroundImage: AssetImage(Img.imgAVT),
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
                    constraints: const BoxConstraints(
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatDateTime(widget.comment.createdAt
                                      .toIso8601String()),
                                  style: TextStyle(
                                    color: AppColor.extraColor,
                                    fontSize: AppFontSize.sizeSmall,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                (widget.comment.userId !=
                                            widget.currentUserID &&
                                        viewModel.currentUser.role != 'admin')
                                    ? PopupMenuButton<int>(
                                        icon: Icon(
                                          Icons.report,
                                          size: 30,
                                          color: AppColor.selectColor,
                                        ),
                                        onSelected: (item) => {
                                            //  viewModel.postNotification(),
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return PopUpWidget(
                                                      icon: Image.asset(
                                                          "assets/ic_success.png"),
                                                      title:
                                                          'Báo cáo bình luận thành công',
                                                      leftText: 'Xác nhận',
                                                      onLeftTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                    );
                                                  })
                                            },
                                        itemBuilder: (context) => [
                                              PopupMenuItem<int>(
                                                  value: 0,
                                                  child: Text('Báo cáo')),
                                            ])
                                    : PopupMenuButton<int>(
                                        icon: Icon(
                                          Icons.delete,
                                          size: 30,
                                          color: AppColor.selectColor,
                                        ),
                                        onSelected: (item) => {
                                              //viewModel.postNotification(),
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return PopUpWidget(
                                                      icon: Image.asset(
                                                          "assets/ic_success.png"),
                                                      title:
                                                          'Xóa bình luận thành công',
                                                      leftText: 'Xác nhận',
                                                      onLeftTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                    );
                                                  })
                                            },
                                        itemBuilder: (context) => [
                                              PopupMenuItem<int>(
                                                  value: 0,
                                                  child: Text('Báo cáo')),
                                            ]),
                              ],
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
                            if (widget.comment.userId != widget.currentUserID)
                              PopupMenuButton<int>(
                                  icon: Icon(
                                    Icons.report,
                                    size: 30,
                                    color: AppColor.selectColor,
                                  ),
                                  onSelected: (item) => {
                                        // viewModel.comment = widget.comment,
                                        print(widget.comment.content),
                                        // viewModel.postNotification(),
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return PopUpWidget(
                                                icon: Image.asset(
                                                    "assets/ic_success.png"),
                                                title:
                                                    'Báo cáo bình luận thành công',
                                                leftText: 'Xác nhận',
                                                onLeftTap: () {
                                                  Navigator.pop(context);
                                                },
                                              );
                                            })
                                      },
                                  itemBuilder: (context) => [
                                        PopupMenuItem<int>(
                                            value: 0, child: Text('Báo cáo')),
                                      ]),
                          ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          );
        });
  }
}
