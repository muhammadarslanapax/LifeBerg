import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/controller/admin_controller/home_controller.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/utils/instance.dart';
import 'package:life_berg/utils/pref_utils.dart';
import 'package:life_berg/view/screens/admin/wellbeing_action_plan/wellbeing_action_plan.dart';
import 'package:life_berg/view/screens/admin/wellbeing_action_plan/wellbing_action_plan_controller.dart';
import 'package:life_berg/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:life_berg/view/screens/home/end_of_day_controller.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/progress_widget.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';
import 'package:life_berg/view/widget/toggle_button.dart';
import 'package:lottie/lottie.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../constant/strings.dart';
import '../../../controller/journal_controller/journal_controller.dart';
import '../../../model/goal/goal.dart';
import '../../../utils/bullet_point_input_formatter.dart';
import '../journal/add_new_journal.dart';

class EndOfDayReport extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();
  final JournalController journalController = Get.put(JournalController());
  final EndOfDayController endOfDayController = Get.put(EndOfDayController());

  EndOfDayReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection,
      ],
      child: Scaffold(
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
                    child: Lottie.asset(homeController.getIcebergJson(),
                        height: 148.27)),
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
                      Container(
                        height: 88,
                        width: 100,
                        child: Center(
                          child: MyText(
                            paddingRight: 9,
                            paddingBottom: 4,
                            align: TextAlign.center,
                            size: 10,
                            height: 1.7,
                            text: homeController.getIcebergComment(),
                          ),
                        ),
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
                      Obx(() => CircularStepProgressIndicator(
                            totalSteps: 100,
                            currentStep:
                                homeController.globalPercentage.value.toInt(),
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
                                    '${homeController.globalPercentage.value.toInt()}%',
                                size: 24,
                              ),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    width: 32,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Obx(() => ProgressWidget(
                              title: wellBeing,
                              currentStep: homeController
                                  .wellbeingPercentage.value
                                  .toInt(),
                              selectedColor: kStreaksColor,
                            )),
                        Obx(
                          () => ProgressWidget(
                            title: vocational,
                            currentStep:
                                homeController.vocationPercentage.value.toInt(),
                            selectedColor: kRACGPExamColor,
                          ),
                        ),
                        Obx(
                          () => ProgressWidget(
                            title: development,
                            currentStep: homeController
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
              inputFormatter: BulletPointInputFormatter(),
              textInputType: TextInputType.multiline,
              controller: endOfDayController.greatFulController,
              hint: greatfulDes,
              maxLines: 2,
              marginBottom: 32,
            ),
            MainHeading(
              text: learnedHeading,
              paddingBottom: 10,
            ),
            MyTextField(
              fillColor: Colors.white,
              hint: learnedDes,
              inputFormatter: BulletPointInputFormatter(),
              textInputType: TextInputType.multiline,
              controller: endOfDayController.learnedTodayController,
              maxLines: 2,
              marginBottom: 24,
            ),
            MainHeading(
              text: tomorrowHighlightHeading,
              paddingBottom: 10,
            ),
            MyTextField(
              fillColor: Colors.white,
              hint: tomorrowHighlightDes,
              controller: endOfDayController.tomorrowHighlightController,
              maxLines: 2,
              marginBottom: 24,
            ),
            MyButton(
              radius: 16.0,
              height: 56,
              text: submit,
              onTap: () {
                homeController.isGoalSubmittedToday.value = true;
                PrefUtils().lastLearntText =
                    endOfDayController.learnedTodayController.text;
                PrefUtils().lastHighlightText =
                    endOfDayController.tomorrowHighlightController.text;
                PrefUtils().lastGratefulText =
                    endOfDayController.greatFulController.text;
                PrefUtils().isGoalSubmittedToday = true;
                List<Goal> allGoals = [];
                allGoals.addAll(homeController.wellBeingGoals);
                allGoals.addAll(homeController.vocationalGoals);
                allGoals.addAll(homeController.personalDevGoals);
                var greatFull =
                    endOfDayController.greatFulController.text.toString();
                var learnedToday =
                    endOfDayController.learnedTodayController.text.toString();
                var tomorrowHighlight = endOfDayController
                    .tomorrowHighlightController.text
                    .toString();
                if ((greatFull.isEmpty ||
                        greatFull.replaceAll(" ", "") == "\u2022") &&
                    (learnedToday.isEmpty ||
                        learnedToday.replaceAll(" ", "") == "\u2022") &&
                    tomorrowHighlight.isEmpty) {
                  journalController.submitReport((isSuccess) {
                    SmartDialog.dismiss();
                    if (isSuccess) {
                      showEndDayReportSuccessDialog(context);
                    }
                  },
                      homeController.isShowHighlight.value
                          ? PrefUtils().tomorrowHighlightGoal
                          : "",
                      allGoals);
                } else {
                  setTomorrowHighlight();
                  journalController.submitReport((isSuccess) {
                    if (greatFull.isNotEmpty &&
                        greatFull.replaceAll(" ", "") != "\u2022") {
                      journalController.addNewJournal((isSuccess) {
                        if (isSuccess) {
                          if (learnedToday.isNotEmpty &&
                              learnedToday.replaceAll(" ", "") != "\u2022") {
                            journalController.addNewJournal((isSuccess) {
                              SmartDialog.dismiss();
                              journalController.getUserJournals();
                              endOfDayController.setInitialBulletPoint();
                              showEndDayReportSuccessDialog(context);
                            },
                                endOfDayController.learnedTodayController.text
                                    .toString(),
                                colorToHex(kTertiaryColor),
                                "Development");
                          } else {
                            SmartDialog.dismiss();
                            journalController.getUserJournals();
                            endOfDayController.setInitialBulletPoint();
                            showEndDayReportSuccessDialog(context);
                          }
                        }
                      }, endOfDayController.greatFulController.text.toString(),
                          colorToHex(kTertiaryColor), "Gratitudes");
                    } else if (learnedToday.isNotEmpty &&
                        learnedToday.replaceAll(" ", "") != "\u2022") {
                      journalController.addNewJournal((isSuccess) {
                        if (isSuccess) {
                          if (greatFull.isNotEmpty &&
                              greatFull.replaceAll(" ", "") != "\u2022") {
                            journalController.addNewJournal((isSuccess) {
                              SmartDialog.dismiss();
                              journalController.getUserJournals();
                              endOfDayController.setInitialBulletPoint();
                              showEndDayReportSuccessDialog(context);
                            },
                                endOfDayController.greatFulController.text
                                    .toString(),
                                colorToHex(kTertiaryColor),
                                "Gratitudes");
                          } else {
                            SmartDialog.dismiss();
                            journalController.getUserJournals();
                            endOfDayController.setInitialBulletPoint();
                            showEndDayReportSuccessDialog(context);
                          }
                        }
                      },
                          endOfDayController.learnedTodayController.text
                              .toString(),
                          colorToHex(kTertiaryColor),
                          "Development");
                    } else {
                      SmartDialog.dismiss();
                      showEndDayReportSuccessDialog(context);
                    }
                  },
                      homeController.isShowHighlight.value
                          ? PrefUtils().tomorrowHighlightGoal
                          : "",
                      allGoals);
                }
              },
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  setTomorrowHighlight() {
    if (endOfDayController.tomorrowHighlightController.text.isNotEmpty) {
      PrefUtils().tomorrowHighlightGoal =
          endOfDayController.tomorrowHighlightController.text;
      DateTime now = DateTime.now();
      DateTime nextDay = now.add(Duration(days: 1));
      PrefUtils().tomorrowHighlightGoalDate =
          DateFormat("yyyy-MM-dd").format(nextDay);
    }
  }

  showEndDayReportSuccessDialog(BuildContext context) {
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
                    text: dailyCheckInCompleteDes,
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
                        right: 0,
                        child: MyText(
                          onTap: () {
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
  }
}

class MessageFromTimmy extends StatelessWidget {
  final WellbeingActionPlanController controller =
      Get.put(WellbeingActionPlanController());

  MessageFromTimmy({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: Get.height * 0.80,
        child: CustomBottomSheet(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 6,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Obx(() => MainHeading(
                          text: 'Message from ${controller.iceBergName.value}',
                          paddingBottom: 24,
                        )),
                  ),
                  Center(
                    child: Image.asset(
                      Assets.imagesIceBag,
                      height: 148.27,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Obx(() => MainHeading(
                          text: 'Hello ${controller.userName.value}!',
                          paddingBottom: 8,
                        )),
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
                    padding: const EdgeInsets.only(left: 4),
                    child: MainHeading(
                      text: 'Wellbeing action plan',
                      paddingBottom: 12,
                    ),
                  ),
                  Obx(() => controller.isLoadingActionPlan.value
                      ? const SizedBox(
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 16,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: List.generate(
                            controller.allActionsList.length + 1,
                            (index) {
                              if (index == controller.allActionsList.length) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() => WellbeingActionPlan());
                                  },
                                  child: Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                        color: kSecondaryColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8.0)),
                                        border: Border.all(
                                          width: 1.0,
                                          color: kBorderColor,
                                        )),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 12.0),
                                    child: SvgPicture.asset(
                                        "assets/vectors/ic_plus.svg"),
                                  ),
                                );
                              } else {
                                var data = controller.allActionsList[index];
                                return GestureDetector(
                                  child: ToggleButton(
                                    horizontalPadding: 12.0,
                                    onTap: () {
                                      // wellbeingActionPlanController
                                      //     .getActionHelp(index);
                                    },
                                    text: data.name!,
                                    isSelected: false,
                                  ),
                                );
                              }
                            },
                          ),
                        )),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => WellbeingActionPlan()),
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          MyText(
                            text:
                                'Click here to edit your wellbeing action plan',
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
            ),
          ),
          onTap: () => Navigator.of(context).pop(),
          buttonText: 'Done',
          isButtonDisable: false,
        ),
      ),
    );
  }
}
