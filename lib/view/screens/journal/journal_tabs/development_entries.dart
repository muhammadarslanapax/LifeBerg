import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/controller/journal_controller/journal_controller.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/main.dart';
import 'package:life_berg/utils/date_utility.dart';
import 'package:life_berg/view/widget/choose_color.dart';
import 'package:life_berg/view/widget/common_image_view.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/custom_check_box_tile.dart';
import 'package:life_berg/view/widget/dialog_action_button.dart';
import 'package:life_berg/view/widget/image_dialog.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/menu_item.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_calender.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/past_entries_widget.dart';
import 'package:life_berg/view/widget/search_bar.dart';
import 'package:life_berg/view/widget/time_line_indicator.dart';
import 'package:textfield_tags/textfield_tags.dart';
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
    setState(() {
      _tapPosition = referenceBox.globalToLocal(tapPosition.globalPosition);
      print(_tapPosition);
    });
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
          title: 'Edit Entry',
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
                  controller.currentTab == 0 ? "Development" : "Gratitudes",
                  journal: controller.developmentJournals[index],
                );
              },
            );
          },
        ),
        menuItem(
          title: 'Delete Entry',
          icon: Assets.imagesDeleteThisItem,
          borderColor: Colors.transparent,
          onTap: () {
            Navigator.of(context).pop();
            Get.dialog(
              MyDialog(
                icon: Assets.imagesDeleteThisItem,
                heading: 'Delete Development',
                content:
                    'Are you sure? The  item will be deleted. To revert changes click undo.',
                haveCustomActionButtons: true,
                customAction: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DialogActionButton(
                      text: 'Undo',
                      onTap: () => Get.back(),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    DialogActionButton(
                      text: 'Delete',
                      textColor: kRedColor,
                      onTap: () {
                        Get.back();
                        controller.deleteJournal(
                            controller.developmentJournals[index].sId ?? "",
                            "Development",
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

  final pageController = PageController();

  void _onNext() {
    pageController.nextPage(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _onBack() {
    pageController.previousPage(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return /*showEntryDetail
        ? pastEntryDetail()
        : showEditEntry
            ? editEntry()
            :*/
        Obx(() => controller.isLoadingJournals.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                children: [
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 50.0),
                        child: SearchBarDAR(
                          onClear: (){
                            controller.searchDevelopmentController.clear();
                            controller.isShowDevelopmentSearch.value = false;
                            controller.searchDevelopment("");
                          },
                          marginBottom: 0,
                          controller: controller.searchDevelopmentController,
                          onChanged: (v) {
                            controller.isShowDevelopmentSearch.value =
                                v.length > 0;
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              MainHeading(
                                                text: 'Sort by',
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              Obx(() => Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: List.generate(
                                                      controller.items.length,
                                                      (index) {
                                                        return CustomCheckBoxTile(
                                                          title: controller
                                                              .items[index],
                                                          isSelected: controller
                                                                      .items[
                                                                  index] ==
                                                              controller
                                                                  .developmentFilter
                                                                  .value,
                                                          onSelect: () {
                                                            controller
                                                                    .developmentFilter
                                                                    .value =
                                                                controller
                                                                        .items[
                                                                    index];
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
                                              ? EdgeInsets.fromLTRB(
                                                  15, 10, 15, 30)
                                              : EdgeInsets.fromLTRB(
                                                  15, 10, 15, 15),
                                          child: MyButton(
                                            height: 56,
                                            radius: 8,
                                            isDisable: false,
                                            text: 'Confirm',
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
                  if (controller.isShowDevelopmentSearch.value == true)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MainHeading(
                          text: 'Search Results',
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
                                onLongPress: () =>
                                    _showContextMenu(context, index),
                                child: PastEntryWidget(
                                  title: controller.developmentJournals[index]
                                          .description ??
                                      "",
                                  time: DateUtility.formatDateForJournal(
                                      controller.developmentJournals[index]
                                              .date ??
                                          ""),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  else
                    FixedTimeline.tileBuilder(
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
                            onTap: () {
                              // setState(() {
                              //   showEntryDetail = true;
                              // });
                            },
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
                        indicatorBuilder: (context, index) {
                          return TimeLineIndicator(
                            color: hexToColor(
                                controller.developmentJournals[index].color ??
                                    ""),
                          );
                        },
                        // indicatorPositionBuilder: (context, index) {
                        //   return index == 0 ? 0.0 : 0.2;
                        // },
                        startConnectorBuilder: (_, index) =>
                            Connector.solidLine(
                          color: kBorderColor,
                          thickness: 4.0,
                        ),
                        endConnectorBuilder: (_, index) => Connector.solidLine(
                          color: kBorderColor,
                          thickness: 4.0,
                        ),
                      ),
                    ),
                ],
              ));
  }

  Widget pastEntryDetail() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RotatedBox(
                    quarterTurns: 2,
                    child: GestureDetector(
                      onTap: () => _onBack(),
                      child: Image.asset(
                        Assets.imagesArrowNext,
                        height: 24,
                        color: kDarkBlueColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          height: Get.height,
                          width: Get.width,
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: Color(0xffE2E8F0),
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: BouncingScrollPhysics(),
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        MyText(
                                          text: 'Charlie’s Birth',
                                          size: 16,
                                          weight: FontWeight.w500,
                                        ),
                                        MyText(
                                          text: 'October 27, 2008',
                                          size: 11,
                                          paddingTop: 4,
                                          color: kDarkBlueColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // setState(() {
                                      //   showEditEntry = true;
                                      //   showEntryDetail = false;
                                      // });
                                    },
                                    child: Image.asset(
                                      Assets.imagesEditItem,
                                      height: 16,
                                      color: Color(0xff7B8794),
                                    ),
                                  ),
                                ],
                              ),
                              MyText(
                                paddingTop: 6,
                                paddingBottom: 16,
                                text:
                                    'Lorem ipsum dolor sit amet consectetur. Euismod sollicitudin nisl metus auctor diam. Orci habitant gravida elit quis. Elit in lobortis quis ut sit. Amet duis laoreet egestas amet. Nunc mattis vel nam morbi. Bibendum porta fringilla mi vitae a.\nLorem ipsum dolor sit amet consectetur. Euismod sollicitudin nisl metus auctor diam. Orci habitant gravida elit quis. Elit in lobortis quis ut sit. Amet duis laoreet egestas amet.',
                                size: 12,
                                height: 1.8,
                                color: Color(0xff323F4B),
                              ),
                              CommonImageView(
                                height: 150,
                                width: Get.width,
                                radius: 8.0,
                                url: dummyImg3,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _onNext(),
                    child: Image.asset(
                      Assets.imagesArrowNext,
                      height: 24,
                      color: kDarkBlueColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(15),
          child: MyButton(
            text: 'Return',
            onTap: () {
              // setState(() {
              //   showEntryDetail = false;
              // });
            },
          ),
        ),
      ],
    );
  }
}
