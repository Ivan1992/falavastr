import 'package:falavastr/calendar/DayText.dart';
import 'package:falavastr/cstext.dart';
import 'package:falavastr/drawer.dart';
import 'package:falavastr/pages/calendarPage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class UstavPage extends StatefulWidget {
  final String name;
  final DayText day;
  final int initialPart;

  UstavPage(this.name, this.day, [this.initialPart = 0]);

  @override
  State<StatefulWidget> createState() => _UstavPageState();
}

class _UstavPageState extends State<UstavPage> {
  CsText _cstext;
  int _currentSluzhba = 0;
  bool _fullscreen = false;
  final ScrollController controller =
      ScrollController(initialScrollOffset: 0.0);

  void showMenuSelection(String value) {
    print('You selected: $value');
  }

  @override
  void initState() {
    super.initState();
    _cstext = CsText(
        widget.day.sluzhby[0].parts[widget.initialPart].text, controller);
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Выберите часть"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.day.sluzhby[_currentSluzhba].parts
                .map(
                  (part) => part.text != null
                      ? FlatButton(
                          onPressed: () {
                            setState(() {
                              controller.jumpTo(0.0);
                              _cstext = CsText(part.text, controller);
                              Navigator.of(context).pop();
                            });
                          },
                          child: Text(part.name),
                        )
                      : Container(),
                )
                .toList(),
          ),
        );
      },
    );
  }

  List<PopupMenuEntry<String>> _buildMenu(BuildContext context) {
    return <PopupMenuEntry<String>>[
      const PopupMenuItem<String>(
        value: 'Preview',
        child: ListTile(
            leading: Icon(Icons.format_color_fill), title: Text('Ночная тема')),
      ),
      const PopupMenuItem<String>(
        value: 'Preview',
        child: ListTile(
            leading: Icon(Icons.format_color_fill),
            title: Text('Дневная тема')),
      ),
      const PopupMenuDivider(),
      const PopupMenuItem<String>(
        value: 'Orthodox',
        child: ListTile(
          leading: Icon(Icons.text_format),
          title: Text('Ортодокс', style: TextStyle(fontFamily: 'Orthodox')),
        ),
      ),
      const PopupMenuItem<String>(
        value: 'Turaevo',
        child: ListTile(
            leading: Icon(Icons.text_format),
            title: Text('Тураево', style: TextStyle(fontFamily: 'Turaevo'))),
      ),
      const PopupMenuItem<String>(
        value: 'Grebnev',
        child: ListTile(
            leading: Icon(Icons.text_format),
            title: Text('Гребнев', style: TextStyle(fontFamily: 'Grebnev'))),
      ),
      const PopupMenuDivider(),
      PopupMenuItem(child: Text("Размер текста")),
      PopupMenuItem(
        child: Slider(onChanged: (value) {}, min: 1.0, max: 5.0, value: 2.5),
      ),
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: DrawerOnly(true),
        floatingActionButton: !_fullscreen ? fab : null,
        appBar: !_fullscreen
            ? AppBar(
                title: Hero(
                  tag: widget.name,
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      widget.name,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(fontSize: 20.0),
                    ),
                  ),
                ),
                actions: <Widget>[
                  PopupMenuButton<String>(
                      icon: Icon(Icons.format_size),
                      padding: EdgeInsets.zero,
                      onSelected: showMenuSelection,
                      itemBuilder: _buildMenu),
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
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                          return CalendarPage(
                              widget.day.today.add(Duration(days: 13)));
                        }),
                      );
                    },
                    icon: Icon(Icons.today),
                  ),
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
          child: Container(color: Colors.white, child: _cstext),
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
