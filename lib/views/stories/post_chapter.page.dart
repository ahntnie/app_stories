import 'package:app_stories/models/chapter_model.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/view_model/post_chap.vm.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:app_stories/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../view_model/mystories.vm.dart';
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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => PostChapViewModel(),
      onViewModelReady: (viewModel) {
        viewModel.viewContext = context;
        viewModel.currentStory = widget.data;
        viewModel.currentChapter = widget.data.chapters!.first;
        //viewModel.getListImageChapter(0);
      },
      builder: (context, viewModel, child) {
        //viewModel.getStoryById();
        print('Hình: ${viewModel.currentChapter.images[0]}');
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
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, // Số cột trong grid
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: viewModel.newChapterImages.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return CustomButton(
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
                                  );
                                }
                                return ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: ImageCard(
                                      urlImage: null,
                                      fileImage:
                                          viewModel.newChapterImages[index - 1],
                                    ));
                              },
                            ))
                      : viewModel.currentChapter.images.isNotEmpty
                          ? GridView.builder(
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
                                return ImageCard(
                                    urlImage:
                                        viewModel.currentChapter.images[index]);
                              },
                            )
                          : const Center(child: Text('No images found.')),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
