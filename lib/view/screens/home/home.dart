import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:life_berg/apis/apis_constants.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/controller/admin_controller/home_controller.dart';
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

import '../../widget/home_goal_tile.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final HomeController homeController = Get.put(HomeController());

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: kTertiaryColor,
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
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            topLeft: Radius.circular(8),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset(
                              Assets.imagesBottomSheetHandle,
                              height: 8,
                            ),
                            SizedBox(
                              height: 26,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                MyText(
                                  text: 'Edit profile picture',
                                  size: 18,
                                  weight: FontWeight.w500,
                                  paddingBottom: 30,
                                ),
                                MyText(
                                  onTap: () async {
                                    var file = await picker.pickImage(
                                        source: ImageSource.gallery);
                                    if (file != null) {
                                      homeController.xFile = file;
                                      homeController.imageFilePath.value =
                                          file.path;
                                      homeController.updateUserImage();
                                      Navigator.of(context).pop();
                                    }
                                  },
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
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Obx(() => homeController.imageFilePath != ""
                    ? CommonImageView(
                        height: 45,
                        width: 45,
                        radius: 100.0,
                        file: File(homeController.imageFilePath.value),
                      )
                    : CommonImageView(
                        height: 45,
                        width: 45,
                        radius: 100.0,
                        url: homeController.userProfileImageUrl.value.isNotEmpty
                            ? "${ApiConstants.BASE_IMAGE_URL}${homeController.userProfileImageUrl.value}"
                            : dummyImg3,
                      )),
              ),
            ),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => MyText(
                  text:
                      '${homeController.getGreeting()}, ${homeController.getFirstName(homeController.fullName.value)}!',
                  size: 16,
                  weight: FontWeight.w500,
                  color: Colors.white,
                )),
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
                      color: Colors.white,
                    ),
                    MyText(
                      text: 'Streak: 24 days',
                      size: 12,
                      paddingLeft: 4,
                      paddingRight: 10,
                      color: Colors.white,
                    ),
                    // Image.asset(
                    //   Assets.imagesStar,
                    //   height: 12,
                    // ),
                    // MyText(
                    //   paddingLeft: 4,
                    //   text: '70',
                    //   size: 12,
                    // ),
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
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.to(() => Settings()),
                  child: Image.asset(
                    Assets.imagesIconMoreVert,
                    height: 24,
                    color: Colors.white,
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
            text: 'Today’s progress',
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
                  currentStep: 0,
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
                      text: '0%',
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
                        currentStep: 0,
                        selectedColor: kStreaksColor,
                      ),
                      ProgressWidget(
                        title: 'Vocational',
                        currentStep: 0,
                        selectedColor: kRACGPExamColor,
                      ),
                      ProgressWidget(
                        title: 'Development',
                        currentStep: 0,
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
            text: 'How are you today?',
            paddingBottom: 12,
          ),
          DailyMoodReport(),
          Obx(() => homeController.isLoadingGoals.value
              ? Container(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  children: [
                    homeController.isLoadingGoals.value == false &&
                            homeController.wellBeingGoals.isNotEmpty
                        ? ProfileHeading(
                            marginTop: 24,
                            heading: 'Wellbeing',
                            leadingColor: kStreaksColor,
                          )
                        : Container(),
                    ListView.builder(
                      itemBuilder: (BuildContext ctx, index) {
                        return HomeGoalTile(
                          type: "wellbeing",
                          index: index,
                          progress: homeController
                              .wellBeingGoals[index].sliderValue,
                          onCheckBoxTap: (){
                            homeController
                                .wellBeingGoals[index].isChecked.value =
                            !homeController
                                .wellBeingGoals[index].isChecked.value;
                          },
                          onProgressChange: (value){
                            homeController
                                .wellBeingGoals[index].sliderValue.value = value;
                          },
                          haveCheckBox: homeController
                                  .wellBeingGoals[index].goalMeasure!.type ==
                              "boolean",
                          checkBoxValue: homeController.wellBeingGoals[index].isChecked,
                          haveSlider: homeController
                                  .wellBeingGoals[index].goalMeasure!.type ==
                              "string",
                          goal: homeController.wellBeingGoals[index],
                          title:
                              homeController.wellBeingGoals[index].name ?? "",
                          imageBgColor: kStreaksBgColor,
                          leadingIcon:
                              "assets/goal_icons/${homeController.wellBeingGoals[index].icon}",
                          leadingColor: kStreaksColor,
                        );
                      },
                      itemCount: homeController.wellBeingGoals.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                    homeController.isLoadingGoals.value == false &&
                            homeController.vocationalGoals.isNotEmpty
                        ? ProfileHeading(
                            marginTop: 24,
                            heading: 'Vocational',
                            leadingColor: kRACGPExamColor,
                          )
                        : Container(),
                    ListView.builder(
                      itemBuilder: (BuildContext ctx, index) {
                        return HomeGoalTile(
                          type: "vocation",
                          index: index,
                          goal: homeController.vocationalGoals[index],
                          onCheckBoxTap: (){
                            homeController
                                .vocationalGoals[index].isChecked.value =
                                !homeController
                                    .vocationalGoals[index].isChecked.value;
                          },
                          onProgressChange: (value){
                            homeController
                                .vocationalGoals[index].sliderValue.value = value;
                          },
                          progress: homeController
                              .vocationalGoals[index].sliderValue,
                          haveCheckBox: homeController
                                  .vocationalGoals[index].goalMeasure!.type ==
                              "boolean",
                          haveSlider: homeController
                                  .vocationalGoals[index].goalMeasure!.type ==
                              "string",
                          imageBgColor: kRACGPBGExamColor,
                          checkBoxValue: homeController
                              .vocationalGoals[index].isChecked,
                          title:
                              homeController.vocationalGoals[index].name ?? "",
                          leadingIcon:
                              "assets/goal_icons/${homeController.vocationalGoals[index].icon}",
                          leadingColor: kRACGPExamColor,
                        );
                      },
                      itemCount: homeController.vocationalGoals.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                    homeController.isLoadingGoals.value == false &&
                            homeController.personalDevGoals.isNotEmpty
                        ? ProfileHeading(
                            marginTop: 24,
                            heading: 'Personal Development',
                            leadingColor: kDailyGratitudeColor,
                          )
                        : Container(),
                    ListView.builder(
                      itemBuilder: (BuildContext ctx, index) {
                        return HomeGoalTile(
                          type: "personal_development",
                          index: index,
                          onCheckBoxTap: (){
                            homeController
                                .personalDevGoals[index].isChecked.value =
                            !homeController
                                .personalDevGoals[index].isChecked.value;
                          },
                          progress: homeController
                              .personalDevGoals[index].sliderValue,
                          checkBoxValue: homeController
                              .personalDevGoals[index].isChecked,
                          goal: homeController.personalDevGoals[index],
                          onProgressChange: (value){
                            homeController
                                .personalDevGoals[index].sliderValue.value = value;
                          },
                          haveCheckBox: homeController
                                  .personalDevGoals[index].goalMeasure!.type ==
                              "boolean",
                          haveSlider: homeController
                                  .personalDevGoals[index].goalMeasure!.type ==
                              "string",
                          imageBgColor: kDailyGratitudeBgColor,
                          title:
                              homeController.personalDevGoals[index].name ?? "",
                          leadingIcon:
                              "assets/goal_icons/${homeController.personalDevGoals[index].icon}",
                          leadingColor: kDailyGratitudeColor,
                        );
                      },
                      itemCount: homeController.personalDevGoals.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    homeController.wellBeingGoals.isEmpty &&
                        homeController.vocationalGoals.isEmpty &&
                        homeController.personalDevGoals.isEmpty ?
                        Container() :
                    MyButton(
                      text: 'Submit',
                      radius: 16,
                      // height: 56,
                      onTap: () => Get.to(
                            () => EndOfDayReport(),
                      ),
                    ),
                  ],
                )),

          /*ProfileTile(
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
          ),*/
          SizedBox(
            height: 80,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddNewGoal(), arguments: {
          "goalCategory": "Select category",
          "goalName": "",
          "isComingFromOnBoarding": false
        }),
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
