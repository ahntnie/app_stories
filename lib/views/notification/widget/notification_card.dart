import 'package:app_stories/models/comment_model.dart';
import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/view_model/notification.vm.dart';
import 'package:app_stories/widget/custom_button.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../models/notification_model.dart' as notification_model;

// ignore: must_be_immutable
class NotificationCard extends StatelessWidget {
  final NotificationViewModel notificationViewModel;
  //final ComicViewModel comicViewModel;
  NotificationCard({
    super.key,
    required this.notification,
    required this.notificationViewModel,
  });
  notification_model.Notification notification;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (notification.title != 'Thông báo báo cáo bình luận' &&
            notification.title != 'Yêu cầu duyệt truyện' &&
            notification.title != 'Thông báo !') {
          await notificationViewModel.markAsReadNotification(notification);
          notificationViewModel.notifyListeners();
        }
      },
      child: Container(
        //height: MediaQuery.of(context).size.height / 10,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColor.bottomSheetColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.circle,
                      size: 5.0,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      timeDifference(notification.createdAt.toIso8601String()),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              notification.message.split('/').last,
              style: const TextStyle(color: Colors.white),
            ),
            if (notification.title == 'Thông báo báo cáo bình luận')
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                      color: Colors.red,
                      title: Text(
                        'Xóa bình luận',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        ComicViewModel comicViewModel = ComicViewModel();

                        await comicViewModel.deleteCommentById(
                            notification.message.split('/').first);
                      }),
                  SizedBox(
                    width: 10,
                  ),
                  CustomButton(
                      title: Text(
                        'Bỏ qua',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {}),
                ],
              )
          ],
        ),
      ),
    );
  }

  String timeDifference(String inputTime) {
    DateTime inputDateTime = DateTime.parse(inputTime).toUtc();
    DateTime currentDateTime = DateTime.now().toUtc();
    Duration duration = currentDateTime.difference(inputDateTime);

    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;

    String result = '';

    if (days > 0) {
      result = '$days ngày ';
    }
    if (days == 0) {
      if (hours > 0) {
        result += '$hours giờ ';
      }
      if (minutes > 0) {
        result += '$minutes phút ';
      }

      if (result.isEmpty) {
        result = 'Vừa mới đây';
      }
    }

    print(result);
    return result.trim();
  }
}
