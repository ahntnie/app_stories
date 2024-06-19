import 'package:app_stories/widget/base_page.dart';
import 'package:flutter/material.dart';

class ComicPage extends StatefulWidget {
  const ComicPage({super.key});

  @override
  State<ComicPage> createState() => _ComicPageState();
}

class _ComicPageState extends State<ComicPage> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      showLogo: true,
      body: Container(),
    );
  }
}
