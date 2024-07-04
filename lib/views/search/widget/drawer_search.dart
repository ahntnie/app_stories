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
      backgroundColor: AppColor.primary,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  viewModel.changeCategoryFilter();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  decoration: BoxDecoration(
                      color: viewModel.categoryFilter
                          ? Colors.red.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      if (viewModel.categoryFilter)
                        const Icon(
                          Icons.menu_open_outlined,
                          color: Colors.red,
                        ),
                      Text(
                        'Thể loại',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: viewModel.categoryFilter
                                ? Colors.red
                                : Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  viewModel.changeSortFilter();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  decoration: BoxDecoration(
                      color: viewModel.categoryFilter
                          ? Colors.transparent
                          : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      if (!viewModel.categoryFilter)
                        const Icon(
                          Icons.menu_open_outlined,
                          color: Colors.red,
                        ),
                      Text(
                        'Sắp xếp',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: viewModel.categoryFilter
                                ? Colors.grey
                                : Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 1.0,

                mainAxisSpacing: 1.0,
                childAspectRatio: 3, // Tỷ lệ khung hình để điều chỉnh chiều cao
              ),
              itemCount: viewModel.categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    viewModel.changeSelectedCategories(index);
                  },
                  child: Container(
                    height: 30,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: viewModel.selectedCategories[index]
                          ? Colors.red.withOpacity(0.5)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        viewModel.categories[index].name!,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: viewModel.selectedCategories[index]
                                ? Colors.white
                                : Colors.grey),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: AppColor.buttonColor,
                        borderRadius: BorderRadius.circular(50)),
                    alignment: Alignment.center,
                    child: const Text(
                      'Hủy',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    viewModel.searchStoriesByFilter();
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50)),
                    alignment: Alignment.center,
                    child: const Text(
                      'Áp dụng',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
