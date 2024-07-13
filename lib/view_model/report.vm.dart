import 'package:app_stories/requests/category.request.dart';
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
  int totalStories = 0;
  int totalNewStories = 0;
  int totalNewUsers = 0;
  String type = 'week';
  init() async {
    await getMyStories();
    fetchViewsData();
    fetchFavouritesData();
    fetchCommentsData();
    await getTotalStories();
    await getCountNewUsers();
    await getCountNewStories();
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

  getTotalStories() async {
    totalStories = await StoryRequest().getTotalStories();
    print('Số lượng truyện: $totalStories');
    notifyListeners();
  }

  getCountNewUsers() async {
    totalNewUsers = await CategoryRequest().getCountNewUsers(type);
    notifyListeners();
  }

  getCountNewStories() async {
    totalNewStories = await StoryRequest().getCountNewStories(type);
    notifyListeners();
  }

  changeType(String typee) async {
    type = typee;
    getCountNewUsers();
    getCountNewStories();
    notifyListeners();
  }
}

class ViewData {
  ViewData(this.name, this.views);
  final String name;
  final int views;
}
