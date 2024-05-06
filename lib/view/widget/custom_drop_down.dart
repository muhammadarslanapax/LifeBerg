import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/my_text.dart';

// ignore: must_be_immutable
class CustomDropDown extends StatelessWidget {
  CustomDropDown({
    required this.hint,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    this.buttonHeight,
  });

  final List<dynamic>? items;
  String? selectedValue;
  final ValueChanged<dynamic>? onChanged;
  String hint;
  double? buttonHeight;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        hint: MyText(
          text: hint,
          size: 15,
          weight: FontWeight.w400,
          color: kTextColor.withOpacity(0.50),
        ),
        items: items!
            .map(
              (item) => DropdownMenuItem<dynamic>(
                value: item,
                child: MyText(
                  text: item,
                  size: 14,
                ),
              ),
            )
            .toList(),
        value: selectedValue,
        onChanged: onChanged,
        icon: Image.asset(
          Assets.imagesDropDownIcon,
          height: 24,
        ),
        isDense: true,
        isExpanded: true,
        buttonHeight: buttonHeight ?? 47,
        buttonPadding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        buttonDecoration: BoxDecoration(
          border: Border.all(
            color: kBorderColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8),
          color: kSecondaryColor,
        ),
        buttonElevation: 0,
        itemHeight: 40,
        itemPadding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        dropdownMaxHeight: 200,
        dropdownWidth: Get.width * 0.92,
        dropdownPadding: null,
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: kSecondaryColor,
        ),
        dropdownElevation: 4,
        scrollbarRadius: const Radius.circular(40),
        scrollbarThickness: 6,
        scrollbarAlwaysShow: true,
        offset: const Offset(-2, -5),
      ),
    );
  }
}
