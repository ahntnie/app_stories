import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/chapter_model.dart';
import 'package:app_stories/view_model/comic.vm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChapterCard extends StatefulWidget {
  ChapterCard(
      {super.key,
      required this.chapter,
      required this.viewModel,
      required this.onPressed});
  Chapter chapter;
  ComicViewModel viewModel;
  VoidCallback onPressed;
  @override
  State<ChapterCard> createState() => _ChapterCardState();
}

class _ChapterCardState extends State<ChapterCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      //  () {
     
      // },
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: AppColor.primary, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.chapter.images.first,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chapter ${widget.chapter.chapterNumber}',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  widget.chapter.title,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
