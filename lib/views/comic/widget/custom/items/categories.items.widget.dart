import 'package:flutter/material.dart';
import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/models/category_model.dart';
import '../../../../../view_model/home.vm.dart';

class CategoriesItems extends StatelessWidget {
  final HomeViewModel homeViewModel;
  final List<Category> categories;

  CategoriesItems({
    super.key,
    required this.categories,
    required this.homeViewModel,
  });

  final List<List<Color>> categoryGradients = [
    [AppColors.blueberry80, AppColors.watermelon80],
    [AppColors.cempedak80, AppColors.rambutan80],
    [AppColors.watermelon80, AppColors.cempedak80],
    [AppColors.rambutan80, AppColors.blueberry80],
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final gradientColors =
              categoryGradients[index % categoryGradients.length];

          return GestureDetector(
            onTap: () async {
              await homeViewModel.searchSotriesViewModel
                  .checkAndSearchStoriesByCategory(
                      categories[index].categoryId);
              homeViewModel.setIndex(1);
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(2, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  categories[index].name!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
