import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class MoodChart extends StatelessWidget {
  MoodChart({
    this.moodChartDataSource,
    this.primaryYAxisMax,
    this.primaryYAxisMin,
    this.primaryYAxisInterval,
    this.primaryXYAxisMax,
    this.primaryXYAxisMin,
    this.primaryXYAxisInterval,
  });

  List<MoodChartDataModel>? moodChartDataSource;

  double? primaryYAxisMax;
  double? primaryYAxisMin;
  double? primaryYAxisInterval;

  double? primaryXYAxisMax;
  double? primaryXYAxisMin;
  double? primaryXYAxisInterval;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: SfCartesianChart(
        tooltipBehavior: TooltipBehavior(
          enable: true,
        ),
        margin: EdgeInsets.zero,
        borderWidth: 0,
        borderColor: Colors.transparent,
        plotAreaBorderWidth: 0,
        enableAxisAnimation: true,
        primaryYAxis: NumericAxis(
          name: 'yAxis',
          maximum: primaryYAxisMax,
          minimum: primaryXYAxisMin,
          interval: primaryYAxisInterval,
          plotOffset: 10.0,
          majorGridLines: MajorGridLines(
            width: 1.2,
            color: kChartBorderColor,
          ),
          majorTickLines: MajorTickLines(
            width: 0,
          ),
          axisLine: AxisLine(
            width: 0,
          ),
          labelStyle: TextStyle(
            color: kChartLabelColor,
            fontSize: 11.0,
            fontFamily: 'Ubuntu',
          ),
        ),
        primaryXAxis: CategoryAxis(
          name: 'xAxis',
          maximum: primaryXYAxisMax,
          minimum: primaryXYAxisMin,
          interval: primaryXYAxisInterval,
          majorGridLines: MajorGridLines(
            width: 0,
          ),
          axisLine: AxisLine(
            width: 0,
          ),
          majorTickLines: MajorTickLines(
            width: 0,
          ),
          labelStyle: TextStyle(
            color: kChartLabelColor,
            fontSize: 11.0,
            fontFamily: 'Ubuntu',
          ),
        ),
        series: graphData(),
      ),
    );
  }

  dynamic graphData() {
    return <ChartSeries>[
      LineSeries<MoodChartDataModel, dynamic>(
        dataSource: moodChartDataSource!,
        xValueMapper: (MoodChartDataModel data, _) => data.xValueMapper,
        yValueMapper: (MoodChartDataModel data, _) => data.yValueMapper,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kDarkBlueColor,
      ),
    ];
  }
}

class MoodChartDataModel {
  MoodChartDataModel(
    this.xValueMapper,
    this.yValueMapper,
  );

  String? xValueMapper;
  int? yValueMapper;
}
