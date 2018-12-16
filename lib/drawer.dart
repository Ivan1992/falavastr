import 'package:falavastr/complex_example.dart';
import 'package:falavastr/pages/calendar.dart';
import 'package:falavastr/pages/firstpage.dart';
import 'package:falavastr/pages/secondpage.dart';
import 'package:falavastr/pages/ustav.dart';
import 'package:flutter/material.dart';

class DrawerOnly extends StatelessWidget {
  final bool expanded;
  DrawerOnly([this.expanded = false]);

  ListTile _getTile(BuildContext ctxt, String name,
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
                builder: (ctxt) => UstavPage(name), fullscreenDialog: true));
      },
    );
  }

  @override
  Widget build(BuildContext ctxt) {
    const List<String> names = [
      "Святцы",
      "ТРОПАРИ",
      "ЕВАНГЕЛИЕ",
      "АПОСТОЛ",
      "МИНЕЯ",
      "ОКТАЙ",
      "ТРИОДЬ"
    ];
    List<Widget> sublist = names.map<ListTile>((name) {
      return _getTile(ctxt, name, Icon(Icons.subdirectory_arrow_right), 10.0);
    }).toList();

    return Drawer(
      child: ListView(
        /*  shrinkWrap: true, */
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            child: Container(
              child: Column(
                /* crossAxisAlignment: CrossAxisAlignment.center, */
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
                                    style:
                                        Theme.of(ctxt).primaryTextTheme.title),
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
              children: sublist),
          _getTile(ctxt, "Библиотека", Icon(Icons.stars)),
          _getTile(ctxt, "Ежедневные молитвы", Icon(Icons.calendar_today)),
          _getTile(ctxt, "Канонник", Icon(Icons.format_list_bulleted)),
          _getTile(ctxt, "О программе", Icon(Icons.info)),
        ],
      ),
    );
  }
}
