import 'package:falavastr/drawer.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerOnly(),
      appBar: AppBar(
        title: Text("Настройки"),
      ),
      body: Center(
        child: Text("Здесь будет Библиотека")
      ),
    );
  }
}
