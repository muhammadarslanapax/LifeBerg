import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/custom_drop_down_header.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Comparison extends StatelessWidget {
  Comparison({Key? key}) : super(key: key);
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
          ComparisonChart(
            dataSource: dataSource,
            primaryXYAxisMax: 3,
            primaryXYAxisMin: 0,
            primaryYAxisMax: 100,
            primaryYAxisMin: 0,
          ),
          Positioned(
            bottom: 30,
            left: 40,
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
        xValueMapper: (ComparisonChartDataModel data, _) => data.xValueMapper,
        yValueMapper: (ComparisonChartDataModel data, _) => data.cardio,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kCardioColor,
      ),
      StackedLineSeries<ComparisonChartDataModel, dynamic>(
        dataSource: dataSource!,
        xValueMapper: (ComparisonChartDataModel data, _) => data.xValueMapper,
        yValueMapper: (ComparisonChartDataModel data, _) => data.sleep,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kDarkBlueColor
      ),
    ];
  }
}

class ComparisonChartDataModel {
  ComparisonChartDataModel(
      this.xValueMapper,
      this.sleep,
      this.cardio,
      );

  String? xValueMapper;

  //CHANGE IT ACCORDING TO YOUR NEED
  int? sleep;
  int? cardio;
}
