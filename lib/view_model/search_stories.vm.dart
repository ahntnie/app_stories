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
  StoryRequest request = StoryRequest();
  CategoryRequest categoryRequest = CategoryRequest();
  bool categoryFilter = true;
  List<Category> categories = [];
  List<bool> selectedCategories = [];
  init() async {
    searchController.text = '';
    setBusy(true);
    await getCategories();
    await searchStories();
    setBusy(false);
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
    List<int> categoriesId = [];
    for (var selected in selectedCategories) {
      if (selected) {
        categoriesId.add(categories[index].categoryId!);
      }
      index++;
    }

    print(categoriesId);
    stories = await request.searchStory(searchController.text, categoriesId);
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
}
