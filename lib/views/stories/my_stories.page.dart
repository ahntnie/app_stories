import 'package:app_stories/views/stories/post_stories.dart';
import 'package:app_stories/views/stories/widget/stories_card.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:app_stories/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../view_model/mystories.vm.dart';
import '../../widget/loading_shimmer.dart';

class MyStoriesPage extends StatefulWidget {
  const MyStoriesPage({super.key});

  @override
  State<MyStoriesPage> createState() => _MyStoriesPageState();
}

class _MyStoriesPageState extends State<MyStoriesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MyStoriesViewModel>.reactive(
        viewModelBuilder: () => MyStoriesViewModel(),
        onViewModelReady: (viewModel) {
          viewModel.viewContext = context;
          viewModel.getMyStories();
        },
        builder: (context, viewModel, child) {
          return BasePage(
            title: 'Đăng truyện',
            body: viewModel.isBusy
                ? const Center(child: GradientLoadingWidget())
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: CustomButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PostStoriesPage(
                                              myStoriesViewModel: viewModel,
                                            )));
                              },
                              title: const Icon(
                                Icons.add_circle_outline,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ...viewModel.myStories.map((story) => StoryCard(
                                data: story,
                                onTap: () {
                                  viewModel.currentStory = story;
                                  viewModel.nextPostChapter();
                                },
                              )),
                        ],
                      ),
                    ),
                  ),
          );
        });
  }
}
