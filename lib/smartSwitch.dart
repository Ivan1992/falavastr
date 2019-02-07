import 'package:flutter/material.dart';

class SmartSwitch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SmartSwitchState();
  }
}

class _SmartSwitchState extends State<SmartSwitch> {
  bool toggle = false;
  GlobalKey _keyLeft = GlobalKey();
  GlobalKey _keyRight = GlobalKey();
  Offset position = Offset(0.0, 0.0);
  double containerWidth = 170.0;
  double buttonWidth = 90.0;
  double height = 30.0;

  @override
  Widget build(BuildContext context) {
    Widget obj = Container(
      height: height,
      width: buttonWidth,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(200),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
    );

    var knopochka = Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanEnd: (details) {
          if (position.dx < (containerWidth / 2 - buttonWidth / 2)) {
            final RenderBox _renderBox =
                _keyLeft.currentContext.findRenderObject();
            setState(() {
              buttonWidth = _renderBox.size.width + 40;
              position = Offset(0.0, position.dy);
            });
          } else {
            final RenderBox _renderBox =
                _keyRight.currentContext.findRenderObject();
            setState(() {
              buttonWidth = _renderBox.size.width + 40;
              position = Offset(containerWidth - buttonWidth, position.dy);
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
      child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            border: Border.all(color: Colors.white, width: 1.0),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "старый",
                      key: _keyLeft,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(
                      "новый",
                      key: _keyRight,
                    ),
                  ),
                ],
              ),
              knopochka,
              Positioned(
                left: containerWidth / 2,
                top: 0.0,
                child: Container(width: 2.0, height: 20.0, color: Colors.pink),
              )
              /* Positioned(
                left: position.dx,
                top: position.dy,
                child: Draggable(
                  onDragCompleted: () {
                    print("completed");
                    setState(() {});
                  },
                  onDraggableCanceled: (velocity, offset) {
                    setState(() {
                      position = Offset(
                          offset.dx,
                          position
                              .dy); //toggle ? Offset(position.dx+100.0, position.dy) :  Offset(position.dx-100.0, position.dy);
                      //toggle = !toggle;
                      print(offset.toString() + " " + position.toString());
                    });
                  },
                  feedback: obj,
                  axis: Axis.horizontal,
                  childWhenDragging: Container(),
                  child: obj,
                ),
              ), */
            ],
          )),
    );
  }
}
