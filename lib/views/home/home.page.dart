import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/view_model/profile.vm.dart';
import 'package:app_stories/view_model/search_stories.vm.dart';
import 'package:app_stories/views/comic/comic.page.dart';
import 'package:app_stories/views/profile/profile.page.dart';
import 'package:app_stories/views/search/search.page.dart';
import 'package:app_stories/widget/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../view_model/home.vm.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeViewModel homeViewModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeViewModel = HomeViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => homeViewModel,
      builder: (context, viewModel, child) => Scaffold(
        body: IndexedStack(
          index: viewModel.currentIndex,
          children: viewModel.getPages(),
        ),
        bottomNavigationBar: HomeNavigationBar(
          currentIndex: viewModel.currentIndex,
          onTabSelected: (index) => viewModel.setIndex(index),
        ),
      ),
    );
  }
}
