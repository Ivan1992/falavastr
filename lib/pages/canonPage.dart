import 'package:falavastr/bloc/application_bloc.dart';
import 'package:falavastr/bloc/bloc_provider.dart';
import 'package:falavastr/calendar/DayText.dart';
import 'package:falavastr/drawer.dart';
import 'package:falavastr/pages/ustav.dart';
import 'package:flutter/material.dart';

class CanonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);

    return StreamBuilder(
      stream: appBloc.outCanonsList,
      builder: (BuildContext context, AsyncSnapshot<List<DayText>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.search),
          ),
          drawer: DrawerOnly(),
          appBar: AppBar(
            title: Text("Канонник"),
          ),
          body: ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) =>
                _buildItem(snapshot.data[index], context),
          ),
        );
      },
    );
  }

  Widget _buildItem(DayText item, BuildContext context) {
    return ListTile(
      title: Text(
        item.sluzhby[0].parts[0].name,
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return UstavPage(item.sluzhby[0].parts[0].name, item, 0, false);
            },
            fullscreenDialog: true,
          ),
        );
      },
    );
  }
}
