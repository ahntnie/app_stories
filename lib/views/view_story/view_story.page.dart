import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/chapter_model.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/views/view_story/widget/chapterbottom.widget.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked/stacked.dart';

import '../../widget/loading_shimmer.dart';
import '../../widget/search_textfield.dart';

class ViewStoryPage extends StatefulWidget {
  ViewStoryPage(
      {super.key,
      required this.story,
      required this.viewModel,
      required this.chapter});
  Story story;
  Chapter chapter;
  final ComicViewModel viewModel;

  @override
  State<ViewStoryPage> createState() => _ViewStoryPageState();
}

class _ViewStoryPageState extends State<ViewStoryPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBar = true;
  bool showNewStories = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        _showAppBar = false;
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        _showAppBar = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => ComicViewModel(),
      onViewModelReady: (viewModel) {
        viewModel.currentChapter = widget.chapter;
        viewModel.currentStory = widget.story;
        viewModel.viewContext = context;
        viewModel.init();
      },
      builder: (context, viewModel, child) {
        return BasePage(
            showAppBar: _showAppBar,
            title: viewModel.isBusy
                ? ''
                : 'Chapter ${viewModel.currentChapter.chapterNumber.toString()}',
            body: viewModel.isBusy
                ? Center(child: GradientLoadingWidget())
                : SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        ...viewModel.currentChapter.images
                            .map((image) => Image.network(image)),
                      ],
                    ),
                  ),
            bottomNav: _showAppBar
                ? Container(
                    height: 70,
                    color: AppColor.darkPrimary,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            viewModel.currentChapter =
                                viewModel.currentStory.chapters![
                                    viewModel.currentChapter.chapterNumber - 2];
                            viewModel.notifyListeners();
                          },
                          child: Image.asset(
                            'assets/ic_back_chapter.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return BottomChapter(
                                      setState: setState,
                                      story: viewModel.currentStory);
                                });
                              },
                            );
                          },
                          child: Image.asset(
                            'assets/ic_view_chapters.png',
                            width: 25,
                            height: 25,
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Image.asset(
                            'assets/ic_comment.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // viewModel.currentChapter.chapterNumber + 1;
                            // viewModel.detailChapter();
                            viewModel.currentChapter =
                                viewModel.currentStory.chapters![
                                    viewModel.currentChapter.chapterNumber];
                            viewModel.notifyListeners();
                          },
                          child: Image.asset(
                            'assets/ic_next_chapter.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ],
                    ),
                  )
                : null);
      },
    );
  }
}
