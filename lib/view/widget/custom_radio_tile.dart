import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/my_text.dart';

class CustomRadioTile extends StatelessWidget {
  const CustomRadioTile({
    Key? key,
    required this.title,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.all(2.0),
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                color: kBorderColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    height: Get.height,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: isSelected ? kTertiaryColor : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: MyText(
              paddingLeft: 10,
              text: title,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }
}
