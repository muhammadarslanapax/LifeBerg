import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/image_dialog.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';

class AddNewTab extends StatelessWidget {
  AddNewTab({
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: CustomBottomSheet(
        height: 270,
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 6, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MainHeading(
                text: 'Add a new tab',
                paddingBottom: 10,
              ),
              MyTextField(
                hint: 'Title',
                marginBottom: 16,
              ),
              // MyText(
              //   text: 'Colour on timeline',
              //   size: 20,
              //   weight: FontWeight.w500,
              //   paddingBottom: 15,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   // alignment: WrapAlignment.spaceBetween,
              //   // runSpacing: 15,
              //   // spacing: 15,
              //   children: [
              //     for (int i = 0; i < 8; i++)
              //       Container(
              //         height: 24,
              //         width: 24,
              //         decoration: BoxDecoration(
              //           color: colors[i],
              //           borderRadius: BorderRadius.circular(8.0),
              //         ),
              //       ),
              //   ],
              // ),
              // SizedBox(
              //   height: 15,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   // alignment: WrapAlignment.spaceBetween,
              //   // runSpacing: 15,
              //   // spacing: 15,
              //   children: [
              //     for (var element in colors.skip(8))
              //       Container(
              //         height: 24,
              //         width: 24,
              //         decoration: BoxDecoration(
              //           color: element,
              //           borderRadius: BorderRadius.circular(8.0),
              //         ),
              //       ),
              //   ],
              // ),
            ],
          ),
        ),
        onTap: () {
          Get.dialog(
            ImageDialog(
              heading: 'New Tab Added',
              content: 'Your list is ready to go!',
              image: Assets.imagesNewTabAdded,
              imagePaddingBottom: 15.0,
              imageSize: 80,
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
