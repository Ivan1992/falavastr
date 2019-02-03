import 'package:falavastr/calendar/DateService.dart';
import 'package:falavastr/calendar/DayText.dart';
import 'package:falavastr/drawer.dart';
import 'package:falavastr/pages/calendarPage.dart';
import 'package:falavastr/pages/ustav.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Future;

/* class InfoPage extends StatefulWidget {
  final DateTime today;

  InfoPage({this.today});

  @override
  State<StatefulWidget> createState() => InfoPageState();
} */

class InfoPage extends StatefulWidget {
  final DateTime today;

  InfoPage({this.today}) {
    initializeDateFormatting("ru");
  }

  @override
  State<StatefulWidget> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  bool newStyle = true;

  Future<Widget> _card(String title, BuildContext context,
      [TEXTTYPE type = TEXTTYPE.SVYATCY]) async {
    DayText d = await DayTextService.getDayText(
        widget.today.subtract(Duration(days: 13)), type);
    List<Widget> _options = [];
    Widget toReturn;

    if (d.sluzhby[0].parts.length > 1) {
      var parts = d.sluzhby[0].parts;
      for (var i = 0; i < parts.length; i++) {
        _options.add(Padding(
          padding: EdgeInsets.all(5.0),
          child: RaisedButton(
            onPressed: () async {
              DayText d = await DayTextService.getDayText(
                  widget.today.subtract(Duration(days: 13)), type);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctxt) => UstavPage(title, d, i),
                ),
              );
            },
            child: Text(parts[i].name),
          ),
        ));
      }
      toReturn = Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: Card(
          child: ExpansionTile(
            title: Text(title),
            children: _options,
          ),
        ),
      );
    } else {
      toReturn = Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: Card(
          child: ListTile(
            onTap: () async {
              DayText d = await DayTextService.getDayText(
                  widget.today.subtract(Duration(days: 13)), type);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctxt) => UstavPage(title, d),
                ),
              );
            },
            title: Text(title),
          ),
        ),
      );
    }

    /* return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Card(
        child: ExpansionTile(
          title: Text(title),
          children: <Widget>[Text("one"), Text("two")],
        ),
      ),
    ); */
    return toReturn;
  }

  Widget _button(String title, BuildContext context,
      [TEXTTYPE type = TEXTTYPE.SVYATCY]) {
    return Center(
      child: RaisedButton(
        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: BorderSide(color: Colors.redAccent, width: 2.0),
        ),
        onPressed: () async {
          DayText d = await DayTextService.getDayText(
              widget.today.subtract(Duration(days: 13)), type);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctxt) => UstavPage(title, d),
                  fullscreenDialog: true));
        },
        child: Text(title),
      ),
    );
  }

  Future<List<Widget>> loadWidget(BuildContext context) async {
    List<Widget> _cards = List()
      ..add(await _card("Святцы", context, TEXTTYPE.SVYATCY))
      ..add(await _card("Евангелие", context))
      ..add(await _card("Минея", context, TEXTTYPE.MINEA))
      ..add(await _card("Октай", context, TEXTTYPE.OKTAY));

    return _cards;
  }

  @override
  Widget build(BuildContext context) {
    List<String> switchOptions = ["старый", "новый"];
    DateTime today =
        newStyle ? widget.today : widget.today.subtract(Duration(days: 13));
    String _month = DateFormat("MMMM", "ru").format(today);
    String _weekday = DateFormat("EEEE", "ru").format(widget.today);
    String _name = DateFormat("Md", "ru").format(today);

    String glas = DateService.glasString(widget.today);

    return FutureBuilder(
      future: loadWidget(context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Scaffold(
          drawer: DrawerOnly(),
          appBar: AppBar(
            title: Text("Дата: $_name"),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<Null>(builder: (BuildContext context) {
                      return CalendarPage(widget.today);
                    }),
                  );
                },
                icon: Icon(Icons.today),
              )
            ],
          ),
          body: Column(
            children: <Widget>[
              Text(
                "${today.day}",
                textScaleFactor: 6.0,
              ),
              Text(_month, textScaleFactor: 2.0),
              Text(_weekday, textScaleFactor: 2.0),
              SizedBox(
                width: 250.0,
                child: Switch(
                  value: false,
                  onChanged: (val) {
                    setState(() {
                      newStyle = val;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text("Глас $glas"),
                    Text("пища с рыбой"),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: snapshot.hasData ? snapshot.data : const <Widget>[],
                ),
              ),
              /* Expanded(
            child: GridView.extent(
              maxCrossAxisExtent: 250.0,
              children: _buttons,
            ),
          ), */
            ],
          ),
        );
      },
    );
  }
}
