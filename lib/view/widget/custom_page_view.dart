import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/my_text.dart';

// ignore: must_be_immutable
class CustomPageView extends StatelessWidget {
  CustomPageView({
    Key? key,
    this.currentIndex = 0,
    this.onTap,
    this.expandIconOnTap,
    this.pages,
    this.pageController,
    this.onPageChanged,
    // this.controller
  }) : super(key: key);

  int? currentIndex;

  GestureTapCallback? expandIconOnTap;
  List<Widget>? pages = [];
  ValueChanged<int>? onPageChanged;
  void Function(int index)? onTap;

  PageController? pageController = PageController();

  // var controller;

  List<String> tabs = [
    '1 wk',
    '1 mo',
    '3 mo',
    '6 mo',
    '1 yr',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(),
              ...List.generate(
                  tabs.length,
                      (index) => GestureDetector(
                    onTap: () => onTap!(index),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          text: tabs[index],
                          size: 12,
                          paddingBottom: 4,
                        ),
                        Container(
                          height: 4,
                          width: 26,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: currentIndex == index
                                ? kDayStepColor
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  )),
              GestureDetector(
                onTap: expandIconOnTap,
                child: Image.asset(
                  Assets.imagesPointsAccuralClose,
                  height: 13,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 250,
          child: PageView.builder(
            itemCount: pages!.length,
            controller: pageController,
            onPageChanged: onPageChanged,
            itemBuilder: (ctx, index) => pages![index],
          ),
        ),
      ],
    );
  }
}