import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/model/goal/goal.dart';
import 'package:life_berg/view/screens/settings/settings_screens/settings_controller.dart';
import 'package:life_berg/view/widget/common_image_view.dart';
import 'package:life_berg/view/widget/dialog_action_button.dart';
import 'package:life_berg/view/widget/menu_item.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/profile_heading.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

import '../../../constant/strings.dart';

class ArchiveItems extends StatefulWidget {
  @override
  State<ArchiveItems> createState() => _ArchiveItemsState();
}

class _ArchiveItemsState extends State<ArchiveItems> {
  final SettingsController settingsController = Get.put(SettingsController());

  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails tapPosition) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(tapPosition.globalPosition);
      print(_tapPosition);
    });
  }

  void _showContextMenu(
    BuildContext context,
    int index,
    String type,
    Goal goal,
  ) async {
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();
    final result = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 0, 0),
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
          icon: Assets.imagesHistory,
          title: 'Restore Goal',
          onTap: () {
            Get.back();
            Get.dialog(
              MyDialog(
                icon: Assets.imagesRestore,
                heading: 'Restore Goal',
                content:
                    'Selected goal will moved from archived goals to active goals. To revert changes click undo.',
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
                        text: 'Okay!',
                        textColor: kRedColor,
                        onTap: () {
                          Get.back();
                          settingsController.restoreGoal(goal, type, index);
                        }),
                  ],
                ),
              ),
            );
          },
        ),
        menuItem(
          icon: Assets.imagesDeleteThisItem,
          title: 'Delete Goal',
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
                        settingsController.deleteGoal(goal, type, index);
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
        title: 'Archive goals',
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(15),
        physics: BouncingScrollPhysics(),
        children: [
          Obx(() => settingsController.isLoadingGoals.value
              ? Container(
                  height: 500,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  children: [
                    _buildWellbeingList(),
                    _buildVocationList(),
                    _buildPersonalDevList(),
                  ],
                )),
          /*ProfileHeading(
            marginTop: 0,
            heading: 'Wellbeing',
            leadingColor: kStreaksColor,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(
              2,
              (index) {
                return GestureDetector(
                  onTapDown: (position) => {
                    _getTapPosition(position),
                  },
                  onLongPress: () => _showContextMenu(context),
                  child: ArchiveTile(
                    title: index == 0 ? '20 mins cardio' : 'Quiet Time',
                    leadingIcon: index == 0
                        ? Assets.imagesHeartRateNew
                        : Assets.imagesQuiteTimeIcon,
                  ),
                );
              },
            ),
          ),
          ProfileHeading(
            marginTop: 24,
            heading: 'Vocational',
            leadingColor: kCardio2Color,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(
              2,
              (index) {
                return GestureDetector(
                  onTapDown: (position) => {
                    _getTapPosition(position),
                  },
                  onLongPress: () => _showContextMenu(context),
                  child: ArchiveTile(
                    title: index == 0 ? 'OSCE practice' : 'Work productivity',
                    leadingIcon: index == 0
                        ? Assets.imagesOse
                        : Assets.imagesWorkProductivity,
                  ),
                );
              },
            ),
          ),
          ProfileHeading(
            marginTop: 24,
            heading: 'Personal Development',
            leadingColor: kDailyGratitudeColor,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(
              2,
              (index) {
                return GestureDetector(
                  onTapDown: (position) => {
                    _getTapPosition(position),
                  },
                  onLongPress: () => _showContextMenu(context),
                  child: ArchiveTile(
                    title: index == 0 ? 'Daily Gratitude' : 'Acts of Kindness',
                    leadingIcon: index == 0
                        ? Assets.imagesDailyGratitude
                        : Assets.imagesActOfKindness,
                  ),
                );
              },
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _buildPersonalDevList() {
    return Column(
      children: [
        Visibility(
          child: ProfileHeading(
            marginTop: 24,
            heading: personalDevelopment,
            leadingColor: kDailyGratitudeColor,
          ),
          visible: settingsController.isLoadingGoals.value == false &&
              settingsController.personalDevGoals.isNotEmpty,
        ),
        ListView.builder(
          itemBuilder: (BuildContext ctx, index) {
            return GestureDetector(
              onTapDown: (position) => {
                _getTapPosition(position),
              },
              onLongPress: () => _showContextMenu(
                  context,
                  index,
                  "personal_development",
                  settingsController.personalDevGoals[index]),
              child: ArchiveTile(
                imgBgColor: kDailyGratitudeBgColor,
                title: settingsController.personalDevGoals[index].name ?? "",
                leadingIcon:
                    "assets/goal_icons/${settingsController.personalDevGoals[index].icon}",
                color: kDailyGratitudeColor,
              ),
            );
          },
          itemCount: settingsController.personalDevGoals.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }

  Widget _buildWellbeingList() {
    return Column(
      children: [
        Visibility(
          visible: settingsController.isLoadingGoals.value == false &&
              settingsController.wellBeingGoals.isNotEmpty,
          child: ProfileHeading(
            marginTop: 24,
            heading: wellBeing,
            leadingColor: kStreaksColor,
          ),
        ),
        ListView.builder(
          itemBuilder: (BuildContext ctx, index) {
            return GestureDetector(
              onTapDown: (position) => {
                _getTapPosition(position),
              },
              onLongPress: () => _showContextMenu(context, index, "wellbeing",
                  settingsController.wellBeingGoals[index]),
              child: ArchiveTile(
                title: settingsController.wellBeingGoals[index].name ?? "",
                imgBgColor: kStreaksBgColor,
                leadingIcon:
                    "assets/goal_icons/${settingsController.wellBeingGoals[index].icon}",
                color: kStreaksColor,
              ),
            );
          },
          itemCount: settingsController.wellBeingGoals.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }

  Widget _buildVocationList() {
    return Column(
      children: [
        Visibility(
          visible: settingsController.isLoadingGoals.value == false &&
              settingsController.vocationalGoals.isNotEmpty,
          child: ProfileHeading(
            marginTop: 24,
            heading: vocational,
            leadingColor: kRACGPExamColor,
          ),
        ),
        ListView.builder(
          itemBuilder: (BuildContext ctx, index) {
            return GestureDetector(
              onTapDown: (position) => {
                _getTapPosition(position),
              },
              onLongPress: () => _showContextMenu(context, index, "vocation",
                  settingsController.vocationalGoals[index]),
              child: ArchiveTile(
                imgBgColor: kRACGPBGExamColor,
                title: settingsController.vocationalGoals[index].name ?? "",
                leadingIcon:
                    "assets/goal_icons/${settingsController.vocationalGoals[index].icon}",
                color: kRACGPExamColor,
              ),
            );
          },
          itemCount: settingsController.vocationalGoals.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class ArchiveTile extends StatelessWidget {
  ArchiveTile(
      {Key? key, this.title, this.leadingIcon, this.color, this.imgBgColor})
      : super(key: key);

  String? title, leadingIcon;
  Color? color;
  Color? imgBgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 8,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      // height: 40,
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
                color: imgBgColor,
                borderRadius: BorderRadius.all(Radius.circular(4))),
            padding: EdgeInsets.all(3.0),
            child: Image.asset(
              leadingIcon!,
              color: color,
            ),
          ),
          Expanded(
            child: MyText(
              text: title,
              size: 14,
              color: kCoolGreyColor,
              paddingLeft: 8,
            ),
          ),
          // Image.asset(
          //   Assets.imagesChecklist,
          //   height: 16,
          // ),
        ],
      ),
    );
  }
}
