import 'dart:convert';

import 'package:app_stories/app/app_sp.dart';
import 'package:app_stories/app/app_sp_key.dart';
import 'package:app_stories/models/chapter_model.dart';
import 'package:app_stories/models/comment_model.dart';
import 'package:app_stories/models/user_model.dart';
import 'package:app_stories/requests/chapter.request.dart';
import 'package:app_stories/requests/notification.request.dart';
import 'package:app_stories/view_model/browse_stories.vm.dart';
import 'package:app_stories/views/browse_stories/detail_story.page.dart';
import 'package:app_stories/views/stories/stories_view/stories.page.dart';
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
  Story currentStories = Story();
  TextEditingController message = TextEditingController();
  TextEditingController title = TextEditingController();
  List<notification_model.Notification> notifications = [];
  NotificationRequest request = NotificationRequest();

  Users? currentUser;

  Future<void> getNotificationByUserId() async {
    setBusy(true);
    notifications = await request.getNotification();
    setBusy(false);
    notifyListeners();
  }

  postNotificationByAdmin() async {
    Users currentUser =
        Users.fromJson(jsonDecode(AppSP.get(AppSPKey.currrentUser)));
    String idUser = currentUser.id;
    print('Comment bên vm: ${comment.content}');
    await request.postNotificationByAdmin(
        idUser,
        "${comment.commentId}/Tài khoản ${currentUser.name} đã báo cáo bình luận sau: '${comment.content}'. Vui lòng kiểm tra và xử lý sớm nhất có thể",
        "Thông báo báo cáo bình luận",
        0,
        currentStory.storyId!,
        currentChapter);
  }

  deleteNotification(int id) async {
    showDialog(
        context: viewContext,
        builder: (context) {
          return PopUpWidget(
            icon: Image.asset("assets/ic_error.png"),
            title: 'Bạn có muốn xóa thông báo này?',
            leftText: 'Xác nhận',
            onLeftTap: () async {
              setBusy(true);
              await request.deleteNotification(id);
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (context) {
                    return PopUpWidget(
                      icon: Image.asset("assets/ic_success.png"),
                      title: 'Xóa thông báo thành công',
                      leftText: 'Xác nhận',
                      onLeftTap: () async {
                        Navigator.pop(context);
                        await getNotificationByUserId();
                      },
                    );
                  });
            },
            twoButton: true,
            onRightTap: () {
              Navigator.pop(context);
            },
          );
        });
  }

  postNotificationReportStoryByAdmin() async {
    Users currentUser =
        Users.fromJson(jsonDecode(AppSP.get(AppSPKey.currrentUser)));
    String idUser = currentUser.id;
    print('Truyện báo cáo bên vm: ${currentStory.title}');
    await request.postNotificationByAdmin(
        idUser,
        "Tài khoản ${currentUser.name} đã báo cáo truyện sau: '${currentStory.title}'. Vui lòng kiểm tra và xử lý sớm nhất có thể",
        "Thông báo báo cáo truyện",
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

  Future<void> markAsReadAuthor(notification_model.Notification notify) async {
    // Story story = await StoryRequest().getStoryById(notify.story.storyId!);
    String? errorString = await request.markAsReadNotification(notify.id);
    if (errorString == null) {
      Navigator.push(
          viewContext,
          MaterialPageRoute(
              builder: (context) => ComicDetailPage(
                    data: currentStories,
                    viewModel: ComicViewModel(),
                  )));
      getNotificationByUserId();
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
