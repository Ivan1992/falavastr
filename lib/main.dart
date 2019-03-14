import 'package:falavastr/bloc/application_bloc.dart';
import 'package:falavastr/bloc/bloc_provider.dart';
import 'package:falavastr/pages/calendarPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.brown[200]//Color(0xFFb97b50),
    ));
    return MaterialApp(
      title: 'Алавастр',
      theme: ThemeData(
        fontFamily: "Balkara",
        primarySwatch: Colors.blue,
        backgroundColor: Colors.teal,//Color(0xFF36332e),
        primaryColor: Colors.brown[200],//Color(0xFFb97b50),
        secondaryHeaderColor: Colors.pink,//Color(0xFFEFE6DD),
        buttonColor: Colors.blue[200],//Color(0xFF4c7e7a),
        //buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        accentColor: Colors.red[200],//Colors.teal[200],//Color(0xFFBB4430),
        canvasColor: Colors.brown[200],//Color(0xFF36332e),
        scaffoldBackgroundColor: Colors.brown[300],//Color(0xFF36332e),
        bottomAppBarColor: Colors.brown[50],//Color(0xFF7EBDC2),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.black,
        ),
        dialogBackgroundColor: Colors.deepOrange,
        textTheme: TextTheme(
          headline: TextStyle(color: Colors.deepOrange),//Colors.red), //Color(0xFFa85147)),
          caption: TextStyle(color: Colors.white), //Color(0xFFa85147)),
          body1: TextStyle(color: Colors.brown[900], fontSize: 15.0), //Color(0xFFa85147)),
          body2: TextStyle(
              color: Colors.orange), //TextStyle(color: Color(0xFFa85147)),
          title: TextStyle(color: Colors.brown[900]),//Color(0xFFa85147)),
          subhead: TextStyle(color: Colors.lightBlue),//Color(0xFFd6ceb9)),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        brightness: Brightness.light,

      ),
      home: CalendarPage(),
      /* home: InfoPage(
        today: DateTime.now(),
      ), */
    );
  }
}
