import 'package:app_stories/widget/base_page.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      title: 'Thống kê',
      body: ColumnChart(),
    );
  }
}

class ColumnChart extends StatelessWidget {
  final List<SalesData> chartData = [
    SalesData('2017', 25),
    SalesData('2018', 12),
    SalesData('2019', 24),
    SalesData('2020', 18),
    SalesData('2021', 30)
  ];

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        series: <CartesianSeries>[
          ColumnSeries<SalesData, String>(
            dataSource: chartData,
            xValueMapper: (SalesData sales, _) => sales.year,
            yValueMapper: (SalesData sales, _) => sales.sales,
          )
        ]);
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
