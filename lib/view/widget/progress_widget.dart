import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

// ignore: must_be_immutable
class ProgressWidget extends StatelessWidget {
  ProgressWidget({
    Key? key,
    required this.currentStep,
    required this.selectedColor,
    required this.title,
  }) : super(key: key);

  final String title;
  final int currentStep;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: title,
            size: 14,
            paddingBottom: 8,
            weight: FontWeight.w500,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: StepProgressIndicator(
              totalSteps: 100,
              currentStep: currentStep,
              selectedSize: 5,
              size: 4,
              padding: 0,
              selectedColor: selectedColor,
              unselectedColor: kUnSelectedColor,
              roundedEdges: Radius.circular(50),
            ),
          ),
        ],
      ),
    );
  }
}