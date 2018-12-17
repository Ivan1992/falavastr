import 'package:falavastr/drawer.dart';
import 'package:falavastr/pages/calendarPage.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerOnly(),
      appBar: AppBar(
        title: Text("First page"),
      ),
      body: Center(
        child: RaisedButton(
            child: Text("Календарь"),
            onPressed: () {
              Navigator.of(context).push(
                new MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return CalendarPage();
                    },
                    fullscreenDialog: true),
              );
            }),
      ),
    );
  }
}
