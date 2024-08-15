import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/screens/personal_statistics/statistics_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Comparison extends StatelessWidget {
  Comparison({Key? key}) : super(key: key);

  final StatisticsController statisticsController =
      Get.find<StatisticsController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: [
          Obx(() => ComparisonChart(
                dataSource: statisticsController.comparisonChartData.value,
                primaryXYAxisMax: 6,
                primaryXYAxisMin: 0,
                primaryYAxisMax: 100,
                primaryYAxisMin: 0,
              )),
          Positioned(
              bottom: 10,
              right: 10,
              child: Row(
                children: [
                  Container(
                    width: 110,
                    child: CustomDropdown<int>(
                      maxlines: 1,
                      closedHeaderPadding:
                          EdgeInsets.symmetric(horizontal: 7.0, vertical: 4),
                      listItemBuilder:
                          (context, item, isSelected, onItemSelect) {
                        return Text(
                          statisticsController.goalsList[item].name ?? "",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 11),
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
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                      decoration: CustomDropdownDecoration(
                        closedFillColor: kDarkBlueColor,
                        expandedFillColor: kSecondaryColor,
                        closedBorderRadius:
                            BorderRadius.all(Radius.circular(8)),
                        expandedBorderRadius:
                            BorderRadius.all(Radius.circular(8)),
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
                      initialItem:
                          statisticsController.selectedFirstGoalIndex.value,
                      onChanged: (value) {
                        statisticsController.selectedFirstGoalIndex.value =
                            value as int;
                        statisticsController.getComparisonGoalReport(true);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: 110,
                    child: CustomDropdown<int>(
                      maxlines: 1,
                      closedHeaderPadding:
                          EdgeInsets.symmetric(horizontal: 7.0, vertical: 4),
                      listItemBuilder:
                          (context, item, isSelected, onItemSelect) {
                        return Text(
                          statisticsController.goalsList[item].name ?? "",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 11),
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
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                      decoration: CustomDropdownDecoration(
                        closedFillColor: kCardioColor,
                        expandedFillColor: kSecondaryColor,
                        closedBorderRadius:
                            BorderRadius.all(Radius.circular(8)),
                        expandedBorderRadius:
                            BorderRadius.all(Radius.circular(8)),
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
                      initialItem:
                          statisticsController.selectedSecondGoalIndex.value,
                      onChanged: (value) {
                        statisticsController.selectedSecondGoalIndex.value =
                            value as int;
                        statisticsController.getComparisonGoalReport(false);
                      },
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ComparisonChart extends StatelessWidget {
  ComparisonChart({
    this.dataSource,
    this.primaryYAxisMax,
    this.primaryYAxisMin,
    this.primaryYAxisInterval,
    this.primaryXYAxisMax,
    this.primaryXYAxisMin,
    this.primaryXYAxisInterval,
  });

  List<ComparisonChartDataModel>? dataSource;

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
          enable: false,
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
          plotOffset: 30.0,
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
      StackedLineSeries<ComparisonChartDataModel, dynamic>(
        dataSource: dataSource!,
        groupName: "Goal One",
        xValueMapper: (ComparisonChartDataModel data, _) => DateFormat("EEE").format(DateTime.parse(data.xValueMapper!)),
        yValueMapper: (ComparisonChartDataModel data, _) => data.goalOne,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        markerSettings: MarkerSettings(
          isVisible: true,
          borderColor: kMapMarkerBorderColor,
        ),
        color: kDarkBlueColor,
      ),
      StackedLineSeries<ComparisonChartDataModel, dynamic>(
          dataSource: dataSource!,
          groupName: "Goal Two",
          xValueMapper: (ComparisonChartDataModel data, _) => DateFormat("EEE").format(DateTime.parse(data.xValueMapper!)),
          yValueMapper: (ComparisonChartDataModel data, _) => data.goalTwo,
          xAxisName: 'xAxis',
          markerSettings: MarkerSettings(
            isVisible: true,
            borderColor: kMapMarkerBorderColor,
          ),
          yAxisName: 'yAxis',
          color: kCardioColor),
    ];
  }
}

class ComparisonChartDataModel {
  ComparisonChartDataModel(
    this.xValueMapper,
    this.goalOne,
    this.goalTwo,
  );

  String? xValueMapper;

  //CHANGE IT ACCORDING TO YOUR NEED
  int? goalOne;
  int? goalTwo;
}
