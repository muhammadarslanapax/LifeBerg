import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/edit_goal/edit_goal.dart';
import 'package:life_berg/view/widget/add_goal_reminder.dart';
import 'package:life_berg/view/widget/add_reminder_widget.dart';
import 'package:life_berg/view/widget/choose_color.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/dialog_action_button.dart';
import 'package:life_berg/view/widget/due_date_and_time.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/menu_item.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

class Notifications extends StatefulWidget {
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final List<String> days = [
    'S',
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
  ];

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
          icon: Assets.imagesEditItem,
          title: 'Edit notification',
          onTap: () {
            showModalBottomSheet(
              context: context,
              elevation: 0,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (_) {
                return EditItem();
              },
            );
          },
        ),
        menuItem(
          icon: Assets.imagesDeleteThisItem,
          title: 'Delete notification',
          borderColor: Colors.transparent,
          onTap: () {
            Get.dialog(
              MyDialog(
                icon: Assets.imagesDeleteThisItem,
                heading: 'Delete Notification',
                content: 'Are you sure?  The selected item will be deleted.',
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
      backgroundColor: kCoolGreyColor3,
      appBar: simpleAppBar(
        title: 'Notifications',
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 16,
        ),
        physics: BouncingScrollPhysics(),
        children: [
          MainHeading(
            paddingLeft: 2,
            paddingBottom: 12,
            text: 'Daily LifeBerg Check-in',
          ),
          Row(
            children: List.generate(
              days.length,
              (index) {
                return weekDaysToggleButton(
                  onTap: () {},
                  isSelected: index == 2 || index == 4 ? true : false,
                  weekDay: days[index],
                );
              },
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: (){
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    isScrollControlled: true,
                    builder: (_) {
                      return ChangeTime();
                    },
                  );
                },
                child: Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(
                    bottom: 8,
                  ),
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      width: 1.0,
                      color: kBorderColor,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      Assets.imagesBellWithDot,
                      height: 24,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 7,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 40,
                  margin: EdgeInsets.only(
                    bottom: 8,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      width: 1.0,
                      color: kBorderColor,
                    ),
                  ),
                  child: MyText(
                    text: '10:00 PM',
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 2),
            physics: BouncingScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTapDown: (position) => {
                  _getTapPosition(position),
                },
                onLongPress: () => _showContextMenu(context),
                child: NotificationTiles(
                  title: index == 0 ? 'Goals' : 'Life Administration',
                  notificationCount: 3,
                  notificationText: 'LifeBerg Check-in',
                  time: '2:30 PM',
                  onTap: () {},
                  clockColor: index == 0 ? kBlueColor : kMaroonColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget weekDaysToggleButton({
    String? weekDay,
    VoidCallback? onTap,
    bool? isSelected,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 3,
        ),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected! ? kDarkBlueColor : kSecondaryColor,
          border: Border.all(
            width: 1.0,
            color: kBorderColor,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: isSelected
                ? kPrimaryColor.withOpacity(0.1)
                : kTextColor.withOpacity(0.1),
            highlightColor: isSelected
                ? kPrimaryColor.withOpacity(0.1)
                : kTextColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(7),
            child: Center(
              child: MyText(
                text: weekDay,
                size: 14,
                color: isSelected ? kPrimaryColor : kTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class NotificationTiles extends StatelessWidget {
  NotificationTiles({
    Key? key,
    required this.title,
    required this.notificationText,
    required this.time,
    required this.onTap,
    required this.notificationCount,
    required this.clockColor,
  }) : super(key: key);

  final String title, notificationText, time;
  final int notificationCount;
  final VoidCallback onTap;
  final Color clockColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MainHeading(
          paddingTop: 10,
          paddingBottom: 8,
          text: title,
        ),
        Column(
          children: List.generate(
            notificationCount,
            (index) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      height: 40,
                      margin: EdgeInsets.only(
                        bottom: 8,
                      ),
                      decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          width: 1.0,
                          color: kBorderColor,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              Assets.imagesContactUs,
                              height: 20,
                            ),
                            Expanded(
                              child: MyText(
                                paddingLeft: 10,
                                text: notificationText,
                                size: 14,
                              ),
                            ),
                            SizedBox(
                              width: 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 12,
                    top: -13,
                    child: Container(
                      height: 27,
                      width: 89,
                      decoration: BoxDecoration(
                        color: Color(0xffF8F9F8),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          width: 1.0,
                          color: kBorderColor,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Assets.imagesClockFilled,
                            height: 12,
                            color: clockColor,
                          ),
                          MyText(
                            paddingLeft: 4,
                            paddingRight: 4,
                            text: time,
                            size: 12,
                            color: kCoolGreyColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}


class ChangeTime extends StatelessWidget {
  const ChangeTime({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      height: Get.height * 0.38,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(0, 6, 0, 15),
              children: [
                hourMinute12HCustomStyle(),
              ],
            ),
          ),
        ],
      ),
      onTap: () => Get.back(),
      buttonText: 'Confirm',
      isButtonDisable: false,
    );
  }
}


class EditItem extends StatefulWidget {
  EditItem({
    Key? key,
  }) : super(key: key);

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
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

  int colorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      height: Get.height * 0.8,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 6, 15, 15),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          children: [
            MainHeading(
              text: 'Edit item',
              paddingBottom: 10,
            ),
            MyTextField(
              hint: 'Lee’s Surprise Birthday Party',
            ),
            MyTextField(
              hint:
              'Bec - finalise date for venue booking\nVera - confirm catering numbers\nOrder cake - black forest\nAsk about dietary requirements\nGuest list finalised',
              maxLines: 6,
              marginBottom: 16,
            ),

            Row(
              children: [
                MainHeading(
                  text: 'Due date & time',
                  paddingRight: 32.0,
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      isScrollControlled: true,
                      builder: (_) {
                        return DueDateAndTime();
                      },
                    );
                  },
                  child: Image.asset(
                    Assets.imagesCalender,
                    height: 24,
                    color: kDarkBlueColor,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            // MyText(
            //   paddingTop: 8,
            //   text: '*Use calendar Icon to select date and time',
            //   size: 12,
            // ),
            MyTextField(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  isScrollControlled: true,
                  builder: (_) {
                    return DueDateAndTime();
                  },
                );
              },
              isReadOnly: true,
              hint: '23/03/2023 @ 8:30pm',
              marginBottom: 16.0,
            ),
            Row(
              children: [
                MainHeading(
                  text: 'Add a reminder',
                  paddingRight: 40.0,
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      builder: (_) {
                        return AddReminderWithCheckBoxTile();
                      },
                    );
                  },
                  child: Image.asset(
                    Assets.imagesReminderBell,
                    height: 24,
                    color: kDarkBlueColor,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            MyTextField(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  builder: (_) {
                    return AddReminderWithCheckBoxTile();
                  },
                );
              },
              isReadOnly: true,
              hint: '10 minutes before',
              marginBottom: 0.0,
            ),
            // MyText(
            //   paddingTop: 8,
            //   text: '*Use Bell Icon to add a reminder',
            //   size: 12,
            // ),
            SizedBox(
              height: 28.0,
            ),
            MainHeading(
              text: 'Colour on timeline',
              paddingBottom: 12,
            ),
            ChooseColor(
              colors: colors,
              colorIndex: colorIndex,
            ),
          ],
        ),
      ),
      onTap: () {
        Get.back();
        // Get.dialog(
        //   MyDialog(
        //     heading: 'Admin task',
        //     content: 'Your new admin task has been created.',
        //     onOkay: () => Get.back(),
        //   ),
        // );
      },
      buttonText: 'Confirm',
      isButtonDisable: false,
    );
  }
}