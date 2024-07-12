import 'package:app_stories/widget/base_page.dart';
import 'package:app_stories/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../constants/app_color.dart';
import '../../view_model/categories.vm.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
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
              body: ListView.builder(
                itemCount: viewModel.categories.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColor.buttonColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          viewModel.categories[index].name!,
                          style: TextStyle(color: Colors.white),
                        ),
                        CustomButton(
                            title: Icon(
                              Icons.delete_outline_outlined,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              viewModel.deleteCategory(
                                  viewModel.categories[index].categoryId!);
                            })
                      ],
                    ),
                  );
                },
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
                          padding: EdgeInsets.all(20),
                          height: MediaQuery.of(context).size.height / 3,
                          color: AppColor.bottomSheetColor,
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
