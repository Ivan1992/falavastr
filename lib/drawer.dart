import 'package:falavastr/calendar/DayText.dart';
import 'package:falavastr/pages/calendarPage.dart';
import 'package:falavastr/pages/ustav.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class DrawerOnly extends StatelessWidget {
  final bool expanded;
  DrawerOnly([this.expanded = false]);

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
    DayText day = await DayTextService.getText(
        DateTime(2018, DateTime.january, 1), TEXTTYPE.MINEA);

    const List<String> names = [
      "СВЯТЦЫ",
      "ЕВАНГЕЛИЕ",
      "АПОСТОЛ",
      "МИНЕЯ",
      "ОКТАЙ",
      "ТРИОДЬ"
    ];

    List<ListTile> sublist = names.map((name) {
      return _getTile(
          ctxt, name, day, Icon(Icons.subdirectory_arrow_right), 10.0);
    }).toList();

    return sublist;
  }

  @override
  Widget build(BuildContext ctxt) {
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
                                    child: Text("25",
                                        style: Theme.of(ctxt)
                                            .primaryTextTheme
                                            .title),
                                  )),
                              Text("декабря",
                                  style: Theme.of(ctxt).primaryTextTheme.title)
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text("Пища с маслом",
                                  style: TextStyle(color: Colors.white)),
                              RaisedButton(
                                onPressed: () {},
                                child: Text("Подробнее..."),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        /* crossAxisAlignment: CrossAxisAlignment.end, */
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[Text("Среда, глас вторыи")],
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
              /* _getTile(ctxt, "Библиотека", Icon(Icons.stars)),
              _getTile(ctxt, "Ежедневные молитвы", Icon(Icons.calendar_today)),
              _getTile(ctxt, "Канонник", Icon(Icons.format_list_bulleted)),
              _getTile(ctxt, "О программе", Icon(Icons.info)), */
            ],
          ),
        );
      },
    );
  }
}
