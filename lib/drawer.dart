import 'package:falavastr/calendar/DateService.dart';
import 'package:falavastr/calendar/DayText.dart';
import 'package:falavastr/pages/calendarPage.dart';
import 'package:falavastr/pages/canonPage.dart';
import 'package:falavastr/pages/ustav.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';

import 'package:intl/intl.dart';

class DrawerOnly extends StatelessWidget {
  final bool expanded;
  final DateTime _today = DateTime.now();

  DrawerOnly([this.expanded = false]) {
    initializeDateFormatting("ru");
  }

  ListTile _getDummy(BuildContext ctxt, String name,
      [Icon icon = const Icon(Icons.bookmark), double padding = 0.0, DayText d]) {
    return ListTile(
      leading: icon,
      title: Padding(
        padding: EdgeInsets.only(left: padding),
        child: Text(
          name,
          style: TextStyle(color: Theme.of(ctxt).primaryTextTheme.title.color),
        ),
      ),
      onTap: () {
        Navigator.push(
          ctxt,
          MaterialPageRoute(
            builder: (ctxt) => CanonPage(),
          ),
        );
      },
    );
  }

  ListTile _getTile(BuildContext ctxt, String name, DayText day,
      [Icon icon = const Icon(Icons.bookmark), double padding = 0.0]) {
    return ListTile(
      leading: icon,
      title: Padding(
        padding: EdgeInsets.only(left: padding),
        child: Text(
          name,
          style: TextStyle(color: Theme.of(ctxt).primaryTextTheme.title.color),
        ),
      ),
      onTap: () {
        Navigator.pop(ctxt);
        Navigator.push(
            ctxt,
            MaterialPageRoute(
                builder: (ctxt) => UstavPage(name, day),
                fullscreenDialog: true));
      },
    );
  }

  Future<List<ListTile>> getAllTiles(BuildContext ctxt) async {
    DayText day = await DayTextService.getDayText(_today, TEXTTYPE.MINEA);

    const List<String> names = [
      "СВЯТЦЫ",
      "МИНЕЯ",
      "ОКТАЙ",
    ];

    List<ListTile> sublist = names.map((name) {
      return _getTile(
          ctxt, name, day, Icon(Icons.subdirectory_arrow_right), 10.0);
    }).toList();

    return sublist;
  }

  @override
  Widget build(BuildContext ctxt) {
    String _month = DateFormat("MMMM", "ru").format(_today);
    String _weekday = DateFormat("EEEE", "ru").format(_today);
    String _glas = DateService.glasString(_today);

    return FutureBuilder(
      future: getAllTiles(ctxt),
      builder: (BuildContext ctxt, AsyncSnapshot<List<ListTile>> snapshot) {
        return Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.black),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                  decoration: ShapeDecoration(
                                    shape: const StadiumBorder(
                                      side: BorderSide(
                                        color: Colors.red,
                                        width: 3.0,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: Text("${_today.day}",
                                        style: Theme.of(ctxt)
                                            .primaryTextTheme
                                            .title),
                                  )),
                              Text(_month,
                                  style: Theme.of(ctxt).primaryTextTheme.title)
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text("Пища с маслом",
                                  style: TextStyle(color: Colors.white)),
                              /* RaisedButton(
                                onPressed: () {},
                                child: Text("Подробнее..."),
                              ), */
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[Text("$_weekday, глас $_glas")],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FloatingActionButton(
                            mini: true,
                            backgroundColor: Theme.of(ctxt).buttonColor,
                            onPressed: () {
                              Navigator.of(ctxt)
                                  .push(new MaterialPageRoute<Null>(
                                      builder: (BuildContext context) {
                                        return CalendarPage();
                                      },
                                      fullscreenDialog: true));
                            },
                            child: Icon(Icons.calendar_today),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              ExpansionTile(
                  initiallyExpanded: expanded,
                  leading: Icon(Icons.bookmark),
                  title: Text("Устав на сегодня",
                      style: TextStyle(
                          color: Theme.of(ctxt).primaryTextTheme.title.color)),
                  children: snapshot.data),
              _getDummy(ctxt, "Библиотека", Icon(Icons.stars)),
              _getDummy(ctxt, "Ежедневные молитвы", Icon(Icons.calendar_today)),
              _getDummy(ctxt, "Канонник", Icon(Icons.format_list_bulleted)),
              _getDummy(ctxt, "О программе", Icon(Icons.info)),
            ],
          ),
        );
      },
    );
  }
}
