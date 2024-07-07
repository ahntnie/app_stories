import 'package:app_stories/models/category_model.dart';
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
        crossAxisCount: 3,
        childAspectRatio: 2,
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
            color: Colors.black87,
            child: Center(
              child: Text(categories[index].name!,
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
        );
      },
    );
  }
}
