import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/styles/font.dart';
import 'package:app_stories/styles/img.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  final bool showLogo;
  final bool showSearch;
  final String? title;
  final bool showLogout;
  final Widget body;
  const BasePage({
    super.key,
    this.showLogo = false,
    this.showSearch = false,
    this.title,
    this.showLogout = false,
    required this.body,
  });

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.primary,
        appBar: AppBar(
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
                            fontWeight: fontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ],
                )
              : widget.showSearch
                  ? Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF252044),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 16.0),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search, color: Colors.white),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        widget.title ?? '',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: fontWeight.bold),
                      ),
                    ),
          actions: [
            widget.showLogo
                ? IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none_outlined,
                      color: Colors.white,
                      size: 30,
                    ))
                : widget.showSearch
                    ? IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.tune,
                          color: Colors.white,
                          size: 30,
                        ))
                    : widget.showLogout
                        ? IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 30,
                            ))
                        : const SizedBox()
          ],
        ),
        body: widget.body,
      ),
    );
  }
}
