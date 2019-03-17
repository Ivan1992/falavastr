import 'package:falavastr/bloc/bloc_provider.dart';
import 'package:falavastr/bloc/library_bloc.dart';
import 'package:falavastr/calendar/DayText.dart';
import 'package:falavastr/drawer.dart';
import 'package:falavastr/pages/library/detailsPage.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  /* ListTile _buildTile(String key, String line, BuildContext context) {
    String title = line.split("|")[0];
    String subtitle = line.split("|")[1];
    return ListTile(
      title: Text(title),
      subtitle: Text("зачала $subtitle"),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return UstavPage("", item, 0, false);
            },
            fullscreenDialog: true,
          ),
        );
      },
    );
  } */

  @override
  Widget build(BuildContext context) {
    /* List<ListTile> map = [];
    NAMES.forEach((key, value) => map.add(_buildTile(key, value, context))); */

    return Scaffold(
      drawer: DrawerOnly(),
      appBar: AppBar(
        title: Text("Библиотека"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(
              "Апостол",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return BlocProvider<LibraryBloc>(
                      bloc: LibraryBloc(),
                      child: DetailsPage(type: BOOKTYPE.APOSTOL),
                    );
                    //return DetailsPage(type: 0);
                  },
                ),
              );
            },
          ),
          Divider(color: Colors.black),
          ListTile(
            title: Text(
              "Евангелие",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return BlocProvider<LibraryBloc>(
                      bloc: LibraryBloc(),
                      child: DetailsPage(type: BOOKTYPE.EVANGELIE),
                    );
                  },
                ),
              );
            },
          ),
          Divider(color: Colors.black),
          ListTile(
            title: Text(
              "Псалтырь",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return BlocProvider<LibraryBloc>(
                      bloc: LibraryBloc(),
                      child: DetailsPage(type: BOOKTYPE.PSALMS),
                    );
                  },
                ),
              );
            },
          ),
          Divider(color: Colors.black),
          ListTile(
            title: Text(
              "Часослов",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return BlocProvider<LibraryBloc>(
                      bloc: LibraryBloc(),
                      child: DetailsPage(type: BOOKTYPE.CHASOSLOV),
                    );
                  },
                ),
              );
            },
          ),
          Divider(color: Colors.black),
        ],
      ),
    );
  }
}
