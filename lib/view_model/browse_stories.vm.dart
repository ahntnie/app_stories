import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/requests/story.request.dart';
import 'package:app_stories/views/browse_stories/detail_story.page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../widget/pop_up.dart';

class BrowseStoriesViewModel extends BaseViewModel {
  late BuildContext viewContext;
  late Story currentStory;
  List<Story> stories = [];
  StoryRequest request = StoryRequest();
  List<Category> categories = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
  TextEditingController summaryController = TextEditingController();
  StoryRequest storyRequest = StoryRequest();

  Future<void> init() async {
    setBusy(true);
    await getStoryNotActive();
    setBusy(false);
    notifyListeners();
  }

  getDetailCurrentStory() {
    titleController.text = currentStory.title!;
    genreController.text =
        currentStory.categories!.map((category) => category.name).join(', ');
    authorNameController.text = currentStory.authorId!;
    summaryController.text = currentStory.summary!;
  }

  Future<void> getStoryNotActive() async {
    setBusy(true);
    stories = await request.getStoriesNotActive();
    setBusy(false);
  }

  nextDetailStory() {
    Navigator.push(
        viewContext,
        MaterialPageRoute(
            builder: (context) => DetailStoryPage(
                  data: currentStory,
                  viewModel: this,
                )));
  }

  Future<void> approveStory() async {
    setBusy(true);
    String? errorString =
        await storyRequest.approveStory(currentStory.storyId!);
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
              title: 'Phê duyệt thành công',
              leftText: 'Xác nhận',
              onLeftTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            );
          });
      await getStoryNotActive();
    }
  }
}
