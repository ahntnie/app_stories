import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/constants/colors/app_theme.dart';
import 'package:flutter/material.dart';
import '../../../constants/app_color.dart';
import '../../../view_model/search_stories.vm.dart';

class DrawerSearch extends StatelessWidget {
  final SearchSotriesViewModel viewModel;

  const DrawerSearch({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent.withOpacity(0.1),
      child: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: AppColors.mono40.withOpacity(0.2))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFilterTab(
                    context: context,
                    title: 'Thể loại',
                    isActive: viewModel.categoryFilter,
                    onTap: viewModel.changeCategoryFilter,
                  ),
                  const SizedBox(width: 16),
                  _buildFilterTab(
                    context: context,
                    title: 'Sắp xếp',
                    isActive: !viewModel.categoryFilter,
                    onTap: viewModel.changeSortFilter,
                  ),
                ],
              ),
            ),

            // Categories Grid
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 3.5,
                  ),
                  itemCount: viewModel.categories.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryItem(
                      context: context,
                      index: index,
                    );
                  },
                ),
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      context: context,
                      title: 'Hủy',
                      color: AppColors.mono40.withOpacity(0.3),
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      context: context,
                      title: 'Áp dụng',
                      color: AppColors.watermelon100,
                      onTap: () {
                        viewModel.searchStoriesByFilter();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab({
    required BuildContext context,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.watermelon100.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? AppColors.watermelon100.withOpacity(0.3)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive)
              const Icon(
                Icons.menu_open_outlined,
                color: AppColors.watermelon100,
                size: 20,
              ),
            if (isActive) const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.watermelon100 : AppColors.mono40,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem({
    required BuildContext context,
    required int index,
  }) {
    final isSelected = viewModel.selectedCategories[index];
    return GestureDetector(
      onTap: () => viewModel.changeSelectedCategories(index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.watermelon100.withOpacity(0.8)
              : AppColors.mono40.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.watermelon100
                : AppColors.mono40.withOpacity(0.3),
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.watermelon100.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Center(
          child: Text(
            viewModel.categories[index].name!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.mono0 : AppColors.mono20,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppColors.mono0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        elevation: 2,
      ),
      child: Text(title, style: AppTheme.titleSmall16),
    );
  }
}
