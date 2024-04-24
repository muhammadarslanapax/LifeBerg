import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/constant/sizes_constant.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/common_image_view.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

class ChooseAvatar extends StatelessWidget {
  ChooseAvatar({Key? key}) : super(key: key);

  final List<String> avatars = [
    Assets.avatarA1,
    Assets.avatarA2,
    Assets.avatarA3,
    Assets.avatarA3,
    Assets.avatarA5,
    Assets.avatarA6,
    Assets.avatarA7,
    Assets.avatarA8,
    Assets.avatarA9,
    Assets.avatarA10,
    Assets.avatarA11,
    Assets.avatarA12,
    Assets.avatarA13,
    Assets.avatarA14,
    Assets.avatarA15,
    Assets.avatarA16,
    Assets.avatarA17,
    Assets.avatarA18,
    Assets.avatarA19,
    Assets.avatarA20,
    Assets.avatarA21,
    Assets.avatarA22,
    Assets.avatarA23,
    Assets.avatarA24,
    Assets.avatarA25,
    Assets.avatarA26,
    Assets.avatarA27,
    Assets.avatarA28,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Choose avatar',
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(15),
              itemCount: avatars.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 0,
                mainAxisSpacing: 10,
                mainAxisExtent: 120,
              ),
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    CommonImageView(
                      imagePath: avatars[index],
                      height: 100,
                      width: 120,
                      radius: 120.0,
                    ),
                    if (index == 0)
                      Positioned(
                        top: 8,
                        right: 12,
                        child: Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kTertiaryColor,
                          ),
                          child: Icon(
                            Icons.check,
                            color: kPrimaryColor,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: Platform.isIOS ? IOS_DEFAULT_MARGIN : EdgeInsets.all(15),
            child: MyButton(
              isDisable: false,
              text: 'Confirm',
              onTap: () => Get.back(),
            ),
          ),
        ],
      ),
    );
  }
}
