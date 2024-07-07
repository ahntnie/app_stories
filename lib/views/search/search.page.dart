import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/category_model.dart';
import 'package:app_stories/views/search/widget/custom_tabview.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:app_stories/widget/search_textfield.dart';
import 'package:app_stories/widget/test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

import '../../view_model/home.vm.dart';
import '../../view_model/search_stories.vm.dart';
import '../../widget/loading_shimmer.dart';
import '../stories/widget/stories_card.dart';
import 'widget/drawer_search.dart';

class SearchPage extends StatefulWidget {
  final HomeViewModel homeViewModel;
  final SearchSotriesViewModel viewModel;
  const SearchPage(
      {super.key, required this.homeViewModel, required this.viewModel});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        disposeViewModel: false,
        viewModelBuilder: () => widget.viewModel,
        onViewModelReady: (viewModel) async {
          viewModel.viewContext = context;
          await viewModel.init();
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
                      title: '', //viewModel.currentCategory?.name ?? 'Tất cả',
                      viewModel: viewModel,
                    ));
        });
  }
}
