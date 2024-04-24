import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/personal_statistics/global_score/gloabl_score_charts/global_score_one_week_chart.dart';
import 'package:life_berg/view/widget/custom_icon_tile.dart';
import 'package:life_berg/view/widget/heading_action_tile.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

// ignore: must_be_immutable
class GlobalScoreExpand extends StatelessWidget {
  GlobalScoreExpand({Key? key}) : super(key: key);

  List<String> tabs = [
    '1 wk',
    '1 mo',
    '3 mo',
    '6 mo',
    '1 yr',
  ];
  List<Widget> tabViews = [
    GlobalScoreOneWeek(),
    Container(),
    Container(),
    Container(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: kSecondaryColor,
        appBar: simpleAppBar(
          title: 'Global Score',
        ),
        body: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: SizedBox(
                height: 41,
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: TabBar(
                          isScrollable: true,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: kDayStepColor,
                          indicatorWeight: 4,
                          labelPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          tabs: List<Tab>.generate(
                            tabs.length,
                            (index) => Tab(
                              child: MyText(
                                text: tabs[index],
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Image.asset(
                        Assets.imagesPointsAccuralClose,
                        height: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 350,
              child: TabBarView(
                physics: BouncingScrollPhysics(),
                children: tabViews,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 32, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HeadingActionTile(
                    heading: 'Display',
                  ),
                  CustomIconTile(
                    title: 'Global Score',
                    leadingColor: kLightPurpleColor,
                    haveCheckBox: true,
                    value: true,
                    onTap: () {},
                  ),
                  CustomIconTile(
                    title: 'Wellbeing',
                    leadingColor: kWellBeingColor,
                    haveCheckBox: true,
                    value: true,
                    onTap: () {},
                  ),
                  CustomIconTile(
                    title: 'Vocational',
                    leadingColor: kRACGPExamColor,
                    haveCheckBox: true,
                    value: true,
                    onTap: () {},
                  ),
                  CustomIconTile(
                    title: 'Personal Development',
                    leadingColor: kDailyGratitudeColor,
                    haveCheckBox: true,
                    value: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
