import 'package:app_stories/constants/api.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/view_model/browse_stories.vm.dart';
import 'package:app_stories/views/stories/post_chapter.page.dart';
import 'package:app_stories/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../constants/app_color.dart';
import '../../../view_model/mystories.vm.dart';

class StoryCard extends StatefulWidget {
  final Story data;
  final MyStoriesViewModel viewModel;
  final VoidCallback onTap;
  final VoidCallback? onPressed;
  StoryCard(
      {super.key,
      required this.data,
      required this.onTap,
      required this.viewModel,
      this.onPressed});

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 4,
        decoration: BoxDecoration(
          color: AppColor.buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            if (widget.data.coverImage?.first != null)
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Image.network(
                  widget.data.coverImage!.first,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: child);
                    } else {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    print('Lỗi: $exception');
                    return const Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.white),
                    );
                  },
                  width: MediaQuery.of(context).size.width / 4,
                  height: MediaQuery.of(context).size.height / 5,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.data.title!,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Chapter ${widget.data.chapterCount!.toString()}',
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xFF676565),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (widget.viewModel.currentUser.role == 'author') ...[
                    if (widget.data.author!.name ==
                        widget.viewModel.currentUser.name) ...[
                      if (widget.data.active == 1)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: CustomButton(
                                enable: widget.data.isCompleted! ? false : true,
                                color: !widget.data.isCompleted!
                                    ? AppColor.primary
                                    : AppColor.buttonColor,
                                title: Text(
                                  widget.data.isCompleted!
                                      ? "Đã hoàn thành"
                                      : 'Hoàn thành',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: AppFontSize.sizeSmall),
                                ),
                                onPressed: () {
                                  widget.viewModel.currentStory = widget.data;
                                  widget.viewModel.completedStory();
                                }),
                          ),
                        ),
                      if (widget.data.active == 0)
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Đang chờ duyệt',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      if (widget.data.active == 2)
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Đã vô hiệu hóa',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      if (widget.data.active == 3)
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Đang chờ duyệt lại',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                    ]
                  ],
                  if (widget.viewModel.currentUser.role == 'admin') ...[
                    if (widget.data.active == 0)
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Đang chờ duyệt',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    if (widget.data.active == 3 &&
                        widget.data.author!.name !=
                            widget.viewModel.currentUser.name)
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Đã duyệt',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    if (widget.data.active == 2 &&
                        widget.data.author!.name !=
                            widget.viewModel.currentUser.name)
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Đã vô hiệu hóa',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    if (widget.data.active == 1 &&
                        widget.data.author!.name !=
                            widget.viewModel.currentUser.name)
                      Align(
                        alignment: Alignment.centerRight,
                        child: CustomButton(
                          color: AppColor.selectColor,
                          //isLoading: viewModel.isBusy,
                          onPressed: widget.onPressed!,
                          title: const Text(
                            'Vô hiệu hóa truyện',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
