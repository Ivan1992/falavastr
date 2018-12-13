import 'package:falavastr/cstext.dart';
import 'package:falavastr/drawer.dart';
import 'package:flutter/material.dart';

class UstavPage extends StatelessWidget {
  final String name;
  UstavPage(this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerOnly(true),
      appBar: AppBar(
        title: Text(name),
        actions: <Widget>[
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.format_size)
          ),
          IconButton(
            onPressed: (){},
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
