import 'package:flutter/material.dart';

class SmartSwitch extends StatefulWidget {
  const SmartSwitch({Key key, this.onChange, this.beginState = true, this.leftText = "старый", this.rightText="новый"})
      : super(key: key);

  final ValueChanged<bool> onChange;
  final bool beginState;
  final String leftText;
  final String rightText;

  @override
  State<StatefulWidget> createState() {
    return _SmartSwitchState();
  }
}

class _SmartSwitchState extends State<SmartSwitch> {
  GlobalKey _keyLeft = GlobalKey();
  GlobalKey _keyRight = GlobalKey();
  Offset _position;
  double _containerWidth;
  double _buttonWidth;
  double _height;
  Color _originalColor = Colors.white;
  Color _buttonColor;
  bool _oldValue;

  @override
  void initState() {
    super.initState();
    _containerWidth = 170.0;
    _buttonWidth = _containerWidth / 2;
    _height = 30.0;
    _originalColor = Colors.white;
    _buttonColor = _originalColor;
    _position =
        Offset(widget.beginState ? (_containerWidth - _buttonWidth) : 0.0, 0.0);
    _oldValue = widget.beginState;
  }

  void _switch(bool val) {
    if (!val) {
      setState(() {
        _position = Offset(0.0, _position.dy);
        if (val != _oldValue) widget.onChange(false);
      });
    } else {
      setState(() {
        _position = Offset(_containerWidth - _buttonWidth, _position.dy);
        if (val != _oldValue) widget.onChange(true);
      });
    }
    _oldValue = val;
  }

  void _onPanEnd(DragEndDetails details) {
    if (_position.dx < (_containerWidth / 2 - _buttonWidth / 2)) {
      _switch(false);
    } else {
      _switch(true);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if ((_position.dx + details.delta.dx) < (_containerWidth - _buttonWidth) &&
        (_position.dx + details.delta.dx) > 0) {
      setState(() {
        _position = Offset(_position.dx + details.delta.dx, _position.dy);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget obj = Container(
      height: _height,
      width: _buttonWidth,
      decoration: BoxDecoration(
        color: _buttonColor,
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
    );

    var knopochka = Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanEnd: _onPanEnd,
        onPanUpdate: _onPanUpdate,
        child: obj,
      ),
    );

    var row = (Widget child) => GestureDetector(
          onPanEnd: _onPanEnd,
          onPanUpdate: _onPanUpdate,
          child: child,
        );

    return SizedBox(
      width: _containerWidth,
      child: Container(
        height: _height,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Stack(
          overflow: Overflow.visible,
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            knopochka,
            row(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _switch(false);
                    },
                    child: Text(widget.leftText, key: _keyLeft),
                  ),
                  GestureDetector(
                    onTap: () {
                      _switch(true);
                    },
                    child: Text(widget.rightText, key: _keyRight),
                  ),
                ],
                /* children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _switch(false);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: _height,
                      child: Text("старый", key: _keyLeft),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _switch(true);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: _height,
                      child: Text("новый", key: _keyRight),
                    ),
                  ),
                ], */
              ),
            ),
          ],
        ),
      ),
    );
  }
}
