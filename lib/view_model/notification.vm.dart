import 'dart:convert';

import 'package:app_stories/app/app_sp.dart';
import 'package:app_stories/app/app_sp_key.dart';
import 'package:app_stories/models/chapter_model.dart';
import 'package:app_stories/models/comment_model.dart';
import 'package:app_stories/models/user_model.dart';
import 'package:app_stories/requests/chapter.request.dart';
import 'package:app_stories/requests/notification.request.dart';
import 'package:flutter/material.dart';
import 'package:app_stories/models/notification_model.dart'
    as notification_model;
import 'package:stacked/stacked.dart';

import '../models/story_model.dart';
import '../requests/story.request.dart';
import '../views/view_story/view_story.page.dart';
import '../widget/pop_up.dart';
import 'comic.vm.dart';

class NotificationViewModel extends BaseViewModel {
  late BuildContext viewContext;
  late Chapter? currentChapter;
  late Story currentStory;
  late Comment comment;
  TextEditingController message = TextEditingController();
  TextEditingController title = TextEditingController();
  List<notification_model.Notification> notifications = [];
  NotificationRequest request = NotificationRequest();
  Users currentUser =
      Users.fromJson(jsonDecode(AppSP.get(AppSPKey.currrentUser)));

  Future<void> getNotificationByUserId() async {
    setBusy(true);
    notifications = await request.getNotification();
    setBusy(false);
    notifyListeners();
  }

  postNotification() async {
    Users currentUser =
        Users.fromJson(jsonDecode(AppSP.get(AppSPKey.currrentUser)));
    String idUser = currentUser.id;
    print('Comment bên vm: ${comment.content}');
    await request.postNotification(
        idUser,
        "Tài khoản ${currentUser.name} đã báo cáo bình luận sau: '${comment.content}'. Vui lòng kiểm tra và xử lý sớm nhất có thể",
        "Thông báo báo cáo bình luận",
        0,
        currentStory.storyId!,
        currentChapter);
  }

  Future<void> markAsReadNotification(
      notification_model.Notification notify) async {
    Story story = await StoryRequest().getStoryById(notify.story.storyId!);
    String? errorString = await request.markAsReadNotification(notify.id);
    if (errorString == null) {
      Navigator.push(
          viewContext,
          MaterialPageRoute(
              builder: (context) => ViewStoryPage(
                    story: story,
                    viewModel: ComicViewModel(),
                    chapter: notify.chapter!,
                  )));
      await getNotificationByUserId();
    } else {
      showDialog(
          context: viewContext,
          builder: (context) {
            return PopUpWidget(
              icon: Image.asset("assets/ic_error.png"),
              title: 'Lỗi: $errorString',
              leftText: 'Xác nhận',
              onLeftTap: () {
                Navigator.pop(context);
              },
            );
          });
    }
  }

  Future<void> markAsReadReportNotification(
      notification_model.Notification notify) async {
    Story story = await StoryRequest().getStoryById(notify.story.storyId!);
    String? errorString = await request.markAsReadNotification(notify.id);
    if (errorString == null) {
      // Navigator.push(
      //     viewContext,
      //     MaterialPageRoute(
      //         builder: (context) => ViewStoryPage(
      //               story: story,
      //               viewModel: ComicViewModel(),
      //               chapter: notify.chapter!,
      //             )));
      
      await getNotificationByUserId();
    } else {
      showDialog(
          context: viewContext,
          builder: (context) {
            return PopUpWidget(
              icon: Image.asset("assets/ic_error.png"),
              title: 'Lỗi: $errorString',
              leftText: 'Xác nhận',
              onLeftTap: () {
                Navigator.pop(context);
              },
            );
          });
    }
  }
}
