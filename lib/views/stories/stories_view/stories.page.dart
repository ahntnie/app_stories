import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/chapter_model.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/view_model/comic.vm.dart';
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
        onViewModelReady: (viewModel) => viewModel.getDetailCurrentStory(),
        builder: (context, viewModel, child) {
          return BasePage(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image.network(
                        widget.data.coverImage!.first,
                        width: double.infinity,
                        height: 400,
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          color: AppColor.selectColor,
                          child: const Text(
                            'Theo dõi',
                            style: TextStyle(color: AppColor.extraColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.data.title!,
                    style: TextStyle(
                        fontSize: AppFontSize.sizeLarge,
                        fontWeight: AppFontWeight.bold,
                        color: AppColor.extraColor),
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
                      // ToggleButtons(
                      //   children: [
                      //     Text('Mới nhất'),
                      //     Text('Cũ nhất'),
                      //   ],
                      //   isSelected: [true, false],
                      // ),
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
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class CommentWidget extends StatelessWidget {
  final String username;
  final String comment;
  final String chapter;
  final String time;

  const CommentWidget({
    super.key,
    required this.username,
    required this.comment,
    required this.chapter,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              'https://via.placeholder.com/150', // Thay thế bằng URL ảnh avatar thực tế
            ),
            radius: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(comment),
                const SizedBox(height: 4),
                Text(chapter),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChapterWidget extends StatelessWidget {
  Chapter chapter;
  ChapterWidget({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Image.network(
            chapter.images.first,
            width: 50,
            height: 50,
          ),
          const SizedBox(width: 8),
          Text('Chapter ${chapter.chapterNumber}'),
        ],
      ),
    );
  }
}
