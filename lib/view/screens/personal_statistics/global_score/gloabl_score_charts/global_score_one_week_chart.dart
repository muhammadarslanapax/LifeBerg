import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GlobalScoreOneWeek extends StatelessWidget {
  final List<GlobalScoreChartOneWeekDataModel> globalScoreChartData = [
    GlobalScoreChartOneWeekDataModel(
      'Jan - Mar',
      0,
      5,
      0,
      0,
    ),
    GlobalScoreChartOneWeekDataModel(
      'Apr - July',
      10,
      10,
      20,
      25,
    ),
    GlobalScoreChartOneWeekDataModel(
      'Aug - Oct',
      30,
      20,
      15,
      20,
    ),
    GlobalScoreChartOneWeekDataModel(
      'Nov-Jan',
      20,
      10,
      20,
      5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      tooltipBehavior: TooltipBehavior(
        enable: true,
      ),
      margin: EdgeInsets.symmetric(horizontal: 15),
      borderWidth: 0,
      borderColor: Colors.transparent,
      plotAreaBorderWidth: 0,
      enableAxisAnimation: true,
      primaryYAxis: NumericAxis(
        name: 'yAxis',
        maximum: 100,
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
    );
  }

  dynamic graphData(List<GlobalScoreChartOneWeekDataModel> dataSource) {
    return <ChartSeries>[
      StackedLineSeries<GlobalScoreChartOneWeekDataModel, dynamic>(
        dataSource: dataSource,
        xValueMapper: (GlobalScoreChartOneWeekDataModel data, _) => data.xValueMapper,
        yValueMapper: (GlobalScoreChartOneWeekDataModel data, _) => data.unKnownValue,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kLifeBergBlueColor,
      ),
      StackedAreaSeries<GlobalScoreChartOneWeekDataModel, dynamic>(
        dataSource: dataSource,
        xValueMapper: (GlobalScoreChartOneWeekDataModel data, _) => data.xValueMapper,
        yValueMapper: (GlobalScoreChartOneWeekDataModel data, _) => data.unKnownValue,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kLifeBergBlueColor.withOpacity(0.22),
      ),
      StackedLineSeries<GlobalScoreChartOneWeekDataModel, dynamic>(
        dataSource: dataSource,
        xValueMapper: (GlobalScoreChartOneWeekDataModel data, _) => data.xValueMapper,
        yValueMapper: (GlobalScoreChartOneWeekDataModel data, _) =>
        data.dailyGratitude,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kDailyGratitudeColor,
      ),
      StackedLineSeries<GlobalScoreChartOneWeekDataModel, dynamic>(
        dataSource: dataSource,
        xValueMapper: (GlobalScoreChartOneWeekDataModel data, _) => data.xValueMapper,
        yValueMapper: (GlobalScoreChartOneWeekDataModel data, _) => data.quiteTime,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kQuiteTimeColor,
      ),
      StackedLineSeries<GlobalScoreChartOneWeekDataModel, dynamic>(
        dataSource: dataSource,
        xValueMapper: (GlobalScoreChartOneWeekDataModel data, _) => data.xValueMapper,
        yValueMapper: (GlobalScoreChartOneWeekDataModel data, _) => data.rCGPA,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kRACGPExamColor,
      ),
    ];
  }
}

class GlobalScoreChartOneWeekDataModel {
  GlobalScoreChartOneWeekDataModel(
      this.xValueMapper,
      this.unKnownValue,
      this.dailyGratitude,
      this.quiteTime,
      this.rCGPA,
      );

  String? xValueMapper;

  //CHANGE IT ACCORDING TO YOUR NEED
  int? unKnownValue;
  int? dailyGratitude;
  int? quiteTime;
  int? rCGPA;
}
