import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/chapter_model.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/views/stories/stories_view/chapter/chapter.widget.dart';
import 'package:app_stories/views/stories/stories_view/comment/comment.widget.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ComicDetailPage extends StatefulWidget {
  const ComicDetailPage(
      {super.key, required this.data, required this.viewModel});
  final Story data;
  final ComicViewModel viewModel;

  @override
  State<ComicDetailPage> createState() => _ComicDetailPageState();
}

class _ComicDetailPageState extends State<ComicDetailPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ComicViewModel>.reactive(
        disposeViewModel: false,
        viewModelBuilder: () => widget.viewModel,
        onViewModelReady: (viewModel) => viewModel.init(),
        builder: (context, viewModel, child) {
          return BasePage(
            showAppBar: false,
            isLoading: viewModel.isBusy,
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
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
                          InkWell(
                            onTap: () {
                              viewModel.postFavourite(
                                  viewModel.currentStory.storyId);
                            },
                            child: Positioned(
                              top: 8,
                              right: 8,
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
                                  viewModel.isFavourite
                                      ? 'Đang theo dõi '
                                      : 'Theo dõi',
                                  style: TextStyle(
                                      color: AppColor.extraColor,
                                      fontSize: AppFontSize.sizeSmall),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Nhóm dịch: Tiến Thành',
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
                            '155k',
                            style: TextStyle(
                                fontSize: AppFontSize.sizeSmall,
                                color: AppColor.extraColor),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.favorite, color: Colors.red),
                          const SizedBox(width: 4),
                          Text(
                            '155k',
                            style: TextStyle(
                                fontSize: AppFontSize.sizeSmall,
                                color: AppColor.extraColor),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.comment, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text(
                            '28',
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
                          Text(
                            'Tổng 2 bình luận',
                            style: TextStyle(
                                fontSize: AppFontSize.sizeSmall,
                                fontWeight: AppFontWeight.bold,
                                color: AppColor.inwellColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                            shrinkWrap: true,
                            // physics: const NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return CommentWidget(
                                username: 'Thành',
                                comment: 'Truyện hay!',
                                chapter: 'Chapter 9',
                                time: '06/06/2024 17:20',
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
                              const SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                child: Text(
                                  "Cũ nhất",
                                  style: TextStyle(
                                      fontSize: AppFontSize.sizeSmall,
                                      color: AppColor.extraColor),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                            //shrinkWrap: true,
                            // physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.data.chapters!.length,
                            itemBuilder: (context, index) {
                              return ChapterWidget(
                                chapter: widget.data.chapters![index],
                                onTap: () {
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
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.black45),
                        child: const Icon(
                          Icons.close,
                          color: AppColor.extraColor,
                          size: 40,
                        ),
                      ),
                    ))
              ],
            ),
          );
        });
  }
}
