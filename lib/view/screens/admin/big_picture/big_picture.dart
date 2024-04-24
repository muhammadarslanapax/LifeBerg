import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/big_picture.dart';
import 'package:life_berg/view/widget/choose_color.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/custom_drop_down.dart';
import 'package:life_berg/view/widget/dialog_action_button.dart';
import 'package:life_berg/view/widget/image_dialog.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/menu_item.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';
import 'package:life_berg/view/widget/time_line_indicator.dart';
import 'package:timelines/timelines.dart';

class BigPicture extends StatefulWidget {
  @override
  State<BigPicture> createState() => _BigPictureState();
}

class _BigPictureState extends State<BigPicture> {
  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails tapPosition) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(tapPosition.globalPosition);
      print(_tapPosition);
    });
  }

  void _showContextMenu(BuildContext context) async {
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();
    final result = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 100, 100),
        Rect.fromLTWH(
          0,
          0,
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
          icon: Assets.imagesRoundedTick,
          title: 'Mark as complete',
          onTap: () {},
        ),
        menuItem(
          icon: Assets.imagesEditItem,
          title: 'Edit goals',
          onTap: () {
            showModalBottomSheet(
              context: context,
              elevation: 0,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (_) {
                return EditGoal();
              },
            );
          },
        ),
        menuItem(
          icon: Assets.imagesDeleteThisItem,
          title: 'Delete Goals',
          borderColor: Colors.transparent,
          onTap: () {
            Get.dialog(
              MyDialog(
                icon: Assets.imagesDeleteThisItem,
                heading: 'Delete Goals',
                content: 'Are you sure? The selected goals will be deleted.',
                haveCustomActionButtons: true,
                customAction: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DialogActionButton(
                      text: 'Undo',
                      textColor: kRedColor,
                      onTap: () => Get.back(),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    DialogActionButton(
                      text: 'Delete',
                      onTap: () => Get.back(),
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
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Big Picture',
        onBackTap: () => Navigator.pop(context),
      ),
      body: Stack(
        children: [
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
            physics: BouncingScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, ix) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MyText(
                    paddingTop: 15,
                    text: ix == 0
                        ? 'Goals for today'
                        : ix == 1
                            ? 'Goals for this week'
                            : ix == 2
                                ? 'Goals for this month'
                                : ix == 3
                                    ? 'Goals for this year'
                                    : 'Goals beyond this year',
                    size: 16,
                    weight: FontWeight.w500,
                    paddingBottom: 16,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (context, i) {
                      return FixedTimeline.tileBuilder(
                        theme: TimelineThemeData(
                          nodePosition: 0,
                          connectorTheme: ConnectorThemeData(
                            color: kTextColor,
                            thickness: 1.0,
                          ),
                        ),
                        builder: TimelineTileBuilder(
                          itemCount: 3,
                          contentsBuilder: (_, ti) {
                            return GestureDetector(
                              onTapDown: (position) => {
                                _getTapPosition(position),
                              },
                              onLongPress: () => _showContextMenu(context),
                              child: BigPictureTile(
                                time: 'October 27, 2008',
                                title: [
                                  BigPictureModel(
                                    isCancelled: false,
                                    note: 'Gastric outlet obstruction (GOO)',
                                  ),
                                  BigPictureModel(
                                    isCancelled: false,
                                    note: 'Insulin infusion protocol',
                                  ),
                                ],
                              ),
                            );
                          },
                          indicatorBuilder: (context, index) {
                            return TimeLineIndicator(
                              color: index == 0
                                  ? kNavyBlueColor
                                  : index == 1
                                      ? kDarkBlueColor
                                      : index == 2
                                          ? kCardio2Color
                                          : kStreaksColor,
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
                          endConnectorBuilder: (_, index) =>
                              Connector.solidLine(
                            color: kBorderColor,
                            thickness: 4.0,
                          ),
                        ),
                      );
                    },
                  )
                ],
              );
            },
          ),
          Positioned(
            right: 15,
            bottom: 15,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  builder: (_) {
                    return AddNewGoal();
                  },
                );
              },
              child: Image.asset(
                Assets.imagesAddButton,
                height: 44,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddNewGoal extends StatefulWidget {
  AddNewGoal({
    Key? key,
  }) : super(key: key);

  @override
  State<AddNewGoal> createState() => _AddNewGoalState();
}

class _AddNewGoalState extends State<AddNewGoal> {
  final List<Color> colors = [
    kC1,
    kC2,
    kC3,
    kC4,
    kC5,
    kC6,
    kC7,
    kC8,
    kC9,
    kC10,
    kC11,
    kC12,
    kC13,
    kQuiteTimeColor,
    kDarkBlueColor,
    kC16,
  ];

  int colorIndex = 10;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: CustomBottomSheet(
        height: Get.height * 0.51,
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 15),
          children: [
            MainHeading(
              text: 'Add a new goal',
              paddingBottom: 10,
            ),
            MyTextField(
              hint: 'Title',
              marginBottom: 10.0,
            ),
            CustomDropDown(
              hint: 'Select timeframe for goal',
              items: [
                'Today',
                'This week',
                'This month',
                'This year',
                'Beyond this year',
              ],
              onChanged: (v) {},
            ),
            MainHeading(
              paddingTop: 16,
              text: 'Colour on timeline',
              paddingBottom: 12,
            ),
            ChooseColor(
              colors: colors,
              colorIndex: colorIndex,
            ),
          ],
        ),
        onTap: () {
          Get.dialog(
            ImageDialog(
              heading: 'Goal Created',
              content:
                  'Great work! You’ve taken the first leap to achieving your goal!',
              imageSize: 85.0,
              imagePaddingBottom: 8,
              image: Assets.imagesGoalCreatedHoriz,
              onOkay: () {
                Get.back();
                Navigator.pop(context);
              },
            ),
          );
        },
        buttonText: 'Confirm',
        isButtonDisable: false,
      ),
    );
  }
}

class EditGoal extends StatelessWidget {
  EditGoal({
    Key? key,
  }) : super(key: key);

  final List<Color> colors = [
    kC1,
    kC2,
    kC3,
    kC4,
    kC5,
    kC6,
    kC7,
    kC8,
    kC9,
    kC10,
    kC11,
    kC12,
    kC13,
    kQuiteTimeColor,
    kDarkBlueColor,
    kC16,
  ];

  int colorIndex = 10;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: CustomBottomSheet(
        height: Get.height * 0.54,
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(15, 6, 15, 15),
          children: [
            MainHeading(
              text: 'Edit goal',
              paddingBottom: 10,
            ),
            MyTextField(
              hint: 'Buy Joe’s gift\nApply for leave\nOrganise picnic',
              maxLines: 3,
              marginBottom: 10,
            ),
            CustomDropDown(
              hint: 'Select timeframe for goal',
              items: [
                'Today',
                'This week',
                'This month',
                'This year',
                'Beyond this year',
              ],
              onChanged: (v) {},
            ),
            MainHeading(
              paddingTop: 16,
              text: 'Colour on timeline',
              paddingBottom: 12,
            ),
            ChooseColor(
              colors: colors,
              colorIndex: colorIndex,
            ),
          ],
        ),
        onTap: () {
          Get.dialog(
            ImageDialog(
              heading: 'Goal Created',
              content:
                  'Great work! You’ve taken the first leap to achieving your goal!',
              imageSize: 85.0,
              imagePaddingBottom: 8,
              image: Assets.imagesGoalCreatedHoriz,
              onOkay: () {
                Get.back();
                Navigator.pop(context);
              },
            ),
          );
        },
        buttonText: 'Confirm',
        isButtonDisable: false,
      ),
    );
  }
}
