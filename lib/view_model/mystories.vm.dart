import 'dart:convert';

import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../app/app_sp.dart';
import '../app/app_sp_key.dart';
import '../requests/story.request.dart';
import '../views/stories/post_chapter.page.dart';
import '../widget/pop_up.dart';

class MyStoriesViewModel extends BaseViewModel {
  late BuildContext viewContext;
  StoryRequest request = StoryRequest();
  List<Story> myStories = [];
  late Story currentStory;
  StoryRequest storyRequest = StoryRequest();
  Users currentUser =
      Users.fromJson(jsonDecode(AppSP.get(AppSPKey.currrentUser)));

  getMyStories() async {
    setBusy(true);
    myStories = await request.getMyStories();
    notifyListeners();
    setBusy(false);
  }

  nextPostChapter() {
    if (currentStory.active == 1 && currentStory.isCompleted == false) {
      print('Hình nexPostChapter: ${currentStory.chapters!.first.images}');
      Navigator.push(
          viewContext,
          MaterialPageRoute(
              builder: (context) => PostChapterPage(
                    data: currentStory,
                    viewModel: this,
                  )));
    } else if (currentStory.active == 1 && currentStory.isCompleted == true) {
      showDialog(
        context: viewContext,
        builder: (context) {
          return PopUpWidget(
            icon: Image.asset("assets/ic_success.png"),
            title: 'Truyện đã hoàn thành',
            leftText: 'Xác nhận',
            onLeftTap: () {
              Navigator.pop(viewContext);
            },
          );
        },
      );
    } else if (currentStory.active == 0) {
      showDialog(
        context: viewContext,
        builder: (context) {
          return PopUpWidget(
            icon: Image.asset("assets/ic_success.png"),
            title: 'Truyện đã được đăng, nhưng chờ duyệt nhé!',
            leftText: 'Xác nhận',
            onLeftTap: () {
              Navigator.pop(viewContext);
            },
          );
        },
      );
    } else if (currentStory.active == 2) {
      showDialog(
          context: viewContext,
          builder: (context) {
            return PopUpWidget(
              icon: Image.asset("assets/ic_error.png"),
              title: 'Truyện bạn đã bị vô hiệu hóa!',
              leftText: 'Xác nhận',
              onLeftTap: () {
                Navigator.pop(viewContext);
              },
            );
          });
    } else if (currentStory.active == 3) {
      showDialog(
          context: viewContext,
          builder: (context) {
            return PopUpWidget(
              icon: Image.asset("assets/ic_error.png"),
              title: 'Truyện không đạt yêu cầu để duyệt!',
              leftText: 'Xác nhận',
              onLeftTap: () {
                Navigator.pop(viewContext);
              },
            );
          });
    }
  }

  Future<void> completedStory() async {
    setBusy(true);
    String? errorString =
        await storyRequest.completedStory(currentStory.storyId!);
    if (errorString != null) {
      setBusy(false);
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
    } else {
      setBusy(false);
      showDialog(
          context: viewContext,
          builder: (context) {
            return PopUpWidget(
              icon: Image.asset("assets/ic_success.png"),
              title: 'Hoàn thành truyện thành công',
              leftText: 'Xác nhận',
              onLeftTap: () {
                Navigator.pop(context);
              },
            );
          });
      getMyStories();
    }
  }
}
