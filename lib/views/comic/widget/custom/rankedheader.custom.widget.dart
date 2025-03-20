import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/views/comic/widget/custom/items/ranked.items.widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RankedHeader extends StatefulWidget {
  final ComicViewModel viewModel;
  const RankedHeader({super.key, required this.viewModel});

  @override
  State<RankedHeader> createState() => _RankedHeaderState();
}

class _RankedHeaderState extends State<RankedHeader> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        disposeViewModel: false,
        viewModelBuilder: () => widget.viewModel,
        onViewModelReady: (viewModel) {
          viewModel.viewContext = context;
        },
        builder: (context, viewModel, child) {
          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  indicatorColor: AppColors.watermelon100,
                  labelColor: AppColors.watermelon100,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: 'Top ngày'),
                    Tab(text: 'Top tuần'),
                    Tab(text: 'Top tháng'),
                  ],
                ),
                Container(
                  height: viewModel.storiesIsActive.length > 1
                      ? MediaQuery.of(context).size.width
                      : MediaQuery.of(context).size.height / 5,
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        child:
                         Column(
                          children: List.generate(
                              viewModel.storiesIsActive.length, (index) {
                            return RankedItems(
                              comicViewModel: viewModel,
                              tabName: 'Top ngày',
                              data: viewModel.storiesIsActive[index],
                              onTap: () {
                                viewModel.currentStory =
                                    viewModel.storiesIsActive[index];
                                viewModel.viewContext = context;
                                viewModel.checkFavourite();
                                viewModel.nextDetailStory();
                              },
                            );
                          }),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                              viewModel.storiesIsActive.length, (index) {
                            return RankedItems(
                              // chapter: viewModel.currentChapter =
                              //     viewModel.currentChapter!,
                              comicViewModel: viewModel,
                              tabName: 'Top tuần',
                              data: viewModel.storiesIsActive[index],
                              onTap: () {
                                viewModel.currentStory =
                                    viewModel.storiesIsActive[index];
                                viewModel.viewContext = context;
                                viewModel.nextDetailStory();
                              },
                            );
                          }),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                              viewModel.storiesIsActive.length, (index) {
                            return RankedItems(
                              // chapter: viewModel.currentChapter =
                              //     viewModel.currentChapter!,
                              comicViewModel: viewModel,
                              tabName: 'Top tháng',
                              data: viewModel.storiesIsActive[index],
                              onTap: () {
                                viewModel.currentStory =
                                    viewModel.storiesIsActive[index];
                                viewModel.nextDetailStory();
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
