import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/constant/sizes_constant.dart';
import 'package:life_berg/controller/admin_controller/home_controller.dart';
import 'package:life_berg/controller/auth_controller/goal_controller.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/common_image_view.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

class ChooseAvatar extends StatelessWidget {
  ChooseAvatar({Key? key}) : super(key: key);

  final HomeController homeController = Get.find<HomeController>();

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
              itemCount: homeController.avatars.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 0,
                mainAxisSpacing: 10,
                mainAxisExtent: 120,
              ),
              itemBuilder: (context, index) {
                return Obx(() => Stack(
                  children: [
                    GestureDetector(
                      onTap: (){
                        homeController.selectedAvatar.value= homeController.avatars[index];
                      },
                      child: CommonImageView(
                        imagePath: homeController.avatars[index],
                        height: 100,
                        width: 120,
                        radius: 120.0,
                      ),
                    ),
                    if(homeController.avatars[index] == homeController.selectedAvatar.value)
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
                ));
              },
            ),
          ),
          Padding(
            padding: Platform.isIOS ? IOS_DEFAULT_MARGIN : EdgeInsets.all(15),
            child: MyButton(
              isDisable: false,
              text: 'Confirm',
              onTap: () {
                if(homeController.selectedAvatar.value.isNotEmpty) {
                  homeController.updateImageFromAsset();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
