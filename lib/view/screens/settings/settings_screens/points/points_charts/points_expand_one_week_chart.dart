import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PointsExpandOneWeekChart extends StatelessWidget {
  final List<PointsExpandOneWeekDataModel> dataSource = [
    PointsExpandOneWeekDataModel(
      'Jan - Mar',
      0,
      5,
      0,
      0,
    ),
    PointsExpandOneWeekDataModel(
      'Apr - July',
      1,
      1,
      2,
      3,
    ),
    PointsExpandOneWeekDataModel(
      'Aug - Oct',
      3,
      2,
      1,
      2,
    ),
    PointsExpandOneWeekDataModel(
      'Nov-Jan',
      2,
      1,
      2,
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
        maximum: 8,
        minimum: 0,
        interval: 2,
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
      series: graphData(dataSource),
    );
  }

  dynamic graphData(List<PointsExpandOneWeekDataModel> dataSource) {
    return <ChartSeries>[
      StackedLineSeries<PointsExpandOneWeekDataModel, dynamic>(
        dataSource: dataSource,
        xValueMapper: (PointsExpandOneWeekDataModel data, _) => data.xValueMapper,
        yValueMapper: (PointsExpandOneWeekDataModel data, _) => data.unKnownValue,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kLifeBergBlueColor,
      ),
      StackedAreaSeries<PointsExpandOneWeekDataModel, dynamic>(
        dataSource: dataSource,
        xValueMapper: (PointsExpandOneWeekDataModel data, _) => data.xValueMapper,
        yValueMapper: (PointsExpandOneWeekDataModel data, _) => data.unKnownValue,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kLifeBergBlueColor.withOpacity(0.22),
      ),
      StackedLineSeries<PointsExpandOneWeekDataModel, dynamic>(
        dataSource: dataSource,
        xValueMapper: (PointsExpandOneWeekDataModel data, _) => data.xValueMapper,
        yValueMapper: (PointsExpandOneWeekDataModel data, _) =>
        data.dailyGratitude,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kDailyGratitudeColor,
      ),
      StackedLineSeries<PointsExpandOneWeekDataModel, dynamic>(
        dataSource: dataSource,
        xValueMapper: (PointsExpandOneWeekDataModel data, _) => data.xValueMapper,
        yValueMapper: (PointsExpandOneWeekDataModel data, _) => data.quiteTime,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kQuiteTimeColor,
      ),
      StackedLineSeries<PointsExpandOneWeekDataModel, dynamic>(
        dataSource: dataSource,
        xValueMapper: (PointsExpandOneWeekDataModel data, _) => data.xValueMapper,
        yValueMapper: (PointsExpandOneWeekDataModel data, _) => data.rCGPA,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kRACGPExamColor,
      ),
    ];
  }
}

class PointsExpandOneWeekDataModel {
  PointsExpandOneWeekDataModel(
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
