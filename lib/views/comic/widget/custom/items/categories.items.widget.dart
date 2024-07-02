import 'package:flutter/material.dart';

class CategoriesItems extends StatelessWidget {
  CategoriesItems({super.key, required this.categories});
  List<String> categories;

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
        return Card(
          color: Colors.black87,
          child: Center(
            child:
                Text(categories[index], style: TextStyle(color: Colors.white)),
          ),
        );
      },
    );
  }
}
