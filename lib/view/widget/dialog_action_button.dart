import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/my_text.dart';

class DialogActionButton extends StatelessWidget {
  DialogActionButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.textColor,
  }) : super(key: key);

  final String text;
  final VoidCallback onTap;
  Color? textColor;

  @override
  Widget build(BuildContext context) {
    return MyText(
      onTap: onTap,
      text: text,
      size: 13,
      weight: FontWeight.w500,
      color: textColor ??  kTertiaryColor,
    );
  }
}