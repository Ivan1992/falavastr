import 'package:falavastr/bloc/application_bloc.dart';
import 'package:falavastr/bloc/bloc_provider.dart';
import 'package:falavastr/calendar/DateService.dart';
import 'package:falavastr/calendar/DayText.dart';
import 'package:falavastr/drawer.dart';
import 'package:falavastr/pages/calendarPage.dart';
import 'package:falavastr/pages/ustav.dart';
import 'package:falavastr/smartSwitch.dart';
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

  Widget _card(DayText d) {
    List<Widget> _options = [];
    Widget toReturn;
    if (d.sluzhby[0].parts.length > 1) {
      var parts = d.sluzhby[0].parts;
      for (var i = 0; i < parts.length; i++) {
        _options.add(Padding(
          padding: EdgeInsets.all(5.0),
          child: RaisedButton(
            onPressed: () async {
              /* DayText d2 = await DayTextService.getDayText(
                  widget.today.subtract(Duration(days: 13)), ); */
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctxt) => UstavPage(d.title, d, i),
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
            title: Text(d.title),
            children: _options,
          ),
        ),
      );
    } else {
      toReturn = Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: Card(
          child: ListTile(
            onTap: () {
              /* DayText d = await DayTextService.getDayText(
                  widget.today.subtract(Duration(days: 13)), type); */
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctxt) => UstavPage(d.title, d),
                ),
              );
            },
            title: Text(d.title),
          ),
        ),
      );
    }
    return toReturn;
  }

  @override
  Widget build(BuildContext context) {
    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);
    //appBloc.updateInfoPage.add(null);

    List<String> switchOptions = ["старый", "новый"];
    DateTime today =
        newStyle ? widget.today : widget.today.subtract(Duration(days: 13));
    String _month = DateFormat("MMMM", "ru").format(today);
    String _weekday = DateFormat("EEEE", "ru").format(widget.today);
    String _name = DateFormat("Md", "ru").format(today);
    String _glas = DateService.glasString(widget.today);

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
      body: StreamBuilder(
          stream: appBloc.outInfoPage,
          builder:
              (BuildContext context, AsyncSnapshot<List<DayText>> snapshot) {
            
            return Column(
              children: <Widget>[
                Text(
                  "${today.day}",
                  textScaleFactor: 6.0,
                ),
                Text(_month, textScaleFactor: 2.0),
                Text(_weekday, textScaleFactor: 2.0),
                SmartSwitch(),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text("Глас $_glas"),
                      Text("пища с рыбой"),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: snapshot.hasData //
                        ? (snapshot.data != null && snapshot.data.length > 0)
                            ? snapshot.data.map((x) => _card(x)).toList()
                            : [Text("Got 0 length data:${snapshot.toString()}")]
                        : [Text("loading...")],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
