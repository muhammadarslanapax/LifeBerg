import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/constant/color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class MoodChartDataModel {
  MoodChartDataModel(this.xValueMapper, this.yValueMapper, this.comment);

  String xValueMapper;
  int? yValueMapper;
  String? comment;
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
        tooltipBehavior: TooltipBehavior(
            enable: true,
            header: '',
            canShowMarker: true,
            textStyle: TextStyle(color: Colors.white),
            color: kTertiaryColor,
            builder: (dynamic data, dynamic point, dynamic series, int index,
                int d) {
              return (data.comment ?? "").toString().isNotEmpty
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
                    );
            }),
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
          maximum: 6,
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
          color: kTertiaryColor,
          borderColor: kMapMarkerBorderColor,
        ),
        xValueMapper: (MoodChartDataModel data, _) =>
            DateFormat("EEE").format(DateTime.parse(data.xValueMapper)),
        yValueMapper: (MoodChartDataModel data, _) => data.yValueMapper,
        xAxisName: 'xAxis',
        yAxisName: 'yAxis',
        color: Colors.transparent,
      ),
    ];
  }
}
