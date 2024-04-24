import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/personal_statistics/goals/goal_charts/goal_one_week_chart.dart';
import 'package:life_berg/view/widget/custom_drop_down.dart';
import 'package:life_berg/view/widget/heading_action_tile.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/note_tile.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

// ignore: must_be_immutable
class GoalExpand extends StatelessWidget {
  GoalExpand({Key? key}) : super(key: key);

  List<String> tabs = [
    '1 wk',
    '1 mo',
    '3 mo',
    '6 mo',
    '1 yr',
  ];
  List<Widget> tabViews = [
    GoalChartOneWeek(),
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
          title: 'Goals',
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
                    heading: 'Goal Selection',
                  ),
                  CustomDropDown(
                    buttonHeight: 40,
                    hint: 'Select',
                    items: [
                      'Goal 1',
                      'Goal 2',
                      'Goal 3',
                    ],
                    onChanged: (value) {},
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  HeadingActionTile(
                    heading: 'Notes',
                  ),
                  NotesTile(
                    note: '23/11 - In hospital with Ellie',
                  ),
                  NotesTile(
                    note: '02/11 - Annual leave',
                  ),
                  NotesTile(
                    note: '4/10 - Tension headache',
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
