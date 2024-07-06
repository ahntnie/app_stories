import 'package:app_stories/firebase_options.dart';
import 'package:app_stories/views/authentication/login.page.dart';
import 'package:app_stories/views/splash/splash.page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app/di.dart';
import 'views/browse_stories/browse_stories.page.dart';
import 'views/home/home.page.dart';
import 'views/stories/my_stories.page.dart';
import 'views/stories/post_stories.dart';
import 'views/upload_image/upload_image.page.dart';
import 'widget/base_page.dart';

//import 'views/home.page.dart';

Future<void> main() async {
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DependencyInjection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
