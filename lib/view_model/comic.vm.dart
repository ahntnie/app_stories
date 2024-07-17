import 'dart:convert';

import 'package:app_stories/app/app_sp.dart';
import 'package:app_stories/app/app_sp_key.dart';
import 'package:app_stories/constants/api.dart';
import 'package:app_stories/models/comment_model.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/models/user_model.dart';
import 'package:app_stories/requests/category.request.dart';
import 'package:app_stories/requests/notification.request.dart';
import 'package:app_stories/requests/story.request.dart';
import 'package:app_stories/services/api_service.dart';
import 'package:app_stories/view_model/profile.vm.dart';
import 'package:app_stories/views/stories/stories_view/stories.page.dart';
import 'package:app_stories/views/view_story/view_story.page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../models/category_model.dart';
import '../models/chapter_model.dart';

class ComicViewModel extends BaseViewModel {
  late BuildContext viewContext;
  Story currentStory = Story();
  late Comment commentStory;
  Chapter? currentChapter;
  List<Story> storiesIsActive = [];
  List<Story> storiesNew = [];
  List<dynamic> storiesFavourite = [];
  StoryRequest request = StoryRequest();
  List<Category> categories = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
  TextEditingController summaryController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController commenStorytController = TextEditingController();
  StoryRequest storyRequest = StoryRequest();
  bool isCategoriesVisible = false;
  late Map<String, dynamic> _commentModel;
  Map<String, dynamic>? get commentModel => _commentModel;
  String idUser = '';
  Users? currentUsers;
  bool isFavourite = false;
  final apiService = ApiService();
  List<Comment> comments = [];
  int pageIndex = 1;
  Future<void> init() async {
    currentUsers = AppSP.get(AppSPKey.currrentUser) != null &&
            AppSP.get(AppSPKey.currrentUser) != ''
        ? Users.fromJson(jsonDecode(AppSP.get(AppSPKey.currrentUser)))
        : null;
    if (currentUsers != null) idUser = currentUsers!.id;
    setBusy(true);
    await getStoryActive();
    categories = await CategoryRequest().getCategories();
    await getCommentByStory();
    await getStoryNew();
    //await getStoryFavourite();
    setBusy(false);
    notifyListeners();
  }

  Future<void> postNotification(
      String? message, String? title, int? is_read) async {
    Map<String, dynamic> notificationModel = {
      'user_id': idUser,
      'title': title,
      'message': message,
      'is_read': 1
    };
    await ApiService().postNotifications(
        '${Api.hostApi}${Api.postNotificationByAdmin}', notificationModel);
    notifyListeners();
  }

  Future<void> getStoryActive([bool nextPage = false]) async {
    print(idUser);
    if (nextPage) {
      pageIndex++;
      List<Story> storiesNextPage = await request.getStoriesIsActive(pageIndex);
      storiesIsActive.addAll(storiesNextPage);
      notifyListeners();
    } else {
      storiesIsActive = await request.getStoriesIsActive(pageIndex);
      print(storiesIsActive);
    }
  }

  Future<void> getStoryNew() async {
    storiesNew = await request.getStoriesNew();
  }

  Future<void> getStoryFavourite() async {
    currentUsers = Users.fromJson(jsonDecode(AppSP.get(AppSPKey.currrentUser)));
    idUser = currentUsers!.id;
    // print('id user: $idUser');
    Response response = await apiService
        .getRequest('${Api.hostApi}${Api.getStoryFavourite}/$idUser');
    print('dataa: ${response.data}');

    //print(idUser);
    final responseData = jsonDecode(jsonEncode(response.data));
    //print(responseData);
    List<dynamic> lstStory = responseData['data'];

    storiesFavourite = lstStory.map((e) => Story.fromJson(e)).toList();
    print(storiesFavourite);
    // notifyListeners();
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
      currentStory.favouriteUser!.add(currentUsers!);
    } else {
      await apiService.postFavourite(
          '${Api.hostApi}${Api.unLike}', favoriteModel);
      isFavourite = false;
      currentStory.favouriteUser!.remove(currentUsers!);
    }
    notifyListeners();
  }

  Future<void> postComment(int? storyID, int? chapterID, String content) async {
    _commentModel = {
      'story_id': currentStory.storyId,
      'user_id': idUser,
      'chapter_id': currentChapter?.chapterId,
      'content': content
    };
    await apiService.postRequestComment(
        '${Api.hostApi}${Api.comment}', _commentModel);
    notifyListeners();
  }

  Future<void> deleteComment() async {
    int id = commentStory.commentId;
    print('Api xóa: ${Api.hostApi}${Api.comment}/${id}');
    await apiService.deleteRequest('${Api.hostApi}${Api.comment}/${id}');
    notifyListeners();
  }

  Future<void> deleteCommentById(String id) async {
    print('Api xóa: ${Api.hostApi}${Api.comment}/${id}');
    await apiService.deleteRequest('${Api.hostApi}${Api.comment}/${id}');
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
    notifyListeners();
  }

  Future<void> getCommentByChapter() async {
    int? chapterID = currentChapter?.chapterId;
    Response infoResponse = await apiService.getRequest(
        '${Api.hostApi}${Api.comment}',
        queryParams: {"chapter_id": chapterID});
    final responseData = jsonDecode(jsonEncode(infoResponse.data));
    List<dynamic> lstComment = responseData['data'];
    comments = lstComment.map((e) => Comment.fromJson(e)).toList();
    notifyListeners();
  }

  checkFavourite() {
    isFavourite = false;
    if (currentStory.favouriteUser != null) {
      for (var user in currentStory.favouriteUser!) {
        if (user.id == idUser) {
          isFavourite = true;
          break;
        }
      }
    }
    print('Giá trị của favourite: $isFavourite');
  }

  nextDetailStory() async {
    categories = currentStory.categories!;
    checkFavourite();
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
                  chapter: currentChapter!,
                  viewModel: this,
                )));
  }

  addViewStory() async {
    await storyRequest.addView(currentStory.storyId!);
  }
}
