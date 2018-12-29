import 'package:falavastr/calendar/DayText.dart';
import 'package:falavastr/cstext.dart';
import 'package:falavastr/drawer.dart';
import 'package:flutter/material.dart';

class UstavPage extends StatefulWidget {
  final String name;
  final DayText day;

  UstavPage(this.name, this.day);

  @override
  State<StatefulWidget> createState() => _UstavPageState();
}

class _UstavPageState extends State<UstavPage> {
  CsText _cstext;
  int currentSluzhba = 0;

  void showMenuSelection(String value) {
    print('You selected: $value');
  }

  @override
  void initState() {
    super.initState();
    _cstext = CsText(widget.day.sluzhby[0].parts[0].text);
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
            children: widget.day.sluzhby[currentSluzhba].parts
                .map((part) => FlatButton(
                      onPressed: () {
                        setState(() {
                          _cstext = CsText(part.text);
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text(part.name),
                    ))
                .toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    FloatingActionButton fab;
    if (widget.day.sluzhby[currentSluzhba].parts.length > 1) {
      fab = FloatingActionButton(
        onPressed: () => _showDialog(),
        child: Icon(Icons.menu),
      );
    }

    return Scaffold(
      drawer: DrawerOnly(true),
      floatingActionButton: fab,
      appBar: AppBar(
        title: Text(widget.name),
        actions: <Widget>[
          PopupMenuButton<String>(
              icon: Icon(Icons.format_size),
              padding: EdgeInsets.zero,
              onSelected: showMenuSelection,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'Preview',
                      child: ListTile(
                          leading: Icon(Icons.format_color_fill),
                          title: Text('Ночная тема')),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Preview',
                      child: ListTile(
                          leading: Icon(Icons.format_color_fill),
                          title: Text('Дневная тема')),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem<String>(
                      value: 'Share',
                      child: ListTile(
                          leading: Icon(Icons.text_format),
                          title: Text('Гребнев',
                              style: TextStyle(fontFamily: 'Grebnev'))),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Get Link',
                      child: ListTile(
                          leading: Icon(Icons.text_format),
                          title: Text('Тураево')),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Get Link',
                      child: ListTile(
                          leading: Icon(Icons.text_format),
                          title: Text('Триодь')),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(child: Text("Размер текста")),
                    PopupMenuItem(
                      child: Slider(
                          onChanged: (value) {},
                          min: 1.0,
                          max: 5.0,
                          value: 2.5),
                    ),
                  ]),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.fullscreen),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.today),
          ),
        ],
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: _cstext,
        ),
      ),
    );
  }
}
