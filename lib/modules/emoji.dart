
import 'package:flutter/material.dart';

class EmojiView extends StatefulWidget {
  final double left;
  final double top;
  final Function ontap;
  final Map mapJson;
 // final Function(DragUpdateDetails) onpanupdate;
  final Function(ScaleUpdateDetails) onscaleupdate;
  final Function(ScaleStartDetails) onscalestart;

  const EmojiView({
    Key key,
    this.left,
    this.top,
    this.ontap,
    //this.onpanupdate,
    this.onscaleupdate,
    this.onscalestart,
    this.mapJson,
  }) : super(key: key);
  @override
  _EmojiViewState createState() => _EmojiViewState();
}

class _EmojiViewState extends State<EmojiView> {
  @override
  Widget build(BuildContext context) {
    //print(widget.rotation);
    return Positioned(
      left:widget.left,
      top:widget.top,
      child: Transform.rotate(
        angle: widget.mapJson['rotation'],
        child: GestureDetector(
          onTap: widget.ontap,
          onScaleUpdate: widget.onscaleupdate,
          onScaleStart: widget.onscalestart,
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(64.0),
            child: Text(widget.mapJson['name']
                .toString(),textAlign: widget.mapJson['align'],
                style: TextStyle(
                  color: widget.mapJson['color'],
                  fontSize: widget.mapJson['size'],
                )),
          ),
        ),
      ),
    );
    /*return widget.mapJson['name']
        .toString()
        .text(
            textAlign: widget.mapJson['align'],
            style: TextStyle(
              color: widget.mapJson['color'],
              fontSize: widget.mapJson['size'],
            ))
        .xGesture(
          onTap: widget.ontap,
          //onPanUpdate: widget.onpanupdate,
          onScaleUpdate: widget.onscaleupdate,
          onScaleStart: widget.onscalestart,
        )
        .xPositioned(
          left: widget.left,
          top: widget.top,
        );*/
  }
}
