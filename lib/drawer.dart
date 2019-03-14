import 'package:falavastr/bloc/application_bloc.dart';
import 'package:falavastr/bloc/bloc_provider.dart';
import 'package:falavastr/calendar/DateService.dart';
import 'package:falavastr/calendar/DayText.dart';
import 'package:falavastr/pages/aboutPage.dart';
import 'package:falavastr/pages/calendarPage.dart';
import 'package:falavastr/pages/canonPage.dart';
import 'package:falavastr/pages/libraryPage.dart';
import 'package:falavastr/pages/settingsPage.dart';
import 'package:falavastr/pages/ustav.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';

import 'package:intl/intl.dart';

class DrawerOnly extends StatelessWidget {
  final bool expanded;
  final DateTime _today = DateTime.now();

  DrawerOnly([this.expanded = false]) {
    initializeDateFormatting("ru");
  }

  ListTile _getDummy(BuildContext ctxt, String name,
      [Icon icon = const Icon(Icons.bookmark),
      double padding = 0.0,
      DayText d,
      Widget navigateTo]) {
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
        Navigator.push(
          ctxt,
          MaterialPageRoute(
            builder: (ctxt) => navigateTo == null ? CanonPage() : navigateTo,
          ),
        );
      },
    );
  }

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
        Navigator.pushReplacement(
            ctxt,
            MaterialPageRoute(
                builder: (ctxt) => UstavPage(name, day),
                fullscreenDialog: true));
      },
    );
  }

  @override
  Widget build(BuildContext ctxt) {
    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(ctxt);

    return StreamBuilder(
      stream: appBloc.outInfoPage,
      builder: (BuildContext context, AsyncSnapshot<List<DayText>> snapshot) {
        return Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.black),
                child: Container(
                    child: Center(
                  child: Text(
                    "Алавастр",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
              ),
              ExpansionTile(
                  initiallyExpanded: expanded,
                  leading: Icon(Icons.bookmark),
                  title: Text(
                    "Устав на сегодня",
                    style: TextStyle(
                        color: Theme.of(ctxt).primaryTextTheme.title.color),
                  ),
                  children: snapshot.hasData
                      ? snapshot.data
                          .where((x) => x != null)
                          .map((x) => _getTile(ctxt, x.title, x,
                              Icon(Icons.subdirectory_arrow_right), 10.0))
                          .toList()
                      : <Widget>[Center(child: CircularProgressIndicator())]),
              _getDummy(ctxt, "Библиотека", Icon(Icons.library_books), 0.0,
                  null, LibraryPage()), //stars
              _getDummy(ctxt, "Канонник", Icon(Icons.format_list_bulleted), 0.0,
                  null, CanonPage()),
              _getDummy(ctxt, "Настройки", Icon(Icons.settings), 0.0, null,
                  SettigsPage()),
              _getDummy(ctxt, "О программе", Icon(Icons.info), 0.0, null,
                  AboutPage()),
            ],
          ),
        );
      },
    );
  }
}
