import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/constants/colors/app_theme.dart';
import 'package:app_stories/models/category_model.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/utils/build_context_extension.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:app_stories/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stacked/stacked.dart';
import '../../constants/app_color.dart';
import '../../view_model/categories.vm.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh(CategoriesViewModel viewModel) async {
    await viewModel.getAllCategory();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoriesViewModel>.reactive(
      viewModelBuilder: () => CategoriesViewModel(context: context),
      onViewModelReady: (viewModel) => viewModel.getAllCategory(),
      builder: (context, viewModel, child) {
        return BasePage(
          isLoading: viewModel.isBusy,
          showAppBar: true,
          title: 'Quản lý thể loại',
          body: SmartRefresher(
            controller: _refreshController,
            onRefresh: () => _onRefresh(viewModel),
            child: viewModel.categories.isEmpty
                ? Center(
                    child: Text(
                      'Chưa có thể loại nào',
                      style: AppTheme.titleExtraLarge24,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    itemCount: viewModel.categories.length,
                    itemBuilder: (context, index) {
                      return CategoryItem(
                        viewModel: viewModel,
                        data: viewModel.categories[index],
                      );
                    },
                  ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.watermelon70,
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onPressed: () => _showAddCategoryBottomSheet(context, viewModel),
            child: Icon(
              Icons.add,
              size: 32,
              color: context.primaryTextColor,
            ),
          ),
        );
      },
    );
  }

  void _showAddCategoryBottomSheet(
      BuildContext context, CategoriesViewModel viewModel) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.blueberry70.withOpacity(0.9),
                AppColors.rambutan70.withOpacity(0.9),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Center(
                  child: Text('Thêm thể loại mới',
                      style: AppTheme.titleLarge20
                          .copyWith(color: AppColors.mono0)),
                ),
                const SizedBox(height: 24),
                TextField(
                  style:
                      AppTheme.titleMedium18.copyWith(color: AppColors.mono0),
                  controller: viewModel.nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColor.primary, width: 1.5),
                    ),
                    labelText: 'Tên thể loại',
                    labelStyle:
                        AppTheme.titleSmall16.copyWith(color: AppColors.mono0),
                    hintStyle:
                        AppTheme.titleSmall16.copyWith(color: AppColors.mono40),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  style:
                      AppTheme.titleMedium18.copyWith(color: AppColors.mono0),
                  controller: viewModel.descriptionController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColor.primary, width: 1.5),
                    ),
                    labelText: 'Mô tả',
                    labelStyle:
                        AppTheme.titleSmall16.copyWith(color: AppColors.mono0),
                    hintStyle:
                        AppTheme.titleSmall16.copyWith(color: AppColors.mono40),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: CustomButton(
                    color: AppColors.watermelon80,
                    title: Text('Thêm',
                        style: AppTheme.titleLarge20
                            .copyWith(color: AppColors.mono0)),
                    onPressed: () {
                      if (viewModel.nameController.text.isEmpty ||
                          viewModel.nameController.text == '') {
                        viewModel.addCategory();
                      }
                      viewModel.addCategory();
                      viewModel.nameController.clear();
                      viewModel.descriptionController.clear();
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CategoryItem extends StatefulWidget {
  final CategoriesViewModel viewModel;
  final Category data;
  const CategoryItem({super.key, required this.viewModel, required this.data});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool showDesc = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.rambutan70.withOpacity(0.9),
              AppColors.blueberry70.withOpacity(0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => showDesc = !showDesc),
                    child: Text(widget.data.name ?? 'Không tên',
                        style: AppTheme.titleExtraLarge24),
                  ),
                  CustomButton(
                    color: Colors.transparent,
                    title: Icon(
                      Icons.delete_forever,
                      color: AppColors.rambutan100,
                      size: 32,
                    ),
                    onPressed: () => widget.viewModel
                        .deleteCategory(widget.data.categoryId!),
                  ),
                ],
              ),
              if (showDesc) ...[
                const SizedBox(height: 8),
                Text(widget.data.description ?? 'Không có mô tả',
                    style: AppTheme.bodyLarge16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
