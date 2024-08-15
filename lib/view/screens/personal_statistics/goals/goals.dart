import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/model/goal/goal.dart';
import 'package:life_berg/view/screens/personal_statistics/statistics_controller.dart';
import 'package:life_berg/view/widget/custom_drop_down_header.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../generated/assets.dart';

class Globals extends StatelessWidget {
  Globals({Key? key}) : super(key: key);

  final StatisticsController statisticsController =
      Get.find<StatisticsController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(
          () => GoalChart(
            statisticsController.goalReportChart.value,
            primaryXYAxisMax: 6,
            primaryXYAxisMin: 0,
            primaryYAxisMax: 100,
            primaryYAxisMin: 0,
          ),
        ),
        Positioned(
            top: 15,
            right: 30,
            child: Container(
              width: 110,
              child: CustomDropdown<int>(
                maxlines: 1,
                closedHeaderPadding:
                    EdgeInsets.symmetric(horizontal: 7.0, vertical: 5),
                listItemBuilder: (context, item, isSelected, onItemSelect) {
                  return Text(
                    statisticsController.goalsList[item].name ?? "",
                    style: const TextStyle(color: Colors.black, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                },
                hideSelectedFieldWhenExpanded: true,
                headerBuilder: (
                  context,
                  item,
                  isSelected,
                ) {
                  return Text(
                    statisticsController.goalsList[item].name ?? "",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                },
                decoration: CustomDropdownDecoration(
                  closedFillColor: kDarkBlueColor,
                  expandedFillColor: kSecondaryColor,
                  closedBorderRadius: BorderRadius.all(Radius.circular(8)),
                  expandedBorderRadius: BorderRadius.all(Radius.circular(8)),
                  closedSuffixIcon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 20,
                  ),
                  expandedSuffixIcon: const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                    size: 20,
                  ),
                  closedShadow: [
                    BoxShadow(
                        offset: Offset(0, 0),
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        spreadRadius: 0.2),
                  ],
                ),
                items: statisticsController.goalsListIndex,
                initialItem: statisticsController.selectedGoalIndex.value,
                onChanged: (value) {
                  statisticsController.selectedGoalIndex.value = value as int;
                  statisticsController.getGoalReport(statisticsController
                      .goalsList[statisticsController.selectedGoalIndex.value]
                      .sId!);
                },
              ),
            )),
      ],
    );
  }
}

// ignore: must_be_immutable
class GoalChart extends StatelessWidget {
  GoalChart(
    this.globalScoreChartDataSource, {
    this.primaryYAxisMax,
    this.primaryYAxisMin,
    this.primaryYAxisInterval,
    this.primaryXYAxisMax,
    this.primaryXYAxisMin,
    this.primaryXYAxisInterval,
  });

  List<GoalChartDateModel> globalScoreChartDataSource;

  double? primaryYAxisMax;
  double? primaryYAxisMin;
  double? primaryYAxisInterval;

  double? primaryXYAxisMax;
  double? primaryXYAxisMin;
  double? primaryXYAxisInterval;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      child: SfCartesianChart(
        tooltipBehavior: TooltipBehavior(
          enable: true,
          textStyle: TextStyle(color: Colors.white),
          header: '',
          canShowMarker: true,
          color: kTertiaryColor,
          activationMode: ActivationMode.singleTap,
          builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
              int seriesIndex) {
            return (data.comment ?? "").isNotEmpty
                ? Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: kTertiaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      data.comment ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Ubuntu',
                      ),
                    ),
                  )
                : Container(
                    width: 40,
                    height: 30,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: kTertiaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
          },
        ),
        margin: EdgeInsets.symmetric(horizontal: 15),
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
      LineSeries<GoalChartDateModel, dynamic>(
        dataSource: globalScoreChartDataSource!,
        xValueMapper: (GoalChartDateModel data, _) =>
            DateFormat("EEE").format(DateTime.parse(data.xValueMapper!)),
        yValueMapper: (GoalChartDateModel data, _) => data.yValueMapper,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        markerSettings: MarkerSettings(
          isVisible: true,
          borderColor: kMapMarkerBorderColor,
        ),
        // dataLabelSettings: DataLabelSettings(
        //   isVisible: true,
        //   margin: EdgeInsets.symmetric(vertical: 4),
        //   builder: (data, point, series, pointIndex, seriesIndex) {
        //     if (data.comment.toString().isNotEmpty) {
        //       return MyText(
        //         text: data.comment,
        //         size: 8,
        //       );
        //     } else {
        //       return SizedBox();
        //     }
        //   },
        // ),
        color: kDarkBlueColor,
      ),
    ];
  }
}

class GoalChartDateModel {
  GoalChartDateModel(this.xValueMapper, this.yValueMapper, this.comment,
      {this.color, this.goalId});

  String? xValueMapper;

  double? yValueMapper;
  String? comment;
  Color? color;
  String? goalId;
}
