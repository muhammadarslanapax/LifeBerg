import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:life_berg/apis/http_manager.dart';
import 'package:life_berg/constant/strings.dart';
import 'package:life_berg/model/journal/journal_color.dart';
import 'package:life_berg/model/journal/journal_list_response.dart';
import 'package:life_berg/model/journal/journal_list_response_data.dart';
import 'package:life_berg/utils/date_utility.dart';
import 'package:life_berg/view/screens/journal/journal.dart';
import 'package:life_berg/view/screens/journal/journal_tabs/gratitudes.dart';
import 'package:life_berg/view/screens/journal/journal_tabs/new_entry.dart';
import 'package:life_berg/view/screens/journal/journal_tabs/development_entries.dart';

import '../../constant/color.dart';
import '../../model/error/error_response.dart';
import '../../model/generic_response.dart';
import '../../utils/pref_utils.dart';
import '../../utils/toast_utils.dart';

class JournalController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final HttpManager httpManager = HttpManager();

  final TextEditingController addTextController = TextEditingController();
  final TextEditingController searchDevelopmentController =
      TextEditingController();
  final TextEditingController searchGratitudeController =
      TextEditingController();

  List<JournalListResponseData> allDevelopmentJournals =
      <JournalListResponseData>[].obs;
  List<JournalListResponseData> allGratitudeJournals =
      <JournalListResponseData>[].obs;

  List<JournalListResponseData> developmentJournals =
      <JournalListResponseData>[].obs;
  List<JournalListResponseData> gratitudeJournals =
      <JournalListResponseData>[].obs;

  late TabController tabController;
  int currentTab = 0;

  RxBool isLoadingJournals = true.obs;

  RxBool isShowDevelopmentSearch = false.obs;
  RxBool isShowGratitudeSearch = false.obs;

  RxString developmentFilter = "Newest".obs;
  RxString gratitudeFilter = "Newest".obs;

  List<String> tabs = [
    development,
    gratitudes,
  ];

  List<Widget> tabViews = [
    DevelopmentEntries(),
    Gratitudes(),
  ];

  List<String> items = [
    newest,
    oldest,
    colorOnTimeline,
    length,
  ];

  final List<JournalColor> colors = [
    JournalColor(2, kC1),
    JournalColor(4, kC2),
    JournalColor(6, kC3),
    JournalColor(8, kC4),
    JournalColor(10, kC5),
    JournalColor(12, kC6),
    JournalColor(14, kC7),
    JournalColor(16, kC8),
    JournalColor(1, kC9),
    JournalColor(3, kC10),
    JournalColor(5, kC11),
    JournalColor(7, kC12),
    JournalColor(9, kC13),
    JournalColor(11, kQuiteTimeColor),
    JournalColor(13, kDarkBlueColor),
    JournalColor(15, kC16),
  ];

  RxInt colorIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    setInitialText();
    tabController = TabController(
      length: tabs.length,
      vsync: this,
    );
    tabController.addListener(() {
      currentTab = tabController.index;
    });
    getUserJournals();
  }

  setInitialText() {
    addTextController.text = '\u2022 ';
    addTextController.selection = TextSelection.fromPosition(
      TextPosition(offset: addTextController.text.length),
    );
  }

  searchDevelopment(String text) {
    developmentJournals.clear();
    if (text.isEmpty) {
      developmentJournals.addAll(allDevelopmentJournals);
    } else {
      for (var journal in allDevelopmentJournals) {
        if (journal.description!.toLowerCase().contains(text.toLowerCase())) {
          developmentJournals.add(journal);
        }
      }
    }
  }

  searchGratitude(String text) {
    gratitudeJournals.clear();
    if (text.isEmpty) {
      gratitudeJournals.addAll(allGratitudeJournals);
    } else {
      for (var journal in allGratitudeJournals) {
        if (journal.description!.toLowerCase().contains(text.toLowerCase())) {
          gratitudeJournals.add(journal);
        }
      }
    }
  }

  int getColorId(String color) {
    for (var c in colors) {
      if (colorToHex(c.color) == color) {
        return c.id;
      }
    }
    return -1;
  }

  getUserJournals() async {
    allDevelopmentJournals.clear();
    allGratitudeJournals.clear();
    gratitudeJournals.clear();
    developmentJournals.clear();
    isLoadingJournals.value = true;
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager.getJournals(PrefUtils().token).then((value) {
      if (value.error == null) {
        if (value.snapshot is! ErrorResponse) {
          JournalListResponse journalListResponse = value.snapshot;
          if (journalListResponse.success == true) {
            if (journalListResponse.data != null) {
              for (var journal in journalListResponse.data!) {
                switch (journal.category) {
                  case development:
                    allDevelopmentJournals.add(journal);
                    break;
                  case gratitudes:
                    allGratitudeJournals.add(journal);
                    break;
                }
              }
              switch (developmentFilter.value) {
                case newest:
                  allDevelopmentJournals.sort((a, b) {
                    DateTime? dateA = DateUtility.parseDate(a.date);
                    DateTime? dateB = DateUtility.parseDate(b.date);
                    return dateB!.compareTo(dateA!);
                  });
                  break;
                case oldest:
                  allDevelopmentJournals.sort((a, b) {
                    DateTime? dateA = DateUtility.parseDate(a.date);
                    DateTime? dateB = DateUtility.parseDate(b.date);
                    return dateA!.compareTo(dateB!);
                  });
                  break;
                case length:
                  allDevelopmentJournals.sort((a, b) =>
                      b.description!.length.compareTo(a.description!.length));
                  break;
                case colorOnTimeline:
                  allDevelopmentJournals.sort((a, b) =>
                      getColorId(a.color!).compareTo(getColorId(b.color!)));
                  break;
              }
              developmentJournals.addAll(allDevelopmentJournals);
              switch (gratitudeFilter.value) {
                case newest:
                  allGratitudeJournals.sort((a, b) {
                    DateTime? dateA = DateUtility.parseDate(a.date);
                    DateTime? dateB = DateUtility.parseDate(b.date);
                    return dateB!.compareTo(dateA!);
                  });
                  break;
                case oldest:
                  allGratitudeJournals.sort((a, b) {
                    DateTime? dateA = DateUtility.parseDate(a.date);
                    DateTime? dateB = DateUtility.parseDate(b.date);
                    return dateA!.compareTo(dateB!);
                  });
                  break;
                case length:
                  allGratitudeJournals.sort((a, b) =>
                      b.description!.length.compareTo(a.description!.length));
                  break;
                case colorOnTimeline:
                  allGratitudeJournals.sort((a, b) =>
                      getColorId(a.color!).compareTo(getColorId(b.color!)));
                  break;
              }
              gratitudeJournals.addAll(allGratitudeJournals);
            }
          } else {
            SmartDialog.dismiss();
            ToastUtils.showToast(journalListResponse.message ?? "",
                color: kRedColor);
          }
        } else {
          ErrorResponse errorResponse = value.snapshot;
          ToastUtils.showToast(errorResponse.error!.details!.message ?? "",
              color: kRedColor);
        }
      } else {
        ToastUtils.showToast(value.error ?? "", color: kRedColor);
      }
      isLoadingJournals.value = false;
    });
  }

  addNewJournal(Function(bool isSuccess) onJournalCreate, String journal,
      String color, String category) {
    FocusManager.instance.primaryFocus?.unfocus();
    SmartDialog.showLoading(msg: pleaseWait);
    httpManager
        .addNewJournal(
      PrefUtils().token,
      journal,
      color,
      category,
    )
        .then((response) {
      SmartDialog.dismiss();
      if (response.error == null) {
        if (response.snapshot! is! ErrorResponse) {
          GenericResponse genericResponse = response.snapshot;
          if (genericResponse.success == true) {
            onJournalCreate(true);
          } else {
            onJournalCreate(false);
          }
        }
      } else {
        onJournalCreate(false);
        ToastUtils.showToast(someError, color: kRedColor);
      }
    });
  }

  deleteJournal(String journalId, String type, int index) {
    SmartDialog.showLoading(msg: pleaseWait);
    FocusManager.instance.primaryFocus?.unfocus();
    httpManager
        .deleteJournal(
      PrefUtils().token,
      journalId,
    )
        .then((response) {
      SmartDialog.dismiss();
      if (response.error == null) {
        GenericResponse genericResponse = response.snapshot;
        if (genericResponse.success == true) {
          switch (type) {
            case development:
              for (var journal in allDevelopmentJournals) {
                if (journal.sId == journalId) {
                  allDevelopmentJournals.remove(journal);
                  break;
                }
              }
              developmentJournals.removeAt(index);
              break;
            case gratitudes:
              for (var journal in allGratitudeJournals) {
                if (journal.sId == journalId) {
                  allGratitudeJournals.remove(journal);
                  break;
                }
              }
              gratitudeJournals.removeAt(index);
              break;
          }
        }
      } else {
        ToastUtils.showToast(someError, color: kRedColor);
      }
    });
  }

  updateJournal(Function(bool isSuccess) onJournalUpdate, String journalId) {
    FocusManager.instance.primaryFocus?.unfocus();
    SmartDialog.showLoading(msg: pleaseWait);
    httpManager
        .updateJournal(
      PrefUtils().token,
      journalId,
      addTextController.text.toString(),
      colorToHex(colors[colorIndex.value].color),
    )
        .then((response) {
      SmartDialog.dismiss();
      if (response.error == null) {
        if (response.snapshot! is! ErrorResponse) {
          GenericResponse genericResponse = response.snapshot;
          if (genericResponse.success == true) {
            onJournalUpdate(true);
          } else {
            onJournalUpdate(false);
          }
        }
      } else {
        onJournalUpdate(false);
        ToastUtils.showToast(someError, color: kRedColor);
      }
    });
  }
}
