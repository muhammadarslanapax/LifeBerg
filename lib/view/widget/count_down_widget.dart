// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class CountDownWidget extends StatelessWidget {
  int? currentStep;
  Color? color;
  String? text, label;
  bool? haveNotificationBell;

  CountDownWidget({
    Key? key,
    this.currentStep,
    this.color,
    this.text,
    this.label,
    this.haveNotificationBell = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20, top: 30),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 3,
                child: Container(
                  height: 2.0,
                  color: Color(0xffDCEAF2),
                ),
              ),
              Flexible(
                flex: 4,
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: kSecondaryColor,
                    border: Border.all(
                      width: 1.0,
                      color: Color(0xffE9E9E8),
                    ),
                  ),
                  child: Center(
                    child: CircularStepProgressIndicator(
                      totalSteps: 100,
                      currentStep: currentStep ?? 74,
                      // stepSize: 5,
                      selectedStepSize: 10,
                      padding: 0,
                      width: 100,
                      height: 100,
                      roundedCap: (_, __) => true,
                      selectedColor: color,
                      unselectedColor: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color!.withOpacity(0.1),
                        ),
                        child: Center(
                          child: MyText(
                            text: text,
                            size: 12,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    if (haveNotificationBell!)
                      Padding(
                        padding: EdgeInsets.only(left: 24.75),
                        child: Image.asset(
                          Assets.imagesNotificationBell,
                          height: 24,
                          color: kDarkBlueColor,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: -24,
            child: MyText(
              text: label,
              size: 16,
              weight: FontWeight.w400,
              paddingTop: 4,
              align: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
