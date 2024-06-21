import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/setup_goal/add_new_goal.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/custom_slider.dart';
import 'package:life_berg/view/widget/dialog_action_button.dart';
import 'package:life_berg/view/widget/menu_item.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';

import '../../constant/strings.dart';
import '../../controller/admin_controller/home_controller.dart';
import '../../model/goal/goal.dart';

// ignore: must_be_immutable
class HomeGoalTile extends StatefulWidget {
  HomeGoalTile({
    Key? key,
    this.title,
    this.leadingColor,
    this.haveCheckBox = false,
    this.checkBoxValue,
    this.haveSlider = false,
    this.leadingIcon,
    this.progress,
    this.onCheckBoxTap,
    this.imageBgColor,
    this.onProgressChange,
    this.goal,
    this.type,
    this.index,
  }) : super(key: key);

  Color? leadingColor;
  String? title, leadingIcon;
  RxDouble? progress;
  bool? haveCheckBox, haveSlider;
  RxBool? checkBoxValue = false.obs;
  VoidCallback? onCheckBoxTap;
  Color? imageBgColor;
  Function(double value)? onProgressChange;
  Goal? goal;
  String? type;
  int? index;

  @override
  State<HomeGoalTile> createState() => _HomeGoalTileState();
}

class _HomeGoalTileState extends State<HomeGoalTile> {
  final HomeController homeController = Get.find<HomeController>();

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
          -Get.height * 0.4,
          overlay!.paintBounds.size.width,
          overlay.paintBounds.size.height,
        ),
      ),
      elevation: 10,
      constraints: BoxConstraints(
        maxWidth: 180,
      ),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      items: <PopupMenuItem>[
        if (widget.goal!.isSkipped.value == false)
          menuItem(
            icon: Assets.imagesSkip,
            title: skipGoal,
            onTap: () {
              Navigator.of(context).pop();
              Get.dialog(
                MyDialog(
                  icon: Assets.imagesSkip,
                  heading: SKIPGOAL,
                  content: skipGoalDes,
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
                        text: skip,
                        textColor: kRedColor,
                        onTap: () {
                          Get.back();
                          widget.goal!.isSkipped.value = true;
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        if (widget.goal!.isSkipped.value == true)
          menuItem(
            icon: Assets.imagesUnSkip,
            title: restoreGoal,
            onTap: () {
              Navigator.of(context).pop();
              Get.dialog(
                MyDialog(
                  icon: Assets.imagesUnSkip,
                  heading: RESTOREGOAL,
                  content: restoreGoalDes,
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
                        text: restore,
                        textColor: kRedColor,
                        onTap: () {
                          Get.back();
                          widget.goal!.isSkipped.value = false;
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        menuItem(
            icon: Assets.imagesEditItem,
            title: editGoal,
            onTap: () {
              Navigator.of(context).pop();
              Get.to(() => AddNewGoal(), arguments: {
                "goal": widget.goal,
                "goalCategory": widget.goal?.category?.name,
                "goalName": widget.goal!.name,
                "isComingFromOnBoarding": false
              });
            }),
        menuItem(
            icon: Assets.imagesAchive,
            title: archiveGoal,
            onTap: () {
              Navigator.of(context).pop();
              Get.dialog(
                MyDialog(
                  icon: Assets.imagesArchive2,
                  heading: ARCHIVEGOAL,
                  content: archiveGoalDes,
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
                        text: okay,
                        textColor: kRedColor,
                        onTap: () {
                          Get.back();
                          Get.back();
                          homeController.archiveGoal(
                              widget.goal!, widget.type!, widget.index!);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
        menuItem(
          icon: Assets.imagesComment,
          title: addComment,
          onTap: () {
            Navigator.of(context).pop();
            homeController.goalCommentController.text =
                widget.goal!.comment ?? "";
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              builder: (_) {
                return AddComment(widget.goal!, widget.type!, widget.index!);
              },
            );
          },
        ),
        menuItem(
          icon: Assets.imagesDeleteThisItem,
          title: deleteGoal,
          borderColor: Colors.transparent,
          onTap: () {
            Navigator.of(context).pop();
            Get.dialog(
              MyDialog(
                icon: Assets.imagesDeleteThisItem,
                heading: DELETEGOAL,
                content: deleteGoalDes,
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
                        homeController.deleteGoal(
                            widget.goal!, widget.type!, widget.index!);
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
    return GestureDetector(
      onTapDown: (position) => {
        if (widget.type != "daily_highlight")
          {
            _getTapPosition(position),
          }
      },
      onLongPress: () {
        if (widget.type != "daily_highlight") {
          _showContextMenu(context);
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 8,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: kSecondaryColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: kBorderColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                  color: widget.imageBgColor,
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              padding: EdgeInsets.all(3.0),
              child: widget.type == "daily_highlight"
                  ? SvgPicture.asset(widget.leadingIcon!,
                      color: widget.leadingColor)
                  : Image.asset(
                      widget.leadingIcon!,
                      color: widget.leadingColor,
                    ),
            ),
            Expanded(
              child: MyText(
                text: widget.title,
                size: 16,
                color: kCoolGreyColor,
                paddingLeft: 8,
                paddingRight: 6,
                maxLines: 1,
              ),
            ),
            widget.haveCheckBox == true
                ? Obx(() => GestureDetector(
                      onTap: () {
                        if (widget.type == "daily_highlight") {
                          widget.onCheckBoxTap!();
                        } else {
                          if (widget.goal!.isSkipped.value == false) {
                            homeController.saveLocalData(widget.goal!,
                                !widget.checkBoxValue!.value, "0.0");
                            widget.onCheckBoxTap!();
                          }
                        }
                      },
                      child: Container(
                        height: 18,
                        width: 18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                              width: 1,
                              color: widget.type == "daily_highlight" &&
                                      widget.checkBoxValue!.value
                                  ? Colors.transparent
                                  : widget.type == "daily_highlight" &&
                                          widget.checkBoxValue!.value == false
                                      ? kBorderColor
                                      : widget.checkBoxValue!.value ||
                                              widget.goal!.isSkipped.value
                                          ? Colors.transparent
                                          : kBorderColor),
                          color: widget.goal != null &&
                                  widget.goal!.isSkipped.value
                              ? kUnSelectedColor
                              : widget.checkBoxValue!.value
                                  ? kTertiaryColor
                                  : Colors.white,
                        ),
                        child: widget.checkBoxValue!.value ||
                                (widget.goal != null &&
                                    widget.goal!.isSkipped.value)
                            ? Icon(
                                Icons.check,
                                color: kPrimaryColor,
                                size: 11,
                              )
                            : Container(),
                      ),
                    ))
                : widget.haveSlider == true
                    ? SizedBox(
                        width: 103,
                        height: 12,
                        child: CustomSlider(
                          value: widget.progress,
                          isSkipped: widget.goal!.isSkipped,
                          onChanged: (value) {
                            homeController.saveLocalData(widget.goal!,
                                !widget.checkBoxValue!.value, value.toString());
                            widget.onProgressChange!(value);
                          },
                        ),
                      )
                    : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class AddComment extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();
  final Goal goal;
  final String type;
  final int index;

  AddComment(
    this.goal,
    this.type,
    this.index, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: CustomBottomSheet(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 6,
          ),
          child: MyTextField(
            fillColor: Colors.white,
            maxLines: 1,
            controller: homeController.goalCommentController,
            hint: addCommentDes,
            marginBottom: 0.0,
          ),
        ),
        onTap: () {
          homeController.addCommentOnGoal(goal, type, index);
          Get.dialog(
            MyDialog(
              icon: Assets.imagesComment,
              heading: commentAdded,
              content: commentAddedDes,
              onOkay: () {
                Get.back();
                Navigator.pop(context);
              },
            ),
          );
        },
        buttonText: submit,
        isButtonDisable: false,
      ),
    );
  }
}
