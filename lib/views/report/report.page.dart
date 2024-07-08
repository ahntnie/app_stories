import 'package:app_stories/view_model/report.vm.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'widget/colum_chart.dart';

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => ReportViewModel(),
      onViewModelReady: (viewModel) {
        viewModel.init();
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
                    height: MediaQuery.of(context).size.height / 2.7,
                    child: ColumnChart(
                      viewsData: viewModel.viewsData,
                      title: 'Số lượt xem',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.7,
                    child: ColumnChart(
                      viewsData: viewModel.favouriteData,
                      title: 'Số yêu thích',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.7,
                    child: ColumnChart(
                      viewsData: viewModel.commentData,
                      title: 'Số lượt bình luận',
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
