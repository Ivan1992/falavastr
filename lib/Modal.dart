import 'package:flutter/material.dart';

class Modal {
  menuBottom(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListView(
            //mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _createTile(context, "На Господи воззвах", Colors.redAccent, _action1),
              _createTile(context, "Паремии", Colors.greenAccent, _action1),
              _createTile(context, "На стиховне", Colors.greenAccent, _action1),
              _createTile(context, "На литии", Colors.greenAccent, _action1),
              _createTile(context, "Стихера по 50м псалме", Colors.blueAccent, _action1),
              _createTile(context, "Канон", Colors.blueAccent, _action1),
              _createTile(context, "Стихеры на Хвалитех", Colors.blueAccent, _action1),
              _createTile(context, "На литургии", Colors.cyanAccent, _action1),
            ],
          );
        });
  }

  Container _createTile(
      BuildContext context, String name, Color color, Function action) {
    return Container(
      //decoration: new BoxDecoration(color: color),
      child: ListTile(
        leading: Icon(Icons.book, color: color),
        title: Text(name),
        onTap: () {
          Navigator.pop(context);
          action();
        },
      ),
    );
  }

  _action1() {
    print("action 1");
  }
}
