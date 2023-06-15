import 'package:ascoop/style.dart';
import 'package:ascoop/web_ui/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime initialDate;
  const CalendarWidget({required this.initialDate, super.key});

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      blackoutDates: blackList(initialDate),
      blackoutDatesTextStyle: const TextStyle(
          fontStyle: FontStyle.normal, fontSize: 13, color: Colors.grey),
      todayHighlightColor: Colors.transparent,
      todayTextStyle: const TextStyle(
          fontStyle: FontStyle.normal, fontSize: 13, color: Colors.black),
      backgroundColor: Colors.white54,
      selectionDecoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: teal8, width: 3),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        shape: BoxShape.rectangle,
      ),
      view: CalendarView.month,
      initialSelectedDate: initialDate,
      minDate: DateTime(initialDate.year, initialDate.month),
      maxDate: DateTime(initialDate.year, initialDate.month + 1),
      headerStyle: CalendarHeaderStyle(
          textAlign: TextAlign.center,
          backgroundColor: teal8,
          textStyle: TextStyle(
            color: Colors.white,
            fontFamily: FontNamedDef,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          )),
    );
  }

  List<DateTime> blackList(DateTime data) {
    List<DateTime> blackDates = [];

    var countDay = getDaysInMonth(data.year, data.month);

    for (var i = 0; i <= countDay; i++) {
      if (i != data.day) {
        blackDates.add(DateTime(data.year, data.month, i));
      }
    }
    return blackDates;
  }

  static int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }
    const List<int> daysInMonth = <int>[
      31,
      -1,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    print(daysInMonth[month - 1]);
    return daysInMonth[month - 1];
  }
}
