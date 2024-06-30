import 'dart:io';

import 'package:dio/dio.dart';

import '../constants/api.dart';
import '../services/api_service.dart';

class ChapterRequest {
  Dio dio = Dio();

  Future<String?> uploadChapter(List<File> chapterImages, String title,
      int chapterNumber, int storyId) async {
    String? errorString;
    try {
      List<MultipartFile> images = [];
      for (File chapter in chapterImages) {
        int count = 0;
        String chapterFileName = 'img_chapter_${count++}';
        images.add(await MultipartFile.fromFile(chapter.path,
            filename: chapterFileName));
      }
      final formData = FormData.fromMap({
        'story_id': storyId,
        'title': title,
        'chapter_number': chapterNumber,
        'chapter_image[]': images,
      });
      ApiService apiService = ApiService();
      final response = await apiService.postRequest(
        '${Api.hostApi}${Api.postChapters}',
        formData,
      );
      print('Body thêm chapter: ${response.data}');
    } catch (e) {
      errorString = e.toString();
    }
    return errorString;
  }
}
