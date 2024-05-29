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
import 'package:life_berg/view/widget/image_dialog.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_border_button.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/progress_widget.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';
import 'package:life_berg/view/widget/toggle_button.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class EndOfDayReport extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();

  EndOfDayReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: simpleAppBar(
        title: 'Daily Check-in',
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
            text: 'Today’s score',
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
                    /*SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        MyText(
                          text: '+1',
                          size: 16,
                          weight: FontWeight.w500,
                          color: kDarkBlueColor,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          child: Image.asset(
                            Assets.imagesStar,
                            color: kTabIndicatorColor,
                            height: 16,
                          ),
                        ),
                        MyText(
                          text: '70',
                          size: 12,
                          weight: FontWeight.w500,
                        ),
                      ],
                    ),*/
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
          Padding(
            padding: const EdgeInsets.only(
              top: 32,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MainHeading(
                  text: 'What were you grateful for today?',
                ),
              ],
            ),
          ),
          MyTextField(
            fillColor: Colors.white,
            hint:
                'Your entry will automatically added to your gratitude timeline.',
            maxLines: 2,
            marginBottom: 32,
          ),
          MainHeading(
            text: 'What have you learnt from today?',
            paddingBottom: 10,
          ),
          MyTextField(
            fillColor: Colors.white,
            hint: 'Your entry will automatically added to your development timeline.',
            maxLines: 2,
            marginBottom: 24,
          ),
          MainHeading(
            text: 'Tomorrow’s daily highlight',
            paddingBottom: 10,
          ),
          MyTextField(
            fillColor: Colors.white,
            hint: 'What is one thing you would like to achieve tomorrow?',
            maxLines: 2,
            marginBottom: 24,
          ),
          MyButton(
            radius: 16.0,
            text: 'Submit',
            onTap: () {
              SmartDialog.showLoading(msg: 'Please wait...');
              Future.delayed(Duration(seconds: 4),(){
                SmartDialog.dismiss();
                Get.dialog(
                  ImageDialog(
                    height: 182,
                    heading: 'Daily Check-in Complete!',
                    content:
                    'Awesome work! Keep your streak going to optimise your holistic wellbeing!',
                    imageSize: 92,
                    image: Assets.imagesDailyCheckIn,
                    onOkay: () {
                      Get.back();
                      Get.offAll(
                        () => BottomNavBar(
                          currentIndex: 4,
                          currentRoute: '/personal_statistics',
                        ),
                      );
                    },
                  ),
                );
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
