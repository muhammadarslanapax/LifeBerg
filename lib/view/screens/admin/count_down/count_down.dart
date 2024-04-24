import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/admin/count_down/add_new_count_down.dart';
import 'package:life_berg/view/screens/admin/count_down/edit_count_down.dart';
import 'package:life_berg/view/widget/count_down_widget.dart';
import 'package:life_berg/view/widget/dialog_action_button.dart';
import 'package:life_berg/view/widget/menu_item.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';
import 'package:life_berg/view/widget/time_line_indicator.dart';
import 'package:timelines/timelines.dart';

// ignore: must_be_immutable
class CountDown extends StatefulWidget {
  CountDown({Key? key}) : super(key: key);

  @override
  State<CountDown> createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  List<Map<String, dynamic>> countDownData = [
    {
      'label': 'OSCE',
      'text': '42 Days',
      'color': kC13,
      'currentStep': 74,
    },
    {
      'label': 'Jay’s Tennis Finals',
      'text': '12 Hours',
      'color': kC10,
      'currentStep': 74,
    },
    {
      'label': 'Wedding',
      'text': '28 Days',
      'color': kDarkBlueColor,
      'currentStep': 74,
    },
    {
      'label': 'Meet Up',
      'text': '28 Days',
      'color': kC11,
      'currentStep': 74,
    },
    {
      'label': 'Deliver Client’s work',
      'text': '28 Days',
      'color': kC10,
      'currentStep': 74,
    },
    {
      'label': 'Cricket Match',
      'text': '2 Days',
      'color': kDarkBlueColor,
      'currentStep': 74,
    },
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
          title: 'Edit countdown',
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) {
                return EditCountDown();
              },
            );
          },
        ),
        menuItem(
          icon: Assets.imagesDeleteThisItem,
          title: 'Delete countdown',
          borderColor: Colors.transparent,
          onTap: () {
            Get.dialog(
              MyDialog(
                icon: Assets.imagesDeleteThisItem,
                heading: 'Delete Countdown',
                content:
                    'Are you sure? The selected countdown timer and its notifications will be deleted.',
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
                      width: 32,
                    ),
                    DialogActionButton(
                      text: 'Delete',
                      onTap: () {
                        Get.back();
                        Get.back();
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
    return Scaffold(
      backgroundColor: kSecondaryColor,
      appBar: simpleAppBar(
        title: 'Countdown',
        onBackTap: () => Navigator.pop(context),
      ),
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            physics: BouncingScrollPhysics(),
            children: [
              FixedTimeline.tileBuilder(
                theme: TimelineThemeData(
                  nodePosition: 0.0,
                  color: Colors.red,
                  connectorTheme: ConnectorThemeData(
                    color: kTextColor,
                    thickness: 1.0,
                  ),
                ),
                builder: TimelineTileBuilder(
                  itemCount: countDownData.length,
                  contentsBuilder: (_, index) {
                    return GestureDetector(
                      onTapDown: (position) => {
                        _getTapPosition(position),
                      },
                      onLongPress: () => _showContextMenu(context),
                      child: CountDownWidget(
                        color: countDownData[index]['color'],
                        text: countDownData[index]['text'],
                        currentStep: countDownData[index]['currentStep'],
                        label: countDownData[index]['label'],
                        haveNotificationBell: index.isEven,
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
                  indicatorPositionBuilder: (context, index) {
                    return 0.53;
                  },
                  contentsAlign: ContentsAlign.basic,
                  startConnectorBuilder: (_, index) => Connector.solidLine(
                    color: Color(0xffDCEAF2),
                    thickness: 2.0,
                  ),
                  endConnectorBuilder: (_, index) => Connector.solidLine(
                    color: Color(0xffDCEAF2),
                    thickness: 2.0,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 15,
            bottom: 15,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) {
                    return AddNewCountDownBottomSheet();
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
