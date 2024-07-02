import 'package:app_stories/view_model/post_stories.vm.dart';
import 'package:app_stories/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../view_model/mystories.vm.dart';
import '../../widget/base_page.dart';
import 'widget/image_card.dart';
import 'widget/custom_textfield.dart';
import 'widget/upload_button.dart';

class PostStoriesPage extends StatefulWidget {
  final MyStoriesViewModel myStoriesViewModel;
  const PostStoriesPage({super.key, required this.myStoriesViewModel});

  @override
  State<PostStoriesPage> createState() => _PostStoriesPageState();
}

class _PostStoriesPageState extends State<PostStoriesPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostStoriesViewModel>.reactive(
        viewModelBuilder: () => PostStoriesViewModel(),
        onViewModelReady: (viewModel) {
          viewModel.viewContext = context;
          viewModel.init();
        },
        builder: (context, viewModel, child) {
          return BasePage(
            title: 'Đăng truyện',
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Tên truyện: ',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            cursorColor: Colors.white,
                            controller: viewModel.storyNameController,
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Thể loại truyện: ',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: PopupMenuButton<String>(
                            itemBuilder: (BuildContext context) {
                              return viewModel.categories.map((category) {
                                return PopupMenuItem<String>(
                                  value: category.name,
                                  child: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      bool isSelected = viewModel
                                          .selectedCategoryIds
                                          .contains(category.categoryId);
                                      return Row(
                                        children: [
                                          Checkbox(
                                            value: isSelected,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                viewModel.currentCategory =
                                                    category;
                                                viewModel
                                                    .onSelectCategories(value!);
                                              });
                                            },
                                          ),
                                          Text(category.name!),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              }).toList();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 10.0),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.white),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      viewModel.genreController.text.isEmpty
                                          ? 'Chọn thể loại'
                                          : viewModel.genreController.text,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_drop_down,
                                      color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Tên tác giả: ',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            cursorColor: Colors.white,
                            controller: viewModel.authorNameController,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
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
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tóm tắt truyện: ',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomTextField(
                          controller: viewModel.summaryController,
                          maxLines: 5,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Các giấy tờ liên quan đến bản quyền:',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    if (viewModel.copyrightDocumentsImages.isNotEmpty)
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 5,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                viewModel.copyrightDocumentsImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  child: ImageCard(
                                    urlImage: null,
                                    fileImage: viewModel
                                        .copyrightDocumentsImages[index],
                                  ));
                            }),
                      ),
                    UploadButton(
                      onPressed: () {
                        viewModel.chooseCopyrightDocumentsImages();
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Ảnh bìa truyện',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    if (viewModel.coverImage != null)
                      Align(
                        alignment: Alignment.center,
                        child: ImageCard(
                          urlImage: null,
                          fileImage: viewModel.coverImage,
                        ),
                      ),
                    UploadButton(
                      onPressed: () {
                        viewModel.chooseCoverImage();
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Chap truyện',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    if (viewModel.chaptersImages.isNotEmpty)
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 5,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: viewModel.chaptersImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1.0),
                                child: ImageCard(
                                  urlImage: null,
                                  fileImage: viewModel.chaptersImages[index],
                                ),
                              );
                            }),
                      ),
                    UploadButton(
                      onPressed: () {
                        viewModel.chooseChaptersImagesImages();
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomButton(
                        isLoading: viewModel.isBusy,
                        onPressed: () async {
                          await viewModel.submitRequest();
                          await widget.myStoriesViewModel.getMyStories();
                        },
                        title: const Text(
                          'Gửi yêu cầu phê duyệt',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
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
