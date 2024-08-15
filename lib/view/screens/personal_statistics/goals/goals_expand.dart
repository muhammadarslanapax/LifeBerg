import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/personal_statistics/goals/goal_charts/goal_one_week_chart.dart';
import 'package:life_berg/view/screens/personal_statistics/statistics_controller.dart';
import 'package:life_berg/view/widget/custom_drop_down.dart';
import 'package:life_berg/view/widget/heading_action_tile.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/note_tile.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

import '../../../../constant/strings.dart';
import '../../../../model/goal/goal.dart';
import '../../../../model/goal/goal_submit/goal_submit_data.dart';
import '../../../../model/goal_report/goal_report_list_response_data.dart';
import '../../../../utils/pref_utils.dart';
import '../../../widget/custom_bottom_sheet.dart';
import '../../../widget/menu_item.dart';
import '../../../widget/my_dialog.dart';
import '../../../widget/my_text_field.dart';
import 'goal_expand_controller.dart';

// ignore: must_be_immutable
class GoalExpand extends StatefulWidget {
  GoalExpand({Key? key}) : super(key: key);

  @override
  State<GoalExpand> createState() => _GoalExpandState();
}

class _GoalExpandState extends State<GoalExpand>
    with SingleTickerProviderStateMixin {
  final StatisticsController controller = Get.find<StatisticsController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GoalExpandController goalExpandController =
      Get.put(GoalExpandController());

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
        goalExpandController.getGoalReport(controller
            .goalsList[goalExpandController.selectedGoalIndex.value].sId!);
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

  showCommentSheet(dynamic data) {
    showModalBottomSheet(
      context: _scaffoldKey.currentContext!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (_) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: CustomBottomSheet(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 6,
              ),
              child: MyTextField(
                fillColor: Colors.white,
                maxLines: 1,
                controller: goalExpandController.commentController,
                hint: addCommentDes,
                marginBottom: 0.0,
              ),
            ),
            onTap: () {
              String goalId = data.goalId ?? "";
              GoalReportListResponseData? report;
              for (var reportData in goalExpandController.expandedGoalReport) {
                if (reportData.details != null &&
                    reportData.details!.isNotEmpty) {
                  DateTime date = DateTime.parse(reportData.date!);
                  String formattedDate = DateFormat('yyyy-MM-dd').format(date);
                  if (reportData.details![0].goal!.sId == goalId &&
                      formattedDate == data.xValueMapper) {
                    report = reportData;
                    break;
                  }
                }
              }
              if (report != null) {
                report.details![0].comment =
                    goalExpandController.commentController.text;
                goalExpandController.getGoalReportByDate(report.date!, report);
                Navigator.pop(_scaffoldKey.currentContext!);
              }
            },
            buttonText: submit,
            isButtonDisable: false,
          ),
        );
      },
    );
  }

  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails tapPosition) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    _tapPosition = referenceBox.globalToLocal(tapPosition.globalPosition);
  }

  void _showContextMenu(BuildContext context, int index, String goalId) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();
    final result = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 100, 100),
        Rect.fromLTWH(
          0,
          -40,
          overlay!.paintBounds.size.width,
          overlay.paintBounds.size.height,
        ),
      ),
      elevation: 10,
      constraints: BoxConstraints(
        maxWidth: 200,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      items: [
        menuItem(
          title: "Delete Comment",
          icon: Assets.imagesDeleteThisItem,
          borderColor: Colors.transparent,
          onTap: () {
            Navigator.of(context).pop();
            String goalId = goalExpandController.expandedGoalReport[index].details![0].goal!.sId ?? "";
            GoalReportListResponseData? report;
            for (var reportData in goalExpandController.expandedGoalReport) {
              if (reportData.details != null &&
                  reportData.details!.isNotEmpty) {
                DateTime date = DateTime.parse(reportData.date!);
                String formattedDate = DateFormat('yyyy-MM-dd').format(date);
                if (reportData.details![0].goal!.sId == goalId &&
                    formattedDate == DateFormat("yyyy-MM-dd").format(DateTime.parse(goalExpandController.expandedGoalReport[index].date!))) {
                  report = reportData;
                  break;
                }
              }
            }
            if (report != null) {
              report.details![0].comment = "";
              goalExpandController.getGoalReportByDate(report.date!, report,
                  isForDelete: true);
            }

            // goalExpandController.updateComment((report) {
            //   List<GoalSubmitData> goalSubmitData = [];
            //   if (PrefUtils().submittedGoals.isNotEmpty) {
            //     List<dynamic> jsonList = jsonDecode(PrefUtils().submittedGoals);
            //     List<GoalSubmitData> goalSubmitDataList = jsonList
            //         .map((jsonItem) => GoalSubmitData.fromJson(jsonItem))
            //         .toList();
            //     goalSubmitData.addAll(goalSubmitDataList);
            //   }
            //   for (var goals in goalSubmitData) {
            //     if (goals.goalId ==
            //         goalExpandController
            //             .expandedGoalReport[index].details![0].goal!.sId) {
            //       goals.comment = "";
            //     }
            //   }
            //   String jsonString = jsonEncode(
            //       goalSubmitData.map((goal) => goal.toJson()).toList());
            //   PrefUtils().submittedGoals = jsonString;
            //   goalExpandController.homeController.getUserData();
            //   if (mounted) {
            //     setState(() {});
            //   }
            // }, goalExpandController.expandedGoalReport,
            //     goalExpandController.expandedGoalReport[index].date!);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: 0,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: kSecondaryColor,
        appBar: simpleAppBar(
          title: 'Goals',
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
                          isScrollable: true,
                          controller: tabController,
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
                children: [
                  GoalChartOneWeek("one_week", (data) {
                    showCommentSheet(data);
                  },(data){
                    String goalId = data.goalId ?? "";
                    GoalReportListResponseData? report;
                    for (var reportData in goalExpandController.expandedGoalReport) {
                      if (reportData.details != null &&
                          reportData.details!.isNotEmpty) {
                        DateTime date = DateTime.parse(reportData.date!);
                        String formattedDate = DateFormat('yyyy-MM-dd').format(date);
                        if (reportData.details![0].goal!.sId == goalId &&
                            formattedDate == data.xValueMapper) {
                          report = reportData;
                          break;
                        }
                      }
                    }
                    if (report != null) {
                      report.details![0].comment = "";
                      goalExpandController.getGoalReportByDate(report.date!, report,
                      isForDelete: true);
                    }
                  }),
                  GoalChartOneWeek("one_month", (d) {
                    showCommentSheet(d);
                  },(d) {
                    String goalId = d.goalId ?? "";
                    GoalReportListResponseData? report;
                    for (var reportData in goalExpandController.expandedGoalReport) {
                      if (reportData.details != null &&
                          reportData.details!.isNotEmpty) {
                        DateTime date = DateTime.parse(reportData.date!);
                        String formattedDate = DateFormat('yyyy-MM-dd').format(date);
                        if (reportData.details![0].goal!.sId == goalId &&
                            formattedDate == d.xValueMapper) {
                          report = reportData;
                          break;
                        }
                      }
                    }
                    if (report != null) {
                      report.details![0].comment = "";
                      goalExpandController.getGoalReportByDate(report.date!, report,
                          isForDelete: true);
                    }
                  }),
                  GoalChartOneWeek("three_month", (d) {},(d){}),
                  GoalChartOneWeek("six_month", (d) {},(d){}),
                  GoalChartOneWeek("one_year", (d) {},(d){}),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 32, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HeadingActionTile(
                    heading: 'Goal Selection',
                  ),
                  Obx(() => DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          hint: MyText(
                            text: "Select",
                            size: 15,
                            weight: FontWeight.w400,
                            color: kTextColor.withOpacity(0.50),
                          ),
                          items: controller.goalsListIndex
                              .map(
                                (item) => DropdownMenuItem<dynamic>(
                                  value: item,
                                  child: MyText(
                                    text: controller.goalsList[item].name,
                                    size: 14,
                                  ),
                                ),
                              )
                              .toList(),
                          value: goalExpandController.selectedGoalIndex.value,
                          onChanged: (index) {
                            goalExpandController.selectedGoalIndex.value =
                                index as int;
                            goalExpandController.getGoalReport(
                              controller
                                  .goalsList[goalExpandController
                                      .selectedGoalIndex.value]
                                  .sId!,
                            );
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
                      )),
                  // CustomDropDown(
                  //   buttonHeight: 40,
                  //   hint: 'Select',
                  //   items: [
                  //     'Goal 1',
                  //     'Goal 2',
                  //     'Goal 3',
                  //   ],
                  //   onChanged: (value) {},
                  // ),
                  SizedBox(
                    height: 32,
                  ),
                  HeadingActionTile(
                    heading: 'Notes',
                  ),
                  Obx(() => ListView.builder(
                        itemBuilder: (BuildContext ctx, index) {
                          return goalExpandController
                                          .expandedGoalReport[index].details !=
                                      null &&
                                  goalExpandController.expandedGoalReport[index]
                                      .details!.isNotEmpty &&
                                  goalExpandController.expandedGoalReport[index]
                                          .details![0].comment !=
                                      null &&
                                  goalExpandController.expandedGoalReport[index]
                                      .details![0].comment!.isNotEmpty
                              ? GestureDetector(
                                  onTapDown: (position) => {
                                    _getTapPosition(position),
                                  },
                                  onLongPress: () => _showContextMenu(
                                      context,
                                      index,
                                      goalExpandController
                                          .expandedGoalReport[index]
                                          .details![0]
                                          .goal!
                                          .sId!),
                                  child: NotesTile(
                                    note:
                                        '${DateFormat("dd/MM").format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(goalExpandController.expandedGoalReport[index].date!))} - ${goalExpandController.expandedGoalReport[index].details![0].comment!}',
                                  ),
                                )
                              : Container();
                        },
                        itemCount:
                            goalExpandController.expandedGoalReport.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
