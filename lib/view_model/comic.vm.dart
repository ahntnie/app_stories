import 'package:app_stories/models/chapter_model.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/requests/story.request.dart';
import 'package:app_stories/views/browse_stories/detail_story.page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../widget/pop_up.dart';

class ComicViewModel extends BaseViewModel {
  late BuildContext viewContext;
  late Story currentStory;
  Chapter? currentChapter;
  List<Story> storiesIsActive = [];
  StoryRequest request = StoryRequest();
  List<Category> categories = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
  TextEditingController summaryController = TextEditingController();
  StoryRequest storyRequest = StoryRequest();

  Future<void> init() async {
    setBusy(true);
    await getStoryActive();

    setBusy(false);
    notifyListeners();
  }

  getDetailCurrentStory() {
    titleController.text = currentStory.title!;
    genreController.text =
        currentStory.categories!.map((category) => category.name).join(', ');
    authorNameController.text = currentStory.author!.name;
    summaryController.text = currentStory.summary!;
  }

  Future<void> getStoryActive() async {
    setBusy(true);
    storiesIsActive = await request.getStoriesIsActive();
    currentStory = storiesIsActive[0];
    currentChapter = currentStory.chapters![0];
    setBusy(false);
  }

  // nextDetailStory() {
  //   Navigator.push(
  //       viewContext,
  //       MaterialPageRoute(
  //           builder: (context) => DetailStoryPage(
  //                 data: currentStory,
  //                 viewModel: this,
  //               )));
  // }
}
