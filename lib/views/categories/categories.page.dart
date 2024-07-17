import 'package:app_stories/models/category_model.dart';
import 'package:app_stories/styles/app_font.dart';
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
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => CategoriesViewModel(context: context),
        onViewModelReady: (viewModel) {
          viewModel.getAllCategory();
        },
        builder: (context, viewModel, child) {
          return BasePage(
              isLoading: viewModel.isBusy,
              showAppBar: true,
              title: 'Quản lí thể loại',
              body: SmartRefresher(
                controller: _refreshController,
                onRefresh: () => _onRefresh(viewModel),
                child: ListView.builder(
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
                backgroundColor: AppColor.buttonColor,
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColor.bottomSheetColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          padding: EdgeInsets.all(20),
                          height: MediaQuery.of(context).size.height / 3,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                TextField(
                                  style: TextStyle(color: Colors.white),
                                  controller: viewModel.nameController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Tên thể loại',
                                      labelStyle:
                                          TextStyle(color: Colors.white)),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  style: TextStyle(color: Colors.white),
                                  controller: viewModel.descriptionController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Mô tả',
                                      labelStyle:
                                          TextStyle(color: Colors.white)),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                CustomButton(
                                    title: Container(
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      height: 35,
                                      child: Text(
                                        'Thêm',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 25),
                                      ),
                                    ),
                                    onPressed: () {
                                      viewModel.addCategory();
                                      Navigator.pop(context);
                                    })
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Icon(
                  Icons.add,
                  size: 40,
                  color: Colors.white,
                ),
              ));
        });
  }
}

class CategoryItem extends StatefulWidget {
  final CategoriesViewModel viewModel;
  final Category data;
  const CategoryItem({
    super.key,
    required this.viewModel,
    required this.data,
  });

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool showDesc = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showDesc = !showDesc;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.data.name!,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: AppFontSize.sizeMedium),
                ),
                CustomButton(
                    title: Icon(
                      Icons.delete_outline_outlined,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      widget.viewModel.deleteCategory(widget.data.categoryId!);
                    })
              ],
            ),
            if (showDesc)
              Text(
                widget.data.description!,
                style: TextStyle(
                    color: Colors.white, fontSize: AppFontSize.sizeSmall),
              ),
          ],
        ),
      ),
    );
  }
}
