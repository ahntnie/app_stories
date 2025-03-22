import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/constants/colors/app_theme.dart';
import 'package:app_stories/utils/build_context_extension.dart';
import 'package:app_stories/view_model/post_stories.vm.dart';
import 'package:app_stories/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../view_model/mystories.vm.dart';
import '../../widget/base_page.dart';
import 'widget/custom_textfield.dart';
import 'widget/image_card.dart';
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildSectionTitle(context, 'Tên truyện'),
                  _buildTextField(
                    controller: viewModel.storyNameController,
                    context: context,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Thể loại truyện'),
                  _buildCategoryDropdown(viewModel, context),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Tóm tắt truyện'),
                  CustomTextField(
                    controller: viewModel.summaryController,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, 'Giấy tờ bản quyền'),
                  if (viewModel.copyrightDocumentsImages.isNotEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 5,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: viewModel.copyrightDocumentsImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ImageCard(
                              urlImage: null,
                              fileImage:
                                  viewModel.copyrightDocumentsImages[index],
                            ),
                          );
                        },
                      ),
                    ),
                  UploadButton(
                    onPressed: () => viewModel.chooseCopyrightDocumentsImages(),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, 'Ảnh bìa truyện'),
                  if (viewModel.coverImage != null)
                    Center(
                      child: ImageCard(
                        urlImage: null,
                        fileImage: viewModel.coverImage,
                      ),
                    ),
                  UploadButton(
                    onPressed: () => viewModel.chooseCoverImage(),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, 'Chap truyện'),
                  if (viewModel.chaptersImages.isNotEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 5,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: viewModel.chaptersImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ImageCard(
                              urlImage: null,
                              fileImage: viewModel.chaptersImages[index],
                            ),
                          );
                        },
                      ),
                    ),
                  UploadButton(
                    onPressed: () => viewModel.chooseChaptersImagesImages(),
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.center,
                    child: CustomButton(
                      isLoading: viewModel.isBusy,
                      onPressed: () async {
                        await viewModel.submitRequest();
                        await widget.myStoriesViewModel.getMyStories();
                      },
                      color: AppColor.successColor,
                      title: Text(
                        'Gửi yêu cầu phê duyệt',
                        style: AppTheme.titleMedium18.copyWith(
                          color: AppColors.mono0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: AppTheme.titleMedium18.copyWith(
        color: context.primaryTextColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required BuildContext context,
  }) {
    return TextField(
      cursorColor: context.primaryTextColor,
      controller: controller,
      style: AppTheme.titleSmall16.copyWith(color: context.primaryTextColor),
      decoration: InputDecoration(
        filled: true,
        fillColor: context.primaryTextColor.withOpacity(0.05),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: context.primaryTextColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.primaryTextColor),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(
      PostStoriesViewModel viewModel, BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return viewModel.categories.map((category) {
          return PopupMenuItem<String>(
            value: category.name,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                bool isSelected =
                    viewModel.selectedCategoryIds.contains(category.categoryId);
                return Row(
                  children: [
                    Checkbox(
                      value: isSelected,
                      activeColor: context.primaryTextColor,
                      onChanged: (bool? value) {
                        setState(() {
                          viewModel.currentCategory = category;
                          viewModel.onSelectCategories(value!);
                        });
                      },
                    ),
                    Text(category.name!, style: AppTheme.titleSmall16),
                  ],
                );
              },
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: context.primaryTextColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.primaryTextColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                viewModel.genreController.text.isEmpty
                    ? 'Chọn thể loại'
                    : viewModel.genreController.text,
                style: AppTheme.titleSmall16
                    .copyWith(color: context.primaryTextColor),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: context.primaryTextColor),
          ],
        ),
      ),
    );
  }
}
