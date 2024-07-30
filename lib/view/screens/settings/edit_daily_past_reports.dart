import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/settings/settings_screens/settings_controller.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/daily_mood_report.dart';
import 'package:life_berg/view/widget/my_border_button.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_calender.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/profile_heading.dart';
import 'package:life_berg/view/widget/profile_tile.dart';
import 'package:life_berg/view/widget/progress_widget.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../constant/strings.dart';
import '../../widget/home_goal_tile.dart';
import '../../widget/main_heading.dart';

class EditDailyPastReports extends StatelessWidget {
  EditDailyPastReports({Key? key}) : super(key: key);

  final SettingsController settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      appBar: simpleAppBar(
        title: 'Edit Reports',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(15),
              children: [
                MyBorderButton(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      builder: (context) {
                        return CustomBottomSheet(
                          height: Get.height * 0.7,
                          child: ListView(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            children: [
                              MyText(
                                paddingLeft: 16,
                                text: 'Date',
                                size: 20,
                                weight: FontWeight.w500,
                              ),
                              MyCalender(
                                onDateSelect: (date) {
                                  settingsController.selectedCalendarDate =
                                      date;
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            if (settingsController.selectedCalendarDate !=
                                null) {
                              settingsController.date.value =
                                  DateFormat("yyyy-MM-dd").format(
                                      settingsController.selectedCalendarDate!);
                              settingsController.getGoalReportByDate(
                                  settingsController.date.value);
                            }
                            Get.back();
                          },
                          buttonText: 'Confirm',
                          isButtonDisable: false,
                        );
                      },
                    );
                  },
                  text: 'Select Date',
                  height: 45,
                ),
                SizedBox(
                  height: 25,
                ),
                _buildProgressWidgets(),
                MainHeading(
                  paddingTop: 22,
                  text: "Daily Mood Report",
                  paddingBottom: 12,
                ),
                DailyMoodReport(),
                Obx(() => settingsController.isLoadingGoals.value
                    ? Container(
                        height: 300,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Column(
                        children: [
                          _buildWellbeingList(),
                          _buildVocationList(),
                          _buildPersonalDevList(),
                        ],
                      )),
                SizedBox(
                  height: 80,
                ),
                /*Padding(
                  padding: EdgeInsets.only(
                    left: 25,
                    right: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularStepProgressIndicator(
                        totalSteps: 100,
                        currentStep: 80,
                        selectedStepSize: 7,
                        unselectedStepSize: 5,
                        padding: 0,
                        width: 94,
                        height: 94,
                        startingAngle: 70,
                        roundedCap: (_, __) => true,
                        selectedColor: kDarkBlueColor,
                        unselectedColor: kUnSelectedColor,
                        child: Center(
                          child: MyText(
                            text: '80%',
                            size: 24,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 32,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ProgressWidget(
                              title: 'Wellbeing',
                              currentStep: 78,
                              selectedColor: kStreaksColor,
                            ),
                            ProgressWidget(
                              title: 'Vocational',
                              currentStep: 48,
                              selectedColor: kRACGPExamColor,
                            ),
                            ProgressWidget(
                              title: 'Development',
                              currentStep: 58,
                              selectedColor: kDailyGratitudeColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                MyText(
                  paddingTop: 32,
                  text: 'Daily Mood Report',
                  size: 20,
                  paddingBottom: 16,
                  weight: FontWeight.w500,
                ),
                DailyMoodReport(),

                //Wellbeing
                ProfileHeading(
                  heading: 'Wellbeing',
                  leadingColor: kStreaksColor,
                ),
                ProfileTile(
                  title: '20 mins cardio',
                  leadingIcon: Assets.imagesHeartRate,
                  leadingColor: kCoolGreyColor,
                ),
                ProfileTile(
                  title: 'Quiet Time',
                  leadingIcon: Assets.imagesQuiteTimeIcon,
                  leadingColor: kStreaksColor,
                  haveCheckBox: true,
                  checkBoxValue: false,
                  onCheckBoxTap: () {},
                ),
                ProfileTile(
                  title: 'Sleep > 7 hours',
                  leadingIcon: Assets.imagesSleepTimeIcon,
                  leadingColor: kStreaksColor,
                  haveCheckBox: true,
                  checkBoxValue: true,
                  onCheckBoxTap: () {},
                ),
                ProfileTile(
                  title: '10,000 Steps',
                  leadingIcon: Assets.imagesStepsIcon,
                  leadingColor: kStreaksColor,
                  haveCheckBox: true,
                  checkBoxValue: true,
                  onCheckBoxTap: () {},
                ),
                ProfileTile(
                  title: 'Social',
                  leadingIcon: Assets.imagesSocialIcon,
                  leadingColor: kStreaksColor,
                  haveCheckBox: true,
                  checkBoxValue: true,
                  onCheckBoxTap: () {},
                ),

                //Vocational
                ProfileHeading(
                  marginTop: 24,
                  heading: 'Vocational',
                  leadingColor: kRACGPExamColor,
                ),
                ProfileTile(
                  title: 'OSCE practice',
                  leadingIcon: Assets.imagesOse,
                  leadingColor: kRACGPExamColor,
                  haveCheckBox: true,
                  checkBoxValue: true,
                  onCheckBoxTap: () {},
                ),
                ProfileTile(
                  title: 'RACGP exam preparation',
                  leadingIcon: Assets.imagesRcgpaIcon,
                  leadingColor: kRACGPExamColor,
                  haveCheckBox: true,
                  checkBoxValue: false,
                  onCheckBoxTap: () {},
                ),
                ProfileTile(
                  title: 'Spinal research paper',
                  leadingIcon: Assets.imagesSpicalResearchPapepr,
                  leadingColor: kRACGPExamColor,
                  haveCheckBox: true,
                  checkBoxValue: true,
                  onCheckBoxTap: () {},
                ),
                ProfileTile(
                  title: 'Work productivity',
                  leadingIcon: Assets.imagesWorkProductivity,
                  leadingColor: kRACGPExamColor,
                  haveSlider: true,
                  progress: 40,
                ),

                //Personal Development
                ProfileHeading(
                  marginTop: 24,
                  heading: 'Personal Development',
                  leadingColor: kDailyGratitudeColor,
                ),
                ProfileTile(
                  title: 'Coding Course',
                  leadingIcon: Assets.imagesCodingCourse,
                  leadingColor: kDailyGratitudeColor,
                  haveSlider: true,
                  progress: 70,
                ),
                ProfileTile(
                  title: 'Daily Gratitude',
                  leadingIcon: Assets.imagesDailyGratitude,
                  leadingColor: kDailyGratitudeColor,
                  haveSlider: true,
                  progress: 90,
                ),
                ProfileTile(
                  title: 'Weight Training (30 min)',
                  leadingIcon: Assets.imagesWeightTraining,
                  leadingColor: kDailyGratitudeColor,
                  haveCheckBox: true,
                  checkBoxValue: true,
                  onCheckBoxTap: () {},
                ),
                ProfileTile(
                  title: 'Acts of Kindness',
                  leadingIcon: Assets.imagesActOfKindness,
                  leadingColor: kDailyGratitudeColor,
                  haveSlider: true,
                  progress: 40,
                ),

                //Daily Highlights
                ProfileHeading(
                  heading: 'Daily Highlights',
                  leadingColor: kTabIndicatorColor,
                ),
                ProfileTile(
                  title: 'Bake Timmy a cake',
                  leadingIcon: Assets.imagesBakeTime,
                  leadingColor: kTabIndicatorColor,
                  haveCheckBox: true,
                  checkBoxValue: true,
                ),*/
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: MyButton(
              text: 'Submit Changes',
              radius: 16,
              onTap: () {
                Get.back();
                Get.dialog(
                  MyDialog(
                    heading: 'Report Edited',
                    content:
                        'Your report for the day selected has been edited.',
                    onOkay: () => Get.back(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDevList() {
    return Column(
      children: [
        Visibility(
          child: ProfileHeading(
            marginTop: 24,
            heading: personalDevelopment,
            leadingColor: kDailyGratitudeColor,
          ),
          visible: settingsController.isLoadingGoals.value == false &&
              settingsController.submittedPersonalDevGoals.isNotEmpty,
        ),
        ListView.builder(
          itemBuilder: (BuildContext ctx, index) {
            return HomeGoalTile(
              type: "personal_development",
              index: index,
              onCheckBoxTap: () {
                settingsController
                        .submittedPersonalDevGoals[index].isChecked.value =
                    !settingsController
                        .submittedPersonalDevGoals[index].isChecked.value;
                settingsController.calculatePercentage(
                    settingsController.submittedPersonalDevGoals,
                    "personal_development");
              },
              progress: settingsController
                  .submittedPersonalDevGoals[index].sliderValue,
              checkBoxValue:
                  settingsController.submittedPersonalDevGoals[index].isChecked,
              goal: settingsController.submittedPersonalDevGoals[index],
              onProgressChange: (value) {
                settingsController
                    .submittedPersonalDevGoals[index].sliderValue.value = value;
                settingsController.calculatePercentage(
                    settingsController.submittedPersonalDevGoals,
                    "personal_development");
              },
              haveCheckBox: settingsController
                      .submittedPersonalDevGoals[index].goalMeasure?.type ==
                  "boolean",
              haveSlider: settingsController
                      .submittedPersonalDevGoals[index].goalMeasure?.type ==
                  "string",
              imageBgColor: kDailyGratitudeBgColor,
              title: settingsController.submittedPersonalDevGoals[index].name ??
                  "",
              leadingIcon:
                  "assets/goal_icons/${settingsController.submittedPersonalDevGoals[index].icon}",
              leadingColor: kDailyGratitudeColor,
            );
          },
          itemCount: settingsController.submittedPersonalDevGoals.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }

  Widget _buildWellbeingList() {
    return Column(
      children: [
        Visibility(
          visible: settingsController.isLoadingGoals.value == false &&
              settingsController.submittedWellBeingGoals.isNotEmpty,
          child: ProfileHeading(
            marginTop: 24,
            heading: wellBeing,
            leadingColor: kStreaksColor,
          ),
        ),
        ListView.builder(
          itemBuilder: (BuildContext ctx, index) {
            return HomeGoalTile(
              type: "wellbeing",
              index: index,
              progress:
                  settingsController.submittedWellBeingGoals[index].sliderValue,
              onCheckBoxTap: () {
                settingsController
                        .submittedWellBeingGoals[index].isChecked.value =
                    !settingsController
                        .submittedWellBeingGoals[index].isChecked.value;
                settingsController.calculatePercentage(
                    settingsController.submittedWellBeingGoals, "wellbeing");
              },
              onProgressChange: (value) {
                settingsController
                    .submittedWellBeingGoals[index].sliderValue.value = value;
                settingsController.calculatePercentage(
                    settingsController.submittedWellBeingGoals, "wellbeing");
              },
              haveCheckBox: settingsController
                      .submittedWellBeingGoals[index].goalMeasure?.type ==
                  "boolean",
              checkBoxValue:
                  settingsController.submittedWellBeingGoals[index].isChecked,
              haveSlider: settingsController
                      .submittedWellBeingGoals[index].goalMeasure?.type ==
                  "string",
              goal: settingsController.submittedWellBeingGoals[index],
              title:
                  settingsController.submittedWellBeingGoals[index].name ?? "",
              imageBgColor: kStreaksBgColor,
              leadingIcon:
                  "assets/goal_icons/${settingsController.submittedWellBeingGoals[index].icon}",
              leadingColor: kStreaksColor,
            );
          },
          itemCount: settingsController.submittedWellBeingGoals.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }

  Widget _buildVocationList() {
    return Column(
      children: [
        Visibility(
          visible: settingsController.isLoadingGoals.value == false &&
              settingsController.submittedVocationalGoals.isNotEmpty,
          child: ProfileHeading(
            marginTop: 24,
            heading: vocational,
            leadingColor: kRACGPExamColor,
          ),
        ),
        ListView.builder(
          itemBuilder: (BuildContext ctx, index) {
            return HomeGoalTile(
              type: "vocation",
              index: index,
              goal: settingsController.submittedVocationalGoals[index],
              onCheckBoxTap: () {
                settingsController
                        .submittedVocationalGoals[index].isChecked.value =
                    !settingsController
                        .submittedVocationalGoals[index].isChecked.value;
                settingsController.calculatePercentage(
                    settingsController.submittedVocationalGoals, "vocation");
              },
              onProgressChange: (value) {
                settingsController
                    .submittedVocationalGoals[index].sliderValue.value = value;
                settingsController.calculatePercentage(
                    settingsController.submittedVocationalGoals, "vocation");
              },
              progress: settingsController
                  .submittedVocationalGoals[index].sliderValue,
              haveCheckBox: settingsController
                      .submittedVocationalGoals[index].goalMeasure?.type ==
                  "boolean",
              haveSlider: settingsController
                      .submittedVocationalGoals[index].goalMeasure?.type ==
                  "string",
              imageBgColor: kRACGPBGExamColor,
              checkBoxValue:
                  settingsController.submittedVocationalGoals[index].isChecked,
              title:
                  settingsController.submittedVocationalGoals[index].name ?? "",
              leadingIcon:
                  "assets/goal_icons/${settingsController.submittedVocationalGoals[index].icon}",
              leadingColor: kRACGPExamColor,
            );
          },
          itemCount: settingsController.submittedVocationalGoals.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }

  _buildProgressWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainHeading(
          text: todayProgress,
          paddingBottom: 22,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 25,
            right: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => CircularStepProgressIndicator(
                    totalSteps: 100,
                    currentStep:
                        settingsController.globalPercentage.value.toInt(),
                    selectedStepSize: 7,
                    unselectedStepSize: 5,
                    padding: 0,
                    width: 94,
                    height: 94,
                    startingAngle: 70,
                    roundedCap: (_, __) => true,
                    selectedColor: kDarkBlueColor,
                    unselectedColor: kUnSelectedColor,
                    child: Center(
                      child: MyText(
                        text:
                            '${settingsController.globalPercentage.value.toInt()}%',
                        size: 24,
                      ),
                    ),
                  )),
              SizedBox(
                width: 32,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(() => ProgressWidget(
                          title: wellBeing,
                          currentStep: settingsController
                              .wellbeingPercentage.value
                              .toInt(),
                          selectedColor: kStreaksColor,
                        )),
                    Obx(
                      () => ProgressWidget(
                        title: vocational,
                        currentStep:
                            settingsController.vocationPercentage.value.toInt(),
                        selectedColor: kRACGPExamColor,
                      ),
                    ),
                    Obx(
                      () => ProgressWidget(
                        title: development,
                        currentStep: settingsController
                            .personalDevPercentage.value
                            .toInt(),
                        selectedColor: kDailyGratitudeColor,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
