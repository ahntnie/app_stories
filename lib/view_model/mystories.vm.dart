import 'package:app_stories/models/story_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

import '../requests/story.request.dart';
import '../views/stories/post_chapter.page.dart';

class MyStoriesViewModel extends BaseViewModel {
  late BuildContext viewContext;
  StoryRequest request = StoryRequest();
  List<Story> myStories = [];
  late Story currentStory;
  getMyStories() async {
    myStories = await request.getMyStories();
    notifyListeners();
  }

  nextPostChapter() {
    Navigator.push(
        viewContext,
        MaterialPageRoute(
            builder: (context) => PostChapterPage(
                  data: currentStory,
                  viewModel: this,
                )));
  }
}
