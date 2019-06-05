import 'dart:async';

import 'package:falavastr/bloc/application_bloc.dart';
import 'package:falavastr/bloc/bloc_provider.dart';
import 'package:falavastr/calendar/DayText.dart';
import 'package:falavastr/cstext.dart';
import 'package:falavastr/drawer.dart';
import 'package:falavastr/pages/infopage.dart';
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
      // disable the button
      _showBottomSheetCallback = null;
    });
    _scaffoldKey.currentState
        .showBottomSheet<void>((BuildContext context) {
          final ThemeData themeData = Theme.of(context);
          return Container(
            decoration: BoxDecoration(
                border:
                    Border(top: BorderSide(color: themeData.disabledColor))),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'This is a Material persistent bottom sheet. Drag downwards to dismiss it.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: themeData.accentColor,
                  fontSize: 24.0,
                ),
              ),
            ),
          );
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              // re-enable the button
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
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: widget.day.sluzhby[_currentSluzhba].parts
                        .map(
                          (part) => part.text != null
                              ? ListTile(
                                  onTap: () {
                                    setState(() {
                                      controller.jumpTo(0.0);
                                      _cstext = CsText(part.text, controller);
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _changeFont(String value) {
    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);
    appBloc.inFontFamily.add(value);
  }

  void _changeNightMode(bool value) {
    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);
    appBloc.inNightMode.add(value);
  }

  PopupMenuItem<String> _createFontTile(String name, String label) {
    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);

    return PopupMenuItem<String>(
      value: name,
      child: StreamBuilder(
          stream: appBloc.outFontFamily,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            bool selected = snapshot.hasData ? (snapshot.data == name) : false;
            return ListTile(
              onTap: () => _changeFont(name),
              leading: Icon(Icons.text_format),
              title: Text(label, style: TextStyle(fontFamily: name)),
              trailing: selected ? Icon(Icons.check) : null,
            );
          }),
    );
  }

  PopupMenuItem<String> _createNightMode(String text, bool value) {
    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);

    return PopupMenuItem<String>(
      value: text,
      child: ListTile(
        leading: Icon(Icons.format_color_fill),
        title: Text(text),
        onTap: () {
          _changeNightMode(value);
          setState(() {
            backgroundColor = value ? Colors.blueGrey[900] : Colors.white;
            _cstext = CsText(_cstext.text, _cstext.controller,
                value ? Colors.yellow[200] : Colors.black);
          });
        },
        trailing: StreamBuilder(
          stream: appBloc.outNightMode,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return (snapshot.hasData && (snapshot.data == value))
                ? Icon(Icons.check)
                : Container(width: 0.0, height: 0.0);
          },
        ),
      ),
    );
  }

  List<PopupMenuEntry<String>> _buildMenu(BuildContext context) {
    return <PopupMenuEntry<String>>[
      _createNightMode("Ночная тема", true),
      _createNightMode("Дневная тема", false),
      const PopupMenuDivider(),
      _createFontTile('Orthodox', 'Ортодокс'),
      _createFontTile('Turaevo', 'Тураево'),
      _createFontTile('Grebnev', 'Гребнев'),
    ];
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

    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);

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
                  PopupMenuButton<String>(
                    icon: Icon(Icons.format_size),
                    padding: EdgeInsets.zero,
                    onSelected: showMenuSelection,
                    itemBuilder: _buildMenu,
                  ),
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
