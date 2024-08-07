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
    } catch (e) {
      errorString = e.toString();
    }
    return errorString;
  }

  Future<String?> updateChapter(
      List<File> chapterImages, String title, int chapterId) async {
    String? errorString;
    try {
      print("Số lượng hình: ${chapterImages.length}");
      List<MultipartFile> images = [];
      for (File chapter in chapterImages) {
        int count = 0;
        String chapterFileName = 'img_chapter_${count++}';
        images.add(await MultipartFile.fromFile(chapter.path,
            filename: chapterFileName));
      }
      Dio dio = Dio();
      Map<String, dynamic> data = {
        '_method': "PUT",
        'title': title,
        'chapter_image[]': images,
      };

      ApiService apiService = ApiService();
      final formData = FormData.fromMap(data);
      final response = await dio.post(
        '${Api.hostApi}${Api.updateChapters}/$chapterId',
        //queryParameters: data,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500; // Allow all status codes below 500
          },
        ),
        //queryParameters: data,
      );
      print('Data update chapter: ${response.data}');
    } catch (e) {
      errorString = e.toString();
    }
    return errorString;
  }

  Future<String?> updateImagesChapter(
      List<int> order, int storyId, int chapterNumber) async {
    print('Order: $order');
    print({
      "order": order.toString(),
      "story_id": storyId,
      "chapter_number": chapterNumber,
    });
    Dio dio = Dio();
    final response = await dio.patch(
      '${Api.hostApi}${Api.updateImages}',
      data: {
        "order": order.toString(),
        "story_id": storyId,
        "chapter_number": chapterNumber,
      },
    );

    print('Body sửa ảnh chapter: ${response.data}');
    return response.data.toString();
  }
}
