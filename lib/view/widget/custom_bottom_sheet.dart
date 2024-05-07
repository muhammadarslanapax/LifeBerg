import 'dart:io';
import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/my_button.dart';

// ignore: must_be_immutable
class CustomBottomSheet extends StatelessWidget {
  CustomBottomSheet({
    Key? key,
    required this.child,
    required this.onTap,
    required this.buttonText,
    required this.isButtonDisable,
    this.height,
  }) : super(key: key);
  final Widget child;
  final VoidCallback onTap;
  final String buttonText;
  final bool isButtonDisable;
  double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 460,
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Image.asset(
              Assets.imagesBottomSheetHandle,
              height: 8,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: child,
          ),
          Padding(
            padding: Platform.isIOS
                ? EdgeInsets.fromLTRB(15, 10, 15, 30)
                : EdgeInsets.fromLTRB(15, 10, 15, 15),
            child: MyButton(
              height: 56,
              radius: 16,
              isDisable: isButtonDisable,
              text: buttonText,
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }
}
