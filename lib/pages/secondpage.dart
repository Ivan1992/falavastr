import 'package:falavastr/drawer.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerOnly(),
      appBar: AppBar(
        title: Text("Second page"),
      ),
      body: Center(
        child: Text("here goes the content 2"),
      ),
    );
  }
}
