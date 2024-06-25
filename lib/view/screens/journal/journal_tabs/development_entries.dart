import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/constant/strings.dart';
import 'package:life_berg/controller/journal_controller/journal_controller.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/utils/date_utility.dart';
import 'package:life_berg/view/widget/custom_check_box_tile.dart';
import 'package:life_berg/view/widget/dialog_action_button.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/menu_item.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/past_entries_widget.dart';
import 'package:life_berg/view/widget/search_bar.dart';
import 'package:life_berg/view/widget/time_line_indicator.dart';
import 'package:timelines/timelines.dart';

import '../add_new_journal.dart';

class DevelopmentEntries extends StatefulWidget {
  @override
  State<DevelopmentEntries> createState() => _DevelopmentEntriesState();
}

class _DevelopmentEntriesState extends State<DevelopmentEntries> {
  final JournalController controller = Get.find<JournalController>();

  bool showResults = false;

  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails tapPosition) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    _tapPosition = referenceBox.globalToLocal(tapPosition.globalPosition);
  }

  void _showContextMenu(BuildContext context, int index) async {
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
        maxWidth: 170,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      items: [
        menuItem(
          icon: Assets.imagesEditItem,
          title: editEntry,
          onTap: () {
            Navigator.of(context).pop();
            controller.addTextController.text =
                controller.developmentJournals[index].description ?? "";
            for (int i = 0; i < controller.colors.length; i++) {
              var color = controller.colors[i];
              if (colorToHex(color.color) ==
                  controller.developmentJournals[index].color) {
                controller.colorIndex.value = i;
              }
            }
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              builder: (_) {
                return AddNewJournal(
                  controller.currentTab == 0 ? development : gratitudes,
                  journal: controller.developmentJournals[index],
                );
              },
            );
          },
        ),
        menuItem(
          title: deleteEntry,
          icon: Assets.imagesDeleteThisItem,
          borderColor: Colors.transparent,
          onTap: () {
            Navigator.of(context).pop();
            Get.dialog(
              MyDialog(
                icon: Assets.imagesDeleteThisItem,
                heading: deleteDevelopment,
                content: deleteDevelopmentDes,
                haveCustomActionButtons: true,
                customAction: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DialogActionButton(
                      text: undo,
                      onTap: () => Get.back(),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    DialogActionButton(
                      text: delete,
                      textColor: kRedColor,
                      onTap: () {
                        Get.back();
                        controller.deleteJournal(
                            controller.developmentJournals[index].sId ?? "",
                            development,
                            index);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
      children: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              child: SearchBarDAR(
                onClear: () {
                  controller.searchDevelopmentController.clear();
                  controller.isShowDevelopmentSearch.value = false;
                  controller.searchDevelopment("");
                },
                marginBottom: 0,
                controller: controller.searchDevelopmentController,
                onChanged: (v) {
                  controller.isShowDevelopmentSearch.value = v.length > 0;
                  controller.searchDevelopment(v);
                },
              ),
            ),
            Positioned(
              right: 10,
              top: 0,
              bottom: 0,
              child: Container(
                width: 20,
                height: 20,
                child: GestureDetector(
                  onTap: () {
                    _showSortByBottomSheet();
                  },
                  child: Image.asset(
                    Assets.imagesFilterButtom,
                    height: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Obx(() => controller.isShowDevelopmentSearch.value == true
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MainHeading(
                    text: searchResults,
                    paddingBottom: 10,
                  ),
                  Column(
                    children: List.generate(
                      controller.developmentJournals.length,
                      (index) {
                        return GestureDetector(
                          onTapDown: (position) => {
                            _getTapPosition(position),
                          },
                          onLongPress: () => _showContextMenu(context, index),
                          child: PastEntryWidget(
                            title: controller
                                    .developmentJournals[index].description ??
                                "",
                            time: DateUtility.formatDateForJournal(
                                controller.developmentJournals[index].date ??
                                    ""),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Obx(
                () => controller.isLoadingJournals.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : FixedTimeline.tileBuilder(
                        theme: TimelineThemeData(
                          nodePosition: 0,
                          connectorTheme: ConnectorThemeData(
                            color: kTextColor,
                            thickness: 1.0,
                          ),
                        ),
                        builder: TimelineTileBuilder(
                          itemCount: controller.developmentJournals.length,
                          contentsBuilder: (_, index) {
                            return GestureDetector(
                              onTapDown: (position) => {
                                _getTapPosition(position),
                              },
                              onLongPress: () =>
                                  _showContextMenu(context, index),
                              child: PastEntryWidget(
                                title: controller.developmentJournals[index]
                                        .description ??
                                    "",
                                time: DateUtility.formatDateForJournal(
                                    controller
                                            .developmentJournals[index].date ??
                                        ""),
                              ),
                            );
                          },
                          indicatorBuilder: (context, index) {
                            return TimeLineIndicator(
                              color: hexToColor(
                                  controller.developmentJournals[index].color ??
                                      ""),
                            );
                          },
                          startConnectorBuilder: (_, index) =>
                              Connector.solidLine(
                            color: kBorderColor,
                            thickness: 4.0,
                          ),
                          endConnectorBuilder: (_, index) =>
                              Connector.solidLine(
                            color: kBorderColor,
                            thickness: 4.0,
                          ),
                        ),
                      ),
              ))
      ],
    );
  }

  _showSortByBottomSheet() {
    showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(8),
              topLeft: Radius.circular(8),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  Assets.imagesBottomSheetHandle,
                  height: 8,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MainHeading(
                      text: sortBy,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Obx(() => Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            controller.items.length,
                            (index) {
                              return CustomCheckBoxTile(
                                title: controller.items[index],
                                isSelected: controller.items[index] ==
                                    controller.developmentFilter.value,
                                onSelect: () {
                                  controller.developmentFilter.value =
                                      controller.items[index];
                                },
                              );
                            },
                          ),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: Platform.isIOS
                    ? EdgeInsets.fromLTRB(15, 10, 15, 30)
                    : EdgeInsets.fromLTRB(15, 10, 15, 15),
                child: MyButton(
                  height: 56,
                  radius: 8,
                  isDisable: false,
                  text: confirm,
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.getUserJournals();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
