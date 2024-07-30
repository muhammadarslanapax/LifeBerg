import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/utils/pref_utils.dart';
import 'package:life_berg/view/screens/archive_items/archive_items.dart';
import 'package:life_berg/view/screens/settings/edit_daily_past_reports.dart';
import 'package:life_berg/view/screens/settings/settings_screens/settings_controller.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/my_border_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

import '../../../widgets/flutter_time_picker_spinner.dart';

class HistoricalReportingGoals extends StatefulWidget {
  HistoricalReportingGoals({Key? key}) : super(key: key);

  @override
  State<HistoricalReportingGoals> createState() =>
      _HistoricalReportingGoalsState();
}

class _HistoricalReportingGoalsState extends State<HistoricalReportingGoals> {
  String? day;

  @override
  void initState() {
    super.initState();
    day = PrefUtils().newGoalStartTime;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCoolGreyColor3,
      appBar: simpleAppBar(
        title: 'Historical Reporting & Goals',
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MyText(
              text: 'Archived goals',
              size: 18,
              weight: FontWeight.w500,
              paddingBottom: 4,
            ),
            MyBorderButton(
              text: 'Restore or delete archived goals',
              onTap: () => Get.to(() => ArchiveItems()),
              height: 50.0,
            ),
            MyText(
              text: 'Edit reports',
              size: 18,
              weight: FontWeight.w500,
              paddingBottom: 4,
              paddingTop: 32,
            ),
            MyBorderButton(
              height: 50.0,
              text: 'Edit past daily reports* ',
              onTap: () => Get.to(() => EditDailyPastReports()),
            ),
            MyText(
              paddingTop: 8,
              text:
                  '*Please note: points and streaks cannot be earnt retrospectively',
              size: 10,
              paddingBottom: 31,
            ),
            MyText(
              text: 'New day begins*',
              size: 18,
              weight: FontWeight.w500,
              paddingBottom: 4,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      builder: (context) {
                        return CustomBottomSheet(
                          height: 350,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                paddingLeft: 16,
                                text: 'Select time',
                                size: 20,
                                weight: FontWeight.w500,
                              ),
                              TimePickerSpinner(
                                time: DateFormat("HH:mm a").parse(day!),
                                is24HourMode: false,
                                normalTextStyle: TextStyle(
                                  fontSize: 20,
                                  color: kTextColor,
                                ),
                                highlightedTextStyle: TextStyle(
                                  fontSize: 20,
                                  color: kTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                spacing: 40,
                                itemHeight: 50,
                                isForce2Digits: false,
                                minutesInterval: 1,
                                onTimeChange: (time) {
                                  day = DateFormat("HH:mm a").format(time);
                                  if (mounted) {
                                    setState(() {});
                                  }
                                },
                              ),
                              SizedBox(),
                            ],
                          ),
                          onTap: () {
                            PrefUtils().newGoalStartTime = day!.toUpperCase();
                            if(mounted){
                              setState(() {

                              });
                            }
                            Get.back();
                          },
                          buttonText: 'Confirm',
                          isButtonDisable: false,
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 45,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kBorderColor, width: 1),
                    ),
                    child: Center(
                      child: Image.asset(
                        Assets.imagesNotificationBell,
                        height: 24,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 45.5,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: kBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      color: kSecondaryColor,
                    ),
                    child: MyText(
                      text: PrefUtils().newGoalStartTime,
                      size: 16,
                      color: kTextColor,
                    ),
                  ),
                ),
              ],
            ),
            MyText(
              paddingTop: 4,
              text:
                  '*Please note: reports not submitted from the previous day will also automatically submit at this time',
              size: 10,
              height: 1.6,
            ),
          ],
        ),
      ),
    );
  }
}
