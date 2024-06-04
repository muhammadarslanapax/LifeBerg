import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/constant/strings.dart';
import 'package:life_berg/controller/admin_controller/home_controller.dart';
import 'package:life_berg/controller/auth_controller/goal_controller.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/utils/toast_utils.dart';
import 'package:life_berg/view/screens/setup_goal/personal_development_goal.dart';
import 'package:life_berg/view/screens/setup_goal/vocation_goal.dart';
import 'package:life_berg/view/screens/setup_goal/we_are_off.dart';
import 'package:life_berg/view/widget/add_goal_reminder.dart';
import 'package:life_berg/view/widget/custom_radio_tile.dart';
import 'package:life_berg/view/widget/custom_track_shape.dart';
import 'package:life_berg/view/widget/icon_and_color_bottom_sheet.dart';
import 'package:life_berg/view/widget/image_dialog.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

import '../../../model/reminder/reminder_date_time.dart';
import '../../widget/my_dialog.dart';

class AddNewGoal extends StatelessWidget {
  final GoalController goalController = Get.put(GoalController());
  late HomeController homeController;

  @override
  Widget build(BuildContext context) {
    if (!goalController.isComingFromOnBoarding) {
      homeController = Get.find<HomeController>();
    }
    return KeyboardDismisser(
      gestures: [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection,
      ],
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: simpleAppBar(
          title: goalController.goal == null ? addNewGoal : editGoal,
        ),
        body: Obx(() {
          return ListView(
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
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        builder: (_) {
                          return IconAndColorBottomSheet(
                            onSelect: (color, icon) {
                              goalController.color = color;
                              goalController.icon.value = icon;
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          width: 1.0,
                          color: kBorderColor,
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          goalController.icon.value.isNotEmpty
                              ? "assets/goal_icons/${goalController.icon.value}"
                              : Assets.imagesPlus,
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: MyTextField(
                      hint: goalName,
                      marginBottom: 0.0,
                      fillColor: kSecondaryColor,
                      controller: goalController.goalNameCon,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton2(
                  hint: MyText(
                    text: selectCategory,
                    size: 14,
                    color: kTextColor.withOpacity(0.50),
                  ),
                  items: List.generate(
                    goalController.goals.length,
                        (index) {
                      var data = goalController.goals[index];
                      return DropdownMenuItem<dynamic>(
                        value: goalController.goals[index],
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (data == selectCategory)
                              SizedBox()
                            else
                              Container(
                                height: 16,
                                width: 16,
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: data == wellBeing
                                      ? kWellBeingColor.withOpacity(0.2)
                                      : data == vocational
                                      ? kPeachColor.withOpacity(0.2)
                                      : data == personalDevelopment
                                      ? kCardioColor.withOpacity(0.2)
                                      : kC3.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: data == wellBeing
                                          ? kWellBeingColor
                                          : data == vocational
                                          ? kCardio2Color
                                          : data == personalDevelopment
                                          ? kCardioColor
                                          : kC3,
                                      shape: BoxShape.circle,
                                    ),
                                    height: Get.height,
                                    width: Get.width,
                                  ),
                                ),
                              ),
                            MyText(
                              paddingLeft: data == selectCategory ? 0 : 11,
                              text: data,
                              size: 14,
                              color: data == selectCategory
                                  ? kTextColor.withOpacity(0.50)
                                  : kCoolGreyColor,
                              weight: FontWeight.w400,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  onChanged: (v) {
                    goalController.selectedGoal.value = v;
                    log(v.toString());
                  },
                  value: goalController.selectedGoal.value,
                  icon: Image.asset(
                    Assets.imagesDropDownIcon,
                    height: 24,
                  ),
                  isDense: true,
                  isExpanded: true,
                  buttonHeight: 56,
                  buttonPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  buttonDecoration: BoxDecoration(
                    border: Border.all(
                      color: kBorderColor,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: kSecondaryColor,
                  ),
                  buttonElevation: 0,
                  itemHeight: 40,
                  itemPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  dropdownMaxHeight: 200,
                  dropdownWidth: Get.width * 0.92,
                  dropdownPadding: null,
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: kSecondaryColor,
                  ),
                  dropdownElevation: 4,
                  scrollbarRadius: const Radius.circular(40),
                  scrollbarThickness: 6,
                  scrollbarAlwaysShow: true,
                  offset: const Offset(-2, -5),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              MyTextField(
                hint: description,
                maxLines: 5,
                controller: goalController.goalDesCon,
              ),
              MyText(
                paddingTop: 20,
                text: weekSelectionDayDetail,
                size: 16,
                weight: FontWeight.w500,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: MyTextField(
                      hint: 'type',
                      onChanged: (String value) {
                        int max = goalController.selectGoalDaysType.value ==
                            week ? 7 : 31;
                        int x;
                        try {
                          x = int.parse(value);
                        } catch (error) {
                          x = 0;
                        }
                        if (x > max) {
                          x = max;
                        }
                        if(x == 0){
                          goalController.daysCon.text = "";
                        }else {
                          goalController.daysCon.value = TextEditingValue(
                            text: x.toString(),
                            selection: TextSelection.fromPosition(
                              TextPosition(
                                  offset: goalController.daysCon.value.selection
                                      .baseOffset),
                            ),
                          );
                        }
                      },
                      textInputType: TextInputType.number,
                      controller: goalController.daysCon,
                    ),
                  ),
                  Expanded(
                    child: MyText(
                      text: daysPer,
                      size: 16,
                      align: TextAlign.center,
                      weight: FontWeight.w400,
                    ),
                  ),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        hint: MyText(
                          text: select,
                          size: 15,
                          weight: FontWeight.w400,
                          color: kTextColor.withOpacity(0.50),
                        ),
                        items: goalController.items
                            .map(
                              (item) =>
                              DropdownMenuItem<dynamic>(
                                value: item,
                                child: MyText(
                                  text: item,
                                  size: 14,
                                ),
                              ),
                        )
                            .toList(),
                        value: goalController.selectGoalDaysType.value,
                        onChanged: (newValue) {
                          goalController.selectGoalDaysType.value = newValue;
                        },
                        icon: Image.asset(
                          Assets.imagesDropDownIcon,
                          height: 24,
                        ),
                        isDense: true,
                        isExpanded: true,
                        buttonHeight: 56,
                        buttonPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        buttonDecoration: BoxDecoration(
                          border: Border.all(
                            color: kBorderColor,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: kSecondaryColor,
                        ),
                        buttonElevation: 0,
                        itemHeight: 40,
                        itemPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        dropdownMaxHeight: 200,
                        dropdownPadding: null,
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: kSecondaryColor,
                        ),
                        dropdownElevation: 4,
                        scrollbarRadius: const Radius.circular(40),
                        scrollbarThickness: 6,
                        scrollbarAlwaysShow: true,
                        offset: const Offset(-2, -5),
                      ),
                    ),
                    flex: 2,
                  )
                ],
              ),
              MyText(
                paddingTop: 20,
                text: howImportantDes,
                size: 16,
                weight: FontWeight.w500,
              ),
              SliderTheme(
                data: SliderThemeData(
                  inactiveTickMarkColor: Colors.transparent,
                  activeTickMarkColor: Colors.transparent,
                  disabledActiveTickMarkColor: Colors.transparent,
                  disabledInactiveTickMarkColor: Colors.transparent,
                  inactiveTrackColor: kBorderColor,
                  activeTrackColor: kTertiaryColor,
                  thumbColor: kTertiaryColor,
                  trackShape: CustomTrackShape(),
                ),
                child: Slider(
                  min: 0.0,
                  max: 10.0,
                  divisions: 10,
                  onChanged: (value) {
                    goalController.seekbarValue.value = value;
                  },
                  value: goalController.seekbarValue.value,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    text: '0',
                    size: 16,
                    color: kTertiaryColor,
                  ),
                  MyText(
                    paddingLeft: 10,
                    text: '5',
                    size: 16,
                    color: kTertiaryColor,
                  ),
                  MyText(
                    text: '10',
                    size: 16,
                    color: kTertiaryColor,
                  ),
                ],
              ),
              MyText(
                paddingTop: 25,
                text: measureTypeDes,
                size: 16,
                weight: FontWeight.w500,
                paddingBottom: 20,
              ),
              CustomRadioTile(
                onTap: () {
                  goalController.isScale.value = false;
                },
                isSelected: !goalController.isScale.value,
                title: measureTypeOptionOne,
              ),
              SizedBox(
                height: 2,
              ),
              CustomRadioTile(
                onTap: () {
                  goalController.isScale.value = true;
                },
                isSelected: goalController.isScale.value,
                title:measureTypeOptionTwo,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MyText(
                    text: addReminder,
                    size: 16,
                    weight: FontWeight.w500,
                    paddingRight: 16,
                  ),
                  Image.asset(
                    Assets.imagesReminderBell,
                    height: 19.5,
                    color: kTertiaryColor,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                itemBuilder: (BuildContext ctx, index) {
                  return _buildTimeWidget(context, index);
                },
                itemCount: goalController.timeList.length + 1,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
              SizedBox(
                height: 10,
              ),
              MyButton(
                isDisable: false,
                text: confirm,
                onTap: () {
                  if (goalController.goal != null) {
                    goalController.editGoal((isCreated) {
                      homeController.getUserGoals();
                      if (isCreated) {
                        Get.back();
                        Get.dialog(
                          MyDialog(
                            icon: Assets.imagesEditItem,
                            heading: editGoal,
                            content: editSuccess,
                            onOkay: () {
                              Get.back();
                            },
                          ),
                        );
                      } else {
                        ToastUtils.showToast("Some error occurred.",
                            color: kRedColor);
                      }
                    });
                  } else {
                    goalController.addNewGoal((isCreated) {
                      if (isCreated) {
                        Get.back();
                        _showGoalCreatedDialog(context);
                      } else {
                        ToastUtils.showToast("Some error occurred.",
                            color: kRedColor);
                      }
                    });
                  }
                },
              ),
              SizedBox(
                height: 30,
              ),
            ],
          );
        }),
      ),
    );
  }

  _showGoalCreatedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return ImageDialog(
          heading: goalCreated,
          content:
          goalCreatedDes,
          image: Assets.imagesGoalCreatedNewImage,
          imageSize: 100.0,
          onOkay: () {
            if (goalController.isComingFromOnBoarding) {
              switch (goalController.selectedGoal.value) {
                case wellBeing:
                  Get.back();
                  Get.to(() => VocationGoal());
                  break;
                case vocational:
                  Get.back();
                  Get.to(() => PersonalDevelopmentGoal());
                  break;
                case personalDevelopment:
                  Get.back();
                  Get.to(() => WeAreOff());
                  break;
                case '':
                  Get.back();
                  break;
                default:
                  Get.back();
              }
            } else {
              homeController.getUserGoals();
              Get.back();
            }
          },
        );
      },
    );
  }

  Widget _buildTimeWidget(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        if (index == goalController.timeList.length) {
          FocusManager.instance.primaryFocus?.unfocus();
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            elevation: 0,
            builder: (_) {
              return AddGoalReminder((days, time) {
                if (days.isNotEmpty && time != null) {
                  for (var day in days) {
                    goalController.timeList.add(ReminderDateTime(day, time));
                  }
                }
              });
            },
          );
        }
      },
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            elevation: 0,
            builder: (_) {
              FocusManager.instance.primaryFocus?.unfocus();
              return AddGoalReminder((days, time) {
                if (days.isNotEmpty && time != null) {
                  goalController.timeList[index] = ReminderDateTime(days[0], time);
                }
              },reminderDateTime: goalController.timeList[index],);
            },
          );
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 10.0),
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      width: 1.0,
                      color: kBorderColor,
                    ),
                  ),
                  child: MyText(
                    text: index == 0 && goalController.timeList.length == 0
                        ? selectDateTime
                        : index == goalController.timeList.length
                        ? selectAnotherDateTime
                        : goalController.timeList[index].day,
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      width: 1.0,
                      color: kBorderColor,
                    ),
                  ),
                  child: MyText(
                    text: goalController.timeList.length > 0 &&
                        index != goalController.timeList.length
                        ? DateFormat("HH:mma")
                        .format(goalController.timeList[index].time)
                        : "",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
