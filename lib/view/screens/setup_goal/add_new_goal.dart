import 'dart:developer';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/constant/sizes_constant.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/utils/instance.dart';
import 'package:life_berg/view/screens/setup_goal/personal_development_goal.dart';
import 'package:life_berg/view/screens/setup_goal/vocation_goal.dart';
import 'package:life_berg/view/screens/setup_goal/we_are_off.dart';
import 'package:life_berg/view/widget/add_goal_reminder.dart';
import 'package:life_berg/view/widget/custom_drop_down.dart';
import 'package:life_berg/view/widget/custom_radio_tile.dart';
import 'package:life_berg/view/widget/custom_track_shape.dart';
import 'package:life_berg/view/widget/icon_and_color_bottom_sheet.dart';
import 'package:life_berg/view/widget/image_dialog.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

import '../../../model/reminder/reminder_date_time.dart';

class AddNewGoal extends StatefulWidget {
  final String? createdFrom;
  final String? title;

  AddNewGoal({
    this.createdFrom = '',
    this.title = '',
  });

  @override
  State<AddNewGoal> createState() => _AddNewGoalState();
}

class _AddNewGoalState extends State<AddNewGoal> {
  String selectGoalDaysType = 'Week';
  double seekbarValue = 5.0;
  bool isScale = true;
  List<String> items = [
    'Week',
    'Month',
  ];

  List<String> _goals = [
    'Select category',
    'Wellbeing',
    'Vocation',
    'Personal Development',
  ];

  String? selectedGoal = 'Select category';

  List<ReminderDateTime> timeList = [];

  @override
  void initState() {
    super.initState();
    if(widget.createdFrom == "wellbeing") {
      selectedGoal = "Wellbeing";
      goalController.goalNameCon.text = goalController.wellBeingIndex.value != -1 ?
          goalController.wellBeingList[goalController.wellBeingIndex.value] : "";
    }else if(widget.createdFrom == "vocationalTasks"){
      selectedGoal = "Vocation";
      goalController.goalNameCon.text = goalController.vocationalTaskIndex.value != -1 ?
      goalController.vocationGoalList[goalController.vocationalTaskIndex.value] : "";
    }else if(widget.createdFrom == "personalDevelopment"){
      selectedGoal = "Personal Development";
      goalController.goalNameCon.text = goalController.personalDevIndex.value != -1 ?
      goalController.personalDevelopmentList[goalController.personalDevIndex.value] : "";
    }
    if(mounted){
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: simpleAppBar(
        title: 'Add a new goal',
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
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    builder: (_) {
                      return IconAndColorBottomSheet();
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
                      Assets.imagesPlus,
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
                  hint: 'Goal name',
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
                text: 'Select category',
                size: 14,
                color: kTextColor.withOpacity(0.50),
              ),
              items: List.generate(
                _goals.length,
                (index) {
                  var data = _goals[index];
                  return DropdownMenuItem<dynamic>(
                    value: _goals[index],
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (data == 'Select category')
                          SizedBox()
                        else
                          Container(
                            height: 16,
                            width: 16,
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: data == 'Wellbeing'
                                  ? kWellBeingColor.withOpacity(0.2)
                                  : data == 'Vocation'
                                      ? kPeachColor.withOpacity(0.2)
                                      : data == 'Personal Development'
                                          ? kCardioColor.withOpacity(0.2)
                                          : kC3.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: data == 'Wellbeing'
                                      ? kWellBeingColor
                                      : data == 'Vocation'
                                          ? kCardio2Color
                                          : data == 'Personal Development'
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
                          paddingLeft: data == 'Select category' ? 0 : 11,
                          text: data,
                          size: 14,
                          color: data == 'Select category'
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
                setState(() {
                  selectedGoal = v;
                });

                log(v.toString());
              },
              value: selectedGoal,
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
          // CustomDropDown(
          //   hint: 'Select category',
          //   items: [
          //     'Wellbeing',
          //     'Vocation',
          //     'Personal Development',
          //   ],
          //   onChanged: (value) {},
          // ),
          SizedBox(
            height: 10,
          ),
          MyTextField(
            hint: 'Description',
            maxLines: 5,
            controller: goalController.goalDesCon,
          ),
          MyText(
            paddingTop: 20,
            text: 'How often do you want to fulfil this goal?',
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
                  textInputType: TextInputType.number,
                  controller: goalController.daysCon,
                ),
              ),
              Expanded(
                child: MyText(
                  text: 'days per',
                  size: 16,
                  align: TextAlign.center,
                  weight: FontWeight.w400,
                ),
              ),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    hint: MyText(
                      text: "Select",
                      size: 15,
                      weight: FontWeight.w400,
                      color: kTextColor.withOpacity(0.50),
                    ),
                    items: items!
                        .map(
                          (item) => DropdownMenuItem<dynamic>(
                            value: item,
                            child: MyText(
                              text: item,
                              size: 14,
                            ),
                          ),
                        )
                        .toList(),
                    value: selectGoalDaysType,
                    onChanged: (newValue) {
                      setState(() {
                        selectGoalDaysType = newValue;
                      });
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
                    // dropdownWidth: Get.width * 0.92,
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
          // CustomDropDown(
          //   hint: 'Certain number of days a week',
          //   items: items,
          //   selectedValue: selectedValue,
          //   onChanged: (value) {
          //     setState(() {
          //       selectedValue = value;
          //     });
          //   },
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          // if (selectedValue == 'Achieve X number of days a week')
          //   Row(
          //     children: List.generate(
          //       7,
          //       (index) {
          //         return certainDay(index, () {}, index == 0);
          //       },
          //     ),
          //   ),
          MyText(
            paddingTop: 20,
            text: 'How important is this goal to you?',
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
              divisions: 2,
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    seekbarValue = value;
                  });
                }
              },
              value: seekbarValue,
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
            text: 'How would you like to measure the goal?',
            size: 16,
            weight: FontWeight.w500,
            paddingBottom: 20,
          ),
          CustomRadioTile(
            onTap: () {
              if (mounted) {
                setState(() {
                  isScale = false;
                });
              }
            },
            isSelected: !isScale,
            title: 'Yes (achieved), No (not achieved)',
          ),
          SizedBox(
            height: 2,
          ),
          CustomRadioTile(
            onTap: () {
              if (mounted) {
                setState(() {
                  isScale = true;
                });
              }
            },
            isSelected: isScale,
            title: 'Point scale (0 to10)',
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MyText(
                text: 'Add a reminder',
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
              return GestureDetector(
                onTap: () {
                  if (index == timeList.length) {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      builder: (_) {
                        return AddGoalReminder((day, time) {
                          if (day != null && time != null) {
                            timeList.add(ReminderDateTime(day, time));
                            if (mounted) {
                              setState(() {});
                            }
                          }
                        });
                      },
                    );
                  }
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
                            text: index == 0 && timeList.length == 0
                                ? "Select date and time"
                                : index == timeList.length
                                ? "Select another date and time"
                                : timeList[index].day,
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
                            text: timeList.length > 0 &&
                                index != timeList.length
                                ? DateFormat("HH:mma")
                                .format(timeList[index].time)
                                : "",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: timeList.length + 1,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          ),
          SizedBox(
            height: 30,
          ),
          MyButton(
            isDisable: false,
            text: 'Confirm',
            onTap: () {
              SmartDialog.showLoading(msg: "Please wait...");
              Future.delayed(Duration(seconds: 5),(){
                Get.back();
                SmartDialog.dismiss();
                showDialog(
                  context: context,
                  builder: (_) {
                    return ImageDialog(
                      heading: 'Goal Created',
                      content:
                      'Great work! You’ve taken the 1st leap to achieving your goal!',
                      image: Assets.imagesGoalCreatedNewImage,
                      imageSize: 100.0,
                      onOkay: () {
                        switch (widget.createdFrom) {
                          case 'wellbeing':
                            Get.back();
                            Get.to(() => VocationGoal());
                            break;
                          case 'vocationalTasks':
                            Get.back();
                            Get.to(() => PersonalDevelopmentGoal());
                            break;
                          case 'personalDevelopment':
                            Get.back();
                            Get.to(() => WeAreOff());
                            break;
                          case '':
                            Get.back();
                            break;
                          default:
                            Get.back();
                        }
                      },
                    );
                  },
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

  Expanded certainDay(
    int index,
    VoidCallback onTap,
    bool isSelected,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(
            left: index == 0 ? 0 : 4,
            right: index == 6 ? 0 : 4,
          ),
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? kTertiaryColor : kSecondaryColor,
            border: Border.all(
              color: kBorderColor,
              width: 1.0,
            ),
          ),
          child: Center(
            child: MyText(
              text: index + 1,
              size: 16,
              color: isSelected ? kPrimaryColor : kTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
