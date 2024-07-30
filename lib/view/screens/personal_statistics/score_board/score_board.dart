import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/personal_statistics/score_board/score_board_controller.dart';
import 'package:life_berg/view/screens/personal_statistics/statistics_controller.dart';
import 'package:life_berg/view/widget/custom_drop_down.dart';
import 'package:life_berg/view/widget/custom_icon_tile.dart';
import 'package:life_berg/view/widget/heading_action_tile.dart';
import 'package:life_berg/view/widget/menu_item.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

class ScoreBoard extends StatelessWidget {
  ScoreBoard({Key? key}) : super(key: key);

  final StatisticsController statisticsController =
      Get.find<StatisticsController>();
  final ScoreBoardController scoreBoardController =
      Get.put(ScoreBoardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      appBar: simpleAppBar(
        title: 'ScoreBoard',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeadingActionTile(
              heading: 'Scoreboard',
              haveTrailing: true,
              customTrailingIcon: Assets.imagesPointsAccuralClose,
              onTap: () => Get.back(),
            ),
            GestureDetector(
              onTap: () {
                showMenu(
                  elevation: 10,
                  constraints: BoxConstraints(
                    maxWidth: 206,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  context: context,
                  position: RelativeRect.fromLTRB(110.0, 170.0, 0.0, 0.0),
                  items: [
                    menuItem(
                        title: 'Past week',
                        icon: '',
                        onTap: () {
                          scoreBoardController.graphType.value = "Past week";
                          scoreBoardController
                              .calculateGoalPercentagesForLastWeek(
                                  statisticsController.goalReportListResponse!);
                          Navigator.of(context).pop();
                        }),
                    menuItem(
                        title: 'Past month',
                        icon: '',
                        onTap: () {
                          scoreBoardController.graphType.value = "Past month";
                          scoreBoardController
                              .calculateGoalPercentagesForLastWeek(
                                  statisticsController.goalReportListResponse!);
                          Navigator.of(context).pop();
                        }),
                    menuItem(
                        title: 'Past year',
                        icon: '',
                        onTap: () {
                          scoreBoardController.graphType.value = "Past year";
                          scoreBoardController
                              .calculateGoalPercentagesForLastWeek(
                                  statisticsController.goalReportListResponse!);
                          Navigator.of(context).pop();
                        }),
                    menuItem(
                        title: 'All',
                        icon: '',
                        borderColor: Colors.transparent,
                        onTap: () {
                          scoreBoardController.graphType.value = "All";
                          scoreBoardController
                              .calculateGoalPercentagesForLastWeek(
                                  statisticsController.goalReportListResponse!);
                          Navigator.of(context).pop();
                        }),
                  ],
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() => MyText(
                        text: scoreBoardController.graphType.value,
                        size: 12,
                        paddingRight: 8,
                      )),
                  Image.asset(
                    Assets.imagesArrowDown,
                    height: 20,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child:
                  Obx(() => ListView.builder(
                    itemBuilder: (BuildContext ctx, index) {
                      return CustomIconTile(
                        title: scoreBoardController.goalCompletionList[index]['name'],
                        leadingColor: statisticsController.getCategoryColor(
                            scoreBoardController.goalCompletionList[index]
                            ['category']),
                        points: scoreBoardController.goalCompletionList[index]
                        ['completionPercentage']
                            .toInt(),
                      );
                    },
                    itemCount: scoreBoardController
                        .goalCompletionList
                        .length,
                  ),),
            ),
            /*CustomIconTile(
              title: 'Daily gratitude',
              leadingColor: kDailyGratitudeColor,
              points: 86,
            ),
            CustomIconTile(
              title: 'Quiet Time',
              leadingColor: kStreaksColor,
              points: 100,
            ),
            CustomIconTile(
              title: 'RACGP Exam',
              leadingColor: kRACGPExamColor,
              points: 86,
            ),
            CustomIconTile(
              title: '10 Steps a day',
              leadingColor: kDayStepColor,
              points: 95,
            ),
            CustomIconTile(
              title: '20 mins cardio',
              leadingColor: kRACGPExamColor,
              points: 62,
            ),*/
          ],
        ),
      ),
    );
  }
}
