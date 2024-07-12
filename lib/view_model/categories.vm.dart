import 'package:app_stories/requests/category.request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

import '../models/category_model.dart';
import '../widget/pop_up.dart';

class CategoriesViewModel extends BaseViewModel {
  final BuildContext context;
  CategoriesViewModel({required this.context});
  CategoryRequest request = CategoryRequest();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Category> categories = [];
  getAllCategory() async {
    setBusy(true);
    categories = await request.getCategories();
    setBusy(false);
    notifyListeners();
  }

  addCategory() async {
    setBusy(true);
    await request.addCategory(nameController.text, descriptionController.text);
    showDialog(
        context: context,
        builder: (context) {
          return PopUpWidget(
            icon: Image.asset("assets/ic_success.png"),
            title: 'Thêm thể loại thành công',
            leftText: 'Xác nhận',
            onLeftTap: () {
              Navigator.pop(context);
            },
          );
        });
    await getAllCategory();
  }

  deleteCategory(int id) async {
    showDialog(
        context: context,
        builder: (context) {
          return PopUpWidget(
            icon: Image.asset("assets/ic_error.png"),
            title: 'Bạn có muốn xóa thể loại này?',
            leftText: 'Xác nhận',
            onLeftTap: () async {
              setBusy(true);
              await request.deleteCategory(id);
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (context) {
                    return PopUpWidget(
                      icon: Image.asset("assets/ic_success.png"),
                      title: 'Xóa thể loại thành công',
                      leftText: 'Xác nhận',
                      onLeftTap: () async {
                        Navigator.pop(context);
                        await getAllCategory();
                      },
                    );
                  });
            },
            twoButton: true,
            onRightTap: () {
              Navigator.pop(context);
            },
          );
        });
  }
}
