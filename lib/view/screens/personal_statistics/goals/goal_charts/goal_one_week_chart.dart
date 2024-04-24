import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/custom_drop_down_header.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class GoalChartOneWeek extends StatelessWidget {
  final List<GoalsChartDateModel> data = [
    GoalsChartDateModel(
      'Jan - Mar',
      0,
    ),
    GoalsChartDateModel(
      'Apr - July',
      40,
    ),
    GoalsChartDateModel(
      'Aug - Oct',
      10,
    ),
    GoalsChartDateModel(
      'Nov-Jan',
      25,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SfCartesianChart(
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
            maximum: 3,
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
        ),
        Positioned(
          top: 20,
          right: 40,
          child: CustomDropDownHeader(
            onTap: () {},
            title: 'Sleep',
            bgColor: kDarkBlueColor,
          ),
        ),
      ],
    );
  }

  dynamic graphData() {
    return <ChartSeries>[
      LineSeries<GoalsChartDateModel, dynamic>(
        dataSource: data,
        xValueMapper: (GoalsChartDateModel data, _) => data.xValueMapper,
        yValueMapper: (GoalsChartDateModel data, _) => data.yValueMapper,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        markerSettings: MarkerSettings(
          isVisible: true,
          borderColor: kMapMarkerBorderColor,
        ),
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          margin: EdgeInsets.symmetric(vertical: 4),
          builder: (data, point, series, pointIndex, seriesIndex) {
            if (pointIndex == 1) {
              return MyText(
                text: 'Tension headache',
                size: 8,
              );
            } else if (pointIndex == 2) {
              return MyText(
                text: 'Annual leave',
                size: 8,
              );
            } else if (pointIndex == 3) {
              return MyText(
                text: 'In hospital with Ellie',
                size: 8,
              );
            } else {
              return SizedBox();
            }
          },
        ),
        color: kDarkBlueColor,
      ),
    ];
  }
}

class GoalsChartDateModel {
  GoalsChartDateModel(
    this.xValueMapper,
    this.yValueMapper,
  );

  String? xValueMapper;

  //CHANGE IT ACCORDING TO YOUR NEED
  int? yValueMapper;
}
