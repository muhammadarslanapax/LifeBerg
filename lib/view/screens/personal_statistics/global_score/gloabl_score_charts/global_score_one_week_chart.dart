import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/screens/personal_statistics/global_score/global_score_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../statistics_controller.dart';

class GlobalScoreOneWeek extends StatefulWidget {
  final String type;

  GlobalScoreOneWeek(this.type, {Key? key}) : super(key: key);

  @override
  State<GlobalScoreOneWeek> createState() => _GlobalScoreOneWeekState();
}

class _GlobalScoreOneWeekState extends State<GlobalScoreOneWeek> {
  final GlobalScoreController globalScoreController =
      Get.find<GlobalScoreController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
        () => /*globalScoreController.isLoadingGoalsReport.value == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        :*/
            SfCartesianChart(
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
                maximum: globalScoreController.tabType.value == "one_week"
                    ? 6
                    : globalScoreController.tabType.value == "one_month"
                        ? 30
                        : globalScoreController.tabType.value == "three_month"
                            ? 2
                            : globalScoreController.tabType.value == "six_month"
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
              series: graphData(globalScoreController.chartData),
            ));
  }

  dynamic graphData(List<GlobalScoreChartOneWeekDataModel> data) {
    return <ChartSeries>[
      if (globalScoreController.isGlobalSelected.value == true)
        StackedLineSeries<GlobalScoreChartOneWeekDataModel, dynamic>(
          groupName: "Global",
          dataSource: data,
          xValueMapper: (GlobalScoreChartOneWeekDataModel data, _) => globalScoreController.tabType.value == "one_week" ? DateFormat("EEE").format(DateTime.parse(data.date!)) : data.date,
          yValueMapper: (GlobalScoreChartOneWeekDataModel data, _) =>
              data.global,
          xAxisName: 'xAxis',
          yAxisName: 'yAxis',
          color: kLifeBergBlueColor,
        ),
      if (globalScoreController.isGlobalSelected.value == true)
        StackedAreaSeries<GlobalScoreChartOneWeekDataModel, dynamic>(
          groupName: "Global B",
          dataSource: data,
          xValueMapper: (GlobalScoreChartOneWeekDataModel data, _) => globalScoreController.tabType.value == "one_week" ? DateFormat("EEE").format(DateTime.parse(data.date!)) : data.date,
          yValueMapper: (GlobalScoreChartOneWeekDataModel data, _) =>
              data.global,
          xAxisName: 'xAxis',
          yAxisName: 'yAxis',
          color: kLifeBergBlueColor.withOpacity(0.22),
        ),
      if (globalScoreController.isWellbeingSelected.value == true)
        StackedLineSeries<GlobalScoreChartOneWeekDataModel, dynamic>(
          groupName: "Wellbeing",
          dataSource: data,
          xValueMapper: (GlobalScoreChartOneWeekDataModel data, _) => globalScoreController.tabType.value == "one_week" ? DateFormat("EEE").format(DateTime.parse(data.date!)) : data.date,
          yValueMapper: (GlobalScoreChartOneWeekDataModel data, _) =>
              data.wellbeing,
          xAxisName: 'xAxis',
          yAxisName: 'yAxis',
          color: kStreaksColor,
        ),
      if (globalScoreController.isVocationalSelected.value == true)
        StackedLineSeries<GlobalScoreChartOneWeekDataModel, dynamic>(
          dataSource: data,
          groupName: "Vocational",
          xValueMapper: (GlobalScoreChartOneWeekDataModel data, _) => globalScoreController.tabType.value == "one_week" ? DateFormat("EEE").format(DateTime.parse(data.date!)) : data.date,
          yValueMapper: (GlobalScoreChartOneWeekDataModel data, _) =>
              data.vocational,
          xAxisName: 'xAxis',
          yAxisName: 'yAxis',
          color: kRACGPExamColor,
        ),
      if (globalScoreController.isPersonalDevelopmentSelected.value == true)
        StackedLineSeries<GlobalScoreChartOneWeekDataModel, dynamic>(
          dataSource: data,
          groupName: "Personal Development",
          xValueMapper: (GlobalScoreChartOneWeekDataModel data, _) => globalScoreController.tabType.value == "one_week" ? DateFormat("EEE").format(DateTime.parse(data.date!)) : data.date,
          yValueMapper: (GlobalScoreChartOneWeekDataModel data, _) =>
              data.personalDevelopment,
          xAxisName: 'xAxis',
          yAxisName: 'yAxis',
          color: kDailyGratitudeColor,
        ),
    ];
  }
}

class GlobalScoreChartOneWeekDataModel {
  GlobalScoreChartOneWeekDataModel(
    this.date,
    this.global,
    this.wellbeing,
    this.vocational,
    this.personalDevelopment,
  );

  String? date;

  //CHANGE IT ACCORDING TO YOUR NEED
  int? global;
  int? wellbeing;
  int? vocational;
  int? personalDevelopment;
}
