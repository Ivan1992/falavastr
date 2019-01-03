import 'package:falavastr/pages/infopage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Color(0xFFb97b50), //or set color with: Color(0xFF0000FF)
    ));
    return MaterialApp(
      title: 'Алавастр',
      theme: ThemeData(
        fontFamily: "Balkara",
        //primarySwatch: Colors.blue,
        backgroundColor: Color(0xFF36332e),
        primaryColor: Color(0xFFb97b50),
        secondaryHeaderColor: Color(0xFFEFE6DD),
        buttonColor: Color(0xFF4c7e7a),
        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        accentColor: Color(0xFFBB4430),
        canvasColor: Color(0xFF36332e),
        scaffoldBackgroundColor: Color(0xFF36332e),
        bottomAppBarColor: Color(0xFF7EBDC2),
        textTheme: TextTheme(
          headline: TextStyle(color: Colors.red),//Color(0xFFa85147)),
          caption: TextStyle(color: Colors.white),//Color(0xFFa85147)),
          body1: TextStyle(color: Colors.red[300]),//Color(0xFFa85147)),
          body2: TextStyle(color: Colors.red),//TextStyle(color: Color(0xFFa85147)),
          title: TextStyle(color: Color(0xFFa85147)),
          subhead: TextStyle(color: Color(0xFFd6ceb9)),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        brightness: Brightness.dark,
      ),
      home: InfoPage(today: DateTime.now()), //MainCollapsingToolbar(),
    );
  }
}
