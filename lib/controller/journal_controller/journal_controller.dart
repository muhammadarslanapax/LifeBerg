

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/view/screens/journal/journal_tabs/gratitudes.dart';
import 'package:life_berg/view/screens/journal/journal_tabs/new_entry.dart';
import 'package:life_berg/view/screens/journal/journal_tabs/past_entries.dart';

class JournalController extends GetxController with GetSingleTickerProviderStateMixin{
  late TabController tabController;
  int currentTab = 0;

  List<String> tabs = [
    'New Entry',
    'Past Entries',
    'Gratitudes',
  ];

  List<Widget> tabViews = [
    NewEntry(),
    PastEntries(),
    Gratitudes(),
  ];


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this,);
    tabController.addListener(() {
      currentTab = tabController.index;
    });
  }








}