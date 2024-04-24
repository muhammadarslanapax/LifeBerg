// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';

// ignore: must_be_immutable
class SearchBarDAR extends StatelessWidget {
  SearchBarDAR({
    Key? key,
    this.controller,
    this.onChanged,
    this.marginBottom = 10.0,
    this.onTap,
    this.isReadOnly = false,
    this.onClear,
  }) : super(key: key);

  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  double? marginBottom;
  VoidCallback? onTap;
  bool? isReadOnly;
  VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom!),
      child: TextFormField(
        readOnly: isReadOnly!,
        onTap: onTap,
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.next,
        style: TextStyle(
          fontSize: 16,
          color: kTextColor,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          filled: true,
          fillColor: kSecondaryColor,
          hintText: 'Search',
          hintStyle: TextStyle(
            fontSize: 16,
            color: kTextColor.withOpacity(0.50),
          ),
          prefixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Assets.imagesSearch,
                height: 16,
              ),
            ],
          ),
          suffix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: GestureDetector(
                  onTap: onClear,
                  child: Image.asset(
                    Assets.imagesClear,
                    height: 16,
                  ),
                ),
              ),
            ],
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: kBorderColor,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: kBorderColor,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
