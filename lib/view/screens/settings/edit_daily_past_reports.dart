import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
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

class EditDailyPastReports extends StatelessWidget {
  EditDailyPastReports({Key? key}) : super(key: key);

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
                              MyCalender(),
                            ],
                          ),
                          onTap: () => Get.back(),
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
                Padding(
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
                ),
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
}
