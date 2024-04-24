import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/my_text.dart';

class BigPictureTile extends StatefulWidget {
  BigPictureTile({
    Key? key,
    required this.title,
    required this.time,
  }) : super(key: key);
  final List<BigPictureModel> title;
  final String time;

  @override
  State<BigPictureTile> createState() => _BigPictureTileState();
}

class _BigPictureTileState extends State<BigPictureTile> {
  void onChanged(int index) {
    var data = widget.title[index];
    setState(() {
      data.isCancelled = !data.isCancelled;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 4,
        bottom: 8,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: kSecondaryColor,
        border: Border.all(
          width: 1.0,
          color: kBorderColor,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 1,),
          if (widget.title.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                widget.title.length,
                    (index) {
                  var data = widget.title[index];
                  return IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => onChanged(index),
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: data.isCancelled
                                    ? kTertiaryColor
                                    : kUnSelectedColor,
                              ),
                              child: Icon(
                                Icons.check,
                                color: kPrimaryColor,
                                size: 11,
                              ),
                            ),
                          ),
                          Expanded(
                            child: MyText(
                              paddingLeft: 8,
                              text: data.note,
                              size: 12,
                              decoration: data.isCancelled
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          MyText(
            paddingTop: 4,
            text: widget.time,
            size: 10,
            color: kDarkBlueColor,
          ),
        ],
      ),
    );
  }
}

class BigPictureModel {
  BigPictureModel({
    required this.isCancelled,
    required this.note,
  });

  bool isCancelled;
  String note;
}
