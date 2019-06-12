import 'dart:async';

import 'package:falavastr/bloc/application_bloc.dart';
import 'package:falavastr/bloc/bloc_provider.dart';
import 'package:falavastr/calendar/DayText.dart';
import 'package:falavastr/cstext.dart';
import 'package:falavastr/drawer.dart';
import 'package:falavastr/pages/infopage.dart';
import 'package:falavastr/pages/ustav_utilities.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class UstavPage extends StatefulWidget {
  final String name;
  final DayText day;
  final int initialPart;
  final bool showInfo;

  UstavPage(this.name, this.day, [this.initialPart = 0, this.showInfo = true]);

  @override
  State<StatefulWidget> createState() => _UstavPageState();
}

class _UstavPageState extends State<UstavPage> {
  CsText _cstext;
  int _currentSluzhba = 0;
  bool _fullscreen = false;
  final ScrollController controller =
      ScrollController(initialScrollOffset: 0.0);
  Color backgroundColor = Colors.white;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  VoidCallback _showBottomSheetCallback;

  void showMenuSelection(String value) {
    print('You selected: $value');
  }

  @override
  void initState() {
    super.initState();
    _cstext = CsText(
        widget.day.sluzhby[0].parts[widget.initialPart].text, controller);
    _showBottomSheetCallback = _showBottomSheet;
  }

  void _showBottomSheet() {
    setState(() {
      _showBottomSheetCallback = null;
    });

    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);
    appBloc.addFav.add(_cstext.copy());

    _scaffoldKey.currentState
        .showBottomSheet<void>((BuildContext context) {
          final ThemeData themeData = Theme.of(context);
          return BSClass(
            themeData: themeData,
            backgroundColor: backgroundColor,
            cstext: _cstext,
          );
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showBottomSheetCallback = _showBottomSheet;
            });
          }
        });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Выберите часть"),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: widget.day.sluzhby[_currentSluzhba].parts
                .map(
                  (part) => part.text != null
                      ? ListTile(
                          onTap: () {
                            setState(() {
                              controller.jumpTo(0.0);
                              _cstext = CsText(part.text, controller, _cstext.textColor);
                              Navigator.of(context).pop();
                            });
                          },
                          title: Center(
                            child: Text(part.name),
                          ),
                        )
                      : Container(),
                )
                .toList(),
          ),
        );
      },
    );
  }


  void updateCsText(bool value) {
    setState(() {
      backgroundColor = value ? Colors.blueGrey[900] : Colors.white;
      _cstext = CsText(_cstext.text, _cstext.controller,
          value ? Colors.brown[100] : Colors.black);
    });
  }

  @override
  Widget build(BuildContext context) {
    FloatingActionButton fab;
    if (widget.day.sluzhby[_currentSluzhba].parts.length > 1) {
      fab = FloatingActionButton(
        onPressed: () => _showDialog(),
        child: Icon(Icons.menu),
      );
    }
    
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: DrawerOnly(true),
        floatingActionButton: !_fullscreen ? fab : null,
        appBar: !_fullscreen
            ? AppBar(
                title: Text(
                  widget.name,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(fontSize: 20.0),
                ),
                actions: <Widget>[
                  PopupListBuilder(
                      updateCsText: updateCsText, context: context),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _fullscreen = true;
                        SystemChrome.setEnabledSystemUIOverlays([]);
                      });
                    },
                    icon: Icon(Icons.fullscreen),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _showBottomSheetCallback,
                  ),
                  widget.showInfo
                      ? IconButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute<Null>(
                                  builder: (BuildContext context) {
                                return InfoPage(
                                  today: widget.day.today,
                                );
                                //return CalendarPage(widget.day.today.add(Duration(days: 13)));
                              }),
                            );
                          },
                          icon: Icon(Icons.info),
                        )
                      : Container(),
                ],
              )
            : null,
        body: GestureDetector(
          onTap: () {
            if (_fullscreen)
              setState(() {
                _fullscreen = false;
                SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
              });
          },
          child: Container(color: backgroundColor, child: _cstext),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    if (_fullscreen) {
      setState(() {
        _fullscreen = false;
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      });
      return Future(() => false);
    }
    return Future(() => true);
  }
}

class BSClass extends StatefulWidget {
  final ThemeData themeData;
  final CsText cstext;
  final Color backgroundColor;

  const BSClass({Key key, this.themeData, this.cstext, this.backgroundColor})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _BSClassState();
}

class _BSClassState extends State<BSClass> with TickerProviderStateMixin {
  double _height = 0.6;
  TabController _controller;

  @override
  Widget build(BuildContext context) {
    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);

    return StreamBuilder(
      stream: appBloc.outFavSize,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        if (!snapshot.hasData) return Container();
        return Container(
          height: MediaQuery.of(context).size.height * snapshot.data,
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: widget.themeData.disabledColor))),
          child: StreamBuilder(
            stream: appBloc.outFavs,
            builder: (BuildContext ctx, AsyncSnapshot<List<CsText>> snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              if (snapshot.data != null && snapshot.data.length == 0)
                return Center(child: Text("нет закладок"));

              _controller =
                  TabController(vsync: this, length: snapshot.data.length);

              List<Tab> tabHeader = [];
              for (int i = 0; i < snapshot.data.length; i++) {
                tabHeader.add(Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("закладка ${i + 1}", style: TextStyle(height: 1.0)),
                      IconButton(
                        onPressed: () {
                          appBloc.removeFav.add(i);
                          if (snapshot.data.length > 1) {
                            _controller = TabController(
                                vsync: this, length: snapshot.data.length - 1);
                          }
                          /* snapshot.data.removeAt(i);
                          setState((){}); */
                        },
                        icon: Icon(Icons.close),
                      )
                    ],
                  ),
                ));
              }

              return Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      /* height: 10, */
                      child: TabBar(
                        controller: _controller,
                        isScrollable: true,
                        tabs: tabHeader,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _controller,
                        children: snapshot.data
                            .map((item) => Container(
                                color: widget.backgroundColor, child: item))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    if (_controller != null)
      _controller.dispose();
    super.dispose();
  }
}
