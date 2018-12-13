import 'package:falavastr/drawer.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerOnly(),
      appBar: AppBar(
        title: Text("First page"),
      ),
      body: Center(
        child: Text("here goes the content"),
      ),
    );
  }
}
