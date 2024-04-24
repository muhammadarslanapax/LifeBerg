import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/my_text.dart';

class ToggleButton extends StatelessWidget {
  ToggleButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.isSelected,
    this.onLongPress,
    this.horizontalPadding,
  });

  final String text;
  final VoidCallback onTap;
  final bool isSelected;
  GestureLongPressCallback? onLongPress;
  double? horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: isSelected ? kTertiaryColor : kSecondaryColor,
          border: Border.all(
            width: 1.0,
            color: isSelected ? kTertiaryColor : kBorderColor,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding ?? 16,
              vertical: 10,
            ),
            child: InkWell(
              onTap: onTap,
              splashColor: kTextColor.withOpacity(0.03),
              highlightColor: kTextColor.withOpacity(0.03),
              borderRadius: BorderRadius.circular(8.0),
              child: MyText(
                onTap: onTap,
                text: text,
                size: 12,
                weight: FontWeight.w400,
                align: TextAlign.center,
                color: isSelected ? kSecondaryColor : kTextColor,
                maxLines: 1,
                overFlow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
