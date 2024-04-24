import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/settings/settings_screens/points/points_expand.dart';
import 'package:life_berg/view/widget/charts_widget/points_accural_chart.dart';
import 'package:life_berg/view/widget/custom_icon_tile.dart';
import 'package:life_berg/view/widget/heading_action_tile.dart';
import 'package:life_berg/view/widget/mile_stone_card.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Points extends StatelessWidget {
  final List<PointAccuralChartDataModel> _pointsAccuralChartData = [
    PointAccuralChartDataModel(
      'Jan - Mar',
      0,
    ),
    PointAccuralChartDataModel(
      'Apr - July',
      2,
    ),
    PointAccuralChartDataModel(
      'Aug - Oct',
      4,
    ),
    PointAccuralChartDataModel(
      'Nov-Jan',
      6,
    ),
    PointAccuralChartDataModel(
      '',
      2,
    ),
  ];

  final List<ChartData> chartData = [
    ChartData(
      'David',
      67,
      kDailyGratitudeColor,
    ),
    ChartData(
      'Steve',
      35,
      kStreaksColor,
    ),
    ChartData(
      'Jack',
      25,
      kRACGPExamColor,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      appBar: simpleAppBar(
        title: 'Points',
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(15),
        children: [
          MyText(
            paddingTop: 5,
            text: 'Milestones',
            size: 20,
            weight: FontWeight.w500,
            paddingBottom: 16,
          ),
          Row(
            children: [
              Expanded(
                child: MilestoneCard(
                  icon: Assets.imagesGoalsAchieve,
                  points: '328',
                  title: 'Goals Achieved',
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: MilestoneCard(
                  icon: Assets.imagesBestStreaks,
                  points: '45',
                  title: 'Best Streaks',
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: MilestoneCard(
                  icon: Assets.imagesPerfectDays,
                  points: '62',
                  title: 'Perfect Days',
                ),
              ),
            ],
          ),
          MyText(
            paddingTop: 32,
            text: 'Points Breakdown',
            size: 20,
            weight: FontWeight.w500,
            paddingBottom: 16,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 200,
                child: SfCircularChart(
                  series: <CircularSeries>[
                    DoughnutSeries<ChartData, String>(
                      dataSource: chartData,
                      radius: '80',
                      pointColorMapper: (ChartData data, Color) => data.color,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      cornerStyle: CornerStyle.bothCurve,
                      innerRadius: '80%',
                    ),
                  ],
                ),
              ),
              MyText(
                text: '127',
                size: 35,
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          CustomIconTile(
            title: 'Daily Reporting',
            leadingColor: kDailyGratitudeColor,
            points: 67,
          ),
          CustomIconTile(
            title: 'Streaks',
            leadingColor: kStreaksColor,
            points: 35,
          ),
          CustomIconTile(
            title: 'Journaling & Development',
            leadingColor: kRACGPExamColor,
            points: 25,
          ),
          SizedBox(
            height: 16,
          ),
          HeadingActionTile(
            heading: 'Points Accural',
            haveTrailing: true,
            onTap: () => Get.to(
              () => PointsExpand(),
            ),
          ),
          PointAccuralChart(
            dataSource: _pointsAccuralChartData,
            primaryXYAxisMax: 3,
            primaryXYAxisMin: 0,
            primaryYAxisMax: 8,
            primaryYAxisMin: 0,
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(
    this.x,
    this.y,
    this.color,
  );

  final String x;
  final double y;
  final Color color;
}
