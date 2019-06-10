import 'package:falavastr/bloc/application_bloc.dart';
import 'package:falavastr/bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

class CsText extends StatefulWidget {
  final String text;
  final ScrollController controller;
  final Color textColor;
  final bool rus;
  CsText(this.text, this.controller,
      [this.textColor = Colors.black, this.rus = false]);

  CsText copy() {
    ScrollController sc =
        ScrollController(initialScrollOffset: controller.offset);
    return CsText(this.text, sc, this.textColor, this.rus);
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'offset': controller.initialScrollOffset ?? 0.0,
        'color': textColor.value,
      };

  CsText.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        controller = ScrollController(initialScrollOffset: json['offset']),
        textColor = Color(json['color']),
        rus = false;

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
    _fontFamily = widget.rus ? 'PTSerif' : 'Grebnev';
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        _fontSize = prefs.getDouble("fontSize") ?? 2.0;
        //_fontFamily = prefs.getString("fontFamily") ?? 'Grebnev';
      });
    }
  }

  _savePreferences(ScaleEndDetails _) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("fontSize", _fontSize);
  }

  List<Widget> _parseText(String text) {
    List<Widget> toReturn = [];
    if (!text.contains(r"<r>")) {
      toReturn.add(RichText(
          text:
              TextSpan(text: text, style: TextStyle(fontFamily: _fontFamily))));
      return toReturn;
    }

    text.split(r"<c>").forEach((part) {
      if (part.isNotEmpty) {
        var fn = part.split("</c>");
        var left = fn[0];
        if (left.isNotEmpty && fn.length > 1) {
          toReturn.add(Text.rich(
            TextSpan(
              style:
                  TextStyle(color: widget.textColor, fontFamily: _fontFamily),
              children: _parseRed(left),
            ),
            style: TextStyle(fontFamily: _fontFamily),
            textAlign: TextAlign.center,
            textScaleFactor: _fontSize,
          ));
        } else {
          toReturn.add(RichText(
            textAlign: TextAlign.justify,
            textScaleFactor: _fontSize,
            text: TextSpan(
              style:
                  TextStyle(color: widget.textColor, fontFamily: _fontFamily),
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
                style:
                    TextStyle(color: widget.textColor, fontFamily: _fontFamily),
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
          toReturn.add(TextSpan(
              text: red,
              style: TextStyle(
                  color: Colors.red[800]))); //, fontFamily: _fontFamily)));
        } else if (fn.length == 1) {
          toReturn.add(TextSpan(text: red));
        }

        if (fn.length > 1) {
          var black = fn[1];
          if (black.isNotEmpty) {
            toReturn.add(TextSpan(
                text: black,
                style: TextStyle(
                    color: Colors.black))); //, fontFamily: _fontFamily)));
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
    //final ScrollController _controller
    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);

    return GestureDetector(
        onScaleStart: _handleOnScaleStart,
        onScaleUpdate: _handleScaleUpdate,
        onScaleEnd: _savePreferences,
        child: StreamBuilder(
          stream: appBloc.outFontFamily,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            _fontFamily = snapshot.hasData ? snapshot.data : 'Grebnev';
            return DraggableScrollbar.semicircle(
              backgroundColor: Theme.of(context).primaryColor,
              child: ListView(
                controller: widget.controller,
                padding: EdgeInsets.all(10.0),
                children: _parseText(widget.text),
              ),
              controller: widget.controller,
            );
          },
        )
        /* child: ListView(
        controller: _controller,
        padding: EdgeInsets.all( 10.0),
        children: _parseText(widget.text),
      ), */
        );
  }
}
