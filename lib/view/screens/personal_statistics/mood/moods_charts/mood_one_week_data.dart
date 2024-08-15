import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/constant/strings.dart';
import 'package:life_berg/view/widget/charts_widget/mood_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../generated/assets.dart';
import '../../../../widget/menu_item.dart';
import '../../statistics_controller.dart';

class MoodChartOneWeek extends StatelessWidget {
  final String? type;
  final Function(dynamic data) onShowCommentBottomSheet;
  final Function(dynamic data) onDeleteComment;

  MoodChartOneWeek(
      this.type, this.onShowCommentBottomSheet, this.onDeleteComment,
      {Key? key})
      : super(key: key);

  final StatisticsController statisticsController =
      Get.find<StatisticsController>();

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      tooltipBehavior: TooltipBehavior(
          enable: true,
          header: '',
          canShowMarker: true,
          textStyle: TextStyle(color: Colors.white),
          color: kTertiaryColor,
          builder:
              (dynamic data, dynamic point, dynamic series, int index, int d) {
            return GestureDetector(
              onLongPress: () async {
                if (type == "one_week" || type == "one_month")
                  showDialog(
                    context: context,
                    builder: (BuildContext ctx) {
                      return AlertDialog(
                        insetPadding: EdgeInsets.symmetric(horizontal: 100),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                        backgroundColor: Colors.white,
                        content: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              menuItem(
                                  icon: Assets.imagesEditItem,
                                  title: (data.comment ?? "")
                                          .toString()
                                          .isNotEmpty
                                      ? 'Edit comment'
                                      : "Add comment",
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    statisticsController.moodCommentController
                                        .text = data.comment ?? "";
                                    onShowCommentBottomSheet(data);
                                  },
                                  borderColor: (data.comment ?? "")
                                          .toString()
                                          .isNotEmpty
                                      ? kBorderColor
                                      : Colors.transparent),
                              if ((data.comment ?? "")
                                  .toString()
                                  .isNotEmpty)
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
              },
              child: (data.comment ?? "").toString().isNotEmpty
                  ? Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: kTertiaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '${data.comment ?? ""}',
                        style: TextStyle(color: Colors.white),
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
          color: kTertiaryColor,
          borderColor: kMapMarkerBorderColor,
        ),
        xValueMapper: (MoodChartDataModel data, _) => type == "one_week"
            ? DateFormat("EEE").format(DateTime.parse(data.xValueMapper))
            : type == "one_month"
                ? DateFormat("MMM dd").format(DateTime.parse(data.xValueMapper))
                : data.xValueMapper,
        yValueMapper: (MoodChartDataModel data, _) => data.yValueMapper,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: Colors.transparent,
      ),
    ];
  }
}

class MoodChartOneWeekDataModel {
  MoodChartOneWeekDataModel(
    this.xValueMapper,
    this.yValueMapper,
    this.comment,
  );

  String? xValueMapper;
  int? yValueMapper;
  String? comment;
}
