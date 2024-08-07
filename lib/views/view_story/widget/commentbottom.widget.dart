import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/chapter_model.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/views/stories/stories_view/bottomcomment/widget/comment_card.wiget.dart';
import 'package:app_stories/views/view_story/widget/commentcard.widget.dart';
import 'package:app_stories/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app_sp.dart';
import '../../../app/app_sp_key.dart';
import '../../../widget/pop_up.dart';
import '../../authentication/login.page.dart';

class CommentBottom extends StatefulWidget {
  CommentBottom(
      {super.key,
      required this.setState,
      required this.story,
      required this.comicViewModel,
      required this.chapter});
  late StateSetter setState;
  Story story;
  Chapter chapter;
  ComicViewModel comicViewModel;
  bool showNewStories = true;
  @override
  State<CommentBottom> createState() => _CommentBottomState();
}

class _CommentBottomState extends State<CommentBottom> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        disposeViewModel: false,
        viewModelBuilder: () => widget.comicViewModel,
        onViewModelReady: (viewModel) {
          viewModel.currentChapter = widget.chapter;
          viewModel.currentStory = widget.story;
          viewModel.viewContext = context;
        },
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: viewModel.isBusy
                  ? GradientLoadingWidget()
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      decoration: const BoxDecoration(
                          color: AppColor.bottomSheetColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              'Chapter ${widget.chapter.chapterNumber}',
                              style: TextStyle(
                                  color: AppColor.extraColor,
                                  fontWeight: AppFontWeight.bold,
                                  fontSize: AppFontSize.sizeLarge),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Tổng ${viewModel.comments.length} bình luận",
                                  style: TextStyle(
                                      color: AppColor.extraColor,
                                      fontSize: AppFontSize.sizeSmall,
                                      fontWeight: AppFontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: viewModel.comments.length,
                                itemBuilder: (context, index) {
                                  return TotalCommentCard(
                                      comment: viewModel.comments[index],
                                      currentUserID: viewModel.idUser,
                                      comicViewModel: viewModel);
                                }),
                          ),
                          const Divider(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 40),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: viewModel.commentController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: AppColor.extraColor,
                                      hintText: 'Nhập bình luận của bạn...',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.send,
                                      color: AppColor.extraColor),
                                  onPressed: () {
                                    if (AppSP.get(AppSPKey.currrentUser) !=
                                            null &&
                                        AppSP.get(AppSPKey.currrentUser) !=
                                            '') {
                                      viewModel.postComment(
                                          viewModel.currentStory.storyId,
                                          viewModel.currentChapter!.chapterId,
                                          viewModel.commentController.text);
                                      viewModel.commentController.clear();
                                      viewModel.getCommentByChapter();
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return PopUpWidget(
                                              icon: Image.asset(
                                                  "assets/ic_error.png"),
                                              title:
                                                  'Bạn cần đăng nhập để bình luận',
                                              leftText: 'Đăng nhập',
                                              onLeftTap: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginPage(),
                                                    ));
                                              },
                                              twoButton: true,
                                              onRightTap: () {
                                                Navigator.pop(context);
                                              },
                                              rightText: 'Hủy',
                                            );
                                          });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          );
        });
  }
}
