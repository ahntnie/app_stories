import 'dart:convert';
import 'dart:io';

import 'package:app_stories/constants/api.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/services/api_service.dart';
import 'package:dio/dio.dart';

class StoryRequest {
  Dio dio = Dio();

  Future<List<Story>> searchStory(String search,
      [List<int>? categoriesId]) async {
    List<Story> stories = [];
    // print('aaa:$categoriesId');
    // print('search: (${{
    //   "is_active": 1,
    //   "search_string": search,
    //   "categories_id": categoriesId ?? [],
    // }})');
    final response = await ApiService()
        .getRequest('${Api.hostApi}${Api.getMyStories}', queryParams: {
      "is_active": 1,
      "search_string": search,
      "categories_id": categoriesId.toString(),
    });
    // print('Body truyện: ${response.data}');
    // print('Code: ${response.statusCode}');
    final responseData = jsonDecode(jsonEncode(response.data));
    List<dynamic> lstStory = responseData['data'];
    stories = lstStory.map((e) => Story.fromJson(e)).toList();
    //print('Số lượng truyện: ${stories.length}');
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
        //print(chapterImages[count - 1].filename);
      }
      //print('List categoriesId: $selectedCategoryIds');
      List<MultipartFile> copyrightDocumentsImages = [];
      for (File document in copyrightDocuments) {
        int count = 0;
        String chapterFileName = 'img_document_${count++}';
        copyrightDocumentsImages.add(await MultipartFile.fromFile(document.path,
            filename: chapterFileName));
        // print(copyrightDocumentsImages[count - 1].filename);
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
      // final responseData = jsonDecode(response.data.toString());
      // print('Body đăng truyện: $response');
    } catch (e) {
      errorString = e.toString();
    }
    return errorString;
  }

  Future<List<Story>> getMyStories() async {
    List<Story> stories = [];
    final response =
        await ApiService().getRequest('${Api.hostApi}${Api.getMyStories}');
    // print('Body truyện: ${response.data}');
    // print('Code: ${response.statusCode}');
    final responseData = jsonDecode(jsonEncode(response.data));
    List<dynamic> lstStory = responseData['data'];
    stories = lstStory.map((e) => Story.fromJson(e)).toList();
    // print('Số lượng truyện: ${stories.length}');
    return stories;
  }

  Future<List<Story>> getStoriesNotActive() async {
    List<Story> stories = [];
    final response = await ApiService().getRequest(
        '${Api.hostApi}${Api.getMyStories}',
        queryParams: {"is_active": 0});
    //  print('Body truyện: ${response.data}');
    // print('Code: ${response.statusCode}');
    final responseData = jsonDecode(jsonEncode(response.data));
    List<dynamic> lstStory = responseData['data'];
    stories = lstStory.map((e) => Story.fromJson(e)).toList();
    // print('Số lượng truyện: ${stories.length}');
    return stories;
  }

  Future<List<Story>> getStoriesIsActive() async {
    List<Story> stories = [];
    final response = await ApiService().getRequest(
        '${Api.hostApi}${Api.getMyStories}',
        queryParams: {"is_active": 1});
    //  print('Body truyện: ${response.data}');
    // print('Code: ${response.statusCode}');
    final responseData = jsonDecode(jsonEncode(response.data));
    List<dynamic> lstStory = responseData['data'];
    stories = lstStory.map((e) => Story.fromJson(e)).toList();
    //  print('Số lượng truyện: ${stories.length}');
    return stories;
  }

  Future<Story> getStoryById(int storyId) async {
    Story story;
    final response = await ApiService()
        .getRequest('${Api.hostApi}${Api.getMyStories}/$storyId');
    // print('Body truyện: ${response.data}');
    // print('Code: ${response.statusCode}');
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
      // print('Body phê duyệt truyện: ${response.data}');
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
}
