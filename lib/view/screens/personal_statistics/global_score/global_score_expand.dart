import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/personal_statistics/global_score/gloabl_score_charts/global_score_one_week_chart.dart';
import 'package:life_berg/view/screens/personal_statistics/global_score/global_score_controller.dart';
import 'package:life_berg/view/widget/custom_icon_tile.dart';
import 'package:life_berg/view/widget/heading_action_tile.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

// ignore: must_be_immutable
class GlobalScoreExpand extends StatefulWidget {
  GlobalScoreExpand({Key? key}) : super(key: key);

  @override
  State<GlobalScoreExpand> createState() => _GlobalScoreExpandState();
}

class _GlobalScoreExpandState extends State<GlobalScoreExpand>
    with SingleTickerProviderStateMixin {
  final GlobalScoreController globalScoreController =
      Get.put(GlobalScoreController());

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    tabController.addListener(() {
      if(tabController.indexIsChanging){

      }else {
        globalScoreController.chartData.clear();
        switch (tabController.index) {
          case 0:
            globalScoreController.tabType.value = "one_week";
            break;
          case 1:
            globalScoreController.tabType.value = "one_month";
            break;
          case 2:
            globalScoreController.tabType.value = "three_month";
            break;
          case 3:
            globalScoreController.tabType.value = "six_month";
            break;
          case 4:
            globalScoreController.tabType.value = "one_year";
            break;
        }
        globalScoreController.getGlobalScoreReport();
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
    GlobalScoreOneWeek("one_week"),
    GlobalScoreOneWeek("one_month"),
    GlobalScoreOneWeek("three_month"),
    GlobalScoreOneWeek("six_month"),
    GlobalScoreOneWeek("one_year"),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: kSecondaryColor,
        appBar: simpleAppBar(
          title: 'Global Score',
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
                children: tabViews,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 32, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HeadingActionTile(
                    heading: 'Display',
                  ),
                  Obx(
                    () => CustomIconTile(
                      title: 'Global Score',
                      leadingColor: kLightPurpleColor,
                      haveCheckBox: true,
                      value: globalScoreController.isGlobalSelected.value,
                      onTap: () {
                        globalScoreController.isGlobalSelected.value =
                            !globalScoreController.isGlobalSelected.value;
                      },
                    ),
                  ),
                  Obx(() => CustomIconTile(
                        title: 'Wellbeing',
                        leadingColor: kWellBeingColor,
                        haveCheckBox: true,
                        value: globalScoreController.isWellbeingSelected.value,
                        onTap: () {
                          globalScoreController.isWellbeingSelected.value =
                              !globalScoreController.isWellbeingSelected.value;
                        },
                      )),
                  Obx(() => CustomIconTile(
                        title: 'Vocational',
                        leadingColor: kRACGPExamColor,
                        haveCheckBox: true,
                        value: globalScoreController.isVocationalSelected.value,
                        onTap: () {
                          globalScoreController.isVocationalSelected.value =
                              !globalScoreController.isVocationalSelected.value;
                        },
                      )),
                  Obx(() => CustomIconTile(
                        title: 'Personal Development',
                        leadingColor: kDailyGratitudeColor,
                        haveCheckBox: true,
                        value: globalScoreController
                            .isPersonalDevelopmentSelected.value,
                        onTap: () {
                          globalScoreController
                                  .isPersonalDevelopmentSelected.value =
                              !globalScoreController
                                  .isPersonalDevelopmentSelected.value;
                        },
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
