import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/model/reminder/reminder_date_time.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';

import '../../widgets/flutter_time_picker_spinner.dart';
import 'my_button.dart';

class AddGoalReminder extends StatefulWidget {
  final ReminderDateTime? reminderDateTime;
  final Function(List<String> day, DateTime? time) onDaySelect;

  AddGoalReminder(
    this.onDaySelect, {
    this.reminderDateTime,
    Key? key,
  }) : super(key: key);

  @override
  State<AddGoalReminder> createState() => _AddGoalReminderState();
}

class _AddGoalReminderState extends State<AddGoalReminder> {
  final List<String> days = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  List<String> selectedDays = [];

  DateTime? time;

  @override
  void initState() {
    super.initState();
    if (widget.reminderDateTime != null) {
      time = widget.reminderDateTime!.time;
      selectedDays.addAll(widget.reminderDateTime!.day);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.5,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Image.asset(
              Assets.imagesBottomSheetHandle,
              height: 8,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          MainHeading(
            text: 'Add a reminder',
            paddingBottom: 20,
            paddingLeft: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: List.generate(
                days.length,
                (index) {
                  return weekDaysToggleButton(
                    onTap: () {
                      // if (widget.reminderDateTime != null) {
                      //   if (selectedDays.contains(days[index])) {
                      //     selectedDays.remove(days[index]);
                      //   } else {
                      //     if (selectedDays.length > 0) {
                      //       selectedDays.clear();
                      //     }
                      //     selectedDays.add(days[index]);
                      //   }
                      // } else {
                      if (selectedDays.contains(days[index])) {
                        selectedDays.remove(days[index]);
                      } else {
                        selectedDays.add(days[index]);
                      }
                      // }
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    isSelected: selectedDays.contains(days[index]),
                    weekDay: days[index],
                  );
                },
              ),
            ),
          ),
          MyText(
            paddingTop: 16.0,
            paddingLeft: 15,
            text: 'Time',
            size: 20,
            weight: FontWeight.w500,
          ),
          Expanded(
            child: TimePickerSpinner(
              is24HourMode: false,
              normalTextStyle: TextStyle(
                fontSize: 22,
                color: kTextColor,
              ),
              highlightedTextStyle: TextStyle(
                fontSize: 22,
                color: kTextColor,
                fontWeight: FontWeight.w500,
              ),
              spacing: 40,
              itemHeight: 40,
              isForce2Digits: false,
              minutesInterval: 1,
              onTimeChange: (time) {
                this.time = time;
                if (mounted) {
                  setState(() {});
                }
              },
            ),
          ),
          Padding(
            padding: Platform.isIOS
                ? EdgeInsets.fromLTRB(15, 10, 15, 30)
                : EdgeInsets.fromLTRB(15, 10, 15, 15),
            child: MyButton(
              height: 56,
              radius: 8,
              isDisable: false,
              text: "Confirm",
              onTap: () {
                if (selectedDays.isNotEmpty && time != null) {
                  Get.back();
                  widget.onDaySelect(selectedDays, time);
                  showDialog(
                    context: context,
                    builder: (_) {
                      return MyDialog(
                        icon: Assets.imagesReminderBell,
                        heading: 'Reminder Added',
                        content:
                            'LifeBerg will give you a nudge at your nominated time!',
                        onOkay: () => Get.back(),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
    /*CustomBottomSheet(
      buttonText: 'Confirm',
      height: Get.height * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MainHeading(
            text: 'Add a reminder',
            paddingBottom: 20,
            paddingLeft: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: List.generate(
                days.length,
                (index) {
                  return weekDaysToggleButton(
                    onTap: () {
                      day = days[index];
                      if(mounted){
                        setState(() {

                        });
                      }
                    },
                    isSelected: day == days[index],
                    weekDay: days[index],
                  );
                },
              ),
            ),
          ),
          // MyText(
          //   paddingTop: 16.0,
          //   paddingLeft: 15,
          //   text: 'Time',
          //   size: 20,
          //   weight: FontWeight.w500,
          // ),
          Expanded(
            child: TimePickerSpinner(
              is24HourMode: false,
              normalTextStyle: TextStyle(
                fontSize: 16,
                color: kTextColor,
              ),
              highlightedTextStyle: TextStyle(
                fontSize: 20,
                color: kTextColor,
                fontWeight: FontWeight.w500,
              ),
              spacing: 40,
              itemHeight: 40,
              isForce2Digits: false,
              minutesInterval: 1,
              onTimeChange: (time) {
                this.time = time;
                if(mounted){
                  setState(() {

                  });
                }
              },
            ),
          ),
        ],
      ),
      isButtonDisable: false,
      onTap: () {
        Get.back();
        widget.onDaySelect(day,time);
        showDialog(
          context: context,
          builder: (_) {
            return MyDialog(
              icon: Assets.imagesReminderBell,
              heading: 'Reminder Added',
              content: 'LifeBerg will give you a nudge at your nominated time!',
              onOkay: () => Get.back(),
            );
          },
        );
      },
    );*/
  }

  Widget weekDaysToggleButton({
    String? weekDay,
    VoidCallback? onTap,
    bool? isSelected,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 3,
        ),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected! ? kTertiaryColor : Colors.transparent,
          border: Border.all(
            width: 1.0,
            color: kBorderColor,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: isSelected
                ? kPrimaryColor.withOpacity(0.1)
                : kTextColor.withOpacity(0.1),
            highlightColor: isSelected
                ? kPrimaryColor.withOpacity(0.1)
                : kTextColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(7),
            child: Center(
              child: MyText(
                text: weekDay,
                size: 14,
                color: isSelected ? kPrimaryColor : kTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget hourMinute12HCustomStyle() {
  return TimePickerSpinner(
    is24HourMode: false,
    normalTextStyle: TextStyle(
      fontSize: 16,
      color: kTextColor,
    ),
    highlightedTextStyle: TextStyle(
      fontSize: 20,
      color: kTextColor,
      fontWeight: FontWeight.w500,
    ),
    spacing: 40,
    itemHeight: 40,
    isForce2Digits: false,
    minutesInterval: 1,
    onTimeChange: (time) {},
  );
}
