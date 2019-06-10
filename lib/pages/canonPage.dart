import 'package:falavastr/bloc/application_bloc.dart';
import 'package:falavastr/bloc/bloc_provider.dart';
import 'package:falavastr/calendar/DayText.dart';
import 'package:falavastr/drawer.dart';
import 'package:falavastr/pages/ustav.dart';
import 'package:flutter/material.dart';

class CanonPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CanonPageState();
}

class _CanonPageState extends State<CanonPage> {
  bool fabVisible = true;
  String searchValue = "";

  @override
  Widget build(BuildContext context) {
    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);

    return Scaffold(
        floatingActionButton: fabVisible
            ? FloatingActionButton(
                tooltip: 'Поиск',
                onPressed: () {
                  setState(() {
                    fabVisible = !fabVisible;
                  });
                },
                child: Icon(Icons.search),
              )
            : null,
        drawer: DrawerOnly(),
        appBar: AppBar(
          title: Text("Канонник"),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder(
                  stream: appBloc.outCanonsList,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<DayText>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      /* separatorBuilder: (context, index) =>
                          Divider(color: Colors.black), */
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        DayText d = snapshot.data[index];
                        if (searchValue.isEmpty) {
                          return _buildItem(d, context);
                        } else if (d.sluzhby[0].parts[0].name
                            .toLowerCase()
                            .contains(searchValue.toLowerCase())) {
                          return _buildItem(d, context);
                        } else {
                          return null;
                        }
                      },
                    );
                  },
                ),
              ),
              !fabVisible
                  ? Container(
                      padding: EdgeInsets.all(5.0),
                      child: TextField(
                        onSubmitted: (value) {
                          setState(() {});
                        },
                        onChanged: (value) {
                          if (value.length > 1) {
                            setState(() {
                              searchValue = value;
                            });
                          }
                        },
                        onEditingComplete: () {
                          setState(() {
                            fabVisible = !fabVisible;
                            searchValue = "";
                          });
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: 'Название...',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                setState(() {
                                  searchValue = "";
                                  fabVisible = !fabVisible;
                                });
                              },
                            )),
                        autofocus: true,
                      ),
                    )
                  : Container()
            ],
          ),
        ));
  }

  Widget _buildItem(DayText item, BuildContext context) {
    return InkWell(
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
      child: Card(
        margin: EdgeInsets.symmetric(vertical:1.0),
        child: Padding(padding: EdgeInsets.all(25.0),
        child: Text(
          item.sluzhby[0].parts[0].name,
          style: TextStyle(color: Colors.black),
        ),),
      ),
    );
  }
}
