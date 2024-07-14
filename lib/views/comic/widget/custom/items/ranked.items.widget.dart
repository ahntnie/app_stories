import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/chapter_model.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/view_model/comic.vm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RankedItems extends StatefulWidget {
  RankedItems({
    super.key,
    this.tabName,
    required this.data,
    required this.onTap,
    required this.comicViewModel,
  });
  String? tabName;
  final Story data;
  final VoidCallback onTap;
  ComicViewModel comicViewModel;

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
            //viewModel.viewContext = context;
            onTap: widget.onTap,
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.data.coverImage!.first != null)
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
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
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
                      children: [
                        Text(
                          widget.data.title!,
                          style: TextStyle(
                            fontSize: AppFontSize.sizeMedium,
                            color: AppColor.extraColor,
                            fontWeight: AppFontWeight.bold,
                          ),
                        ),
                        Text(
                          'Chapter ${widget.data.chapterCount!.toString()}',
                          style: TextStyle(
                            fontSize: AppFontSize.sizeSmall,
                            color: AppColor.inwellColor,
                            fontWeight: AppFontWeight.bold,
                          ),
                        ),
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
                            const Icon(Icons.favorite,
                                color: AppColor.selectColor),
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
                              '${widget.data.totalComment}',
                              style: TextStyle(
                                  fontSize: AppFontSize.sizeSmall,
                                  color: AppColor.extraColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 80,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              timeDifference(
                                  widget.data.createdAt!.toIso8601String()),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  String timeDifference(String inputTime) {
    DateTime inputDateTime = DateTime.parse(inputTime).toUtc();
    DateTime currentDateTime = DateTime.now().toUtc();
    Duration duration = currentDateTime.difference(inputDateTime);

    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;

    String result = '';

    if (days > 0) {
      result = '$days ngày trước';
    }
    if (days == 0) {
      if (hours > 0) {
        result += '$hours giờ trước';
      }
      if (result.isEmpty) {
        result = 'Vừa mới đây';
      }
    }
    return result.trim();
  }
}
