import 'package:app_stories/constants/themes/theme.serivce.dart';
import 'package:app_stories/views/splash/splash.page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/di.dart';

//import 'views/home.page.dart';

Future<void> main() async {
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,O
  // );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DependencyInjection.init();
  await Future.delayed(const Duration(seconds: 1));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeService = getIt<ThemeService>();
    return AnimatedBuilder(
      animation: themeService,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: themeService.currentTheme,
          home: const SplashPage(),
        );
      },
    );
  }
}
