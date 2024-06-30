import 'dart:io';

import 'package:app_stories/constants/api.dart';
import 'package:app_stories/models/chapter_model.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/requests/chapter.request.dart';
import 'package:app_stories/requests/story.request.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:image_picker/image_picker.dart';

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

  // getListImageChapter(int chapter_index) {
  //   imagesChapter = currentStory.chapters![chapter_index].images
  //       .map((image) => '${Api.hostImage}$image')
  //       .toList();
  //   notifyListeners();
  //   print(imagesChapter);
  // }

  changeShowChapter() {
    print('Nhấn chapter');
    showChapters = !showChapters;
    notifyListeners();
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
      print('Số lượng hình chap mới: ${newChapterImages.length}');
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
