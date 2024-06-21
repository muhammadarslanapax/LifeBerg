import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/my_text.dart';

class CustomCheckBoxTile extends StatelessWidget {
  const CustomCheckBoxTile({
    Key? key,
    required this.title,
    required this.onSelect,
    required this.isSelected,
  }) : super(key: key);

  final String title;
  final Function onSelect;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10,
      ),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: kSecondaryColor,
        border: Border.all(
          width: 1.0,
          color: kBorderColor,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){
            onSelect();
          },
          borderRadius: BorderRadius.circular(8.0),
          splashColor: kTertiaryColor.withOpacity(0.1),
          highlightColor: kTertiaryColor.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: MyText(
                    text: title,
                    size: 14,
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    onSelect();
                  },
                  child: Container(
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                      border: Border.all(color: isSelected ?
                      Colors.transparent
                          : kBorderColor),
                      borderRadius: BorderRadius.circular(5.0),
                      color: isSelected ? kTertiaryColor : Colors.transparent,
                    ),
                    child: Icon(
                      Icons.check,
                      color: isSelected ? kPrimaryColor : Colors.transparent,
                      size: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
