import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/utils/instance.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IceBerg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 30,
      ),
      children: [
        SizedBox(
          height: 30,
        ),
        Image.asset(
          Assets.imagesIceBag,
          height: 157,
        ),
        MyText(
          paddingTop: 25,
          text: 'Hello, ${completeProfileController.userNameCon.text.toString()}!',
          size: 24,
          weight: FontWeight.w500,
          align: TextAlign.center,
        ),
        MyText(
          paddingTop: 6,
          text: 'I will be your companion! Would you like to name me?',
          size: 16,
          align: TextAlign.center,
          height: 1.5,
          paddingBottom: 20,
        ),
        MyTextField(
          hint: 'Name your iceberg',
          textInputAction: TextInputAction.done,
          fillColor: kSecondaryColor,
          controller: completeProfileController.iceBergCon,
          onChanged: (value) => completeProfileController.getIceBerg(value),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            completeProfileController.profileSteps.length,
                (index) {
              return Obx(() {
                return AnimatedContainer(
                  margin: EdgeInsets.symmetric(horizontal: 2.5),
                  duration: Duration(
                    milliseconds: 250,
                  ),
                  curve: Curves.easeInOut,
                  height: 8,
                  width: completeProfileController.currentIndex.value == index ? 22: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: completeProfileController.currentIndex.value == index
                        ? kTertiaryColor
                        : kTertiaryColor.withOpacity(0.2),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }
}
