import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class CustomSplineChart extends StatelessWidget {
  CustomSplineChart({
    this.customSplineChartData,
    this.primaryYAxisMax,
    this.primaryYAxisMin,
    this.primaryYAxisInterval,
    this.primaryXYAxisMax,
    this.primaryXYAxisMin,
    this.primaryXYAxisInterval,
    this.title = '',
    this.onThisWeek,
  });

  List<CustomSplineChartData>? customSplineChartData;

  double? primaryYAxisMax;
  double? primaryYAxisMin;
  double? primaryYAxisInterval;

  double? primaryXYAxisMax;
  double? primaryXYAxisMin;
  double? primaryXYAxisInterval;
  String? title;
  VoidCallback? onThisWeek;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
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
          minimum: primaryYAxisMin,
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
            color: kTertiaryColor.withOpacity(0.3),
            fontSize: 10.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        primaryXAxis: CategoryAxis(
          name: 'xAxis',
          maximum: primaryXYAxisMax,
          minimum: primaryXYAxisMin,
          interval: primaryXYAxisInterval,
          plotOffset: 5.0,
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
            color: kTertiaryColor.withOpacity(0.3),
            fontSize: 10.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        series: graphData(),
      ),
    );
  }

  dynamic graphData() {
    return <ChartSeries>[
      SplineAreaSeries<CustomSplineChartData, dynamic>(
        dataSource: customSplineChartData!,
        xValueMapper: (CustomSplineChartData data, _) => data.xValueMapper,
        yValueMapper: (CustomSplineChartData data, _) => data.yValueMapper,
        splineType: SplineType.natural,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            kDarkBlueColor.withOpacity(0.4),
            kDarkBlueColor.withOpacity(0.3),
            kDarkBlueColor.withOpacity(0.1),
          ],
        ),
      ),
      SplineSeries<CustomSplineChartData, dynamic>(
        dataSource: customSplineChartData!,
        xValueMapper: (CustomSplineChartData data, _) => data.xValueMapper,
        yValueMapper: (CustomSplineChartData data, _) => data.yValueMapper,
        splineType: SplineType.natural,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: kDarkBlueColor,
      ),
    ];
  }
}

class CustomSplineChartData {
  CustomSplineChartData(
    this.xValueMapper,
    this.yValueMapper,
  );

  String? xValueMapper;
  int? yValueMapper;
}
