import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/requests/story.request.dart';
import 'package:app_stories/views/browse_stories/detail_story.page.dart';
import 'package:app_stories/views/stories/stories_view/stories.page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../widget/pop_up.dart';

class ComicViewModel extends BaseViewModel {
  late BuildContext viewContext;
  late Story currentStory;
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
    // authorNameController.text = currentStory.authorI;
    summaryController.text = currentStory.summary!;
  }

  Future<void> getStoryActive() async {
    setBusy(true);
    storiesIsActive = await request.getStoriesIsActive();
    setBusy(false);
  }

  nextDetailStory() {
    print(currentStory.title);
    Navigator.push(
        viewContext,
        MaterialPageRoute(
            builder: (context) => ComicDetailPage(
                  data: currentStory,
                  viewModel: this,
                )));
  }
}
