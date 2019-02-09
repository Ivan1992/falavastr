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

class InfoPage extends StatefulWidget {
  final DateTime today;

  InfoPage({this.today}) {
    initializeDateFormatting("ru");
  }

  @override
  State<StatefulWidget> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> with TickerProviderStateMixin {
  bool _newStyle = true;
  AnimationController controller;
  Animation animation;
  Animation curve;

  String _month;
  String _weekday;
  String _name;
  String _glas;
  DateTime today;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    curve = CurvedAnimation(parent: controller, curve: Curves.easeOut);

    today =
        _newStyle ? widget.today : widget.today.subtract(Duration(days: 13));
    _month = DateFormat("MMMM", "ru").format(today);
    _name = DateFormat("dd.MM.yyyy", "ru").format(today);
    _weekday = DateFormat("EEEE", "ru").format(widget.today);
    _glas = DateService.glasString(widget.today);

    animation = IntTween(begin: 0, end: today.day).animate(curve);
    controller.forward();
  }

  Widget _card(DayText d) {
    List<Widget> _options = [];
    Widget toReturn;
    if (d.sluzhby[0].parts.length > 1) {
      var parts = d.sluzhby[0].parts;
      for (var i = 0; i < parts.length; i++) {
        _options.add(Container(
            height: 40.0,
            padding: EdgeInsets.symmetric(vertical: 0.5),
            child: SizedBox.expand(
              child: OutlineButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctxt) => UstavPage(d.title, d, i),
                    ),
                  );
                },
                child: Padding(
                    padding: EdgeInsets.only(bottom: 0.0),
                    child: Text(parts[i].name)),
              ),
            )));
      }
      toReturn = Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: Card(
          child: ExpansionTile(
            title: Hero(
              tag: d.title,
              child: Material(
                color: Colors.transparent,
                child: Text(d.title),
              ),
            ),
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
            title: Hero(
              tag: d.title,
              child: Material(
                color: Colors.transparent,
                child: Text(d.title),
              ),
            ),
          ),
        ),
      );
    }
    return toReturn;
  }

  @override
  Widget build(BuildContext context) {
    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);
    appBloc.changeDate.add(widget.today);

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
            return AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, Widget child) {
                  return Column(
                    children: <Widget>[
                      Text(
                        animation.value.toString(),
                        textScaleFactor: 5.0,
                      ),
                      Text(_month, textScaleFactor: 2.0),
                      Text(_weekday, textScaleFactor: 2.0),
                      SmartSwitch(
                        onChange: (val) {
                          setState(() {
                            _newStyle = val;
                            _animate(val);
                          });
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text("Глас $_glas"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.info),
                                  onPressed: () {},
                                ),
                                Text("пища с рыбой"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: snapshot.hasData
                              ? snapshot.data.map((x) => _card(x)).toList()
                              : [Center(child: CircularProgressIndicator(),)],
                        ),
                      ),
                    ],
                  );
                });
          }),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _animate(bool val) {
    int begin, end;
    if (val) {
      begin = widget.today.subtract(Duration(days: 13)).day;
      end = widget.today.day;
      today = widget.today;
    } else {
      begin = widget.today.day;
      end = widget.today.subtract(Duration(days: 13)).day;
      today = widget.today.subtract(Duration(days: 13));
    }
    controller.reset();
    /* curve = CurvedAnimation(
                                parent: controller, curve: Curves.easeOut); */
    animation = IntTween(begin: begin, end: end).animate(curve);
    controller.forward();
    _month = DateFormat("MMMM", "ru").format(today);
    _name = DateFormat("dd.MM.yyyy", "ru").format(today);
  }
}
