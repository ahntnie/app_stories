import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked/stacked.dart';

import '../../../constants/app_color.dart';
import '../../../models/story_model.dart';
import '../../../styles/app_font.dart';
import '../../../view_model/comic.vm.dart';
import '../../../widget/base_page.dart';
import '../../view_story/widget/chaptercard.wiget.dart';
import 'bottomcomment/bottom_total_comment.widget.dart';
import 'chapter/chapter.widget.dart';
import 'comment/comment.widget.dart';

class ComicDetailPage extends StatefulWidget {
  const ComicDetailPage(
      {super.key, required this.data, required this.viewModel});
  final Story data;
  final ComicViewModel viewModel;

  @override
  State<ComicDetailPage> createState() => _ComicDetailPageState();
}

class _ComicDetailPageState extends State<ComicDetailPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBar = true;
  bool showNewStories = true;
  bool isScrollControlled = true;

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
    return ViewModelBuilder<ComicViewModel>.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => widget.viewModel,
      onViewModelReady: (viewModel) async {
        await viewModel.getCommentByStory();
        await viewModel.checkFavourite();
        await widget.viewModel.addViewStory();
      },
      builder: (context, viewModel, child) {
        viewModel.viewContext = context;
        return BasePage(
          showAppBar: false,
          isLoading: viewModel.isBusy,
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.data.coverImage!.first,
                        width: double.infinity,
                        height: 400,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.data.title!,
                          style: TextStyle(
                              fontSize: AppFontSize.sizeLarge,
                              fontWeight: AppFontWeight.bold,
                              color: AppColor.extraColor),
                        ),
                      ],
                    ),
                    Text(
                      'Tác giả: ${widget.data.author!.name}',
                      style: TextStyle(
                          fontSize: AppFontSize.sizeSmall,
                          color: AppColor.extraColor),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.visibility, color: Colors.orange),
                        const SizedBox(width: 4),
                        Text(
                          widget.data.totalView.toString(),
                          style: TextStyle(
                              fontSize: AppFontSize.sizeSmall,
                              color: AppColor.extraColor),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.favorite, color: AppColor.selectColor),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.data.favouriteUser!.length}',
                          style: TextStyle(
                              fontSize: AppFontSize.sizeSmall,
                              color: AppColor.extraColor),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.comment, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          '${viewModel.comments.length}',
                          style: TextStyle(
                              fontSize: AppFontSize.sizeSmall,
                              color: AppColor.extraColor),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bình luận',
                          style: TextStyle(
                              fontSize: AppFontSize.sizeMedium,
                              fontWeight: AppFontWeight.bold,
                              color: AppColor.extraColor),
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: isScrollControlled,
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return TotalComment(
                                    setState: setState,
                                    story: viewModel.currentStory,
                                    comicViewModel: viewModel,
                                  );
                                });
                              },
                            );
                          },
                          child: Text(
                            'Tổng ${viewModel.comments.length} bình luận',
                            style: TextStyle(
                                fontSize: AppFontSize.sizeSmall,
                                fontWeight: FontWeight.bold,
                                color: AppColor.inwellColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (viewModel.comments.isNotEmpty)
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                viewModel.comments.take(5).toList().length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return CommentWidget(
                                story: viewModel.currentStory,
                                comment: viewModel.comments[index],
                              );
                            }),
                      ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chapter',
                          style: TextStyle(
                              fontSize: AppFontSize.sizeMedium,
                              fontWeight: AppFontWeight.bold,
                              color: AppColor.extraColor),
                        ),
                        Row(
                          children: [
                            InkWell(
                              child: Text(
                                "Mới nhất",
                                style: TextStyle(
                                    fontSize: AppFontSize.sizeSmall,
                                    color: AppColor.extraColor),
                              ),
                            ),
                            const SizedBox(width: 5),
                            InkWell(
                              child: Text(
                                "Cũ nhất",
                                style: TextStyle(
                                    fontSize: AppFontSize.sizeSmall,
                                    color: AppColor.extraColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                          itemCount: widget.data.chapters!.length,
                          itemBuilder: (context, index) {
                            return ChapterCard(
                              chapter: widget.data.chapters![index],
                              viewModel: viewModel,
                              onPressed: () {
                                viewModel.currentChapter =
                                    viewModel.currentStory.chapters![index];
                                viewModel.detailChapter();
                              },
                            );
                          }),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 20,
                left: 10,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black45),
                    child: const Icon(
                      Icons.close,
                      color: AppColor.extraColor,
                      size: 40,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 10,
                child: InkWell(
                  onTap: () {
                    viewModel.postFavourite(viewModel.currentStory.storyId);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: viewModel.isFavourite
                          ? AppColor.inwellColor
                          : AppColor.selectColor,
                    ),
                    child: Text(
                      viewModel.isFavourite ? 'Đang theo dõi ' : 'Theo dõi',
                      style: TextStyle(
                          color: AppColor.extraColor,
                          fontSize: AppFontSize.sizeSmall),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
