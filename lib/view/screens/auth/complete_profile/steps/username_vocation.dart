import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/utils/instance.dart';
import 'package:life_berg/view/widget/custom_drop_down.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class UserNameVocation extends StatelessWidget {
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
          Assets.imagesLogo,
          height: 80,
        ),
        MyText(
          paddingTop: 25,
          text: 'Welcome to LifeBerg!',
          size: 24,
          weight: FontWeight.w500,
          align: TextAlign.center,
        ),
        MyText(
          paddingTop: 6,
          text: 'Let’s set up your profile to get started.',
          size: 16,
          align: TextAlign.center,
          height: 1.5,
          paddingBottom: 20,
        ),
        MyTextField(
          hint: 'Username',
          controller: completeProfileController.userNameCon,
          fillColor: kSecondaryColor,
          textInputAction: TextInputAction.done,
        ),
        Obx(() {
          return CustomDropDown(
            buttonHeight: 56,
            selectedValue: completeProfileController.selectedVocation.value,
            hint: 'Select',
            onChanged: (value) => completeProfileController.getVocation(value),
            items: completeProfileController.vocationList,
          );
        }),
        SizedBox(
          height: 10,
        ),
        MyTextField(
          hint: 'Country',
          controller: completeProfileController.countryCon,
          fillColor: kSecondaryColor,
          textInputAction: TextInputAction.done,
        ),
        // SizedBox(
        //   height: 10,
        // ),
        // Obx(() {
        //   return SizedBox(
        //     child: completeProfileController.showOtherField.value
        //         ? MyTextField(
        //             hint: 'Please Specify',
        //           )
        //         : SizedBox(),
        //   );
        // }),
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
        // Center(
        //   child: SmoothPageIndicator(
        //     controller: completeProfileController.pageController,
        //     count: completeProfileController.profileSteps.length,
        //     effect: ExpandingDotsEffect(
        //       dotHeight: 8,
        //       dotWidth: 8,
        //       spacing: 5.0,
        //       activeDotColor: kTertiaryColor,
        //       dotColor: kTertiaryColor.withOpacity(0.2),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
