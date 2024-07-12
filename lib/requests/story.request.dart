import 'dart:convert';
import 'dart:io';

import 'package:app_stories/constants/api.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/services/api_service.dart';
import 'package:dio/dio.dart';

import '../app/app_sp.dart';
import '../app/app_sp_key.dart';
import '../models/user_model.dart';

class StoryRequest {
  Dio dio = Dio();

  Future<int> getTotalStories() async {
    final response = await ApiService().getRequest(
      '${Api.hostApi}${Api.getTotalStories}',
    );
    final responseData = jsonDecode(jsonEncode(response.data));
    return responseData['total_stories'];
  }

  Future<List<Story>> searchStory(String search,
      [List<int>? categoriesId]) async {
    List<Story> stories = [];
    final response = await ApiService()
        .getRequest('${Api.hostApi}${Api.getMyStories}', queryParams: {
      "is_active": 1,
      "search_string": search,
      "categories_id": categoriesId.toString(),
    });
    final responseData = jsonDecode(jsonEncode(response.data));
    List<dynamic> lstStory = responseData['data'];
    stories = lstStory.map((e) => Story.fromJson(e)).toList();
    return stories;
  }

  Future<List<Story>> getStoryIsComplete(String search,
      [List<int>? categoriesId]) async {
    List<Story> stories = [];
    final response = await ApiService()
        .getRequest('${Api.hostApi}${Api.getMyStories}', queryParams: {
      "is_active": 1,
      "search_string": search,
      "categories_id": categoriesId.toString(),
      "is_complete": 1,
    });
    final responseData = jsonDecode(jsonEncode(response.data));
    List<dynamic> lstStory = responseData['data'];
    stories = lstStory.map((e) => Story.fromJson(e)).toList();
    return stories;
  }

  Future<List<Story>> getStoryIsNotComplete(String search,
      [List<int>? categoriesId]) async {
    List<Story> stories = [];
    final response = await ApiService()
        .getRequest('${Api.hostApi}${Api.getMyStories}', queryParams: {
      "is_active": 1,
      "search_string": search,
      "categories_id": categoriesId.toString() ?? [],
      "is_complete": 0,
    });
    final responseData = jsonDecode(jsonEncode(response.data));
    List<dynamic> lstStory = responseData['data'];
    stories = lstStory.map((e) => Story.fromJson(e)).toList();
    return stories;
  }

  Future<String?> uploadStory(
      File image,
      List<File> chapters,
      List<File> copyrightDocuments,
      Story story,
      List<int> selectedCategoryIds) async {
    String? errorString;
    try {
      String fileName = 'img_${story.title}';
      List<MultipartFile> chapterImages = [];
      for (File chapter in chapters) {
        int count = 0;
        String chapterFileName = 'img_chapter_${count++}';
        chapterImages.add(await MultipartFile.fromFile(chapter.path,
            filename: chapterFileName));
      }
      List<MultipartFile> copyrightDocumentsImages = [];
      for (File document in copyrightDocuments) {
        int count = 0;
        String chapterFileName = 'img_document_${count++}';
        copyrightDocumentsImages.add(await MultipartFile.fromFile(document.path,
            filename: chapterFileName));
      }
      final formData = FormData.fromMap({
        'title': story.title,
        'author_id': story.author!.id,
        'summary': story.summary,
        'cover_image':
            await MultipartFile.fromFile(image.path, filename: fileName),
        'chapter_image[]': chapterImages,
        'license_image[]': copyrightDocumentsImages,
        'category_ids[]': selectedCategoryIds,
      });
      ApiService apiService = ApiService();
      final response = await apiService.postRequest(
        '${Api.hostApi}${Api.postStory}',
        formData,
      );
    } catch (e) {
      errorString = e.toString();
    }
    return errorString;
  }

  Future<List<Story>> getMyStories() async {
    List<Story> stories = [];
    Users currentUser =
        Users.fromJson(jsonDecode(AppSP.get(AppSPKey.currrentUser)));
    final response = await ApiService()
        .getRequest('${Api.hostApi}${Api.getMyStories}', queryParams: {
      "user_id": currentUser.id,
    });
    final responseData = jsonDecode(jsonEncode(response.data));
    List<dynamic> lstStory = responseData['data'];
    stories = lstStory.map((e) => Story.fromJson(e)).toList();
    return stories;
  }

  Future<List<Story>> getStoriesNotActive() async {
    List<Story> stories = [];
    final response = await ApiService().getRequest(
        '${Api.hostApi}${Api.getMyStories}',
        queryParams: {"is_active": 0});
    final responseData = jsonDecode(jsonEncode(response.data));
    List<dynamic> lstStory = responseData['data'];
    stories = lstStory.map((e) => Story.fromJson(e)).toList();
    return stories;
  }

  Future<List<Story>> getStoriesIsActive(int pageIndex) async {
    List<Story> stories = [];
    final response = await ApiService().getRequest(
      '${Api.hostApi}${Api.getMyStories}',
      queryParams: {
        "is_active": 1,
        "page": pageIndex,
      },
    );
    final responseData = jsonDecode(jsonEncode(response.data));
    List<dynamic> lstStory = responseData['data'];
    stories = lstStory.map((e) => Story.fromJson(e)).toList();
    return stories;
  }

  Future<List<Story>> getStoriesNew() async {
    List<Story> stories = [];
    final response = await ApiService().getRequest(
      '${Api.hostApi}${Api.getMyStories}',
      queryParams: {"is_active": 1, "is_story_new": 1},
    );
    final responseData = jsonDecode(jsonEncode(response.data));
    List<dynamic> lstStory = responseData['data'];
    stories = lstStory.map((e) => Story.fromJson(e)).toList();
    return stories;
  }

  Future<Story> getStoryById(int storyId) async {
    Story story;
    final response = await ApiService()
        .getRequest('${Api.hostApi}${Api.getMyStories}/$storyId');
    final responseData = jsonDecode(jsonEncode(response.data));
    dynamic storyJson = responseData['data'];
    story = Story.fromJson(storyJson);
    return story;
  }

  Future<String?> approveStory(int storyId) async {
    String? errorString;
    try {
      final response = await ApiService()
          .patchRequest('${Api.hostApi}${Api.approveStory}/$storyId', null);
      if (response.statusCode == 200) {
        errorString = null;
      } else {
        errorString = response.data['message'].toString();
      }
    } catch (e) {
      errorString = e.toString();
    }
    return errorString;
  }

  Future<void> addView(int storyId) async {
    Users currentUser =
        Users.fromJson(jsonDecode(AppSP.get(AppSPKey.currrentUser)));
    final formData = FormData.fromMap({
      "user_id": currentUser.id,
    });
    final response = await ApiService()
        .postRequest('${Api.hostApi}${Api.addViewStory}/$storyId', formData);
    final responseData = response.data;
  }
}
