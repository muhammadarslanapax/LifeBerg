import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/personal_statistics/comparison/comparison_charts/comparison_one_week_chart.dart';
import 'package:life_berg/view/screens/personal_statistics/goals/goal_charts/goal_one_week_chart.dart';
import 'package:life_berg/view/widget/custom_drop_down.dart';
import 'package:life_berg/view/widget/custom_icon_tile.dart';
import 'package:life_berg/view/widget/heading_action_tile.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/note_tile.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

// ignore: must_be_immutable
class ComparisonExpand extends StatefulWidget {
  ComparisonExpand({Key? key}) : super(key: key);

  @override
  State<ComparisonExpand> createState() => _ComparisonExpandState();
}

class _ComparisonExpandState extends State<ComparisonExpand> {
  List<String> tabs = [
    '1 wk',
    '1 mo',
    '3 mo',
    '6 mo',
    '1 yr',
  ];

  String? data;

  List<Widget> tabViews = [
    ComparisonChartOneWeek(),
    Container(),
    Container(),
    Container(),
    Container(),
  ];

  List<Map<String, dynamic>> _goals = [
    {'goalType': 'wellbeing', 'goal': 'Goal 1'},
    {'goalType': 'vocational', 'goal': 'Goal 2'},
    {'goalType': 'personalDevelopment', 'goal': 'Goal 3'},
    {'goalType': 'dailyHighLights', 'goal': 'Goal 4'},
  ];

  String? selectedGoal = 'Goal 1';
  String? selectedGoalType = 'wellbeing';

  List<Map<String, dynamic>> _goalsForComparison = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: kSecondaryColor,
        appBar: simpleAppBar(
          title: 'Comparison',
        ),
        body: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            Text(data!),
            Padding(
              padding: EdgeInsets.all(15),
              child: SizedBox(
                height: 41,
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: TabBar(
                          isScrollable: true,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: kDayStepColor,
                          indicatorWeight: 4,
                          labelPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          tabs: List<Tab>.generate(
                            tabs.length,
                            (index) => Tab(
                              child: MyText(
                                text: tabs[index],
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Image.asset(
                        Assets.imagesPointsAccuralClose,
                        height: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 350,
              child: TabBarView(
                physics: BouncingScrollPhysics(),
                children: tabViews,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 32, 15, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HeadingActionTile(
                    heading: 'Select goals for comparison',
                  ),
                  if (_goalsForComparison.isNotEmpty)
                    ...List.generate(
                      _goalsForComparison.length,
                      (index) {
                        var data = _goalsForComparison[index];
                        return CustomIconTile(
                          title: data['goal'],
                          leadingColor: data['goalType'] == 'wellbeing'
                              ? kWellBeingColor
                              : data['goalType'] == 'vocational'
                                  ? kPeachColor
                                  : data['goalType'] == 'personalDevelopment'
                                      ? kCardioColor
                                      : kC3,
                          haveTrailingIcon: true,
                        );
                      },
                    ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      hint: MyText(
                        text: 'Select Goal',
                        size: 14,
                        color: kTextColor.withOpacity(0.50),
                      ),
                      items: List.generate(
                        _goals.length,
                        (index) {
                          var data = _goals[index];
                          return DropdownMenuItem<dynamic>(
                            value: data,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 16,
                                  width: 16,
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: data['goalType'] == 'wellbeing'
                                        ? kWellBeingColor.withOpacity(0.2)
                                        : data['goalType'] == 'vocational'
                                            ? kPeachColor.withOpacity(0.2)
                                            : data['goalType'] ==
                                                    'personalDevelopment'
                                                ? kCardioColor.withOpacity(0.2)
                                                : kC3.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: data['goalType'] == 'wellbeing'
                                            ? kWellBeingColor
                                            : data['goalType'] == 'vocational'
                                                ? kPeachColor
                                                : data['goalType'] ==
                                                        'personalDevelopment'
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
                                  paddingLeft: 11,
                                  text: data['goal'],
                                  size: 14,
                                  color: kCoolGreyColor,
                                  weight: FontWeight.w400,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      onChanged: (v) {
                        setState(() {
                          selectedGoal = v['goal'];
                          selectedGoalType = v['goalType'];
                          _goalsForComparison.add({
                            'goal': selectedGoal,
                            'goalType': selectedGoalType,
                          });
                        });
                      },
                      icon: Image.asset(
                        Assets.imagesDropDownIcon,
                        height: 24,
                      ),
                      isDense: true,
                      isExpanded: true,
                      buttonHeight: 40,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
