import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class MoodChartOneWeek extends StatelessWidget {
  final List<MoodChartOneWeekDataModel> dummyData = [
    MoodChartOneWeekDataModel(
      'Jan - Mar',
      0,
    ),
    MoodChartOneWeekDataModel(
      'Apr - July',
      80,
    ),
    MoodChartOneWeekDataModel(
      'Aug - Oct',
      50,
    ),
    MoodChartOneWeekDataModel(
      'Nov-Jan',
      25,
    ),
    MoodChartOneWeekDataModel(
      '',
      70,
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
        interval: 10,
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
      series: graphData(),
    );
  }

  dynamic graphData() {
    return <ChartSeries>[
      LineSeries<MoodChartOneWeekDataModel, dynamic>(
        dataSource: dummyData,
        markerSettings: MarkerSettings(
          isVisible: true,
          borderColor: kMapMarkerBorderColor,
        ),
        xValueMapper: (MoodChartOneWeekDataModel data, _) => data.xValueMapper,
        yValueMapper: (MoodChartOneWeekDataModel data, _) => data.yValueMapper,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kDarkBlueColor,
      ),
    ];
  }
}

class MoodChartOneWeekDataModel {
  MoodChartOneWeekDataModel(
    this.xValueMapper,
    this.yValueMapper,
  );

  String? xValueMapper;
  int? yValueMapper;
}
