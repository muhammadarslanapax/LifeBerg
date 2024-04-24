import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:life_berg/constant/color.dart';
import 'package:table_calendar/table_calendar.dart';

class MyCalender extends StatefulWidget {
  @override
  State<MyCalender> createState() => _MyCalenderState();
}

class _MyCalenderState extends State<MyCalender> {
  TextStyle _calendarTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: 'Ubuntu',
    color: kTextColor,
  );
  TextStyle _disableTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: 'Ubuntu',
    color: Colors.transparent,
  );
  TextStyle _todayTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: 'Ubuntu',
    color: kSecondaryColor,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
        headerStyle: HeaderStyle(
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: kTextColor,
          ),
          titleCentered: true,
          formatButtonVisible: false,
          leftChevronMargin: EdgeInsets.zero,
          rightChevronMargin: EdgeInsets.zero,
        ),
        calendarStyle: CalendarStyle(
          cellAlignment: Alignment.center,
          markerMargin: EdgeInsets.zero,
          cellPadding: EdgeInsets.zero,
          cellMargin: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: 15,
          ),
          holidayTextStyle: _calendarTextStyle,
          defaultTextStyle: _calendarTextStyle,
          disabledTextStyle: _calendarTextStyle,
          outsideTextStyle: _disableTextStyle,
          selectedTextStyle: _calendarTextStyle,
          rangeEndTextStyle: _calendarTextStyle,
          rangeStartTextStyle: _calendarTextStyle,
          todayTextStyle: _todayTextStyle,
          weekendTextStyle: _calendarTextStyle,
          weekNumberTextStyle: _calendarTextStyle,
          withinRangeTextStyle: _calendarTextStyle,
          todayDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: kDarkBlueColor,
          ),
          tablePadding: EdgeInsets.zero,
        ),
        // calendarFormat: _calendarFormat,
        // onFormatChanged: (format) {
        //   setState(() {
        //     _calendarFormat = format;
        //   });
        // },
        // selectedDayPredicate: (day) {
        //   return day.isUtc;
        // },
        // onDaySelected: (selectedDay, focusedDay) {},
      ),
    );
  }
}
