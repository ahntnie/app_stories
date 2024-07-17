import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ViewStory extends StatefulWidget {
  const ViewStory({super.key});

  @override
  State<ViewStory> createState() => _ViewStoryState();
}

class _ViewStoryState extends State<ViewStory> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        disposeViewModel: false,
        viewModelBuilder: () => ComicViewModel(),
        onViewModelReady: (viewModel) {},
        builder: (context, viewModel, child) {
          return BasePage(
            isLoading: viewModel.isBusy,
            showAppBar: true,
            title: 'Lịch sử đọc truyện',
            body: Container(),
          );
        });
  }
}
