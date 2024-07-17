import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/requests/story.request.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class StoryViewViewModel extends BaseViewModel {
  BuildContext context;
  StoryViewViewModel({required this.context});
  StoryRequest request = StoryRequest();
  List<Story> listStory = [];
  Story? currentStory;
  Future<void> getStoryView() async {
    setBusy(true);
    listStory = await request.getStoryView();
    setBusy(false);
  }
}
