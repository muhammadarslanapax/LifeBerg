import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/personal_statistics/mood/moods_charts/mood_one_week_data.dart';
import 'package:life_berg/view/screens/personal_statistics/statistics_controller.dart';
import 'package:life_berg/view/widget/heading_action_tile.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/note_tile.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

import '../../../../model/mood_history/mood_history_response_data.dart';

// ignore: must_be_immutable
class MoodExpand extends StatelessWidget {
  final List<MoodHistoryResponseData> moodHistory;

  MoodExpand(this.moodHistory, {Key? key}) : super(key: key);

  final StatisticsController statisticsController =
      Get.find<StatisticsController>();

  List<String> tabs = [
    '1 wk',
    '1 mo',
    '3 mo',
    '6 mo',
    '1 yr',
  ];

  List<Widget> tabViews = [
    MoodChartOneWeek("one_week"),
    MoodChartOneWeek("one_month"),
    MoodChartOneWeek("three_month"),
    MoodChartOneWeek("six_month"),
    MoodChartOneWeek("one_year"),
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
                  children: [
                    HeadingActionTile(
                      heading: 'Notes',
                    ),
                    ListView.builder(
                      itemBuilder: (BuildContext ctx, index) {
                        return (moodHistory[index].comment ?? "").isEmpty
                            ? SizedBox()
                            : NotesTile(
                                note:
                                    "${DateFormat("dd/MM").format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(moodHistory[index].date!))} - ${moodHistory[index].comment ?? ""}",
                              );
                      },
                      itemCount: moodHistory.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                  ],
                )),
            // Padding(
            //   padding: EdgeInsets.fromLTRB(15, 32, 15, 15),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.stretch,
            //     children: [
            //       HeadingActionTile(
            //         heading: 'Notes',
            //       ),
            //       NotesTile(
            //         note: '23/11 - Macy’s cancer diagnosis',
            //       ),
            //       NotesTile(
            //         note: '02/11 - Alla’s graduation',
            //       ),
            //       NotesTile(
            //         note: '4/10 - back pain from slipped disc',
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
