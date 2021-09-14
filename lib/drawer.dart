import 'package:falavastr/bloc/application_bloc.dart';
import 'package:falavastr/bloc/bloc_provider.dart';
import 'package:falavastr/calendar/DayText.dart';
import 'package:falavastr/pages/aboutPage.dart';
import 'package:falavastr/pages/canonPage.dart';
import 'package:falavastr/pages/libraryPage.dart';
import 'package:falavastr/pages/rss/rssfeed.dart';
import 'package:falavastr/pages/settingsPage.dart';
import 'package:falavastr/pages/ustav.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'bloc/library_bloc.dart';
import 'pages/library/detailsPage.dart';

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

  ListTile _getLibraryTile(BuildContext context, String title, BOOKTYPE type) {
    return ListTile(
      leading: Icon(Icons.subdirectory_arrow_right),
      title: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Text(
          title,
          style:
              TextStyle(color: Theme.of(context).primaryTextTheme.title.color),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return BlocProvider<LibraryBloc>(
                bloc: LibraryBloc(),
                child: DetailsPage(type: type),
              );
              //return DetailsPage(type: 0);
            },
          ),
        );
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
                    : <Widget>[Center(child: CircularProgressIndicator())],
              ),
              ExpansionTile(
                leading: Icon(Icons.library_books),
                title: Text(
                  "Библиотека",
                  style: TextStyle(
                      color: Theme.of(ctxt).primaryTextTheme.title.color),
                ),
                children: <Widget>[
                  _getLibraryTile(ctxt, "Апостол", BOOKTYPE.APOSTOL),
                  _getLibraryTile(ctxt, "Евангелие", BOOKTYPE.EVANGELIE),
                  _getLibraryTile(ctxt, "Псалтырь", BOOKTYPE.PSALMS),
                  _getLibraryTile(ctxt, "Часослов", BOOKTYPE.CHASOSLOV),
                ],
              ),
              /* _getDummy(ctxt, "Библиотека", Icon(Icons.library_books), 0.0,
                  null, LibraryPage()), */
              _getDummy(ctxt, "Канонник", Icon(Icons.format_list_bulleted), 0.0,
                  null, CanonPage()),
              _getDummy(ctxt, "Новости РПСЦ", Icon(Icons.rss_feed), 0.0, null,
                  RSSFeed()),
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
