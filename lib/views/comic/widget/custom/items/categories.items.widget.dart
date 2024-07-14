import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/category_model.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:flutter/material.dart';

import '../../../../../view_model/home.vm.dart';

class CategoriesItems extends StatelessWidget {
  HomeViewModel homeViewModel;
  CategoriesItems(
      {super.key, required this.categories, required this.homeViewModel});
  List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            await homeViewModel.searchSotriesViewModel
                .checkAndSearchStoriesByCategory(categories[index].categoryId);
            homeViewModel.setIndex(1);
          },
          child: Card(
            color: AppColor.selectColor,
            child: Center(
              child: Text(categories[index].name!,
                  style: TextStyle(
                      color: AppColor.extraColor,
                      fontWeight: AppFontWeight.bold,
                      fontSize: AppFontSize.sizeMedium)),
            ),
          ),
        );
      },
    );
  }
}
