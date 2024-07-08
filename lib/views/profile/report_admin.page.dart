import 'package:app_stories/view_model/report.vm.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../view_model/profile.vm.dart';
import '../report/widget/colum_chart.dart';
import 'widget/circular_counter.dart';

class ReportAdminPage extends StatelessWidget {
  final ProfileViewModel profileViewModel;
  ReportAdminPage({required this.profileViewModel});
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => profileViewModel,
      onViewModelReady: (viewModel) {
        viewModel.getTotalStories();
      },
      builder: (context, viewModel, child) {
        return BasePage(
          showAppBar: true,
          title: 'Thống kê',
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: CircularCounter(
                      number: viewModel.totalStories,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
