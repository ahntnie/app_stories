import 'package:app_stories/models/category_model.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/requests/category.request.dart';
import 'package:app_stories/requests/story.request.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SearchSotriesViewModel extends BaseViewModel {
  late BuildContext viewContext;
  TextEditingController searchController = TextEditingController();
  List<Story> stories = [];
  List<Story> storiesIsComplete = [];
  List<Story> storiesIsNotComplete = [];
  StoryRequest request = StoryRequest();
  CategoryRequest categoryRequest = CategoryRequest();
  bool categoryFilter = true;
  List<Category> categories = [];
  List<bool> selectedCategories = [];
  List<int> categoriesId = [];
  Category? currentCategory;
  init() async {
    searchController.text = '';
    setBusy(true);
    await getCategories();
    if (categoriesId.isEmpty) {
      await searchStories();
      await getStoryIsComplete();
      await getStoryIsNotComplete();
      setBusy(false);
    }
  }

  getStoryIsComplete() async {
    storiesIsComplete = await request.getStoryIsComplete(searchController.text);
    notifyListeners();
  }

  getStoryIsNotComplete() async {
    storiesIsNotComplete =
        await request.getStoryIsNotComplete(searchController.text);
    notifyListeners();
  }

  Future<void> getCategories() async {
    categories = await categoryRequest.getCategories();
    selectedCategories = List<bool>.filled(categories.length, false);
    notifyListeners();
  }

  changeSelectedCategories(int index) {
    selectedCategories[index] = !selectedCategories[index];
    notifyListeners();
  }

  Future<void> searchStories() async {
    setBusy(true);
    stories = await request.searchStory(searchController.text);
    setBusy(false);
    notifyListeners();
  }

  Future<void> searchStoriesByFilter() async {
    setBusy(true);
    int index = 0;
    print('Vào lấy stories');
    categoriesId = [];
    for (var selected in selectedCategories) {
      if (selected) {
        categoriesId.add(categories[index].categoryId!);
      }
      index++;
    }
    stories = await request.searchStory(searchController.text, categoriesId);
    print('Vào lấy xong stories');
    setBusy(false);
    notifyListeners();
  }

  changeCategoryFilter() {
    categoryFilter = true;
    notifyListeners();
  }

  changeSortFilter() {
    categoryFilter = false;
    notifyListeners();
  }

  Future<void> checkAndSearchStoriesByCategory(int? selectedCategoryId) async {
    print('Đúng');
    categoriesId = [selectedCategoryId!];
    currentCategory = categories
        .firstWhere((category) => category.categoryId == selectedCategoryId);
    int index = categories.indexOf(currentCategory!);
    selectedCategories[index] = true;
    await searchStoriesByFilter();
  }
}
