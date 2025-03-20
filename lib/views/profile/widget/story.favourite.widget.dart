import 'package:app_stories/custom/empty.custom.dart';
import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/views/comic/widget/custom/items/ranked.items.widget.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:app_stories/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stacked/stacked.dart';

class FavouriteStory extends StatefulWidget {
  const FavouriteStory({super.key, required this.comicViewModel});
  final ComicViewModel comicViewModel; // Sử dụng final cho immutable

  @override
  State<FavouriteStory> createState() => _FavouriteStoryState();
}

class _FavouriteStoryState extends State<FavouriteStory> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    try {
      await widget.comicViewModel.getStoryFavourite();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
      if (mounted) {
        // Kiểm tra widget còn tồn tại
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi làm mới: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _refreshController.dispose(); // Giải phóng controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ComicViewModel>.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => widget.comicViewModel,
      onViewModelReady: (viewModel) async {
        viewModel.viewContext = context;
        await viewModel.getStoryFavourite(); // Đảm bảo gọi async
      },
      builder: (context, viewModel, child) {
        return BasePage(
          isLoading: viewModel.isBusy,
          showAppBar: true,
          title: 'Truyện đã theo dõi',
          body: SmartRefresher(
            enablePullDown: true, // Bật kéo xuống để refresh
            controller: _refreshController,
            onRefresh: _onRefresh,

            child: viewModel.storiesFavourite.isNotEmpty
                ? ListView.builder(
                    itemCount: viewModel.storiesFavourite.length,
                    itemBuilder: (context, index) {
                      return RankedItems(
                        comicViewModel: viewModel,
                        data: viewModel.storiesFavourite[index],
                        onTap: () {
                          viewModel.currentStory =
                              viewModel.storiesFavourite[index];
                          viewModel.viewContext = context;
                          viewModel.checkFavourite();
                          viewModel.nextDetailStory();
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
