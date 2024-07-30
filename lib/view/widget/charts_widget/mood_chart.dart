import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class MoodChartDataModel {
  MoodChartDataModel(this.xValueMapper, this.yValueMapper);

  String xValueMapper;
  int yValueMapper;
}

class MoodChart extends StatelessWidget {
  MoodChart({
    required this.moodChartDataSource,
    this.primaryYAxisMax = 100,
    this.primaryYAxisMin = 0,
    this.primaryYAxisInterval = 20,
    this.primaryXYAxisMax,
    this.primaryXYAxisMin,
    this.primaryXYAxisInterval = 1,
  });

  final List<MoodChartDataModel> moodChartDataSource;
  final double primaryYAxisMax;
  final double primaryYAxisMin;
  final double primaryYAxisInterval;
  final double? primaryXYAxisMax;
  final double? primaryXYAxisMin;
  final double primaryXYAxisInterval;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: SfCartesianChart(
        tooltipBehavior: TooltipBehavior(enable: true),
        margin: EdgeInsets.zero,
        borderWidth: 0,
        borderColor: Colors.transparent,
        plotAreaBorderWidth: 0,
        enableAxisAnimation: true,
        primaryYAxis: NumericAxis(
          name: 'yAxis',
          maximum: primaryYAxisMax,
          minimum: primaryYAxisMin,
          interval: primaryYAxisInterval,
          plotOffset: 10.0,
          majorGridLines: MajorGridLines(
            width: 1.2,
            color: kChartBorderColor,
          ),
          majorTickLines: MajorTickLines(width: 0),
          axisLine: AxisLine(width: 0),
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 11.0,
            fontFamily: 'Ubuntu',
          ),
        ),
        primaryXAxis: CategoryAxis(
          name: 'xAxis',
          maximum: primaryXYAxisMax,
          minimum: primaryXYAxisMin,
          interval: primaryXYAxisInterval,
          majorGridLines: MajorGridLines(width: 0),
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(width: 0),
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 11.0,
            fontFamily: 'Ubuntu',
          ),
        ),
        series: graphData(),
      ),
    );
  }

  List<ChartSeries<MoodChartDataModel, String>> graphData() {
    return <ChartSeries<MoodChartDataModel, String>>[
      LineSeries<MoodChartDataModel, String>(
        dataSource: moodChartDataSource,
        markerSettings: MarkerSettings(
          isVisible: true,
          borderColor: kMapMarkerBorderColor,
        ),
        xValueMapper: (MoodChartDataModel data, _) => data.xValueMapper,
        yValueMapper: (MoodChartDataModel data, _) => data.yValueMapper,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kDarkBlueColor,
      ),
    ];
  }
}
