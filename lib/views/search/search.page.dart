import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:app_stories/widget/search_textfield.dart';
import 'package:app_stories/widget/test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

import '../../view_model/search_stories.vm.dart';
import '../../widget/loading_shimmer.dart';
import '../stories/widget/stories_card.dart';
import 'widget/drawer_search.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key, required this.title});
  String title;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => SearchSotriesViewModel(),
        onViewModelReady: (viewModel) {
          viewModel.viewContext = context;
          viewModel.init();
        },
        builder: (context, viewModel, child) {
          return BasePage(
            showLeading: false,
            isLoading: viewModel.isBusy,
            drawer: DrawerSearch(
              viewModel: viewModel,
            ),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const Icon(
                    Icons.tune,
                    color: AppColor.extraColor,
                    size: 30,
                  ),
                ),
              ),
            ],
            appBar: SearchTextField(
              seatchController: viewModel.searchController,
              onChanged: () {
                viewModel.searchStories();
              },
            ),
            body: viewModel.isBusy
                ? GradientLoadingWidget(
                    showFull: true,
                  )
                : CustomTabView(
                    title: widget.title,
                    stories: viewModel.stories,
                  ),
          );
        });
  }
}
