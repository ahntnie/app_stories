import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/constants/colors/app_theme.dart';
import 'package:app_stories/widget/custom_button.dart';
import 'package:flutter/material.dart';

import '../views/authentication/login.page.dart';

class NextLoginPage extends StatelessWidget {
  final String title;
  const NextLoginPage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTheme.titleLarge20,
          ),
          CustomButton(
              color: AppColors.watermelon100,
              title: Text(
                'Đăng nhập',
                style: AppTheme.titleLarge20,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              })
        ],
      ),
    );
  }
}
