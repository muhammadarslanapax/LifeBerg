import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/controller/journal_controller/journal_controller.dart';
import 'package:life_berg/view/screens/journal/add_new_journal.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

import '../../../generated/assets.dart';

class Journal extends StatelessWidget {
  final JournalController controller = Get.put(JournalController());

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection,
      ],
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: simpleAppBar(
          centerTitle: true,
          haveLeading: false,
          title: 'Journal',
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 50, top: 15, bottom: 15),
              child: SizedBox(
                height: 41,
                child: Center(
                  child: TabBar(
                    dividerColor: Colors.transparent,
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
                          color: kTextColor,
                          text: controller.tabs[index],
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 14,
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
        floatingActionButton: FloatingActionButton(
          heroTag: "journal_floating_button",
          onPressed: () async {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              builder: (_) {
                return AddNewJournal(
                  controller.currentTab == 0 ? "Development" : "Gratitudes",
                );
              },
            );
            controller.setInitialText();
          },
          elevation: 0,
          highlightElevation: 0,
          backgroundColor: Colors.transparent,
          child: Image.asset(
            Assets.imagesAddButton,
            height: 44,
          ),
        ),
      ),
    );
  }
}
