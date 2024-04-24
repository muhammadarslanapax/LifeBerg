import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/custom_check_box_tile.dart';
import 'package:life_berg/view/widget/my_text.dart';

// ignore: must_be_immutable
class NoteTileWidget extends StatefulWidget {
  final String title;
  final String time;
  final List<NoteModel> notes;

  const NoteTileWidget({
    super.key,
    required this.title,
    required this.time,
    required this.notes,
  });

  @override
  State<NoteTileWidget> createState() => _NoteTileWidgetState();
}

class _NoteTileWidgetState extends State<NoteTileWidget> {


  void onChanged(int index) {
    var data = widget.notes[index];
    setState(() {
      data.isNoteCancelled = !data.isNoteCancelled;
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
          MyText(
            text: widget.title,
            paddingBottom: 10,
            size: 16,
            weight: FontWeight.w500,
          ),
          if (widget.notes.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                widget.notes.length,
                (index) {
                  var data = widget.notes[index];
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
                                color: data.isNoteCancelled
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
                              decoration: data.isNoteCancelled
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

class NoteModel {
  NoteModel({
    required this.isNoteCancelled,
    required this.note,
  });

  bool isNoteCancelled;
  String note;
}
