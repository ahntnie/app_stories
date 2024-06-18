import 'package:app_stories/firebase_options.dart';
import 'package:app_stories/views/input.page.dart';
import 'package:app_stories/views/start.page.dart';
import 'package:app_stories/views/users.page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//import 'views/home.page.dart';

Future<void> main() async {
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      initialRoute: '/',
      routes: {
        '/': (context) => InputPage(),
        '/users': (context) => UsersPage(),
      },
    );
  }
}
