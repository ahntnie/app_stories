import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stacked/stacked.dart';

import '../../../view_model/story_view.vm.dart';
import '../../comic/widget/custom/items/ranked.items.widget.dart';

class ViewStory extends StatefulWidget {
  const ViewStory({super.key, required this.comicViewModel});
  final ComicViewModel comicViewModel;

  @override
  State<ViewStory> createState() => _ViewStoryState();
}

class _ViewStoryState extends State<ViewStory> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh(StoryViewViewModel viewModel) async {
    await viewModel.getStoryView();
    _refreshController.refreshCompleted();
  }

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
            body: SmartRefresher(
              controller: _refreshController,
              onRefresh: () => _onRefresh(viewModel),
              child: ListView.builder(
                  itemCount: viewModel.listStory.length,
                  itemBuilder: (context, index) {
                    return RankedItems(
                        comicViewModel: widget.comicViewModel,
                        data: viewModel.listStory[index],
                        onTap: () {
                          widget.comicViewModel.viewContext = context;
                          widget.comicViewModel.currentStory =
                              viewModel.listStory[index];
                          widget.comicViewModel.checkFavourite();
                          widget.comicViewModel.nextDetailStory();
                        });
                  }),
            ),
          );
        });
  }
}
