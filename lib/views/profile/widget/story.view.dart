import 'package:app_stories/custom/empty.custom.dart';
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
    try {
      await viewModel.getStoryView();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi làm mới: $e')),
      );
    }
  }

  @override
  void dispose() {
    _refreshController.dispose(); // Giải phóng controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StoryViewViewModel>.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => StoryViewViewModel(context: context),
      onViewModelReady: (viewModel) async {
        await viewModel.getStoryView(); // Đảm bảo gọi async
      },
      builder: (context, viewModel, child) {
        return BasePage(
          isLoading: viewModel.isBusy,
          showAppBar: true,
          title: 'Lịch sử đọc truyện',
          body: SmartRefresher(
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: () => _onRefresh(viewModel),

            child: viewModel.listStory.isNotEmpty
                ? ListView.builder(
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
                        },
                      );
                    },
                  )
                : const EmptyCustom(), // Giả sử EmptyCustom không cần tham số
          ),
        );
      },
    );
  }
}
