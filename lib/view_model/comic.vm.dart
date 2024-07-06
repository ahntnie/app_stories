import 'dart:convert';

import 'package:app_stories/app/app_sp.dart';
import 'package:app_stories/app/app_sp_key.dart';
import 'package:app_stories/constants/api.dart';
import 'package:app_stories/models/comment_model.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/requests/story.request.dart';
import 'package:app_stories/services/api_service.dart';
import 'package:app_stories/views/stories/stories_view/stories.page.dart';
import 'package:app_stories/views/view_story/view_story.page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../models/chapter_model.dart';

class ComicViewModel extends BaseViewModel {
  late BuildContext viewContext;
  Story currentStory = Story();
  late Comment commentStory;
  late Chapter currentChapter;
  List<Story> storiesIsActive = [];
  StoryRequest request = StoryRequest();
  List<Category> categories = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
  TextEditingController summaryController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController commenStorytController = TextEditingController();
  StoryRequest storyRequest = StoryRequest();
  late Map<String, dynamic> _commentModel;
  Map<String, dynamic>? get commentModel => _commentModel;
  String idUser = AppSP.get(AppSPKey.userinfo);
  bool isFavourite = false;
  final apiService = ApiService();
  List<Comment> comments = [];
  List<Comment> timeComment = [];
  Future<void> init() async {
    setBusy(true);
    await getStoryActive();
    //checkFavourite();
    // getCommentByStory();
    // getCommentByChapter();
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

  Future<void> postComment(int? storyID, int? chapterID, String content) async {
    _commentModel = {
      'story_id': currentStory.storyId,
      'user_id': idUser,
      'chapter_id': currentChapter.chapterId,
      'content': content
    };
    await apiService.postRequestComment(
        '${Api.hostApi}${Api.comment}', _commentModel);
    notifyListeners();
  }

  Future<void> postCommentStory(int? storyID, String content) async {
    _commentModel = {
      'story_id': currentStory.storyId,
      'user_id': idUser,
      'content': content
    };
    await apiService.postRequestComment(
        '${Api.hostApi}${Api.commentStory}', _commentModel);
    notifyListeners();
  }

  Future<void> getCommentByStory() async {
    int? storyID = currentStory.storyId;
    Response infoResponse = await apiService.getRequest(
        '${Api.hostApi}${Api.comment}',
        queryParams: {"story_id": storyID});
    final responseData = jsonDecode(jsonEncode(infoResponse.data));
    List<dynamic> lstComment = responseData['data'];
    comments = lstComment.map((e) => Comment.fromJson(e)).toList();
    comments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    timeComment = comments.take(5).toList();
    notifyListeners();
  }

  Future<void> getCommentByChapter() async {
    int? chapterID = currentChapter.chapterId;
    Response infoResponse = await apiService.getRequest(
        '${Api.hostApi}${Api.comment}',
        queryParams: {"chapter_id": chapterID});
    final responseData = jsonDecode(jsonEncode(infoResponse.data));
    List<dynamic> lstComment = responseData['data'];
    comments = lstComment.map((e) => Comment.fromJson(e)).toList();
    comments.forEach((e) {
      print(e.toJson());
    });
    notifyListeners();
  }

  checkFavourite() {
    if (currentStory.favouriteUser != null) {
      // Kiểm tra xem currentUserId có trong danh sách favouritedUsers hay không
      for (var user in currentStory.favouriteUser!) {
        if (user.id == idUser) {
          isFavourite = true;
          // print('Có like');
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
