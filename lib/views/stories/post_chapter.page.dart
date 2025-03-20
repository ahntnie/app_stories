import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/chapter_model.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/view_model/post_chap.vm.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:app_stories/widget/custom_button.dart';
import 'package:app_stories/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:stacked/stacked.dart';

import '../../view_model/mystories.vm.dart';
import '../../widget/pop_up.dart';
import 'widget/image_card.dart';

class PostChapterPage extends StatefulWidget {
  final Story data;
  final MyStoriesViewModel viewModel;
  const PostChapterPage(
      {super.key, required this.data, required this.viewModel});

  @override
  State<PostChapterPage> createState() => _PostChapterPageState();
}

class _PostChapterPageState extends State<PostChapterPage> {
  bool showChapters = false;
  late PostChapViewModel viewModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = PostChapViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => viewModel,
      onViewModelReady: (viewModel) {
        print('vào onViewModelReady');
        viewModel.viewContext = context;
        viewModel.currentStory = widget.data;
        viewModel.currentChapter = widget.data.chapters!.first;
        viewModel.oldIndex = List.generate(
            viewModel.currentChapter.images.length,
            (int index) => int.parse(viewModel.currentChapter.images[index]
                .split('/')
                .last
                .split('.')
                .first
                .split('_')
                .last),
            growable: true);
      },
      builder: (context, viewModel, child) {
        return BasePage(
          title: 'Đăng truyện',
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        title: Text(
                          'Chapter ${viewModel.showAddChapter ? (viewModel.currentStory.chapterCount! + 1) : viewModel.currentChapter.chapterNumber}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => viewModel.changeShowChapter(),
                      ),
                      viewModel.showAddChapter
                          ? CustomButton(
                              isLoading: viewModel.isBusy,
                              title: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tải lên',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  Icon(
                                    Icons.file_upload_outlined,
                                    color: Colors.white,
                                    size: 30,
                                  )
                                ],
                              ),
                              onPressed: () async {
                                await viewModel.postChapter();
                                widget.viewModel.getMyStories();
                              },
                            )
                          : CustomButton(
                              title: const Icon(
                                Icons.add_circle_outline,
                                size: 35,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                viewModel.showChapters = false;
                                viewModel.changeShowAddChapter();
                              },
                            )
                    ],
                  ),
                  if (viewModel.showChapters) ...[
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                          itemCount: viewModel.currentStory.chapters!.length,
                          itemBuilder: (context, index) {
                            Chapter chapter =
                                viewModel.currentStory.chapters![index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: ListTile(
                                title: Text(
                                  'Chapter ${chapter.chapterNumber}: ${chapter.title}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  viewModel.currentChapter = chapter;
                                  viewModel.showAddChapter = false;
                                  viewModel.oldIndex = List.generate(
                                      viewModel.currentChapter.images.length,
                                      (int index) => int.parse(viewModel
                                          .currentChapter.images[index]
                                          .split('/')
                                          .last
                                          .split('.')
                                          .first
                                          .split('_')
                                          .last),
                                      growable: true);
                                  // viewModel.currentChapter.images = viewModel
                                  //     .currentStory.chapters![index].images;
                                  print('Nhấn đổi chap');
                                  print(
                                      'Thứ tự chỉnh sửa: ${viewModel.oldIndex}');
                                  viewModel.notifyListeners();
                                  // viewModel.getListImageChapter(
                                  //     chapter.chapterNumber - 1);
                                },
                              ),
                            );
                          }),
                    )
                  ],
                  if (viewModel.showAddChapter)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Row(
                        children: [
                          const Text(
                            'Tiêu đề: ',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              cursorColor: Colors.white,
                              controller: viewModel.titleChapterController,
                              style: const TextStyle(color: Colors.white),
                              textAlignVertical: TextAlignVertical.bottom,
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  viewModel.showAddChapter
                      ? (viewModel.newChapterImages.isEmpty
                          ? CustomButton(
                              onPressed: () {
                                viewModel.chooseNewChapterImages();
                              },
                              title: const Center(
                                child: Icon(
                                  Icons.add_circle_outline,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : ReorderableGridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: viewModel.newChapterImages.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return ReorderableDragStartListener(
                                    key: const ValueKey('add'),
                                    index: index,
                                    child: CustomButton(
                                      onPressed: () {
                                        viewModel.chooseNewChapterImages();
                                      },
                                      title: const Center(
                                        child: Icon(
                                          Icons.add_circle_outline,
                                          size: 80,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return ReorderableDragStartListener(
                                  key: ValueKey(
                                      viewModel.newChapterImages[index - 1]),
                                  index: index,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: ImageCard(
                                      urlImage: null,
                                      fileImage:
                                          viewModel.newChapterImages[index - 1],
                                    ),
                                  ),
                                );
                              },
                              onReorder: (oldIndex, newIndex) {
                                // Adjust the newIndex if it's greater than the list length
                                if (newIndex >
                                    viewModel.newChapterImages.length) {
                                  newIndex = viewModel.newChapterImages.length;
                                }
                                if (newIndex == 0 || oldIndex == 0) {
                                  return;
                                }

                                final item = viewModel.newChapterImages
                                    .removeAt(oldIndex - 1);
                                viewModel.newChapterImages
                                    .insert(newIndex - 1, item);
                                viewModel
                                    .notifyListeners(); // Call this method to update the UI
                              },
                            ))
                      : viewModel.currentChapter.images.isNotEmpty
                          ? ReorderableGridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: viewModel.currentChapter.images.length,
                              itemBuilder: (context, index) {
                                return ReorderableDragStartListener(
                                  key: ValueKey(
                                      viewModel.currentChapter.images[index]),
                                  index: index,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: ImageCard(
                                      isLoad: true, //viewModel.isLoadImage,
                                      urlImage: viewModel
                                          .currentChapter.images[index],
                                    ),
                                  ),
                                );
                              },
                              onReorder: (oldIndex, newIndex) {
                                print('newIndex: $newIndex');
                                print('oldIndex: $oldIndex');
                                final int index =
                                    viewModel.oldIndex.removeAt(oldIndex);
                                viewModel.oldIndex.insert(newIndex, index);
                                final item = viewModel
                                    .currentStory
                                    .chapters![
                                        viewModel.currentChapter.chapterNumber -
                                            1]
                                    .images
                                    .removeAt(oldIndex);
                                viewModel
                                    .currentStory
                                    .chapters![
                                        viewModel.currentChapter.chapterNumber -
                                            1]
                                    .images
                                    .insert(newIndex, item);
                                viewModel.notifyListeners();
                              },
                            )
                          : const Center(child: Text('No images found.')),
                ],
              ),
            ),
          ),
          bottomSheet: !viewModel.showAddChapter
              ? GestureDetector(
                  onTap: () async {
                    print('Nhấn cập nhật');
                    await viewModel.updateChapter();
                    await widget.viewModel.getMyStories();
                    // widget
                    //     .viewModel
                    //     .myStories
                    //     .chapters![viewModel.currentChapter.chapterNumber - 1]
                    //     .images = viewModel.currentChapter.images;
                    // widget.viewModel.myStories
                    //         .where((story) =>
                    //             story.storyId == viewModel.currentStory.storyId)
                    //         .toList()
                    //         .first
                    //         .chapters![viewModel.currentChapter.chapterNumber - 1]
                    //         .images =
                    //     viewModel
                    //         .currentStory
                    //         .chapters![
                    //             viewModel.currentChapter.chapterNumber - 1]
                    //         .images;
                    // widget.viewModel.notifyListeners();
                    print(widget.viewModel.myStories.length);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return PopUpWidget(
                            icon: Image.asset("assets/ic_success.png"),
                            title: 'Cập nhật truyện thành công',
                            leftText: 'Xác nhận',
                            onLeftTap: () {
                              Navigator.pop(context);
                            },
                          );
                        });
                  },
                  child: Container(
                    height: 70,
                    width: double.infinity,
                    color: AppColor.buttonColor,
                    alignment: Alignment.center,
                    child: viewModel.isBusy
                        ? GradientLoadingWidget()
                        : const Text(
                            'Cập nhật',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                )
              : null,
        );
      },
    );
  }

  // Hàm kiểm tra thứ tự tăng dần
  bool _isAscending(List<int> list) {
    for (int i = 0; i < list.length - 1; i++) {
      if (list[i] > list[i + 1]) {
        return false;
      }
    }
    return true;
  }
}
