import 'dart:async';

import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/styles/app_img.dart';
import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/view_model/login.vm.dart';
import 'package:app_stories/view_model/notification.vm.dart';
import 'package:app_stories/views/authentication/login.page.dart';
import 'package:app_stories/views/splash/splash.page.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:app_stories/models/notification_model.dart'
    as notification_model;

import '../app/app_sp.dart';
import '../app/app_sp_key.dart';
import '../requests/notification.request.dart';
import '../views/notification/notification.page.dart';
import 'loading_shimmer.dart';

class BasePage extends StatefulWidget {
  final bool showLogo;
  final String? title;
  final bool showLogout;
  final Widget body;
  final bool showAppBar;
  final Widget? bottomNav;
  final Widget? appBar;
  final bool showLeading;
  final List<Widget>? actions;
  final Widget? drawer;
  final bool isLoading;
  final VoidCallback? onPressedLeading;
  final Widget? bottomSheet;
  final Widget? floatingActionButton;
  BasePage({
    super.key,
    this.showLogo = false,
    this.title,
    this.showLogout = false,
    required this.body,
    this.showAppBar = true,
    this.bottomNav,
    this.appBar,
    this.showLeading = true,
    this.actions,
    this.drawer,
    this.isLoading = false,
    this.onPressedLeading,
    this.bottomSheet,
    this.floatingActionButton,
  });

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  NotificationRequest request = NotificationRequest();
  NotificationViewModel notificationViewModel = NotificationViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  // getNotification()async

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        endDrawer: widget.drawer,
        backgroundColor: AppColor.primary,
        appBar: widget.showAppBar
            ? AppBar(
                leading: widget.showLeading
                    ? IconButton(
                        onPressed: widget.onPressedLeading ??
                            () {
                              Navigator.pop(context);
                            },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ))
                    : null,
                toolbarHeight: 100,
                backgroundColor: AppColor.darkPrimary,
                title: widget.appBar ??
                    (widget.showLogo
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    Img.imgLogo,
                                    width: 70,
                                    height: 70,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    'TRUYENHAY',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: AppFontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )
                        : Center(
                            child: Text(
                              widget.title ?? '',
                              style: const TextStyle(
                                  color: AppColor.extraColor,
                                  fontWeight: AppFontWeight.bold),
                            ),
                          )),
                actions: widget.actions ??
                    [
                      widget.showLogo
                          ? ViewModelBuilder.reactive(
                              viewModelBuilder: () => notificationViewModel,
                              onViewModelReady: (viewModel) async {
                                if (AppSP.get(AppSPKey.currrentUser) != null &&
                                    AppSP.get(AppSPKey.currrentUser) != '') {
                                  await viewModel.getNotificationByUserId();
                                  // Timer.periodic(Duration(minutes: 1),
                                  //     (timer) async {
                                  //   print('Vào lấy thông báo');
                                  //   await viewModel.getNotificationByUserId();
                                  // });
                                }
                              },
                              builder: (context, viewModel, child) {
                                if (AppSP.get(AppSPKey.currrentUser) != null &&
                                    AppSP.get(AppSPKey.currrentUser) != '') {}

                                return IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NotificationPage(
                                                    notificationViewModel:
                                                        viewModel,
                                                  )));
                                    },
                                    icon: Stack(
                                      children: [
                                        const Icon(
                                          Icons.notifications_none_outlined,
                                          color: AppColor.extraColor,
                                          size: 30,
                                        ),
                                        if (viewModel.unReadNotify != 0)
                                          Positioned(
                                            left: 12,
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  viewModel.unReadNotify
                                                      .toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ));
                              },
                            )
                          : widget.showLogout
                              ? IconButton(
                                  onPressed: () {
                                    LoginViewModel().signOut();
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SplashPage()),
                                      (router) => false,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.logout,
                                    color: AppColor.extraColor,
                                    size: 30,
                                  ))
                              : const SizedBox()
                    ],
              )
            : null,
        body: widget.isLoading
            ? Center(child: GradientLoadingWidget())
            : widget.body,
        floatingActionButton: widget.floatingActionButton,
        bottomNavigationBar: widget.bottomNav,
        bottomSheet: widget.bottomSheet,
      ),
    );
  }
}
