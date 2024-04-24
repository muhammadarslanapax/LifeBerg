import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/my_text.dart';

// ignore: must_be_immutable
class MyTextField extends StatefulWidget {
  MyTextField({
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
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.marginBottom!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.haveLabel!
              ? MyText(
                  text: widget.label,
                  size: widget.labelSize ?? 12,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                )
              : SizedBox(),
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            onTap: widget.onTap,
            readOnly: widget.isReadOnly!,
            maxLines: widget.maxLines,
            controller: widget.controller,
            onChanged: widget.onChanged,
            // textInputAction: TextInputAction.next,
            obscureText: widget.isObSecure!,
            obscuringCharacter: '*',
            style: TextStyle(
              fontSize: 14,
              color: kTextColor,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: widget.maxLines! > 1 ? 15 : 0,
              ),
              filled: true,
              fillColor: widget.fillColor ?? kSecondaryColor,
              hintText: widget.hint,
              hintStyle: TextStyle(
                fontSize: 14,
                color: widget.hintColor ?? kTextColor.withOpacity(0.50),
              ),
              suffixIcon: widget.haveObSecureIcon!
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() {
                            widget.isObSecure = !widget.isObSecure!;
                          }),
                          child: Image.asset(
                            Assets.imagesVisibilityIcon,
                            height: 16,
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: widget.borderColor ?? kBorderColor,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: widget.borderColor ?? kBorderColor,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
