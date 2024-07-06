import 'package:app_stories/app/app_sp.dart';
import 'package:app_stories/app/app_sp_key.dart';
import 'package:app_stories/styles/app_img.dart';

import 'package:app_stories/views/home/home.page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

import '../authentication/login.page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    if (AppSP.get(AppSPKey.userinfo) != null) {
      print(AppSP.get(AppSPKey.userinfo));
      await Future.delayed(const Duration(seconds: 2), () {
        // Tải ảnh trong 3 giây
        precacheImage(const AssetImage('assets/imgStart.png'), context);
      });
      // Chuyển sang màn hình tiếp theo
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      await Future.delayed(const Duration(seconds: 2), () {
        // Tải ảnh trong 3 giây
        precacheImage(const AssetImage('assets/imgStart.png'), context);
      });
      // Chuyển sang màn hình tiếp theo
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      // }
      // print(AppSP.get(ProfileViewModel().user!.email));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Img.imgStart),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.1), // Mức độ tối (0.0 - 1.0)
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Lottie.network(Img.loadBook),
            ],
          ),
        ),
      ),
    );
  }
}
