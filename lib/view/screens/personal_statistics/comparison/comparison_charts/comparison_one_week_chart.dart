import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/screens/personal_statistics/statistics_controller.dart';
import 'package:life_berg/view/widget/custom_drop_down_header.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../comparison.dart';
import '../comparison_expand.dart';
import '../comparison_goal_expand_controller.dart';

// ignore: must_be_immutable
class ComparisonChartOneWeek extends StatelessWidget {
  final ComparisonGoalExpandController goalExpandController =
      Get.find<ComparisonGoalExpandController>();
  final StatisticsController statisticsController =
      Get.find<StatisticsController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() => goalExpandController.isLoadingData.value == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SfCartesianChart(
                tooltipBehavior: TooltipBehavior(
                  enable: false,
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
                  maximum: goalExpandController.tabType.value == "one_week"
                      ? 6
                      : goalExpandController.tabType.value == "one_month"
                          ? 30
                          : goalExpandController.tabType.value == "three_month"
                              ? 2
                              : goalExpandController.tabType.value ==
                                      "six_month"
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
                series: graphData(goalExpandController.comparisonGoalsChartData),
              )),
      ],
    );
  }

  dynamic graphData(List<List<ExpandComparisonChartDataModel>> dataSource) {
    List<ChartSeries> chartLines = [];
    for(int i = 0; i < dataSource.length; i ++){
      chartLines.add(StackedLineSeries<ExpandComparisonChartDataModel, dynamic>(
        dataSource: dataSource[i],
        groupName: "Goal $i",
        xValueMapper: (ExpandComparisonChartDataModel data, _) => goalExpandController.tabType.value == "one_week" ? DateFormat("EEE").format(DateTime.parse(data.xValueMapper!)) : data.xValueMapper,
        yValueMapper: (ExpandComparisonChartDataModel data, _) => data.score,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        markerSettings: MarkerSettings(
          isVisible: true,
          borderColor: kMapMarkerBorderColor,
        ),
        color: goalExpandController.colors[i],
      ));
    }
    return chartLines;
  }
}

class ComparisonChartOneWeekDataModel {
  ComparisonChartOneWeekDataModel(
    this.xValueMapper,
    this.sleep,
    this.cardio,
  );

  String? xValueMapper;

  //CHANGE IT ACCORDING TO YOUR NEED
  int? sleep;
  int? cardio;
}
