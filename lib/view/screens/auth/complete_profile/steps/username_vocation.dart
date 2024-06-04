import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/controller/auth_controller/complete_profile_controller.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/utils/instance.dart';
import 'package:life_berg/view/widget/custom_drop_down.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class UserNameVocation extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final CompleteProfileController controller  = Get.find<CompleteProfileController>();
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
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
          controller: controller.userNameCon,
          textInputType: TextInputType.text,
          fillColor: kSecondaryColor,
          onChanged: (text) => controller.validateUsernameVocation(),
          textInputAction: TextInputAction.done,
        ),
        Obx(() {
          return CustomDropDown(
            buttonHeight: 56,
            selectedValue: controller.selectedVocation.value,
            hint: 'Select',
            onChanged: (value) => controller.getVocation(value),
            items: controller.vocationList,
          );
        }),
        SizedBox(
          height: 10,
        ),
        MyTextField(
          hint: 'Country',
          onTap: (){
            showCountryPicker(
              context: context,
              showPhoneCode: true,
              onSelect: (Country country) {
                controller.countryCon.text = country.name;
                controller.validateUsernameVocation();
              },
            );
          },
          isReadOnly: true,
          controller: controller.countryCon,
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
            controller.profileSteps.length,
            (index) {
              return Obx(() {
                return AnimatedContainer(
                  margin: EdgeInsets.symmetric(horizontal: 2.5),
                  duration: Duration(
                    milliseconds: 250,
                  ),
                  curve: Curves.easeInOut,
                  height: 8,
                  width: controller.currentIndex.value == index ? 22: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: controller.currentIndex.value == index
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
