import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/screens/personal_statistics/goals/goal_expand_controller.dart';
import 'package:life_berg/view/widget/custom_drop_down_header.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../generated/assets.dart';
import '../../statistics_controller.dart';
import '../goals.dart';

// ignore: must_be_immutable
class GoalChartOneWeek extends StatelessWidget {
  final String type;

  GoalChartOneWeek(this.type, {Key? key}) : super(key: key);

  final GoalExpandController goalExpandController =
      Get.find<GoalExpandController>();

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
                  enable: true,
                  activationMode: ActivationMode.singleTap,
                  builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                    if (data.comment != null && data.comment!.isNotEmpty) {
                      return Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          data.comment!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Ubuntu',
                          ),
                        ),
                      );
                    } else {
                      // Return an empty container if the comment is empty to hide the tooltip
                      return SizedBox.shrink();
                    }
                  },
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
                series: graphData(goalExpandController.expandedGoalReportChart),
              )),
        // Positioned(
        //     top: 20,
        //     right: 40,
        //     child: Container(
        //         width: 120,
        //         height: 40,
        //         child: Obx(
        //           () => DropdownButtonHideUnderline(
        //             child: DropdownButton2(
        //               style: TextStyle(
        //                 fontSize: 12,
        //                 color: Colors.white,
        //               ),
        //               items: statisticsController.goalsListIndex
        //                   .map(
        //                     (item) => DropdownMenuItem<int>(
        //                       value: item,
        //                       child: MyText(
        //                         text: statisticsController.goalsList[item].name,
        //                         size: 13,
        //                       ),
        //                     ),
        //                   )
        //                   .toList(),
        //               value: statisticsController.selectedExpandGoalIndex.value,
        //               onChanged: (index) {
        //                 statisticsController.selectedExpandGoalIndex.value =
        //                     index as int;
        //                 statisticsController.getGoalReport(
        //                     statisticsController
        //                         .goalsList[statisticsController
        //                             .selectedExpandGoalIndex.value]
        //                         .sId!,
        //                     true,
        //                     false,
        //                     type: type);
        //               },
        //               icon: Image.asset(
        //                 Assets.imagesDropIcon,
        //                 height: 12,
        //               ),
        //               isDense: true,
        //               isExpanded: false,
        //               buttonHeight: 40,
        //               buttonPadding: EdgeInsets.symmetric(
        //                 horizontal: 10,
        //               ),
        //               buttonDecoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(8),
        //                 color: kDarkBlueColor,
        //               ),
        //               buttonElevation: 0,
        //               itemHeight: 30,
        //               itemPadding: EdgeInsets.symmetric(
        //                 horizontal: 10,
        //               ),
        //               dropdownMaxHeight: 200,
        //               // dropdownWidth: Get.width * 0.92,
        //               dropdownPadding: null,
        //               dropdownDecoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(8),
        //                 color: kSecondaryColor,
        //               ),
        //               dropdownElevation: 4,
        //               scrollbarRadius: const Radius.circular(40),
        //               scrollbarThickness: 6,
        //               scrollbarAlwaysShow: true,
        //               offset: const Offset(-2, -5),
        //             ),
        //           ),
        //         ))),
      ],
    );
  }

  dynamic graphData(RxList<GoalChartDateModel> data) {
    return <ChartSeries>[
      LineSeries<GoalChartDateModel, dynamic>(
        dataSource: data,
        xValueMapper: (GoalChartDateModel data, _) => data.xValueMapper,
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
