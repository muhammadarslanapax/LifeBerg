import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';

class AddGoalReminder extends StatefulWidget {
  final Function(String? day, DateTime? time) onDaySelect;

  AddGoalReminder(
    this.onDaySelect, {
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

  String? day;

  DateTime? time;

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
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
    );
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
    onTimeChange: (time) {

    },
  );
}