import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/constants/colors/app_theme.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/utils/build_context_extension.dart';
import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/widget/loading_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RankedItems extends StatefulWidget {
  final String? tabName;
  final Story data;
  final VoidCallback onTap;
  final ComicViewModel comicViewModel;

  const RankedItems({
    super.key,
    this.tabName,
    required this.data,
    required this.onTap,
    required this.comicViewModel,
  });

  @override
  State<RankedItems> createState() => _RankedItemsState();
}

class _RankedItemsState extends State<RankedItems> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => widget.comicViewModel,
      onViewModelReady: (viewModel) {
        viewModel.viewContext = context;
      },
      builder: (context, viewModel, child) {
        return InkWell(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.mono40),
              color: context.primaryBackgroundColor, // Nền card tối ưu
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ảnh bìa truyện
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.data.coverImage!.first ?? '',
                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.height / 6,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height / 6,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.white),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: GradientLoadingWidget());
                    },
                  ),
                ),

                const SizedBox(width: 12),

                // Thông tin truyện
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tên truyện
                      Text(
                        widget.data.title ?? 'Không có tiêu đề',
                        style: AppTheme.titleMedium18,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Số chapter
                      Text(
                        'Chapter ${widget.data.chapterCount ?? 0}',
                        style: AppTheme.titleSmall16,
                      ),

                      const SizedBox(height: 6),

                      // Các chỉ số: View - Favourite - Comment
                      Row(
                        children: [
                          Icon(CupertinoIcons.eye_fill,
                              color: AppColors.cempedak100, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            widget.data.totalView.toString(),
                            style: AppTheme.titleTiny12,
                          ),
                          const SizedBox(width: 14),
                          const Icon(CupertinoIcons.heart_circle_fill,
                              color: AppColors.rambutan100, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.data.favouriteUser!.length}',
                            style: AppTheme.titleTiny12,
                          ),
                          const SizedBox(width: 14),
                          const Icon(CupertinoIcons.chat_bubble_2_fill,
                              color: AppColors.blueberry100, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.data.totalComment}',
                            style: AppTheme.titleTiny12,
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Thời gian đăng tải
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          timeDifference(
                              widget.data.createdAt!.toIso8601String()),
                          style: AppTheme.titleTiny12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Hàm tính thời gian đăng
  String timeDifference(String inputTime) {
    DateTime inputDateTime = DateTime.parse(inputTime).toUtc();
    DateTime currentDateTime = DateTime.now().toUtc();
    Duration duration = currentDateTime.difference(inputDateTime);

    int days = duration.inDays;
    int hours = duration.inHours % 24;

    if (days > 0) return '$days ngày trước';
    if (hours > 0) return '$hours giờ trước';
    return 'Vừa mới đây';
  }
}
