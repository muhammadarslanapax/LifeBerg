import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
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
import 'package:life_berg/view/widget/time_line_indicator.dart';
import 'package:life_berg/view/widget/todo_tile_widget.dart';
import 'package:timelines/timelines.dart';

class Todo extends StatefulWidget {
  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
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
          title: 'Edit item',
          onTap: () {
            showModalBottomSheet(
              context: context,
              elevation: 0,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (_) {
                return EditToDo();
              },
            );
          },
        ),
        menuItem(
          icon: Assets.imagesDeleteThisItem,
          title: 'Delete Item',
          borderColor: Colors.transparent,
          onTap: () {
            Get.dialog(
              MyDialog(
                icon: Assets.imagesDeleteThisItem,
                heading: 'Delete Item',
                content: 'Are you sure? The selected item will be deleted. ',
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
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(15),
      children: [
        FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            connectorTheme: ConnectorThemeData(
              color: kTextColor,
              thickness: 1.0,
            ),
          ),
          builder: TimelineTileBuilder(
            itemCount: 10,
            contentsBuilder: (_, index) {
              return GestureDetector(
                onTapDown: (position) => {
                  _getTapPosition(position),
                },
                onLongPress: () => _showContextMenu(context),
                child: TodoTileWidget(
                  title: 'Things to look up',
                  completedTime: index == 2 ? '3 hrs ago' : '',
                  time: 'October 27, 2008',
                  todos: [
                    TodoModel(
                      todo: 'Gastric outlet obstruction (GOO)',
                      isCancelled: false,
                    ),
                    TodoModel(
                      todo: 'Insulin infusion protocol',
                      isCancelled: false,
                    ),
                  ],
                  completedTodos: index == 3
                      ? [
                          'Chase up latest PET scan',
                          'Discuss next steps - conservative vs radical',
                          'NDIS forms require faxing',
                        ]
                      : [],
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
            startConnectorBuilder: (_, index) => Connector.solidLine(
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
    );
  }
}

class EditToDo extends StatefulWidget {
  EditToDo({
    Key? key,
  }) : super(key: key);

  @override
  State<EditToDo> createState() => _EditToDoState();
}

class _EditToDoState extends State<EditToDo> {
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
      height: Get.height * 0.83,
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
       Navigator.pop(context);
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
