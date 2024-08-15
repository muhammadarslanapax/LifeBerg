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

import '../../../../constant/strings.dart';
import '../../../../model/mood_history/mood_history_response_data.dart';
import '../../../widget/custom_bottom_sheet.dart';
import '../../../widget/my_text_field.dart';

// ignore: must_be_immutable
class MoodExpand extends StatelessWidget {
  MoodExpand({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final StatisticsController statisticsController =
      Get.find<StatisticsController>();

  List<String> tabs = [
    '1 wk',
    '1 mo',
    '3 mo',
    '6 mo',
    '1 yr',
  ];

  deleteComment(dynamic data) {
    String date = data.xValueMapper ?? "";
    int score = data.yValueMapper ?? "";
    data.comment = "";
    statisticsController.updateUserMood(date, score, data.comment, (isSuccess) {
      MoodHistoryResponseData? report;
      for (var reportData in statisticsController.moodHistory) {
        DateTime date = DateTime.parse(reportData.date!);
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);
        if (formattedDate == data.xValueMapper) {
          report = reportData;
          break;
        }
      }
      if (report != null) {
        report.comment = data.comment;
        statisticsController.getMoodHistory();
      }
    });
  }

  showCommentSheet(dynamic data) {
    showModalBottomSheet(
      context: _scaffoldKey.currentContext!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (_) {
        return Padding(
          padding: MediaQuery.of(_scaffoldKey.currentContext!).viewInsets,
          child: CustomBottomSheet(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 6,
              ),
              child: MyTextField(
                fillColor: Colors.white,
                maxLines: 1,
                controller: statisticsController.moodCommentController,
                hint: addCommentDes,
                marginBottom: 0.0,
              ),
            ),
            onTap: () {
              String date = data.xValueMapper ?? "";
              int score = data.yValueMapper ?? "";
              print("Date: $date, Score: $score");
              data.comment =
                  statisticsController.moodCommentController.text.toString();
              statisticsController.updateUserMood(date, score, data.comment,
                  (isSuccess) {
                    MoodHistoryResponseData? report;
                    for (var reportData in statisticsController.moodHistory) {
                      DateTime date = DateTime.parse(reportData.date!);
                      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
                      if (formattedDate == data.xValueMapper) {
                        report = reportData;
                        break;
                      }
                    }
                    if (report != null) {
                      report.comment = data.comment;
                      statisticsController.getMoodHistory();
                    }
                Navigator.pop(_scaffoldKey.currentContext!);
              });
            },
            buttonText: submit,
            isButtonDisable: false,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: 0,
      child: Scaffold(
        key: _scaffoldKey,
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
                children: [
                  MoodChartOneWeek("one_week", (d) {
                    showCommentSheet(d);
                  }, (d) {
                    deleteComment(d);
                  }),
                  MoodChartOneWeek("one_month", (d) {
                    showCommentSheet(d);
                  }, (d) {
                    deleteComment(d);
                  }),
                  MoodChartOneWeek("three_month", (d) {}, (d) {}),
                  MoodChartOneWeek("six_month", (d) {}, (d) {}),
                  MoodChartOneWeek("one_year", (d) {}, (d) {}),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(15, 32, 15, 15),
                child: Column(
                  children: [
                    HeadingActionTile(
                      heading: 'Notes',
                    ),
                    Obx(() => statisticsController.isLoadingMoodHistory.value ==
                            true
                        ? Container(
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : ListView.builder(
                            itemBuilder: (BuildContext ctx, index) {
                              return (statisticsController
                                              .moodHistory[index].comment ??
                                          "")
                                      .isEmpty
                                  ? SizedBox()
                                  : NotesTile(
                                      note:
                                          "${DateFormat("dd/MM").format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(statisticsController.moodHistory[index].date!))} - ${statisticsController.moodHistory[index].comment ?? ""}",
                                    );
                            },
                            itemCount: statisticsController.moodHistory.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                          )),
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
