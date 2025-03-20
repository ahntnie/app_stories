import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/constants/colors/app_theme.dart';
import 'package:app_stories/utils/build_context_extension.dart';
import 'package:app_stories/views/stories/stories_view/bottomcomment/widget/comment_card.wiget.dart';
import 'package:app_stories/views/stories/stories_view/category/category.wiget.dart';
import 'package:app_stories/views/stories/stories_view/summary/summary.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app_sp.dart';
import '../../../app/app_sp_key.dart';
import '../../../constants/app_color.dart';
import '../../../models/story_model.dart';
import '../../../styles/app_font.dart';
import '../../../view_model/comic.vm.dart';
import '../../../view_model/notification.vm.dart';
import '../../../widget/base_page.dart';
import '../../../widget/pop_up.dart';
import '../../authentication/login.page.dart';
import '../../view_story/widget/chaptercard.wiget.dart';
import 'bottomcomment/bottom_total_comment.widget.dart';
import 'chapter/chapter.widget.dart';
import 'comment/comment.widget.dart';

class ComicDetailPage extends StatefulWidget {
  const ComicDetailPage({
    super.key,
    required this.data,
    required this.viewModel,
  });

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
      setState(() => _showAppBar = false);
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() => _showAppBar = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate dynamic dimensions based on screen size
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double padding = screenWidth * 0.02; // 2% of screen width
    final double imageHeight = screenHeight * 0.5; // 40% of screen height

    return ViewModelBuilder<ComicViewModel>.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => widget.viewModel,
      onViewModelReady: (viewModel) async {
        viewModel.checkFavourite();
        await viewModel.getCommentByStory();
        if (AppSP.get(AppSPKey.currrentUser)?.isNotEmpty ?? false) {
          await widget.viewModel.addViewStory();
        }
      },
      builder: (context, viewModel, child) {
        viewModel.viewContext = context;
        return BasePage(
          showAppBar: false,
          isLoading: viewModel.isBusy,
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.data.coverImage!.first,
                        width: double.infinity,
                        height: imageHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: padding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.data.title!,
                            style: AppTheme.titleExtraLarge24,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.data.author!.id !=
                                viewModel.currentUsers?.id &&
                            viewModel.currentUsers?.role != 'admin')
                          PopupMenuButton<int>(
                            icon: Icon(
                              CupertinoIcons.info_circle_fill,
                              size: screenWidth * 0.08,
                              color: AppColors.rambutan100,
                            ),
                            onSelected: (item) {
                              _handleReport(context, viewModel);
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem<int>(
                                value: 0,
                                child: Text('Báo cáo'),
                              ),
                            ],
                          ),
                      ],
                    ),
                    Text(
                      'Tác giả: ${widget.data.author!.name}',
                      style: AppTheme.titleSmall16,
                    ),
                    SizedBox(height: padding),
                    Row(
                      children: [
                        Icon(CupertinoIcons.eye_fill,
                            color: AppColors.cempedak100),
                        SizedBox(width: padding / 2),
                        Text(
                          widget.data.totalView.toString(),
                          style: AppTheme.titleSmall16,
                        ),
                        SizedBox(width: padding * 2),
                        const Icon(CupertinoIcons.heart_circle_fill,
                            color: AppColors.rambutan100),
                        SizedBox(width: padding / 2),
                        Text(
                          '${viewModel.currentStory.favouriteUser!.length}',
                          style: AppTheme.titleSmall16,
                        ),
                        SizedBox(width: padding * 2),
                        const Icon(CupertinoIcons.chat_bubble_2_fill,
                            color: AppColors.blueberry100),
                        SizedBox(width: padding / 2),
                        Text(
                          '${viewModel.comments.length}',
                          style: AppTheme.titleSmall16,
                        ),
                      ],
                    ),
                    if (viewModel.categories.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.all(padding),
                        child: SizedBox(
                          height: screenHeight * 0.04,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                viewModel.currentStory.categories!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return CategoryWidget(
                                story: viewModel.currentStory,
                                category: viewModel.categories[index],
                              );
                            },
                          ),
                        ),
                      ),
                    ExpandableText(viewModel.currentStory.summary!),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Bình luận', style: AppTheme.titleSmall16),
                        InkWell(
                          onTap: () =>
                              _showCommentsBottomSheet(context, viewModel),
                          child: Text(
                            'Tổng ${viewModel.comments.length} bình luận',
                            style: AppTheme.titleMedium18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: padding),
                    if (viewModel.comments.isNotEmpty)
                      SizedBox(
                        height: screenHeight * 0.25,
                        child: ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          itemCount: viewModel.comments.take(5).length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return TotalCommentCard(
                              comment: viewModel.comments[index],
                              currentUserID: viewModel.idUser,
                              comicViewModel: viewModel,
                              isTotalComment: false,
                            );
                          },
                        ),
                      ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Chapter', style: AppTheme.titleExtraLarge24),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                viewModel.showNewStories = true;
                                viewModel.notifyListeners();
                              },
                              child: Text(
                                'Mới nhất',
                                style: TextStyle(
                                  color: viewModel.showNewStories
                                      ? AppColors.watermelon100
                                      : context.secondaryTextColor,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                viewModel.showNewStories = false;
                                viewModel.notifyListeners();
                              },
                              child: Text(
                                'Cũ nhất',
                                style: TextStyle(
                                  color: viewModel.showNewStories
                                      ? context.secondaryTextColor
                                      : AppColors.watermelon100,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: padding),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.data.chapters!.length,
                      itemBuilder: (context, index) {
                        final chapters = viewModel.showNewStories
                            ? widget.data.chapters!
                            : widget.data.chapters!.reversed.toList();
                        return ChapterCard(
                          chapter: chapters[index],
                          viewModel: viewModel,
                          onPressed: () {
                            viewModel.currentChapter = chapters[index];
                            viewModel.viewContext = context;
                            viewModel.detailChapter();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: padding,
                left: padding,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                    padding: EdgeInsets.all(padding / 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.black45,
                    ),
                    child: Icon(
                      Icons.close,
                      color: AppColor.extraColor,
                      size: screenWidth * 0.1,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: padding,
                right: padding,
                child: InkWell(
                  onTap: () => _handleFavourite(context, viewModel),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: padding * 3,
                      vertical: padding,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: viewModel.isFavourite
                          ? AppColor.successColor
                          : AppColors.rambutan100,
                    ),
                    child: Text(
                      viewModel.isFavourite ? 'Đang theo dõi' : 'Theo dõi',
                      style: TextStyle(
                        color: AppColor.extraColor,
                        fontSize: AppFontSize.sizeSmall,
                      ),
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

  void _handleReport(BuildContext context, ComicViewModel viewModel) {
    if (AppSP.get(AppSPKey.currrentUser)?.isNotEmpty ?? false) {
      NotificationViewModel notiViewModel = NotificationViewModel()
        ..currentChapter = viewModel.currentChapter
        ..viewContext = context
        ..currentStory = viewModel.currentStory;
      notiViewModel.postNotificationReportStoryByAdmin();
      showDialog(
        context: context,
        builder: (context) => PopUpWidget(
          icon: Image.asset("assets/ic_success.png"),
          title: 'Đã gửi phản hồi',
          leftText: 'Xác nhận',
          onLeftTap: () => Navigator.pop(context),
        ),
      );
    } else {
      _showLoginDialog(context);
    }
  }

  void _showCommentsBottomSheet(
      BuildContext context, ComicViewModel viewModel) {
    showModalBottomSheet(
      isScrollControlled: isScrollControlled,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => TotalComment(
          setState: setState,
          story: viewModel.currentStory,
          comicViewModel: viewModel,
        ),
      ),
    );
  }

  void _handleFavourite(BuildContext context, ComicViewModel viewModel) async {
    if (AppSP.get(AppSPKey.currrentUser)?.isNotEmpty ?? false) {
      await viewModel.postFavourite(widget.data.storyId);
      await viewModel.getStoryActive();
      await viewModel.getStoryNew();
    } else {
      _showLoginDialog(context);
    }
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PopUpWidget(
        icon: Image.asset("assets/ic_error.png"),
        title: 'Bạn cần đăng nhập để thực hiện hành động này',
        leftText: 'Đăng nhập',
        onLeftTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        twoButton: true,
        onRightTap: () => Navigator.pop(context),
        rightText: 'Hủy',
      ),
    );
  }
}
