import 'package:app_stories/view_model/browse_stories.vm.dart';
import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/views/comic/widget/custom/items/categories.items.widget.dart';
import 'package:app_stories/views/comic/widget/custom/items/newstories.items.widget.dart';
import 'package:app_stories/views/comic/widget/custom/items/ranked.items.widget.dart';
import 'package:app_stories/views/comic/widget/custom/rankedheader.custom.widget.dart';
import 'package:app_stories/views/comic/widget/custom/sectionheader.custom.widget.dart';
import 'package:app_stories/views/stories/widget/stories_card.dart';
import 'package:app_stories/widget/loading_shimmer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ComicWidget extends StatefulWidget {
  const ComicWidget({super.key});

  @override
  State<ComicWidget> createState() => _ComicWidgetState();
}

class _ComicWidgetState extends State<ComicWidget> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => ComicViewModel(),
        onViewModelReady: (viewModel) {
          viewModel.viewContext = context;
          viewModel.init();
        },
        builder: (context, viewModel, child) {
          return viewModel.isBusy
              ? const Center(child: GradientLoadingWidget())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(title: 'Truyện mới'),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                            shrinkWrap: true,
                            //physics: const NeverScrollableScrollPhysics(),
                            itemCount: viewModel.storiesIsActive.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return NewStoriesItems(
                                data: viewModel.storiesIsActive[index],
                                onTap: () {
                                  viewModel.currentStory =
                                      viewModel.storiesIsActive[index];
                                  viewModel.nextDetailStory();
                                 // print('nhan');
                                },
                              );
                            }),
                      ),
                      SectionHeader(title: 'Phân loại truyện'),
                      CategoriesItems(categories: const [
                        'Tất cả',
                        'Ngôn tình',
                        'Học đường',
                        'Cổ đại',
                        'Hành động',
                        'Đam mỹ',
                      ]),
                      SectionHeader(title: 'BXH hot'),
                      const RankedHeader(),
                    ],
                  ),
                );
        });
  }
}
