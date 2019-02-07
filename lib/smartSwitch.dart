import 'package:flutter/material.dart';

class SmartSwitch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SmartSwitchState();
  }
}

class _SmartSwitchState extends State<SmartSwitch> {
  bool _toggle = false;
  GlobalKey _keyLeft = GlobalKey();
  GlobalKey _keyRight = GlobalKey();
  Offset position = Offset(0.0, 0.0);
  double containerWidth;
  double buttonWidth;
  double height;
  Color originalColor = Colors.white;
  Color buttonColor;

  @override
  void initState() {
    super.initState();
    containerWidth = 270.0;
    buttonWidth = containerWidth / 2;
    height = 50.0;
    originalColor = Colors.white;
    buttonColor = originalColor.withAlpha(100);
  }

  @override
  Widget build(BuildContext context) {
    Widget obj = Container(
      height: height,
      width: buttonWidth,
      decoration: BoxDecoration(
        color: Colors.lime, //buttonColor,
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
    );

    var knopochka = Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanStart: (details) {
          setState(() {
            buttonColor = originalColor.withAlpha(150);
          });
        },
        onPanEnd: (details) {
          if (position.dx < (containerWidth / 2 - buttonWidth / 2)) {
            final RenderBox _renderBox =
                _keyLeft.currentContext.findRenderObject();
            setState(() {
              //buttonWidth = _renderBox.size.width + 40;
              position = Offset(0.0, position.dy);
              _toggle = false;
              buttonColor = originalColor.withAlpha(100);
            });
          } else {
            final RenderBox _renderBox =
                _keyRight.currentContext.findRenderObject();
            setState(() {
              //buttonWidth = _renderBox.size.width + 40;
              position = Offset(containerWidth - buttonWidth, position.dy);
              _toggle = true;
              buttonColor = originalColor.withAlpha(100);
            });
          }
        },
        onPanUpdate: (details) {
          if ((position.dx + details.delta.dx) <
                  (containerWidth - buttonWidth) &&
              (position.dx + details.delta.dx) > 0) {
            setState(() {
              position = Offset(position.dx + details.delta.dx, position.dy);
            });
          }
        },
        child: obj,
      ),
    );

    return SizedBox(
      width: containerWidth,
      child: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            //border: Border.all(color: Colors.white, width: 1.0),
          ),
          child: Stack(
            overflow: Overflow.visible,
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              //knopochka,
              Container(
                height: 30.0,
                color: Colors.pink,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "старый",
                      key: _keyLeft,
                      style: TextStyle(
                          color: !_toggle
                              ? Theme.of(context).textTheme.display1.color
                              : Colors.transparent),
                    ),
                    Text(
                      "новый",
                      key: _keyRight,
                    ),
                  ],
                ),
              ),
              knopochka,
              /* Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "старый",
                    style: TextStyle(color: Colors.blue),
                  ),
                  Text(
                    "новый",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ), */
            ],
          ),
        ),
      ),
    );
  }
}
