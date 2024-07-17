import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/views/comic/widget/custom/items/ranked.items.widget.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:app_stories/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class FavouriteStory extends StatefulWidget {
  FavouriteStory({super.key, required this.comicViewModel});
  ComicViewModel comicViewModel;

  @override
  State<FavouriteStory> createState() => _FavouriteStoryState();
}

class _FavouriteStoryState extends State<FavouriteStory> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        disposeViewModel: false,
        viewModelBuilder: () => widget.comicViewModel,
        onViewModelReady: (viewModel) async {
          viewModel.viewContext = context;
          viewModel.getStoryFavourite();
        },
        builder: (context, viewModel, child) {
          return BasePage(
            isLoading: viewModel.isBusy,
            showAppBar: true,
            title: 'Truyện đã theo dõi',
            body: ListView.builder(
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
                      });
                }),
          );
        });
  }
}
