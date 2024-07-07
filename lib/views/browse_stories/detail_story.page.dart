import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/view_model/post_stories.vm.dart';
import 'package:app_stories/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../constants/api.dart';
import '../../view_model/browse_stories.vm.dart';
import '../../widget/base_page.dart';
import '../stories/widget/custom_textfield.dart';
import '../stories/widget/image_card.dart';
import '../stories/widget/upload_button.dart';

class DetailStoryPage extends StatefulWidget {
  final Story data;
  final BrowseStoriesViewModel viewModel;
  const DetailStoryPage(
      {super.key, required this.data, required this.viewModel});

  @override
  State<DetailStoryPage> createState() => _DetailStoryPageState();
}

class _DetailStoryPageState extends State<DetailStoryPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BrowseStoriesViewModel>.reactive(
        disposeViewModel: false,
        viewModelBuilder: () => widget.viewModel,
        onViewModelReady: (viewModel) => viewModel.getDetailCurrentStory(),
        builder: (context, viewModel, child) {
          return BasePage(
            title: 'Phê duyệt truyện',
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
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            enabled: false,
                            controller: viewModel.titleController,
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
                          child: TextField(
                            cursorColor: Colors.white,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            enabled: false,
                            controller: viewModel.genreController,
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
                            enabled: false,
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
                          enabled: false,
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
                    if (widget.data.licenseImage!.isNotEmpty)
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 5,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.data.licenseImage!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  child: ImageCard(
                                    urlImage: widget.data.licenseImage![index],
                                  ));
                            }),
                      ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Ảnh bìa truyện',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ImageCard(
                        urlImage: widget.data.coverImage!.first,
                        fileImage: null,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Chap đầu tiên',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    if (widget.data.chapters!.first.images.isNotEmpty)
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 5,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                widget.data.chapters!.first.images.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1.0),
                                child: ImageCard(
                                  urlImage:
                                      widget.data.chapters!.first.images[index],
                                  fileImage: null,
                                ),
                              );
                            }),
                      ),
                    const SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomButton(
                        isLoading: viewModel.isBusy,
                        onPressed: () async {
                          await viewModel.approveStory();
                        },
                        title: const Text(
                          'Phê duyệt truyện',
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
