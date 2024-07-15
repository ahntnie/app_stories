import 'dart:io';
import 'dart:math' as math;
import 'package:app_stories/models/chapter_model.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/requests/chapter.request.dart';
import 'package:app_stories/requests/story.request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../widget/pop_up.dart';

class PostChapViewModel extends BaseViewModel {
  late BuildContext viewContext;
  late Story currentStory;
  List<String> imagesChapter = [];
  late Chapter currentChapter;
  bool showAddChapter = false;
  bool showChapters = false;
  List<File> newChapterImages = [];
  final picker = ImagePicker();
  ChapterRequest chapterRequest = ChapterRequest();
  StoryRequest storyRequest = StoryRequest();
  TextEditingController titleChapterController = TextEditingController();
  List<File> downloadedFiles = [];
  bool isLoadImage = false;
  List<int> oldIndex = [];
  late Story oldStory;

  changeShowChapter() {
    showChapters = !showChapters;
    notifyListeners();
  }

  Future<void> downloadImages() async {
    Dio dio = Dio();
    downloadedFiles = [];

    for (String url in currentChapter.images) {
      try {
        File file = await urlToFile(url);
        downloadedFiles.add(file);
        print("Downloaded file path: ${file.path}");
      } catch (e) {
        print("Error downloading image: $e");
      }
    }

    newChapterImages = downloadedFiles;
    notifyListeners();
  }

  Future<File> urlToFile(String imageUrl) async {
    var rng = math.Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File('$tempPath/${rng.nextInt(100)}.png');
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<void> clearTempDirectory(Directory tempDir) async {
    try {
      var files = tempDir.listSync();
      for (var file in files) {
        if (file is File) {
          await file.delete();
        }
      }
    } catch (e) {
      print("Error clearing temp directory: $e");
    }
  }

  Future<void> updateChapter() async {
    setBusy(true);
    // await downloadImages();
    // await chapterRequest.updateChapter(
    //     downloadedFiles, 'Truyện update', currentChapter.chapterId);
  if(currentStory.active != 0) {
    
  }
    String? errorString = await chapterRequest.updateImagesChapter(
        oldIndex, currentStory.storyId!, currentChapter.chapterNumber);

    oldIndex =
        List.generate(currentChapter.images.length, (int index) => index);
    print(oldIndex);
    currentStory = await StoryRequest().getStoryById(currentStory.storyId!);
    currentChapter = currentStory.chapters![currentChapter.chapterNumber - 1];
    // print('Danh sách ảnh get về: ${currentStory.chapters!.first.images}');
    // currentStory.chapters![currentChapter.chapterNumber - 1].images =
    //     currentStory.chapters![currentChapter.chapterNumber - 1].images
    //         .map((image) =>
    //             '$image?timestamp=${DateTime.now().millisecondsSinceEpoch}')
    //         .toList();
    notifyListeners();
    setBusy(false);

    isLoadImage = true;
    notifyListeners();
    isLoadImage = false;
    notifyListeners();
    Directory tempDir = await getTemporaryDirectory();
    await clearTempDirectory(tempDir);
  }

  changeShowAddChapter() {
    showAddChapter = true;
    notifyListeners();
  }

  Future<void> chooseNewChapterImages() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      newChapterImages =
          pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      notifyListeners();
    } else {
      print('No image selected.');
    }
  }

  Future<void> postChapter() async {
    if (titleChapterController.text.isEmpty || newChapterImages.isEmpty) {
      showDialog(
          context: viewContext,
          builder: (context) {
            return PopUpWidget(
              icon: Image.asset("assets/ic_error.png"),
              title: 'Bạn chưa điền đủ thông tin',
              leftText: 'Xác nhận',
              onLeftTap: () {
                Navigator.pop(context);
              },
            );
          });
    } else {
      setBusy(true);
      String? errorString = await chapterRequest.uploadChapter(
          newChapterImages,
          titleChapterController.text,
          currentStory.chapterCount! + 1,
          currentStory.storyId!);
      if (errorString != null) {
        showDialog(
            context: viewContext,
            builder: (context) {
              return PopUpWidget(
                icon: Image.asset("assets/ic_error.png"),
                title: 'Lỗi: $errorString',
                leftText: 'Xác nhận',
                onLeftTap: () {
                  Navigator.pop(context);
                },
              );
            });
      } else {
        newChapterImages = [];
        await getStoryById();
      }
      setBusy(false);
    }
  }

  Future<void> getStoryById() async {
    currentStory = await storyRequest.getStoryById(currentStory.storyId!);
    showAddChapter = false;
    notifyListeners();
  }
}
