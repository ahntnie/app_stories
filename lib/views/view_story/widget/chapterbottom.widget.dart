import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/views/view_story/widget/chaptercard.wiget.dart';
import 'package:app_stories/widget/search_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BottomChapter extends StatefulWidget {
  BottomChapter({
    super.key,
    required this.setState,
    required this.story,
  });
  late StateSetter setState;
  Story story;
  bool showNewStories = true;
  @override
  State<BottomChapter> createState() => _BottomChapterState();
}

class _BottomChapterState extends State<BottomChapter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: const BoxDecoration(
          color: AppColor.bottomSheetColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 20, left: 20, top: 30, bottom: 10),
            child: SearchTextField(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      widget.showNewStories = true;
                    });
                  },
                  child: Text(
                    'Mới nhất',
                    style: TextStyle(
                        color:
                            widget.showNewStories ? Colors.red : Colors.white),
                  )),
              TextButton(
                  onPressed: () {
                    setState(() {
                      widget.showNewStories = false;
                    });
                  },
                  child: Text(
                    'Cũ nhất',
                    style: TextStyle(
                        color:
                            widget.showNewStories ? Colors.white : Colors.red),
                  ))
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: ListView.builder(
                itemCount: widget.story.chapters!.length,
                itemBuilder: (context, index) {
                  return ChapterCard(chapter: widget.story.chapters![index]);
                }),
          )
        ],
      ),
    );
  }
}
