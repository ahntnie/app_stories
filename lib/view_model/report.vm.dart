import 'package:app_stories/requests/story.request.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../models/story_model.dart';
import '../views/report/widget/colum_chart.dart';

class ReportViewModel extends BaseViewModel {
  late BuildContext viewContext;
  List<ViewData> viewsData = [];
  List<ViewData> favouriteData = [];
  List<ViewData> commentData = [];
  List<Story> stories = [];
  init() async {
    await getMyStories();
    fetchViewsData();
    fetchFavouritesData();
    fetchCommentsData();
    notifyListeners();
  }

  fetchViewsData() {
    viewsData = stories
        .map((story) => ViewData(story.title!, story.totalView!))
        .toList();
  }

  fetchFavouritesData() async {
    favouriteData = stories
        .map((story) => ViewData(story.title!, story.favouriteUser!.length))
        .toList();
  }

  fetchCommentsData() async {
    commentData = stories
        .map((story) => ViewData(story.title!, story.totalComment!))
        .toList();
  }

  getMyStories() async {
    stories = await StoryRequest().getMyStories();
  }
}

class ViewData {
  ViewData(this.name, this.views);
  final String name;
  final int views;
}
