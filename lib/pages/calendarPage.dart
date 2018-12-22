import 'package:falavastr/calendar/calendar_carousel.dart';
import 'package:falavastr/drawer.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CalendarPage();
}

class _CalendarPage extends State<CalendarPage> {

  DateTime _currentDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerOnly(),
      appBar: AppBar(
        title: Text("Календарь"),
      ),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: CalendarCarousel(
              onDayPressed: (DateTime date) {
                this.setState(() => _currentDate = date);
              },
              weekendTextStyle: TextStyle(
                color: Colors.red,
              ),
              locale: "ru",
              thisMonthDayBorderColor: Colors.grey,
              daysTextStyle: TextStyle(color: Colors.white),
              weekFormat: false,
              /* height: 420.0, */
              selectedDateTime: _currentDate,
              daysHaveCircularBorder: false,
              customGridViewPhysics: NeverScrollableScrollPhysics(),

              /// null for not rendering any border, true for circular border, false for rectangular border
            ),
          )),
    );
  }
}
