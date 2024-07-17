import 'dart:async';

import 'package:app_stories/app/app_sp.dart';
import 'package:app_stories/app/app_sp_key.dart';
import 'package:app_stories/styles/app_img.dart';
import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/view_model/profile.vm.dart';
import 'package:app_stories/view_model/search_stories.vm.dart';
import 'package:app_stories/views/comic/comic.page.dart';
import 'package:app_stories/views/profile/profile.page.dart';
import 'package:app_stories/views/search/search.page.dart';
import 'package:app_stories/widget/nav_bar.dart';
import 'package:app_stories/widget/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

import '../../view_model/home.vm.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeViewModel homeViewModel;
  Timer? timer;
  bool showDialogs = false;
  DateTime? startTime;
  int timeDuration = 1800;

  @override
  void initState() {
    super.initState();
    homeViewModel = HomeViewModel();
    loadStartTime();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   loadStartTime();
  // }

  Future<void> loadStartTime() async {
    String? startTimeString = AppSP.get(AppSPKey.timeuse);
    print(AppSP.get(AppSPKey.timeuse));
    if (startTimeString != null) {
      int startTimeMillis = int.tryParse(startTimeString) ??
          DateTime.now().millisecondsSinceEpoch;
      startTime = DateTime.fromMillisecondsSinceEpoch(startTimeMillis);
      print(startTimeMillis);
      checkTimeElapsed();
    } else {
      startTime = DateTime.now();
      AppSP.set(AppSPKey.timeuse, startTime!.millisecondsSinceEpoch.toString());
      startTimer();
    }
  }

  void checkTimeElapsed() {
    if (startTime != null) {
      final elapsed = DateTime.now().difference(startTime!);
      if (elapsed >= Duration(seconds: timeDuration)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            showDialogs = true;
          });
          //      _showTimeoutDialog();
        });
      } else {
        startTimer(duration: Duration(seconds: timeDuration) - elapsed);
      }
    }
  }

  void startTimer({Duration duration = const Duration(seconds: 3600)}) {
    timer = Timer(duration, () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          showDialogs = true;
        });
        //    _showTimeoutDialog();
      });
    });
  }

  // void _showTimeoutDialog() {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return PopUpWidget(
  //           //title: Text('Thông báo'),
  //           icon: Lottie.asset(Img.wait),
  //           title:
  //               'Sư huynh đã đọc truyện 60 phút rồi. Vui lòng nghỉ mắt một xíu để tránh bị hư mắt nhé.',
  //           leftText: 'Xác nhận',
  //           onLeftTap: () {
  //             Timer(Duration(seconds: timeDuration), () {
  //               setState(() {
  //                 showDialogs = false;
  //               });
  //               Navigator.pop(context);
  //               resetStartTime();
  //             });
  //           });
  //     },
  //   );
  // }

  Future<void> resetStartTime() async {
    startTime = DateTime.now();
    AppSP.set(AppSPKey.timeuse, startTime!.millisecondsSinceEpoch.toString());
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => homeViewModel,
      builder: (context, viewModel, child) => Scaffold(
        body: IndexedStack(
          index: viewModel.currentIndex,
          children: viewModel.getPages(),
        ),
        bottomNavigationBar: HomeNavigationBar(
          currentIndex: viewModel.currentIndex,
          onTabSelected: (index) => viewModel.setIndex(index),
        ),
      ),
    );
  }
}
