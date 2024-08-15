import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/screens/personal_statistics/statistics_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'gloabl_score_charts/global_score_one_week_chart.dart';

class GlobalScore extends StatelessWidget {
  final StatisticsController statisticsController =
      Get.find<StatisticsController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      child: Obx(
        () => statisticsController.isLoadingGoalsReport.value == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SfCartesianChart(
                tooltipBehavior: TooltipBehavior(
                    enable: true,
                    header: '',
                    canShowMarker: true,
                    textStyle: TextStyle(color: Colors.white),
                    color: kTertiaryColor,
                    builder: (dynamic data, dynamic point, dynamic series,
                        int index, int d) {
                      return Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: kTertiaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Global: ${data.global}\nWellbeing: ${data.wellbeing}\nVocational: ${data.vocational}\nPersonal Development: ${data.personalDevelopment}',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }),
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
                  maximum: 6,
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
                series: graphData(statisticsController.chartData),
              ),
      ),
    );
  }

  dynamic graphData(
      List<GlobalScoreChartOneWeekDataModel> globalScoreChartData) {
    return <ChartSeries>[
      StackedLineSeries<GlobalScoreChartOneWeekDataModel, dynamic>(
        groupName: "Global",
        dataSource: globalScoreChartData,
        xValueMapper: (GlobalScoreChartOneWeekDataModel data, _) => DateFormat("EEE").format(DateTime.parse(data.date!)),
        yValueMapper: (GlobalScoreChartOneWeekDataModel data, _) => data.global,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kLifeBergBlueColor,
        markerSettings: MarkerSettings(
          isVisible: true,
          borderColor: kMapMarkerBorderColor,
        ),
      ),
      StackedAreaSeries<GlobalScoreChartOneWeekDataModel, dynamic>(
        groupName: "Global B",
        dataSource: globalScoreChartData,
        xValueMapper: (GlobalScoreChartOneWeekDataModel data, _) => DateFormat("EEE").format(DateTime.parse(data.date!)),
        yValueMapper: (GlobalScoreChartOneWeekDataModel data, _) => data.global,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kLifeBergBlueColor.withOpacity(0.22),
        markerSettings: MarkerSettings(
          isVisible: true,
          borderColor: kMapMarkerBorderColor,
        ),
      ),
      StackedLineSeries<GlobalScoreChartOneWeekDataModel, dynamic>(
        groupName: "Wellbeing",
        dataSource: globalScoreChartData,
        xValueMapper: (GlobalScoreChartOneWeekDataModel data, _) => DateFormat("EEE").format(DateTime.parse(data.date!)),
        yValueMapper: (GlobalScoreChartOneWeekDataModel data, _) =>
            data.wellbeing,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kStreaksColor,
        markerSettings: MarkerSettings(
          isVisible: true,
          borderColor: kMapMarkerBorderColor,
        ),
      ),
      StackedLineSeries<GlobalScoreChartOneWeekDataModel, dynamic>(
        dataSource: globalScoreChartData,
        groupName: "Vocational",
        xValueMapper: (GlobalScoreChartOneWeekDataModel data, _) => DateFormat("EEE").format(DateTime.parse(data.date!)),
        yValueMapper: (GlobalScoreChartOneWeekDataModel data, _) =>
            data.vocational,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kRACGPExamColor,
        markerSettings: MarkerSettings(
          isVisible: true,
          borderColor: kMapMarkerBorderColor,
        ),
      ),
      StackedLineSeries<GlobalScoreChartOneWeekDataModel, dynamic>(
        dataSource: globalScoreChartData,
        groupName: "Personal Development",
        xValueMapper: (GlobalScoreChartOneWeekDataModel data, _) => DateFormat("EEE").format(DateTime.parse(data.date!)),
        yValueMapper: (GlobalScoreChartOneWeekDataModel data, _) =>
            data.personalDevelopment,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kDailyGratitudeColor,
        markerSettings: MarkerSettings(
          isVisible: true,
          borderColor: kMapMarkerBorderColor,
        ),
      ),
    ];
  }
}