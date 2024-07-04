import 'package:app_stories/constants/api.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/views/stories/post_chapter.page.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../view_model/mystories.vm.dart';

class StoryCard extends StatelessWidget {
  final Story data;
  final VoidCallback onTap;
  StoryCard({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    print('Đường dẫn: ${data.coverImage!.first}');
    return GestureDetector(
      onTap: () {
        // viewModel.currentStory = data;
        // viewModel.nextPostChapter();
        onTap();
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 5,
        decoration: BoxDecoration(
          color: AppColor.buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            if (data.coverImage?.first != null)
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
                mainAxisAlignment: data.active == 0
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.start,
                children: [
                  Text(
                    data.title!,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (data.active != 0)
                    const SizedBox(
                      height: 30,
                    ),
                  Text(
                    'Chapter ${data.chapterCount!.toString()}',
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xFF676565),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (data.active == 0)
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Đang chờ duyệt',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
