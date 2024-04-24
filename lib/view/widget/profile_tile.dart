import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/archive_items/archive_items.dart';
import 'package:life_berg/view/screens/edit_goal/edit_goal.dart';
import 'package:life_berg/view/widget/common_image_view.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/custom_slider.dart';
import 'package:life_berg/view/widget/dialog_action_button.dart';
import 'package:life_berg/view/widget/menu_item.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';

// ignore: must_be_immutable
class ProfileTile extends StatefulWidget {
  ProfileTile({
    Key? key,
    this.title,
    this.leadingColor,
    this.haveCheckBox = false,
    this.checkBoxValue = false,
    this.haveSlider = false,
    this.leadingIcon,
    this.progress,
    this.onCheckBoxTap,
  }) : super(key: key);

  Color? leadingColor;
  String? title, leadingIcon;
  double? progress;
  bool? haveCheckBox, checkBoxValue, haveSlider;
  VoidCallback? onCheckBoxTap;

  @override
  State<ProfileTile> createState() => _ProfileTileState();
}

class _ProfileTileState extends State<ProfileTile> {
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
        maxWidth: 170,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      items: <PopupMenuItem>[
        menuItem(
          icon: Assets.imagesSkip,
          title: 'Skip goal',
          onTap: () {
            Get.back();
            Get.dialog(
              MyDialog(
                icon: Assets.imagesSkip,
                heading: 'Skip Goal',
                content:
                    'Selected goal will be skipped for today. To revert changes please click undo.',
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
                      text: 'Skip',
                      onTap: () => Get.back(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        menuItem(
          icon: Assets.imagesUnSkip,
          title: 'Restore goal',
          onTap: () {
            Get.back();
            Get.dialog(
              MyDialog(
                icon: Assets.imagesUnSkip,
                heading: 'Restore Goal',
                content:
                    'Selected goal will be restored. To skip it, please click undo',
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
                      text: 'Restore',
                      onTap: () => Get.back(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        menuItem(
          icon: Assets.imagesEditItem,
          title: 'Edit goal',
          onTap: () => Get.to(() => EditGoal()),
        ),
        menuItem(
          icon: Assets.imagesAchive,
          title: 'Archive goal',
          onTap: () => Get.dialog(
            MyDialog(
              icon: Assets.imagesArchive2,
              heading: 'Archive Goal',
              content: 'Selected goal will be archived and made inactive.',
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
                    text: 'Okay',
                    onTap: () {
                      Get.back();
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        menuItem(
          icon: Assets.imagesComment,
          title: 'Add comment',
          onTap: () {
            Get.back();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              builder: (_) {
                return AddComment();
              },
            );
          },
        ),
        menuItem(
          icon: Assets.imagesDeleteThisItem,
          title: 'Delete goal',
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
    return GestureDetector(
      onTapDown: (position) => {
        _getTapPosition(position),
      },
      onLongPress: () => _showContextMenu(context),
      child: Container(
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
              imagePath: widget.leadingIcon!,
              height: 24,
              width: 24,
              radius: 4.0,
            ),
            Expanded(
              child: MyText(
                text: widget.title,
                size: 14,
                color: kCoolGreyColor,
                paddingLeft: 8,
              ),
            ),
            widget.haveCheckBox!
                ? GestureDetector(
                    onTap: widget.onCheckBoxTap,
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: widget.checkBoxValue!
                            ? kTertiaryColor
                            : kUnSelectedColor,
                      ),
                      child: Icon(
                        Icons.check,
                        color: kPrimaryColor,
                        size: 11,
                      ),
                    ),
                  )
                : widget.haveSlider!
                    ? SizedBox(
                        width: 103,
                        child: CustomSlider(
                          value: widget.progress,
                          onChanged: (value) {},
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
  const AddComment({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: CustomBottomSheet(
        height: 300,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 6,
          ),
          child: MyTextField(
            fillColor: kInputFillColor,
            maxLines: 6,
            hint: 'Add a short comment to your selected item',
            marginBottom: 0.0,
          ),
        ),
        onTap: () {
          Get.dialog(
            MyDialog(
              icon: Assets.imagesComment,
              heading: 'Comment Added',
              content: 'Your comment has been added to the selected goal.',
              onOkay: () {
                Get.back();
                Navigator.pop(context);
              },
            ),
          );
        },
        buttonText: 'Submit',
        isButtonDisable: false,
      ),
    );
  }
}
