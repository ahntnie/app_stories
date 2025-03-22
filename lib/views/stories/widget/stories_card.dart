import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/constants/colors/app_theme.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/utils/build_context_extension.dart';
import 'package:app_stories/widget/custom_button.dart';
import 'package:app_stories/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';

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
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.mono40),
          color: context.primaryBackgroundColor, // Nền card tối ưu
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                          child: GradientLoadingWidget(),
                        ),
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    print('Lỗi: $exception');
                    return Text(
                      'Failed to load image',
                      style: AppTheme.titleSmall16,
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
                    style: AppTheme.titleExtraLarge24,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Chapter ${widget.data.chapterCount!.toString()}',
                    style: AppTheme.titleMedium18
                        .copyWith(color: AppColors.mono60),
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
                                    ? AppColor.successColor
                                    : AppColors.rambutan100,
                                title: Text(
                                  widget.data.isCompleted!
                                      ? "Đã hoàn thành"
                                      : 'Hoàn thành',
                                  style: AppTheme.titleSmall16,
                                ),
                                onPressed: () {
                                  widget.viewModel.currentStory = widget.data;
                                  widget.viewModel.completedStory();
                                }),
                          ),
                        ),
                      if (widget.data.active == 0)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.orange,
                                  width: 1.5), // Chờ duyệt: màu cam
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Đang chờ duyệt',
                              style: AppTheme.titleSmall16,
                            ),
                          ),
                        ),
                      if (widget.data.active == 2)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.red,
                                  width: 1.5), // Vô hiệu hóa: màu đỏ
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Đã vô hiệu hóa',
                              style: AppTheme.titleSmall16,
                            ),
                          ),
                        ),
                      if (widget.data.active == 3)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.yellow,
                                  width: 1.5), // Chờ duyệt lại: màu vàng
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Đang chờ duyệt lại',
                              style: AppTheme.titleSmall16,
                            ),
                          ),
                        ),
                    ]
                  ],
                  if (widget.viewModel.currentUser.role == 'admin') ...[
                    if (widget.data.active == 0)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.orange,
                                width: 1.5), // Chờ duyệt: màu cam
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Đang chờ duyệt',
                            style: AppTheme.titleSmall16,
                          ),
                        ),
                      ),
                    if (widget.data.active == 3 &&
                        widget.data.author!.name !=
                            widget.viewModel.currentUser.name)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.green,
                                width: 1.5), // Đã duyệt: màu xanh
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Đã duyệt',
                            style: AppTheme.titleSmall16,
                          ),
                        ),
                      ),
                    if (widget.data.active == 2 &&
                        widget.data.author!.name !=
                            widget.viewModel.currentUser.name)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.red,
                                width: 1.5), // Vô hiệu hóa: màu đỏ
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Đã vô hiệu hóa',
                            style: AppTheme.titleSmall16,
                          ),
                        ),
                      ),
                    if (widget.data.active == 1 &&
                        widget.data.author!.name !=
                            widget.viewModel.currentUser.name)
                      Align(
                        alignment: Alignment.centerRight,
                        child: CustomButton(
                          color: AppColor.selectColor,
                          onPressed: widget.onPressed!,
                          title: Text(
                            'Vô hiệu hóa truyện',
                            style: AppTheme.titleLarge20,
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
