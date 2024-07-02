import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/styles/app_img.dart';
import 'package:app_stories/view_model/login.vm.dart';
import 'package:app_stories/views/authentication/login.page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'search_textfield.dart';

class BasePage extends StatefulWidget {
  final bool showLogo;
  final bool showSearch;
  final String? title;
  final bool showLogout;
  final Widget body;
  final bool showAppBar;
  final Widget? bottomNav;
  const BasePage({
    super.key,
    this.showLogo = false,
    this.showSearch = false,
    this.title,
    this.showLogout = false,
    required this.body,
    this.showAppBar = true,
    this.bottomNav,
  });

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => LoginViewModel(),
        onViewModelReady: (viewModel) {
          viewModel.viewContext = context;
        },
        builder: (context, viewModel, child) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColor.primary,
              appBar: widget.showAppBar
                  ? AppBar(
                      leading: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                      toolbarHeight: 100,
                      backgroundColor: AppColor.darkPrimary,
                      title: widget.showLogo
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
                          : widget.showSearch
                              ? const SearchTextField()
                              : Center(
                                  child: Text(
                                    widget.title ?? '',
                                    style: const TextStyle(
                                        color: AppColor.extraColor,
                                        fontWeight: AppFontWeight.bold),
                                  ),
                                ),
                      actions: [
                        widget.showLogo
                            ? IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.notifications_none_outlined,
                                  color: AppColor.extraColor,
                                  size: 30,
                                ))
                            : widget.showSearch
                                ? IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.tune,
                                      color: AppColor.extraColor,
                                      size: 30,
                                    ))
                                : widget.showLogout
                                    ? IconButton(
                                        onPressed: () {
                                          viewModel.signOut();
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage()),
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
              body: widget.body,
              bottomNavigationBar: widget.bottomNav,
            ),
          );
        });
  }
}

