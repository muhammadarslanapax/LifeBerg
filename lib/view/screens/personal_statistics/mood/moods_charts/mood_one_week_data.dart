import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/constant/strings.dart';
import 'package:life_berg/view/widget/charts_widget/mood_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../statistics_controller.dart';

// ignore: must_be_immutable
class MoodChartOneWeek extends StatelessWidget {
  final String? type;

  MoodChartOneWeek(this.type, {Key? key}) : super(key: key);

  final StatisticsController statisticsController =
      Get.find<StatisticsController>();

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
        maximum: type == "one_week"
            ? 6
            : type == "one_month"
                ? 30
                : type == "three_month"
                    ? 2
                    : type == "six_month"
                        ? 5
                        : 11,
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
      LineSeries<MoodChartDataModel, dynamic>(
        dataSource: statisticsController.getMoodHistoryStats(
            statisticsController.moodHistory, type!),
        markerSettings: MarkerSettings(
          isVisible: true,
          borderColor: kMapMarkerBorderColor,
        ),
        xValueMapper: (MoodChartDataModel data, _) => data.xValueMapper,
        yValueMapper: (MoodChartDataModel data, _) => data.yValueMapper,
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
