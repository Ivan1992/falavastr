import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CsText extends StatefulWidget {

  final String text;
  CsText(this.text);

  @override
  State<StatefulWidget> createState() => _CsText();
}

class _CsText extends State<CsText> {
  double _fontSize = 2.0;
  double _previousScale = 2.0;
  String _fontFamily = 'Grebnev';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _fontSize = prefs.getDouble("fontSize") ?? 2.0;
    _fontFamily = prefs.getString("fontFamily") ?? 'Grebnev';
  }
 
  List<Widget> _parseText(String text) {
    List<Widget> toReturn = [];
    if (!text.contains(r"<r>")) {
      toReturn.add(RichText(text: TextSpan(text: text)));
      return toReturn;
    }

    text.split(r"<c>").forEach((part) {
      if (part.isNotEmpty) {
        var fn = part.split("</c>");
        var left = fn[0];
        if (left.isNotEmpty && fn.length > 1) {
          toReturn.add(Text.rich(
            TextSpan(
                style: TextStyle(color: Colors.black, fontFamily: _fontFamily),
                children: _parseRed(left)),
            textAlign: TextAlign.center,
            textScaleFactor: _fontSize,
          ));
        } else {
          toReturn.add(RichText(
            textAlign: TextAlign.justify,
            textScaleFactor: _fontSize,
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontFamily: _fontFamily),
              children: _parseRed(left),
            ),
          ));
        }

        if (fn.length > 1) {
          var right = fn[1];
          if (right.isNotEmpty) {
            toReturn.add(RichText(
              textAlign: TextAlign.justify,
              textScaleFactor: _fontSize,
              text: TextSpan(
                style: TextStyle(color: Colors.black, fontFamily: _fontFamily),
                children: _parseRed(right),
              ),
            ));
          }
        }
      }
    });
    return toReturn;
  }

  List<TextSpan> _parseRed(String text) {
    List<TextSpan> toReturn = [];

    text.split(r"<r>").forEach((x) {
      if (x.isNotEmpty) {
        var fn = x.split(r"</r>");
        var red = fn[0];
        if (red.isNotEmpty && fn.length > 1) {
          toReturn
              .add(TextSpan(text: red, style: TextStyle(color: Colors.red)));
        } else if (fn.length == 1) {
          toReturn.add(TextSpan(text: red));
        }

        if (fn.length > 1) {
          var black = fn[1];
          if (black.isNotEmpty) {
            toReturn.add(TextSpan(text: black));
          }
        }
      }
    });
    return toReturn;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _fontSize = (_previousScale * details.scale).clamp(1.0, 4.0);
    });
  }

  void _handleOnScaleStart(ScaleStartDetails details) {
    setState(() {
      _previousScale = _fontSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _handleOnScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      child: ListView(
        children: _parseText(widget.text),
      ),
    );
  }
}
