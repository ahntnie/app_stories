import 'package:app_stories/view_model/browse_stories.vm.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../widget/loading_shimmer.dart';
import '../stories/widget/stories_card.dart';

class BrowseStoriesPage extends StatefulWidget {
  const BrowseStoriesPage({super.key});

  @override
  State<BrowseStoriesPage> createState() => _BrowseStoriesPageState();
}

class _BrowseStoriesPageState extends State<BrowseStoriesPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => BrowseStoriesViewModel(),
        onViewModelReady: (viewModel) {
          viewModel.viewContext = context;
          viewModel.init();
        },
        builder: (context, viewModel, child) {
          return BasePage(
            title: 'Phê duyệt truyện',
            body: viewModel.isBusy
                ? Center(child: GradientLoadingWidget())
                : ListView.builder(
                    itemCount: viewModel.stories.length,
                    itemBuilder: (context, index) {
                      return StoryCard(
                        data: viewModel.stories[index],
                        onTap: () {
                          viewModel.currentStory = viewModel.stories[index];
                          viewModel.nextDetailStory();
                        },
                      );
                    }),
          );
        });
  }
}
