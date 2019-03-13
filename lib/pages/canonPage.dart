import 'package:falavastr/bloc/application_bloc.dart';
import 'package:falavastr/bloc/bloc_provider.dart';
import 'package:falavastr/calendar/DayText.dart';
import 'package:falavastr/drawer.dart';
import 'package:falavastr/pages/calendarPage.dart';
import 'package:flutter/material.dart';

class CanonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);

    return StreamBuilder(
      stream: appBloc.outCanonsList,
      builder: (BuildContext context, AsyncSnapshot<DayText> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        /*
         * onPressed: () {
                Navigator.of(context).push(
                  new MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return CalendarPage();
                      },
                      fullscreenDialog: true),
                );
              },
         */

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.search),
          ),
          drawer: DrawerOnly(),
          appBar: AppBar(
            title: Text("Канонник"),
          ),
          body: ListView(
            children: snapshot.data.sluzhby
                .map((item) => ListTile(
                      title: Text(item.parts[0].name),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}
