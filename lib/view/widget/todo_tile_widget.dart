import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/my_text.dart';

class TodoModel {
  TodoModel({
    required this.isCancelled,
    required this.todo,
  });

  bool isCancelled;
  String todo;
}

// ignore: must_be_immutable
class TodoTileWidget extends StatefulWidget {
  TodoTileWidget({
    Key? key,
    required this.time,
    required this.title,
    this.completedTime,
    required this.todos,
    required this.completedTodos,
  }) : super(key: key);

  final String title;

  final List<TodoModel> todos;
  final List<String> completedTodos;
  final String time;
  String? completedTime;

  @override
  State<TodoTileWidget> createState() => _TodoTileWidgetState();
}

class _TodoTileWidgetState extends State<TodoTileWidget> {
  void onChanged(int index) {
    var data = widget.todos[index];
    setState(() {
      data.isCancelled = !data.isCancelled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
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
              if (widget.completedTodos.isEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(
                    widget.todos.length,
                    (index) {
                      var data = widget.todos[index];
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
                                  text: data.todo,
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
                )
              else
                ...List.generate(
                  widget.completedTodos.length,
                  (index) {
                    return MyText(
                      paddingBottom: 4,
                      text: widget.completedTodos[index],
                      size: 12,
                      height: 1.8,
                    );
                  },
                ),
              MyText(
                paddingTop: 4,
                text: widget.time,
                size: 10,
                color: kDarkBlueColor,
              ),
            ],
          ),
        ),
        if (widget.completedTime!.isNotEmpty)
          Positioned(
            right: 12,
            top: -13,
            child: TimeChip(
              time: widget.completedTime!,
              clockColor: kMaroonColor,
            ),
          ),
      ],
    );
  }
}

class TimeChip extends StatelessWidget {
  const TimeChip({
    super.key,
    required this.time,
    required this.clockColor,
  });

  final String time;
  final Color clockColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 27,
      width: 89,
      decoration: BoxDecoration(
        color: Color(0xffF8F9F8),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 1.0,
          color: kBorderColor,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Assets.imagesClockFilled,
            height: 12,
            color: clockColor,
          ),
          MyText(
            paddingLeft: 4,
            paddingRight: 4,
            text: time,
            size: 12,
            color: kCoolGreyColor,
          ),
        ],
      ),
    );
  }
}
