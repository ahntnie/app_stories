import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../views/comic/comic.page.dart';
import '../views/profile/profile.page.dart';
import '../views/search/search.page.dart';
import 'comic.vm.dart';
import 'profile.vm.dart';
import 'search_stories.vm.dart';

class HomeViewModel extends BaseViewModel {
  int currentIndex = 0;
  late ComicViewModel comicViewModel;
  late SearchSotriesViewModel searchSotriesViewModel;
  late ProfileViewModel profileViewModel;

  HomeViewModel() {
    comicViewModel = ComicViewModel();
    searchSotriesViewModel = SearchSotriesViewModel();
    profileViewModel = ProfileViewModel();
  }

  Future<void> setIndex(int index) async {
    currentIndex = index;
    notifyListeners();
  }

  List<Widget> getPages() {
    return [
      ComicPage(
        viewModel: comicViewModel,
        homeViewModel: this,
      ),
      SearchPage(
        homeViewModel: this,
        viewModel: searchSotriesViewModel,
      ),
      ProfilePage(
        viewModel: profileViewModel,
        homeViewModel: this,
      ),
    ];
  }
}
