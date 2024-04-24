import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/custom_drop_down_header.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class ComparisonChartOneWeek extends StatelessWidget {
  final List<ComparisonChartOneWeekDataModel> dataSource = [
    ComparisonChartOneWeekDataModel(
      'Jan - Mar',
      35,
      45,
    ),
    ComparisonChartOneWeekDataModel(
      'Apr - July',
      40,
      30,
    ),
    ComparisonChartOneWeekDataModel(
      'Aug - Oct',
      45,
      30,
    ),
    ComparisonChartOneWeekDataModel(
      'Nov-Jan',
      25,
      15,
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
          bottom: 30,
          left: 50,
          child: Row(
            children: [
              CustomDropDownHeader(
                onTap: () {},
                title: 'Sleep',
                bgColor: kDarkBlueColor,
              ),
              SizedBox(
                width: 8,
              ),
              CustomDropDownHeader(
                onTap: () {},
                title: '20 mins cardio',
                bgColor: kCardioColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  dynamic graphData() {
    return <ChartSeries>[
      StackedLineSeries<ComparisonChartOneWeekDataModel, dynamic>(
        dataSource: dataSource,
        xValueMapper: (ComparisonChartOneWeekDataModel data, _) =>
            data.xValueMapper,
        yValueMapper: (ComparisonChartOneWeekDataModel data, _) => data.cardio,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kCardioColor,
      ),
      StackedLineSeries<ComparisonChartOneWeekDataModel, dynamic>(
          dataSource: dataSource,
          xValueMapper: (ComparisonChartOneWeekDataModel data, _) =>
              data.xValueMapper,
          yValueMapper: (ComparisonChartOneWeekDataModel data, _) => data.sleep,
          xAxisName: 'xAxis',
          yAxisName: 'yAxis',
          color: kDarkBlueColor),
    ];
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
