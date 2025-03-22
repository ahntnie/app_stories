import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/constants/colors/app_theme.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/utils/build_context_extension.dart';
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
                        Text('Tên truyện: ', style: AppTheme.titleMedium18),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            cursorColor: AppColors.mono0,
                            style: AppTheme.titleMedium18
                                .copyWith(color: context.primaryTextColor),
                            enabled: false,
                            controller: viewModel.titleController,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.mono0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.mono0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Thể loại truyện: ',
                            style: AppTheme.titleMedium18),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            cursorColor: AppColors.mono0,
                            style: AppTheme.titleMedium18
                                .copyWith(color: context.primaryTextColor),
                            enabled: false,
                            controller: viewModel.genreController,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.mono0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.mono0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Tên tác giả: ', style: AppTheme.titleMedium18),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            cursorColor: AppColors.mono0,
                            controller: viewModel.authorNameController,
                            style: AppTheme.titleMedium18
                                .copyWith(color: context.primaryTextColor),
                            enabled: false,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.mono0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.mono0),
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
                        Text('Tóm tắt truyện: ', style: AppTheme.titleMedium18),
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
                    Text('Các giấy tờ liên quan đến bản quyền:',
                        style: AppTheme.titleMedium18),
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
                    Text('Ảnh bìa truyện', style: AppTheme.titleMedium18),
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
                    Text('Chap đầu tiên', style: AppTheme.titleMedium18),
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
                    if (widget.data.active == 3)
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              "Đã từ chối duyệt",
                              style: AppTheme.titleMedium18
                                  .copyWith(color: AppColors.rambutan100),
                            )
                          ],
                        ),
                      ),
                    if (widget.data.active == 1)
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              "Truyện đã được phê duyệt thành công",
                              style: AppTheme.titleMedium18
                                  .copyWith(color: AppColors.watermelon100),
                            )
                          ],
                        ),
                      ),
                    if (widget.data.active == 2)
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              "Truyện đã bị vô hiệu hóa",
                              style: AppTheme.titleMedium18
                                  .copyWith(color: AppColors.cempedak100),
                            )
                          ],
                        ),
                      ),
                    if (widget.data.active == 0)
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            CustomButton(
                              color: AppColor.successColor,
                              isLoading: viewModel.isBusy,
                              onPressed: () async {
                                await viewModel.approveStory();
                              },
                              title: Text('Phê duyệt truyện',
                                  style: AppTheme.titleLarge20),
                            ),
                            CustomButton(
                              color: AppColors.rambutan100,
                              isLoading: viewModel.isBusy,
                              onPressed: () async {
                                await viewModel.noApproveStory();
                              },
                              title: Text('Không duyệt',
                                  style: AppTheme.titleLarge20),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
