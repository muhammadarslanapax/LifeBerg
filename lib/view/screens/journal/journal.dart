import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/controller/journal_controller/journal_controller.dart';
import 'package:life_berg/view/screens/journal/journal_tabs/gratitudes.dart';
import 'package:life_berg/view/screens/journal/journal_tabs/new_entry.dart';
import 'package:life_berg/view/screens/journal/journal_tabs/past_entries.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

class Journal extends StatelessWidget {

  final JournalController controller = Get.find<JournalController>();

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection,
      ],
      child: Scaffold(
        backgroundColor: kSecondaryColor,
        appBar: simpleAppBar(
          centerTitle: true,
          haveLeading: false,
          title: 'Journal',
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: SizedBox(
                height: 41,
                child: Center(
                  child: TabBar(
                    isScrollable: true,
                    controller: controller.tabController,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: kDayStepColor,
                    indicatorWeight: 4,
                    labelPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    tabs: List<Tab>.generate(
                      controller.tabs.length,
                      (index) => Tab(
                        child: MyText(
                          text: controller.tabs[index],
                          size: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                physics: BouncingScrollPhysics(),
                children: controller.tabViews,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
