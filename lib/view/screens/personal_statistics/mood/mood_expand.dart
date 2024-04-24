import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/personal_statistics/mood/moods_charts/mood_one_week_data.dart';
import 'package:life_berg/view/widget/heading_action_tile.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/note_tile.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

// ignore: must_be_immutable
class MoodExpand extends StatelessWidget {
  MoodExpand({Key? key}) : super(key: key);

  List<String> tabs = [
    '1 wk',
    '1 mo',
    '3 mo',
    '6 mo',
    '1 yr',
  ];
  List<Widget> tabViews = [
    MoodChartOneWeek(),
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
          title: 'Mood',
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
                    heading: 'Notes',
                  ),
                  NotesTile(
                    note: '23/11 - Macy’s cancer diagnosis',
                  ),
                  NotesTile(
                    note: '02/11 - Alla’s graduation',
                  ),
                  NotesTile(
                    note: '4/10 - back pain from slipped disc',
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
