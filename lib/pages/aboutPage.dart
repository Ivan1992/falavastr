import 'package:falavastr/drawer.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerOnly(),
      appBar: AppBar(
        title: Text("О программе"),
      ),
      body: Center(
        child: Text("Здесь будет О программе"),
      ),
    );
  }
}
