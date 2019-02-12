import 'package:falavastr/bloc/application_bloc.dart';
import 'package:falavastr/bloc/bloc_provider.dart';
import 'package:falavastr/calendar/calendar_carousel.dart';
import 'package:falavastr/drawer.dart';
import 'package:falavastr/pages/infopage.dart';
import 'package:falavastr/smartSwitch.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  final DateTime selected;

  CalendarPage([this.selected]);

  @override
  State<StatefulWidget> createState() => _CalendarPage();
}

class _CalendarPage extends State<CalendarPage> {
  DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _currentDate = widget.selected ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);

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
                width: 400.0,//MediaQuery.of(context).size.width-32,
                height: 420.0,
                child: CalendarCarousel(
                  onDayPressed: (DateTime date) {
                    appBloc.changeDate.add(date);
                    Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                        return InfoPage(today: date);
                      }),
                    );
                    //this.setState(() => _currentDate = date);
                  },
                  weekendTextStyle: TextStyle(
                    color: Colors.red,
                  ),
                  locale: "ru",
                  thisMonthDayBorderColor: Colors.grey,
                  daysTextStyle: TextStyle(color: Colors.white),
                  weekFormat: false,
                  selectedDateTime: _currentDate,
                  daysHaveCircularBorder: false,
                  customGridViewPhysics: NeverScrollableScrollPhysics(),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: SmartSwitch(
                    onChange: (val) {},
                  ),
                ),
              )
            ],
          ),)
        ],
      ),
    );
  }
}
