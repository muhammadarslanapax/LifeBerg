import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/model/expand_goal_selection/expand_selected_goal.dart';
import 'package:life_berg/view/screens/personal_statistics/comparison/comparison_charts/comparison_one_week_chart.dart';
import 'package:life_berg/view/screens/personal_statistics/comparison/comparison_goal_expand_controller.dart';
import 'package:life_berg/view/widget/custom_icon_tile.dart';
import 'package:life_berg/view/widget/heading_action_tile.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

import '../../../../model/goal/goal.dart';
import '../statistics_controller.dart';

// ignore: must_be_immutable
class ComparisonExpand extends StatefulWidget {
  ComparisonExpand({Key? key}) : super(key: key);

  @override
  State<ComparisonExpand> createState() => _ComparisonExpandState();
}

class _ComparisonExpandState extends State<ComparisonExpand>
    with SingleTickerProviderStateMixin {
  final StatisticsController controller = Get.find<StatisticsController>();
  final ComparisonGoalExpandController goalExpandController =
      Get.put(ComparisonGoalExpandController());

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
      } else {
        switch (tabController.index) {
          case 0:
            goalExpandController.tabType.value = "one_week";
            break;
          case 1:
            goalExpandController.tabType.value = "one_month";
            break;
          case 2:
            goalExpandController.tabType.value = "three_month";
            break;
          case 3:
            goalExpandController.tabType.value = "six_month";
            break;
          case 4:
            goalExpandController.tabType.value = "one_year";
            break;
        }
        goalExpandController.getComparisonGoalReport();
      }
    });
  }

  List<String> tabs = [
    '1 wk',
    '1 mo',
    '3 mo',
    '6 mo',
    '1 yr',
  ];

  List<Widget> tabViews = [
    ComparisonChartOneWeek(),
    ComparisonChartOneWeek(),
    ComparisonChartOneWeek(),
    ComparisonChartOneWeek(),
    ComparisonChartOneWeek(),
  ];

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
            Padding(
              padding: EdgeInsets.all(15),
              child: SizedBox(
                height: 41,
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: TabBar(
                          controller: tabController,
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
                controller: tabController,
                physics: BouncingScrollPhysics(),
                children: tabViews,
              ),
            ),
            Obx(
              () => Padding(
                padding: EdgeInsets.fromLTRB(15, 32, 15, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HeadingActionTile(
                      heading: 'Select goals for comparison',
                    ),
                    if (goalExpandController.selectedGoalsList.isNotEmpty)
                      ...List.generate(
                        goalExpandController.selectedGoalsList.length,
                        (index) {
                          var data = goalExpandController
                              .selectedGoalsList[index].goal;
                          return Container(
                            margin: EdgeInsets.only(bottom: 3),
                            child: goalExpandController.getDropdown(
                                data.value, index),
                          );
                        },
                      ),
                    SizedBox(
                      height: 5,
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        hint: MyText(
                          text: 'Select Goal',
                          size: 14,
                          color: kTextColor.withOpacity(0.50),
                        ),
                        items: List.generate(
                          controller.goalsList.length,
                          (index) {
                            var data = controller.goalsList[index];
                            return DropdownMenuItem<Goal>(
                              value: data,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 16,
                                    width: 16,
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: data.category?.name == 'Wellbeing'
                                          ? kStreaksColor.withOpacity(0.2)
                                          : data.category?.name == 'Vocational'
                                              ? kRACGPExamColor.withOpacity(0.2)
                                              : data.category?.name ==
                                                      'Personal Development'
                                                  ? kDailyGratitudeColor
                                                      .withOpacity(0.2)
                                                  : kC3.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: data.category?.name ==
                                                  'Wellbeing'
                                              ? kStreaksColor
                                              : data.category?.name ==
                                                      'Vocational'
                                                  ? kRACGPExamColor
                                                  : data.category?.name ==
                                                          'Personal Development'
                                                      ? kDailyGratitudeColor
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
                                    text: data.name ?? "",
                                    size: 14,
                                    color: kCoolGreyColor,
                                    weight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        onChanged:
                            goalExpandController.selectedGoalsList.length == 7
                                ? null
                                : (v) {
                                    goalExpandController.selectedGoalsList.add(
                                        ExpandSelectedGoal(
                                            goalExpandController.getDropdown(
                                                v as Goal,
                                                goalExpandController
                                                    .selectedGoalsList.length),
                                            (v).obs));
                                    goalExpandController
                                        .getComparisonGoalReport();
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
            ),
          ],
        ),
      ),
    );
  }
}

class ExpandComparisonChartDataModel {
  ExpandComparisonChartDataModel(this.xValueMapper, this.score, this.color);

  String? xValueMapper;
  int? score;
  Color? color;
}
