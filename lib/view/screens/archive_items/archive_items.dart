import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/common_image_view.dart';
import 'package:life_berg/view/widget/dialog_action_button.dart';
import 'package:life_berg/view/widget/menu_item.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/profile_heading.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

class ArchiveItems extends StatefulWidget {
  @override
  State<ArchiveItems> createState() => _ArchiveItemsState();
}

class _ArchiveItemsState extends State<ArchiveItems> {
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
                      textColor: kRedColor,
                      onTap: () => Get.back(),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    DialogActionButton(
                      text: 'Okay!',
                      onTap: () => Get.back(),
                    ),
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
            Get.back();
            Get.dialog(
              MyDialog(
                icon: Assets.imagesDeleteThisItem,
                heading: 'Delete Goal',
                content:
                    'Are you sure? The selected goal will be deleted. To revert changes click undo.',
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
      backgroundColor: kSecondaryColor,
      appBar: simpleAppBar(
        title: 'Archive goals',
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(15),
        physics: BouncingScrollPhysics(),
        children: [
          ProfileHeading(
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
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ArchiveTile extends StatelessWidget {
  ArchiveTile({
    Key? key,
    this.title,
    this.leadingIcon,
  }) : super(key: key);

  String? title, leadingIcon;

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
          CommonImageView(
            imagePath: leadingIcon!,
            height: 24,
            width: 24,
            radius: 4.0,
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
