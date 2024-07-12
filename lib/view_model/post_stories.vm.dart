import 'dart:convert';
import 'dart:io';

import 'package:app_stories/app/app_sp.dart';
import 'package:app_stories/app/app_sp_key.dart';
import 'package:app_stories/models/category_model.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/models/user_model.dart';
import 'package:app_stories/requests/category.request.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

import '../requests/story.request.dart';
import '../widget/pop_up.dart';

class PostStoriesViewModel extends BaseViewModel {
  late BuildContext viewContext;

  TextEditingController storyNameController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
  TextEditingController summaryController = TextEditingController();
  List<File> copyrightDocumentsImages = [];
  List<File> chaptersImages = [];
  File? coverImage;
  final picker = ImagePicker();
  StoryRequest request = StoryRequest();
  CategoryRequest categoryRequest = CategoryRequest();
  List<Category> categories = [];
  List<Category> selectedCategories = [];
  List<int> selectedCategoryIds = [];
  late Category currentCategory;

  init() async {
    await getCategories();
    notifyListeners();
  }

  Future<void> submitRequest() async {
    setBusy(true);
    Users currentUser =
        Users.fromJson(jsonDecode(AppSP.get(AppSPKey.currrentUser)));
    String? errorString = await request.uploadStory(
      coverImage!,
      chaptersImages,
      copyrightDocumentsImages,
      Story(
        title: storyNameController.text,
        author: Users(
            id: currentUser.id,
            name: currentUser.name,
            email: currentUser.email,
            birthDate: DateTime(2003, 5, 23),
            role: currentUser.role,
            bio: currentUser.role,
            penName: currentUser.penName,
            previousWorks: currentUser.previousWorks),
        summary: summaryController.text,
      ),
      selectedCategoryIds,
    );
    setBusy(false);
    if (errorString != null) {
      showDialog(
          context: viewContext,
          builder: (context) {
            return PopUpWidget(
              icon: Image.asset("assets/ic_error.png"),
              title: 'Lỗi gửi yêu cầu phê duyệt: $errorString',
              leftText: 'Xác nhận',
              onLeftTap: () {
                Navigator.pop(context);
              },
            );
          });
    } else {
      chaptersImages = [];
      coverImage = null;
      copyrightDocumentsImages = [];
      storyNameController.clear();
      summaryController.clear();
      genreController.clear();
      authorNameController.clear();
      Navigator.pop(viewContext);
    }

    notifyListeners();
  }

  onSelectCategories(bool value) {
    if (value == true) {
      selectedCategoryIds.add(currentCategory.categoryId!);
    } else {
      selectedCategoryIds.remove(currentCategory.categoryId);
    }
    genreController.text = selectedCategoryIds
        .map((id) =>
            categories.firstWhere((category) => category.categoryId == id).name)
        .join(', ');
    notifyListeners();
  }

  Future<void> chooseCopyrightDocumentsImages() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      copyrightDocumentsImages =
          pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      notifyListeners();
    } else {
      print('No image selected.');
    }
  }

  Future<void> chooseChaptersImagesImages() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      chaptersImages =
          pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      notifyListeners();
    } else {
      print('No image selected.');
    }
  }

  onChangeGenre(Category category) {
    genreController.text = category.name!;
    notifyListeners();
  }

  Future<void> chooseCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      notifyListeners();
    } else {
      print('No image selected.');
    }
  }

  Future<void> getCategories() async {
    categories = await categoryRequest.getCategories();
  }
}
