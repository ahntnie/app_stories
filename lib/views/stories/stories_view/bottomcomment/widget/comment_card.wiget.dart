import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/comment_model.dart';
import 'package:app_stories/models/notification_model.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/styles/app_img.dart';
import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/view_model/notification.vm.dart';
import 'package:app_stories/widget/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import '../../../../../app/app_sp.dart';
import '../../../../../app/app_sp_key.dart';
import '../../../../authentication/login.page.dart';

class TotalCommentCard extends StatefulWidget {
  TotalCommentCard(
      {super.key,
      required this.comment,
      required this.currentUserID,
      this.isTotalComment = true,
      required this.comicViewModel});
  Comment comment;
  String currentUserID;
  ComicViewModel comicViewModel;
  bool isTotalComment;
  @override
  State<TotalCommentCard> createState() => _TotalCommentCardState();
}

String formatDateTime(String isoString) {
  if (isoString == null) return '';
  DateTime dateTime = DateTime.parse(isoString);
  return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
}

class _TotalCommentCardState extends State<TotalCommentCard> {
  bool showFullContent = false;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        disposeViewModel: false,
        viewModelBuilder: () => widget.comicViewModel,
        onViewModelReady: (viewModel) {
          viewModel.viewContext = context;
        },
        builder: (context, comicViewModel, child) {
          print('${widget.currentUserID} / ${widget.comment.userId}');
          return GestureDetector(
            onTap: widget.isTotalComment
                ? () {
                    setState(() {
                      showFullContent = !showFullContent;
                    });
                  }
                : null,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: MediaQuery.of(context).size.width / 1.5,
              decoration: BoxDecoration(
                color: AppColor.inwellColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                            Img.imgAVT, // Thay thế bằng URL ảnh avatar thực tế
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
                      ),
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
                      maxLines: showFullContent ? null : 2,
                      overflow: showFullContent ? null : TextOverflow.ellipsis,
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
                        : const Text(''),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatDateTime(
                              widget.comment.createdAt.toIso8601String()),
                          style: TextStyle(
                            color: AppColor.extraColor,
                            fontSize: AppFontSize.sizeSmall,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        if (widget.comment.userId != widget.currentUserID &&
                            comicViewModel.currentUsers?.role != 'admin')
                          PopupMenuButton<int>(
                              icon: Icon(
                                Icons.report,
                                size: 30,
                                color: AppColor.selectColor,
                              ),
                              onSelected: (item) {
                                if (AppSP.get(AppSPKey.currrentUser) != null &&
                                    AppSP.get(AppSPKey.currrentUser) != '') {
                                  NotificationViewModel notiViewModel =
                                      NotificationViewModel();
                                  notiViewModel.currentChapter =
                                      comicViewModel.currentChapter;
                                  notiViewModel.viewContext = context;
                                  notiViewModel.currentStory =
                                      comicViewModel.currentStory;
                                  notiViewModel.comment = widget.comment;
                                  notiViewModel.postNotificationByAdmin();
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return PopUpWidget(
                                          icon: Image.asset(
                                              "assets/ic_success.png"),
                                          title: 'Đã gửi báo cáo',
                                          leftText: 'Xác nhận',
                                          onLeftTap: () {
                                            Navigator.pop(context);
                                          },
                                        );
                                      });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return PopUpWidget(
                                          icon: Image.asset(
                                              "assets/ic_error.png"),
                                          title:
                                              'Bạn cần đăng nhập để báo cáo bình luận',
                                          leftText: 'Đăng nhập',
                                          onLeftTap: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginPage(),
                                                ));
                                          },
                                          twoButton: true,
                                          onRightTap: () {
                                            Navigator.pop(context);
                                          },
                                          rightText: 'Hủy',
                                        );
                                      });
                                }
                              },
                              itemBuilder: (context) => [
                                    PopupMenuItem<int>(
                                        value: 0, child: Text('Báo cáo')),
                                  ])
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
