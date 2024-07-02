import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/view_model/comic.vm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RankedItems extends StatelessWidget {
  RankedItems(
      {super.key,
      required this.tabName,
      required this.data,
      required this.onTap});
  String tabName;
  final Story data;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => ComicViewModel(),
        onViewModelReady: (viewModel) {
          viewModel.viewContext = context;
          viewModel.init();
        },
        builder: (context, viewModel, child) {
          return InkWell(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data.coverImage!.first != null)
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Image.network(
                        data.coverImage!.first,
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
                          data.title!,
                          style: TextStyle(
                            fontSize: AppFontSize.sizeMedium,
                            color: AppColor.extraColor,
                            fontWeight: AppFontWeight.bold,
                          ),
                        ),
                        Text(
                          'Chapter ${data.chapterCount!.toString()}',
                          style: TextStyle(
                            fontSize: AppFontSize.sizeSmall,
                            color: AppColor.inwellColor,
                            fontWeight: AppFontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
