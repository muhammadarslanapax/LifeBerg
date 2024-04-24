import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/constant/color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GlobalScore extends StatelessWidget {
  final List<GlobalScoreChartDateModel> globalScoreChartData = [
    GlobalScoreChartDateModel(
      'Jan - Mar',
      0,
      .5,
      0,
      0,
    ),
    GlobalScoreChartDateModel(
      'Apr - July',
      1.0,
      1.0,
      2.0,
      2.5,
    ),
    GlobalScoreChartDateModel(
      'Aug - Oct',
      3.0,
      2.0,
      1.5,
      2.0,
    ),
    GlobalScoreChartDateModel(
      'Nov-Jan',
      2.0,
      1.0,
      2.0,
      .5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: SfCartesianChart(
        tooltipBehavior: TooltipBehavior(
          enable: true,
        ),
        margin: EdgeInsets.symmetric(horizontal: 15),
        borderWidth: 0,
        borderColor: Colors.transparent,
        plotAreaBorderWidth: 0,
        enableAxisAnimation: true,
        primaryYAxis: NumericAxis(
          numberFormat: NumberFormat.percentPattern(),
          name: 'yAxis',
          maximum: 10.0,
          minimum: 0,
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
          maximum: 3,
          minimum: 0,
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
        series: graphData(globalScoreChartData),
      ),
    );
  }

  dynamic graphData(List<GlobalScoreChartDateModel> dataSource) {
    return <ChartSeries>[
      StackedLineSeries<GlobalScoreChartDateModel, dynamic>(
        dataSource: dataSource,
        xValueMapper: (GlobalScoreChartDateModel data, _) => data.xValueMapper,
        yValueMapper: (GlobalScoreChartDateModel data, _) => data.unKnownValue,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kLifeBergBlueColor,
      ),
      StackedAreaSeries<GlobalScoreChartDateModel, dynamic>(
        dataSource: dataSource,
        xValueMapper: (GlobalScoreChartDateModel data, _) => data.xValueMapper,
        yValueMapper: (GlobalScoreChartDateModel data, _) => data.unKnownValue,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kLifeBergBlueColor.withOpacity(0.22),
      ),
      StackedLineSeries<GlobalScoreChartDateModel, dynamic>(
        dataSource: dataSource,
        xValueMapper: (GlobalScoreChartDateModel data, _) => data.xValueMapper,
        yValueMapper: (GlobalScoreChartDateModel data, _) =>
            data.dailyGratitude,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kDailyGratitudeColor,
      ),
      StackedLineSeries<GlobalScoreChartDateModel, dynamic>(
        dataSource: dataSource,
        xValueMapper: (GlobalScoreChartDateModel data, _) => data.xValueMapper,
        yValueMapper: (GlobalScoreChartDateModel data, _) => data.quiteTime,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kQuiteTimeColor,
      ),
      StackedLineSeries<GlobalScoreChartDateModel, dynamic>(
        dataSource: dataSource,
        xValueMapper: (GlobalScoreChartDateModel data, _) => data.xValueMapper,
        yValueMapper: (GlobalScoreChartDateModel data, _) => data.rCGPA,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kRACGPExamColor,
      ),
    ];
  }
}

class GlobalScoreChartDateModel {
  GlobalScoreChartDateModel(
    this.xValueMapper,
    this.unKnownValue,
    this.dailyGratitude,
    this.quiteTime,
    this.rCGPA,
  );

  String? xValueMapper;

  //CHANGE IT ACCORDING TO YOUR NEED
  double? unKnownValue;
  double? dailyGratitude;
  double? quiteTime;
  double? rCGPA;
}
