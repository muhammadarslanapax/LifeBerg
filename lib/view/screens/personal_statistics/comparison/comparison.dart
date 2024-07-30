import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/screens/personal_statistics/statistics_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Comparison extends StatelessWidget {
  Comparison({Key? key}) : super(key: key);

  final StatisticsController statisticsController =
      Get.find<StatisticsController>();

  final List<ComparisonChartDataModel> dataSource = [
    ComparisonChartDataModel(
      'Jan - Mar',
      35,
      45,
    ),
    ComparisonChartDataModel(
      'Apr - July',
      40,
      30,
    ),
    ComparisonChartDataModel(
      'Aug - Oct',
      45,
      30,
    ),
    ComparisonChartDataModel(
      'Nov-Jan',
      25,
      15,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: [
          Obx(() => ComparisonChart(
                dataSource: statisticsController.comparisonChartData.value,
                primaryXYAxisMax: 5,
                primaryXYAxisMin: 0,
                primaryYAxisMax: 100,
                primaryYAxisMin: 0,
              )),
          Positioned(
              bottom: 30,
              left: 40,
              child: Row(
                children: [
                  Container(
                    width: 110,
                    child: CustomDropdown<int>(
                      maxlines: 1,
                      closedHeaderPadding:
                          EdgeInsets.symmetric(horizontal: 7.0, vertical: 5),
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
                  // Container(
                  //     // width: 100,
                  //     height: 30,
                  //     child: Obx(
                  //       () => DropdownButtonHideUnderline(
                  //         child: DropdownButton2(
                  //           style: TextStyle(
                  //             fontSize: 10,
                  //             color: Colors.white,
                  //           ),
                  //           items: statisticsController.goalsListIndex
                  //               .map(
                  //                 (item) => DropdownMenuItem<int>(
                  //                   value: item,
                  //                   child: MyText(
                  //                     text: statisticsController
                  //                         .goalsList[item].name,
                  //                     size: 12,
                  //                   ),
                  //                 ),
                  //               )
                  //               .toList(),
                  //           value: statisticsController
                  //               .selectedFirstGoalIndex.value,
                  //           onChanged: (index) {
                  //             statisticsController
                  //                 .selectedFirstGoalIndex.value = index as int;
                  //             statisticsController
                  //                 .getComparisonGoalReport(true);
                  //           },
                  //           icon: Image.asset(
                  //             Assets.imagesDropIcon,
                  //             height: 12,
                  //           ),
                  //           isDense: true,
                  //           isExpanded: false,
                  //           buttonHeight: 40,
                  //           buttonPadding: EdgeInsets.symmetric(
                  //             horizontal: 10,
                  //           ),
                  //           buttonDecoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(8),
                  //             color: kDarkBlueColor,
                  //           ),
                  //           buttonElevation: 0,
                  //           itemHeight: 30,
                  //           itemPadding: EdgeInsets.symmetric(
                  //             horizontal: 10,
                  //           ),
                  //           dropdownMaxHeight: 200,
                  //           // dropdownWidth: Get.width * 0.92,
                  //           dropdownPadding: null,
                  //           dropdownDecoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(8),
                  //             color: kSecondaryColor,
                  //           ),
                  //           dropdownElevation: 4,
                  //           scrollbarRadius: const Radius.circular(40),
                  //           scrollbarThickness: 6,
                  //           scrollbarAlwaysShow: true,
                  //           offset: const Offset(-2, -5),
                  //         ),
                  //       ),
                  //     )),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: 110,
                    child: CustomDropdown<int>(
                      maxlines: 1,
                      closedHeaderPadding:
                          EdgeInsets.symmetric(horizontal: 7.0, vertical: 5),
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
                  // Container(
                  //     // width: 100,
                  //     height: 30,
                  //     child: Obx(
                  //       () => DropdownButtonHideUnderline(
                  //         child: DropdownButton2(
                  //           style: TextStyle(
                  //             fontSize: 10,
                  //             color: Colors.white,
                  //           ),
                  //           items: statisticsController.goalsListIndex
                  //               .map(
                  //                 (item) => DropdownMenuItem<int>(
                  //                   value: item,
                  //                   child: MyText(
                  //                     text: statisticsController
                  //                         .goalsList[item].name,
                  //                     size: 12,
                  //                   ),
                  //                 ),
                  //               )
                  //               .toList(),
                  //           value: statisticsController
                  //               .selectedSecondGoalIndex.value,
                  //           onChanged: (index) {
                  //             statisticsController
                  //                 .selectedSecondGoalIndex.value = index as int;
                  //             statisticsController
                  //                 .getComparisonGoalReport(false);
                  //           },
                  //           icon: Image.asset(
                  //             Assets.imagesDropIcon,
                  //             height: 12,
                  //           ),
                  //           isDense: true,
                  //           isExpanded: false,
                  //           buttonHeight: 40,
                  //           buttonPadding: EdgeInsets.symmetric(
                  //             horizontal: 10,
                  //           ),
                  //           buttonDecoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(8),
                  //             color: kCardioColor,
                  //           ),
                  //           buttonElevation: 0,
                  //           itemHeight: 30,
                  //           itemPadding: EdgeInsets.symmetric(
                  //             horizontal: 10,
                  //           ),
                  //           dropdownMaxHeight: 200,
                  //           // dropdownWidth: Get.width * 0.92,
                  //           dropdownPadding: null,
                  //           dropdownDecoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(8),
                  //             color: Colors.white,
                  //           ),
                  //           dropdownElevation: 4,
                  //           scrollbarRadius: const Radius.circular(40),
                  //           scrollbarThickness: 6,
                  //           scrollbarAlwaysShow: true,
                  //           offset: const Offset(-2, -5),
                  //         ),
                  //       ),
                  //     )),
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
      height: 200,
      child: SfCartesianChart(
        tooltipBehavior: TooltipBehavior(
          enable: true,
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
          plotOffset: 10.0,
          majorGridLines: MajorGridLines(
            width: 0,
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
        xValueMapper: (ComparisonChartDataModel data, _) => data.xValueMapper,
        yValueMapper: (ComparisonChartDataModel data, _) => data.goalOne,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kDarkBlueColor,
      ),
      StackedLineSeries<ComparisonChartDataModel, dynamic>(
          dataSource: dataSource!,
          groupName: "Goal Two",
          xValueMapper: (ComparisonChartDataModel data, _) => data.xValueMapper,
          yValueMapper: (ComparisonChartDataModel data, _) => data.goalTwo,
          xAxisName: 'xAxis',
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
