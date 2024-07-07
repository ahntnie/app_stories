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
  List<notification_model.Notification> notifications = [];
  NotificationRequest request = NotificationRequest();
  Future<void> getNotificationByUserId() async {
    setBusy(true);
    notifications = await request.getNotification();
    setBusy(false);
    notifyListeners();
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
                    chapter: notify.chapter,
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
}
