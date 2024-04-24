import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/my_text_field.dart';

class AddGratitude extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        elevation: 1,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Image.asset(
                Assets.imagesClear,
                height: 20,
              ),
            ),
          ],
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Image.asset(
                    Assets.imagesArrowForward,
                    height: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: MyTextField(
                  maxLines: 10,
                  hint: 'Reflect away...',
                  borderColor: Colors.transparent,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    height: 30,
                    width: Get.width,
                    color: kSecondaryColor,
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 16,
                      children: [
                        Image.asset(
                          Assets.imagesGrin,
                          height: 16,
                          color: kTextColor.withOpacity(0.5),
                        ),
                        Image.asset(
                          Assets.imagesBold,
                          height: 22,
                          color: kTextColor.withOpacity(0.5),
                        ),
                        Image.asset(
                          Assets.imagesItalic,
                          height: 20,
                          color: kTextColor.withOpacity(0.5),
                        ),
                        Image.asset(
                          Assets.imagesListOlAlt,
                          height: 16,
                          color: kTextColor.withOpacity(0.5),
                        ),
                        Image.asset(
                          Assets.imagesListUl,
                          height: 22,
                          color: kTextColor.withOpacity(0.5),
                        ),
                        Image.asset(
                          Assets.imagesLink,
                          height: 16,
                          color: kTextColor.withOpacity(0.5),
                        ),
                        Image.asset(
                          Assets.imagesColor,
                          height: 16,
                          color: kTextColor.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  CustomField(),
                ],
              ),
            ],
          ),
          Positioned(
            right: 15,
            bottom: 100,
            child: Image.asset(
              Assets.imagesVoiceNote,
              height: 36,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomField extends StatefulWidget {
  CustomField({
    Key? key,
    this.controller,
    this.hint,
    this.label,
    this.onChanged,
    this.isObSecure = false,
    this.marginBottom = 10.0,
    this.maxLines = 1,
    this.hintColor,
    this.haveLabel = false,
    this.labelSize,
    this.haveObSecureIcon = false,
    this.fillColor,
    this.isReadOnly = false,
    this.onTap,
    this.borderColor,
  }) : super(key: key);
  String? label, hint;

  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  bool? isObSecure, haveLabel, haveObSecureIcon;
  double? marginBottom;
  int? maxLines;
  double? labelSize;
  Color? hintColor, fillColor, borderColor;
  bool? isReadOnly;
  VoidCallback? onTap;

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      onTap: widget.onTap,
      readOnly: widget.isReadOnly!,
      maxLines: widget.maxLines,
      controller: widget.controller,
      onChanged: widget.onChanged,
      textInputAction: TextInputAction.next,
      obscureText: widget.isObSecure!,
      obscuringCharacter: '*',
      style: TextStyle(
        fontSize: 16,
        color: kTextColor,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        filled: true,
        fillColor: kCoolGreyColor2,
        hintText: widget.hint,
        hintStyle: TextStyle(
          fontSize: 16,
          color: widget.hintColor ?? kTextColor.withOpacity(0.50),
        ),
        prefixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {},
              child: Image.asset(
                Assets.imagesPaperClip,
                height: 24,
              ),
            ),
          ],
        ),
        suffixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {},
              child: Image.asset(
                Assets.imagesMicGrey,
                height: 24,
              ),
            ),
          ],
        ),
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
}
