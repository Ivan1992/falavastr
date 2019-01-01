import 'package:falavastr/calendar/DayText.dart';
import 'package:falavastr/drawer.dart';
import 'package:falavastr/pages/calendarPage.dart';
import 'package:falavastr/pages/ustav.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/* class InfoPage extends StatefulWidget {
  final DateTime today;

  InfoPage({this.today});

  @override
  State<StatefulWidget> createState() => InfoPageState();
} */

class InfoPage extends StatelessWidget {
  final DateTime today;

  InfoPage({this.today}) {
    initializeDateFormatting("ru");
  }

  Widget _button(String title, BuildContext context, [TEXTTYPE type=TEXTTYPE.SVYATCY]) {
    return Center(
      child: RaisedButton(
        padding: EdgeInsets.all(25.0),
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: BorderSide(color: Colors.redAccent, width: 2.0),
        ),
        onPressed: () async {
          DayText d = await DayTextService.getDayText(today, type);
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

  @override
  Widget build(BuildContext context) {
    String _month = DateFormat("MMMM", "ru").format(today);
    String _weekday = DateFormat("EEEE", "ru").format(today);
    String _name = DateFormat("MEd", "ru").format(today);
    List<Widget> _buttons = List()
      ..add(_button("Святцы", context, TEXTTYPE.SVYATCY))
      ..add(_button("Евангелие", context))
      ..add(_button("Апостол", context))
      ..add(_button("Минея", context, TEXTTYPE.MINEA))
      ..add(_button("Октай", context));

    return Scaffold(
      drawer: DrawerOnly(),
      appBar: AppBar(
        title: Text("Дата: $_name"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return CalendarPage(today);
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
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text("Глас шестыи"),
              Text("пища с рыбой"),
            ],
          ),
          ),
          Expanded(
            child: GridView.extent(
              maxCrossAxisExtent: 150.0,
              children: _buttons,
            ),
          )
        ],
      ),
    );
  }
}
