import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/add_goal_reminder.dart';
import 'package:life_berg/view/widget/custom_drop_down.dart';
import 'package:life_berg/view/widget/custom_radio_tile.dart';
import 'package:life_berg/view/widget/custom_track_shape.dart';
import 'package:life_berg/view/widget/dialog_action_button.dart';
import 'package:life_berg/view/widget/icon_and_color_bottom_sheet.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

class EditGoal extends StatefulWidget {
  @override
  State<EditGoal> createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  final List<String> days = [
    'S',
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
  ];

  String selectedValue = 'Achieve everyday';

  List<String> items = [
    'Achieve everyday',
    'Achieve X number of days a week',
  ];

  List<String> _goals = [
    'Select category',
    'Wellbeing',
    'Vocation',
    'Personal Development',
  ];

  String? selectedGoal = 'Select category';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      appBar: simpleAppBar(
        title: 'Edit goal',
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
                  height: 47,
                  width: 47,
                  decoration: BoxDecoration(
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
              },
              value: selectedGoal,
              icon: Image.asset(
                Assets.imagesDropDownIcon,
                height: 24,
              ),
              isDense: true,
              isExpanded: true,
              buttonHeight: 47,
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
            hint: 'Description',
            maxLines: 5,
          ),
          // Wrap(
          //   spacing: 3,
          //   alignment: WrapAlignment.spaceBetween,
          //   children: List.generate(
          //     days.length,
          //     (index) {
          //       return weekDaysToggleButton(
          //         onTap: () {},
          //         isSelected: index == 2 || index == 4 ? true : false,
          //         weekDay: days[index],
          //       );
          //     },
          //   ),
          // ),
          CustomDropDown(
            hint: 'Certain number of days a week',
            items: items,
            selectedValue: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          if (selectedValue == 'Achieve X number of days a week')
            Row(
              children: List.generate(
                7,
                (index) {
                  return certainDay(index, () {}, index == 0);
                },
              ),
            ),
          MyText(
            paddingTop: 20,
            text: 'Weighting',
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
              max: 100.0,
              divisions: 2,
              onChanged: (value) {},
              value: 50.0,
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
            paddingTop: 20,
            text: 'Reporting',
            size: 16,
            weight: FontWeight.w500,
            paddingBottom: 16,
          ),
          CustomRadioTile(
            onTap: () {},
            isSelected: false,
            title: 'Yes (achieved), No (not achieved)',
          ),
          SizedBox(
            height: 2,
          ),
          CustomRadioTile(
            onTap: () {},
            isSelected: true,
            title: 'Point scale (0 to10)',
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                elevation: 0,
                builder: (_) {
                  return AddGoalReminder((day,time){});
                },
              );
            },
            child: Row(
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
          ),
          SizedBox(
            height: 10,
          ),
          Row(
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
                    text: 'Sun, Mon, Tue, Wed, Thu, Fri',
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
                    text: '05:30PM',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MyText(
                  text: 'Archive goal',
                  size: 16,
                  weight: FontWeight.w500,
                  paddingRight: 16,
                ),
                GestureDetector(
                  onTap: () {
                    Get.dialog(
                      MyDialog(
                        icon: Assets.imagesArchive2,
                        heading: 'Archive Goal',
                        content:
                            'Selected goal will be archived and made inactive.',
                        haveCustomActionButtons: true,
                        customAction: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            DialogActionButton(
                              text: 'Undo',
                              textColor: kRedColor,
                              onTap: () => Get.back(),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            DialogActionButton(
                              text: 'Okay',
                              onTap: () {
                                Get.back();
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Image.asset(
                    Assets.imagesArchive2,
                    height: 19.5,
                    color: kTertiaryColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          MyButton(
            isDisable: false,
            text: 'Save changes',
            onTap: () {
              Get.dialog(
                MyDialog(
                  icon: Assets.imagesEditItem,
                  heading: 'Edit goal',
                  content: 'Your selected item has been edited.',
                  onOkay: () {
                    Get.back();
                    Get.back();
                  },
                ),
              );
            },
          ),
          SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  width: 1.0,
                  color: kTertiaryColor,
                ),
              ),
              child: Center(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    color: kTertiaryColor,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Ubuntu',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget weekDaysToggleButton({
    String? weekDay,
    VoidCallback? onTap,
    bool? isSelected,
    int? index,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0),
        width: 41,
        height: 51,
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
                size: 16,
                color: isSelected ? kPrimaryColor : kTextColor,
              ),
            ),
          ),
        ),
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
