import 'package:app_stories/view_model/report.vm.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ColumnChart extends StatelessWidget {
  final List<ViewData> viewsData;
  final String title;

  ColumnChart({required this.viewsData, required this.title});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SfCartesianChart(
        title: ChartTitle(text: title),
        backgroundColor: Colors.white,
        primaryXAxis: const CategoryAxis(
          labelStyle: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
          labelIntersectAction: AxisLabelIntersectAction.wrap,
        ),
        series: <CartesianSeries>[
          ColumnSeries<ViewData, String>(
            dataSource: viewsData,
            xValueMapper: (ViewData views, _) => views.name,
            yValueMapper: (ViewData views, _) => views.views,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
              textStyle: TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
