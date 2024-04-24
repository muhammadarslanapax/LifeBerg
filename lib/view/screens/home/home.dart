import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/main.dart';
import 'package:life_berg/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:life_berg/view/screens/home/end_of_day_report.dart';
import 'package:life_berg/view/screens/personal_statistics/personal_statistics.dart';
import 'package:life_berg/view/screens/settings/choose_avatar.dart';
import 'package:life_berg/view/screens/settings/settings.dart';
import 'package:life_berg/view/screens/settings/settings_screens/notifications.dart';
import 'package:life_berg/view/screens/setup_goal/add_new_goal.dart';
import 'package:life_berg/view/widget/common_image_view.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/daily_mood_report.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/profile_heading.dart';
import 'package:life_berg/view/widget/profile_tile.dart';
import 'package:life_berg/view/widget/progress_widget.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: kSecondaryColor,
        toolbarHeight: 75,
        leadingWidth: 60,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (context) {
                      return Container(
                        height: 300,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            topLeft: Radius.circular(8),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset(
                              Assets.imagesBottomSheetHandle,
                              height: 8,
                            ),
                            SizedBox(
                              height: 26,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  MyText(
                                    text: 'Edit profile picture',
                                    size: 18,
                                    weight: FontWeight.w500,
                                    paddingBottom: 30,
                                  ),
                                  MyText(
                                    paddingLeft: 16,
                                    paddingRight: 16,
                                    text: 'Select from photos',
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 16),
                                    height: 1,
                                    color: kBorderColor,
                                  ),
                                  MyText(
                                    onTap: () => Get.to(() => ChooseAvatar()),
                                    paddingLeft: 16,
                                    paddingRight: 16,
                                    text: 'Use our avatars',
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 16),
                                    height: 1,
                                    color: kBorderColor,
                                  ),
                                  MyText(
                                    paddingLeft: 16,
                                    paddingRight: 16,
                                    text: 'Remove current photo',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: CommonImageView(
                  height: 45,
                  width: 45,
                  radius: 100.0,
                  url: dummyImg3,
                ),
              ),
            ),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: 'Good Evening, Timothy!',
              size: 16,
              weight: FontWeight.w500,
            ),
            SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () => Get.offAll(
                () => BottomNavBar(
                  currentIndex: 4,
                  currentRoute: '/personal_statistics',
                ),
              ),
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    Image.asset(
                      Assets.imagesStreakIcon,
                      height: 12,
                    ),
                    MyText(
                      text: 'Streak: 24 days',
                      size: 12,
                      paddingLeft: 4,
                      paddingRight: 10,
                    ),
                    Image.asset(
                      Assets.imagesStar,
                      height: 12,
                    ),
                    MyText(
                      paddingLeft: 4,
                      text: '70',
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: Wrap(
              spacing: 8,
              children: [
                GestureDetector(
                  onTap: () => Get.to(() => Notifications()),
                  child: Image.asset(
                    Assets.imagesNotificationBellHome,
                    height: 24,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.to(() => Settings()),
                  child: Image.asset(
                    Assets.imagesIconMoreVert,
                    height: 24,
                  ),
                ),
                SizedBox(
                  width: 7,
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(15),
        children: [
          MainHeading(
            text: 'Current Progress',
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
          MainHeading(
            paddingTop: 22,
            text: 'Daily Mood Report',
            paddingBottom: 12,
          ),
          DailyMoodReport(),

          //Wellbeing
          ProfileHeading(
            marginTop: 24,
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
          SizedBox(
            height: 18,
          ),
          MyButton(
            text: 'Submit',
            radius: 16,
            // height: 56,
            onTap: () => Get.to(
              () => EndOfDayReport(),
            ),
          ),
          SizedBox(
            height: 80,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddNewGoal()),
        elevation: 0,
        highlightElevation: 0,
        backgroundColor: Colors.transparent,
        child: Image.asset(
          Assets.imagesAddButton,
          height: 44,
        ),
      ),
    );
  }
}
