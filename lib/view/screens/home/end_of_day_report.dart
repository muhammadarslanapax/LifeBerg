import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/controller/admin_controller/home_controller.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/utils/instance.dart';
import 'package:life_berg/view/screens/admin/wellbeing_action_plan/wellbeing_action_plan.dart';
import 'package:life_berg/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/progress_widget.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';
import 'package:life_berg/view/widget/toggle_button.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../constant/strings.dart';

class EndOfDayReport extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();

  EndOfDayReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: simpleAppBar(
        title: dailyCheckIn,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(15),
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    builder: (_) {
                      return MessageFromTimmy();
                    },
                  );
                },
                child: Image.asset(
                  Assets.imagesLifeRing,
                  height: 24,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Image.asset(
                  Assets.imagesIceBag,
                  height: 148.27,
                ),
              ),
              Positioned(
                right: 0,
                top: -28,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Image.asset(
                      Assets.imagesBox,
                      height: 88,
                    ),
                    MyText(
                      paddingRight: 9,
                      paddingBottom: 4,
                      align: TextAlign.center,
                      size: 10,
                      height: 1.7,
                      text:
                          'Fantastic work!\nYou achieved your\ndaily highlight!',
                    ),
                  ],
                ),
              ),
            ],
          ),
          MyText(
            paddingTop: 8,
            align: TextAlign.center,
            text: homeController.user!.lifeBergName ?? "",
            size: 12,
            paddingBottom: 32,
          ),
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
                Column(
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
                  ],
                ),
                SizedBox(
                  width: 32,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProgressWidget(
                        title: wellBeing,
                        currentStep: 0,
                        selectedColor: kStreaksColor,
                      ),
                      ProgressWidget(
                        title: vocational,
                        currentStep: 0,
                        selectedColor: kRACGPExamColor,
                      ),
                      ProgressWidget(
                        title: development,
                        currentStep: 0,
                        selectedColor: kDailyGratitudeColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 32,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MainHeading(
                  text: greatfulHeading,
                ),
              ],
            ),
          ),
          MyTextField(
            fillColor: Colors.white,
            controller: homeController.greatFulController,
            hint:
            greatfulDes,
            maxLines: 2,
            marginBottom: 32,
          ),
          MainHeading(
            text: learnedHeading,
            paddingBottom: 10,
          ),
          MyTextField(
            fillColor: Colors.white,
            hint:
                learnedDes,
            controller: homeController.learnedTodayController,
            maxLines: 2,
            marginBottom: 24,
          ),
          MainHeading(
            text: tomorrowHighlightHeading,
            paddingBottom: 10,
          ),
          MyTextField(
            fillColor: Colors.white,
            hint:tomorrowHighlightDes,
            controller: homeController.tomorrowHighlightController,
            maxLines: 2,
            marginBottom: 24,
          ),
          MyButton(
            radius: 16.0,
            height: 56,
            text: submit,
            onTap: () {
              SmartDialog.showLoading(msg: pleaseWait);
              Future.delayed(Duration(seconds: 4), () {
                SmartDialog.dismiss();
                Get.dialog(Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 13, 20, 10),
                      width: Get.width,
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: kSecondaryColor,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                text: dailyCheckInComplete,
                                size: 18,
                                color: kPopupTextColor,
                                weight: FontWeight.w500,
                              ),
                              MyText(
                                paddingTop: 6,
                                text:
                                dailyCheckInCompleteDes,
                                color: kPopupTextColor,
                                height: 1.5,
                                size: 16,
                                paddingBottom: 17.0,
                              ),
                              Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 0,
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: 0.0,
                                          bottom: 0.0,
                                        ),
                                        child: Image.asset(
                                          Assets.imagesDailyCheckIn,
                                          height: 92,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right:0,
                                    child: MyText(
                                      onTap: (){
                                        Get.back();
                                        Get.offAll(
                                              () => BottomNavBar(
                                            currentIndex: 4,
                                            currentRoute: '/personal_statistics',
                                          ),
                                        );
                                      },
                                      align: TextAlign.end,
                                      text: okay_,
                                      size: 16,
                                      weight: FontWeight.w500,
                                      color: kTertiaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ));
              });
            },
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

class MessageFromTimmy extends StatelessWidget {
  const MessageFromTimmy({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: Get.height * 0.95,
        child: CustomBottomSheet(
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 6,
            ),
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4),
                child: MainHeading(
                  text: 'Message from Timmy-Berg',
                  paddingBottom: 24,
                ),
              ),
              Image.asset(
                Assets.imagesIceBag,
                height: 148.27,
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: EdgeInsets.only(left: 4),
                child: MainHeading(
                  text: 'Hello Timothy!',
                  paddingBottom: 8,
                ),
              ),
              MyText(
                paddingLeft: 4,
                paddingRight: 4,
                text:
                    'It is normal to have good days and bad days, and it is important that we give ourselves time and space to make it through the bad ones. Might some of the following strategies help you?',
                size: 12,
                paddingBottom: 24,
                height: 1.8,
              ),
              Padding(
                padding: EdgeInsets.only(left: 4),
                child: MainHeading(
                  text: 'Wellbeing action plan',
                  paddingBottom: 12,
                ),
              ),
              Row(
                children: [
                  for (int i = 0; i < 4; i++)
                    Obx(
                      () {
                        var data = goalController.wellBeingPlanList[i];
                        return Expanded(
                          flex: i == 1 ? 3 : 2,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: ToggleButton(
                              horizontalPadding: 0.0,
                              onTap: () {},
                              text: data.text,
                              isSelected: goalController.wellBeingIndex == i,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  for (int i = 4; i < 7; i++)
                    Obx(
                      () {
                        var data = goalController.wellBeingPlanList[i];
                        return Expanded(
                          flex: i == 6 ? 3 : 2,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: ToggleButton(
                              horizontalPadding: 0.0,
                              onTap: () {},
                              text: data.text,
                              isSelected: goalController.wellBeingIndex == i,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  for (int i = 7; i < 10; i++)
                    Obx(
                      () {
                        var data = goalController.wellBeingPlanList[i];
                        return Expanded(
                          flex: i == 7 ? 4 : 2,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: ToggleButton(
                              horizontalPadding: 0.0,
                              onTap: () {},
                              text: data.text,
                              isSelected: goalController.wellBeingIndex == i,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
              // Wrap(
              //   spacing: 5,
              //   runSpacing: 16,
              //   children: List.generate(
              //     goalController.wellBeingPlanList.length,
              //     (index) {
              //       if (index == goalController.wellBeingPlanList.length - 1) {
              //         return SizedBox();
              //       } else {
              //         var data = goalController.wellBeingPlanList[index];
              //         return Obx(
              //           () {
              //             return ToggleButton(
              //               onTap: () {},
              //               text: data.text,
              //               isSelected: data.isSelected.value,
              //             );
              //           },
              //         );
              //       }
              //     },
              //   ),
              // ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () => Get.to(() => WellbeingActionPlan()),
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      MyText(
                        text: 'Click here to edit your wellbeing action plan',
                        size: 13,
                        weight: FontWeight.w500,
                        color: kTertiaryColor,
                        paddingRight: 10,
                        paddingLeft: 4,
                      ),
                      Image.asset(
                        Assets.imagesEditItem,
                        height: 13.33,
                        color: kTertiaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          onTap: () => Get.back(),
          buttonText: 'Done',
          isButtonDisable: false,
        ),
      ),
    );
  }
}
