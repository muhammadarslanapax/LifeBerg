import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/screens/personal_statistics/goals/goal_expand_controller.dart';
import 'package:life_berg/view/screens/personal_statistics/statistics_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../generated/assets.dart';
import '../../../../widget/menu_item.dart';
import '../goals.dart';

// ignore: must_be_immutable
class GoalChartOneWeek extends StatelessWidget {
  final String type;
  final Function(dynamic data) onShowCommentBottomSheet;
  final Function(dynamic data) onDeleteComment;

  GoalChartOneWeek(this.type, this.onShowCommentBottomSheet,this.onDeleteComment, {Key? key})
      : super(key: key);

  final GoalExpandController goalExpandController =
      Get.find<GoalExpandController>();

  final StatisticsController controller = Get.find<StatisticsController>();

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
                  textStyle: TextStyle(color: Colors.white),
                  header: '',
                  canShowMarker: true,
                  color: kTertiaryColor,
                  activationMode: ActivationMode.singleTap,
                  builder: (dynamic data, dynamic point, dynamic series,
                      int pointIndex, int seriesIndex) {
                    return GestureDetector(
                      onLongPress: () async {
                        if (goalExpandController.tabType.value == "one_week" ||
                        goalExpandController.tabType.value == "one_month") {
                          showDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return AlertDialog(
                                insetPadding: EdgeInsets.symmetric(horizontal: 100),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10.0),
                                backgroundColor: Colors.white,
                                content: Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      menuItem(
                                          icon: Assets.imagesEditItem,
                                          title: (data.comment ?? "").isNotEmpty
                                              ? 'Edit comment'
                                              : "Add comment",
                                          onTap: () {
                                            Navigator.of(context).pop();
                                              goalExpandController
                                                  .commentController
                                                  .text = data.comment ?? "";
                                              onShowCommentBottomSheet(data);
                                          },
                                          borderColor:
                                              (data.comment ?? "").isNotEmpty
                                                  ? kBorderColor
                                                  : Colors.transparent),
                                      if ((data.comment ?? "").isNotEmpty)
                                        menuItem(
                                          icon: Assets.imagesDeleteThisItem,
                                          title: 'Delete comment',
                                          borderColor: Colors.transparent,
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            onDeleteComment(data);
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              );
                            },
                          );
                        }
                      },
                      child: (data.comment ?? "").isNotEmpty
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
                series: graphData(
                    goalExpandController.expandedGoalReportChart, context),
              )),
      ],
    );
  }

  dynamic graphData(RxList<GoalChartDateModel> data, BuildContext context) {
    return <ChartSeries>[
      LineSeries<GoalChartDateModel, dynamic>(
        dataSource: data,
        xValueMapper: (GoalChartDateModel data, _) =>
            goalExpandController.tabType.value == "one_week"
                ? DateFormat("EEE").format(DateTime.parse(data.xValueMapper!))
                : goalExpandController.tabType.value == 'one_month' ?
            DateFormat("MMM dd").format(DateTime.parse(data.xValueMapper!)): data.xValueMapper,
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
