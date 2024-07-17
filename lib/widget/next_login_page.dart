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
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          CustomButton(
              title: Text(
                'Đăng nhập',
                style: TextStyle(color: Colors.white, fontSize: 20),
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
