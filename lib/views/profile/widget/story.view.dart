import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../view_model/story_view.vm.dart';
import '../../comic/widget/custom/items/ranked.items.widget.dart';

class ViewStory extends StatefulWidget {
  const ViewStory({super.key});

  @override
  State<ViewStory> createState() => _ViewStoryState();
}

class _ViewStoryState extends State<ViewStory> {
  ComicViewModel comicViewModel = ComicViewModel();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        disposeViewModel: false,
        viewModelBuilder: () => StoryViewViewModel(context: context),
        onViewModelReady: (viewModel) {
          viewModel.getStoryView();
        },
        builder: (context, viewModel, child) {
          return BasePage(
            isLoading: viewModel.isBusy,
            showAppBar: true,
            title: 'Lịch sử đọc truyện',
            body: ListView.builder(
                itemCount: viewModel.listStory.length,
                itemBuilder: (context, index) {
                  return RankedItems(
                      comicViewModel: comicViewModel,
                      data: viewModel.listStory[index],
                      onTap: () {
                        comicViewModel.currentStory =
                            viewModel.listStory[index];
                        comicViewModel.checkFavourite();
                        comicViewModel.nextDetailStory();
                      });
                }),
          );
        });
  }
}
