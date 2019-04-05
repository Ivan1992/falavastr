import 'package:falavastr/bloc/application_bloc.dart';
import 'package:falavastr/bloc/bloc_provider.dart';
import 'package:falavastr/calendar/DateService.dart';
import 'package:falavastr/calendar/Event.dart';
import 'package:falavastr/calendar/calendar_carousel.dart';
import 'package:falavastr/drawer.dart';
import 'package:falavastr/pages/infopage.dart';
import 'package:falavastr/smartSwitch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  final DateTime selected;

  CalendarPage([this.selected]);

  @override
  State<StatefulWidget> createState() => _CalendarPage();
}

class _CalendarPage extends State<CalendarPage> {
  DateTime _currentDate = DateTime.now();
  List<Event> _prazdniki;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.selected ?? DateTime.now();
    _prazdniki = DateService.getPrazdniki(_currentDate);
    _prazdniki.sort((one, two) => one.getDate(_currentDate.year).day - two.getDate(_currentDate.year).day);
  }

  @override
  Widget build(BuildContext context) {
    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);

    return StreamBuilder(
      stream: appBloc.outNewStyle,
      builder: (BuildContext builder, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return Scaffold(
          drawer: DrawerOnly(),
          appBar: AppBar(
            title: Text("Календарь"),
          ),
          body: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 400.0, //MediaQuery.of(context).size.width-32,
                    height: 450.0,
                    child: CalendarCarousel(
                      onDayPressed: (DateTime date) {
                        appBloc.changeDate.add(date);
                        Navigator.of(context).push(
                          MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                            return InfoPage(today: date);
                          }),
                        );
                        //this.setState(() => _currentDate = date);
                      },
                      weekendTextStyle: TextStyle(
                        color: Colors.red,
                      ),
                      dayPadding: 0.0,
                      locale: "ru",
                      thisMonthDayBorderColor: Colors.grey,
                      daysTextStyle: TextStyle(color: Colors.white),
                      weekFormat: false,
                      selectedDateTime: _currentDate,
                      daysHaveCircularBorder: false,
                      customGridViewPhysics: NeverScrollableScrollPhysics(),
                      todayBorderColor: Colors.transparent,
                      onMonthChanged: (month) {
                        // if (month == _currentDate.month) return;
                        DateTime d = DateTime(_currentDate.year, month);
                        setState(() {
                          _prazdniki = DateService.getPrazdniki(d);
                          _prazdniki.sort((one, two) => one.getDate(_currentDate.year).day - two.getDate(_currentDate.year).day);
                        });
                      },
                    ),
                  ),
                ],
              ),
              /* Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: SmartSwitch(
                          onChange: (val) {
                            setState(() {
                              appBloc.inNewStyle.add(val);
                              //_newStyle = val;
                              _currentDate = val
                                  ? _currentDate.add(Duration(days: 13))
                                  : _currentDate.subtract(Duration(days: 13));
                            });
                          },
                          beginState: snapshot.data,
                        ),
                      ),
                    )
                  ],
                ),
              ), */
              Container(
                height: 250.0,
                child: ListView(
                  padding: EdgeInsets.only(top: 10.0),
                  physics: BouncingScrollPhysics(),
                  children: _prazdniki
                      .map((event) => ListTile(
                            leading: Text(
                              event.getDate(_currentDate.year).day.toString(),
                              //DateFormat.MEd().format(event.getDate(_currentDate.year)),
                              style: TextStyle(color: Colors.red[900]),
                            ),
                            title: Text(event.name),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
