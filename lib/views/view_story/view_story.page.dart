import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/chapter_model.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

import '../../widget/loading_shimmer.dart';
import '../../widget/search_textfield.dart';

class ViewStoryPage extends StatefulWidget {
  const ViewStoryPage({super.key});

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
        viewModel.init();
      },
      builder: (context, viewModel, child) {
        return BasePage(
            showAppBar: _showAppBar,
            title: viewModel.isBusy
                ? ''
                : 'Chapter ${viewModel.currentChapter!.chapterNumber.toString()}',
            body: viewModel.isBusy
                ? Center(child: GradientLoadingWidget())
                : SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        ...viewModel.currentChapter!.images
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
                          onTap: () {},
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
                                    builder: (context, _setState) {
                                  return listChapterBottomSheet(context,
                                      _setState, viewModel.currentStory);
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
                          onTap: () {},
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

  Container listChapterBottomSheet(
      BuildContext context, StateSetter _setState, Story story) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: const BoxDecoration(
          color: AppColor.bottomSheetColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(right: 20, left: 20, top: 30, bottom: 10),
            child: SearchTextField(
              seatchController: TextEditingController(),
              onChanged: () {},
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    _setState(() {
                      showNewStories = true;
                    });
                  },
                  child: Text(
                    'Mới nhất',
                    style: TextStyle(
                        color: showNewStories ? Colors.red : Colors.white),
                  )),
              TextButton(
                  onPressed: () {
                    _setState(() {
                      showNewStories = false;
                    });
                  },
                  child: Text(
                    'Cũ nhất',
                    style: TextStyle(
                        color: showNewStories ? Colors.white : Colors.red),
                  ))
            ],
          ),
          SizedBox(
            height: 290,
            child: ListView.builder(
                itemCount: story.chapters!.length,
                itemBuilder: (context, index) {
                  return chapterCard(story.chapters![index]);
                }),
          )
        ],
      ),
    );
  }

  Container chapterCard(Chapter chapter) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: AppColor.primary, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                chapter.images.first,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chapter ${chapter.chapterNumber}',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                chapter.title,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              )
            ],
          )
        ],
      ),
    );
  }
}
