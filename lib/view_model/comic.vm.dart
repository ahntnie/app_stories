import 'package:app_stories/app/app_sp.dart';
import 'package:app_stories/app/app_sp_key.dart';
import 'package:app_stories/constants/api.dart';
import 'package:app_stories/models/favourite_mode.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/requests/story.request.dart';
import 'package:app_stories/services/api_service.dart';
import 'package:app_stories/views/browse_stories/detail_story.page.dart';
import 'package:app_stories/views/stories/stories_view/stories.page.dart';
import 'package:app_stories/views/view_story/view_story.page.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../models/chapter_model.dart';
import '../widget/pop_up.dart';

class ComicViewModel extends BaseViewModel {
  late BuildContext viewContext;
  late Story currentStory;
  late Chapter currentChapter;
  List<Story> storiesIsActive = [];
  StoryRequest request = StoryRequest();
  List<Category> categories = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
  TextEditingController summaryController = TextEditingController();
  StoryRequest storyRequest = StoryRequest();
  String idUser = AppSP.get(AppSPKey.userinfo);
  bool isFavourite = false;

  Future<void> init() async {
    setBusy(true);
    await getStoryActive();
    checkFavourite();
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

  Future<void> postFavourite(int? storyID) async {
    Map<String, dynamic> favoriteModel = {
      'story_id': currentStory.storyId,
      'user_id': idUser
    };
    final apiService = ApiService();
    if (!isFavourite) {
      await apiService.postFavourite(
          '${Api.hostApi}${Api.postLike}', favoriteModel);
      isFavourite = true;
    } else {
      await apiService.postFavourite(
          '${Api.hostApi}${Api.unLike}', favoriteModel);
      isFavourite = false;
    }
    notifyListeners();
  }

  checkFavourite() {
    if (currentStory.favouriteUser != null) {
      // Kiểm tra xem currentUserId có trong danh sách favouritedUsers hay không
      for (var user in currentStory.favouriteUser!) {
        if (user.id == idUser) {
          isFavourite = true;
          print('Có like');
        }
      }
      notifyListeners();
    }

    return false;
  }

  nextDetailStory() {
    // print(currentStory.title);
    Navigator.push(
        viewContext,
        MaterialPageRoute(
            builder: (context) => ComicDetailPage(
                  data: currentStory,
                  viewModel: this,
                )));
  }

  detailChapter() {
    Navigator.push(
        viewContext,
        MaterialPageRoute(
            builder: (context) => ViewStoryPage(
                  story: currentStory,
                  chapter: currentChapter,
                  viewModel: this,
                )));
  }
}
