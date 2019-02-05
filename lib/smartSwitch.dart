import 'package:flutter/material.dart';

class SmartSwitch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SmartSwitchState();
  }
}

class _SmartSwitchState extends State<SmartSwitch> {

  bool toggle = false;
  Offset position = Offset(0.0, 0.0);

  @override
  Widget build(BuildContext context) {

    Widget obj = Container(
      height: 40.0,
      width: 100.0,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(200),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
    );
    return SizedBox(
      width: 250.0,
      child: Container(
          height: 40.0,
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  DragTarget(
                    builder: (BuildContext context, List candidateData,
                        List rejectedData) {
                      return Container(
                        color: Colors.pink,
                        child: Text("старый"),
                      );
                    },
                    onAccept: (data) => print("accepted"),
                    onWillAccept: (data) => false,
                  ),
                  Text("новый")
                ],
              ),
              Positioned(
                left: position.dx,
                top: position.dy,
                child: Draggable(
                onDragCompleted: () {
                  print("completed");
                  setState(() {
                    //finished = true;
                  });
                },
                onDraggableCanceled: (velocity, offset) {
                  setState(() {
                    position = Offset(offset.dx, position.dy);//toggle ? Offset(position.dx+100.0, position.dy) :  Offset(position.dx-100.0, position.dy); 
                    //toggle = !toggle;
                    print(offset.toString()+" "+position.toString());
                  });
                },
                feedback: obj,
                axis: Axis.horizontal,
                childWhenDragging: Container(),
                child: obj,
              ),
              )
            ],
          )),
    );
  }
}
