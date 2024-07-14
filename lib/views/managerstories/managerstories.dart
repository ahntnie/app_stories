import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/view_model/browse_stories.vm.dart';
import 'package:app_stories/view_model/mystories.vm.dart';
import 'package:app_stories/views/stories/widget/stories_card.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:app_stories/widget/loading_shimmer.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ManagerStories extends StatefulWidget {
  ManagerStories({super.key});
  //Story story;
  @override
  State<ManagerStories> createState() => _ManagerStoriesState();
}

class _ManagerStoriesState extends State<ManagerStories> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => BrowseStoriesViewModel(),
        onViewModelReady: (viewModel) {
          viewModel.viewContext = context;
          //viewModel.currentStory =
          viewModel.getAllStory();
          // viewModel.getAllCategory();
        },
        builder: (context, viewModel, child) {
          return BasePage(
            showAppBar: true,
            title: 'Quản lý truyện',
            body: viewModel.isBusy
                ? Center(child: GradientLoadingWidget())
                : ListView.builder(
                    itemCount: viewModel.stories.length,
                    itemBuilder: (context, index) {
                      return StoryCard(
                        viewModel: MyStoriesViewModel(),
                        data: viewModel.stories[index],
                        onTap: () {
                          viewModel.currentStory = viewModel.stories[index];
                          viewModel.nextDetailStory();
                        },
                        onPressed: () {
                          print('nhan');
                          viewModel.currentStory = viewModel.stories[index];
                          //viewModel.getAllStory();
                          viewModel.disableStory();
                        },
                      );
                    }),
          );
        });
  }
}