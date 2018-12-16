import 'package:falavastr/cstext.dart';
import 'package:falavastr/drawer.dart';
import 'package:flutter/material.dart';

class UstavPage extends StatelessWidget {
  final String name;
  UstavPage(this.name);

  void showMenuSelection(String value) {
    print('You selected: $value');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerOnly(true),
      appBar: AppBar(
        title: Text(name),
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
          /* IconButton(onPressed: () {}, icon: Icon(Icons.format_size)), */
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
          child: CsText(),
        ),
      ),
    );
  }
}
