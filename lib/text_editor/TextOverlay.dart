import 'package:after_layout/after_layout.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import 'text_overlay_model.dart';

class TextOverlay extends StatefulWidget {
  final TextOverlayModel textOverlayModel;
  final VoidCallback updateCallback;
  final EdgeInsets devicePadding;
  final Function(TextOverlayModel) onTap;
  final Function(bool) draggingCallback;
  final GlobalKey parentWidgetKey;

  TextOverlay({
    Key key,
    @required this.textOverlayModel,
    @required this.updateCallback,
    @required this.devicePadding,
    @required this.onTap,
    @required this.draggingCallback,
    this.parentWidgetKey,
  }) : super(key: key);

  @override
  _TextOverlayState createState() => _TextOverlayState();
}

class _TextOverlayState extends State<TextOverlay> with AfterLayoutMixin<TextOverlay> {
  double scale;
  double rotation;

  ScaleUpdateDetails _lastScale;
  Size lastWidgetSize;

  GlobalKey widgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: reconsiderFocalPoint(widget.textOverlayModel.offset).dx,
      top: reconsiderFocalPoint(widget.textOverlayModel.offset).dy - widget.devicePadding.top,
      child: buildMainChild(32.0, widgetKey),
    );
  }

  Widget buildMainChild(double padding, GlobalKey childKey) {
    final box = widget.parentWidgetKey.currentContext.findRenderObject() as RenderBox;

    Widget movableChild = Container(
      //color: Colors.green,
      width: box.size.width,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Transform(
          transform: Matrix4.diagonal3(vector.Vector3(scale ?? widget.textOverlayModel.scale, scale ?? widget.textOverlayModel.scale, scale ?? widget.textOverlayModel.scale))
            ..rotateZ(rotation ?? widget.textOverlayModel.rotation),
          alignment: FractionalOffset.center,
          child: Text(
            widget.textOverlayModel.text,
            style: widget.textOverlayModel.textStyle,
            softWrap: true,
            textAlign: widget.textOverlayModel.align,
            maxLines: 15,

          ),
        ),
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      key: childKey,
      onTap: () {
        widget.onTap(widget.textOverlayModel);
      },
      dragStartBehavior: DragStartBehavior.down,
      /*onHorizontalDragUpdate: (details){

        widget.textOverlayModel.offset = Offset(details.globalPosition.dx,details.globalPosition.dy);
        widget.draggingCallback(true);
        setState(() {});
      },*/
      /*onVerticalDragUpdate: (details){

        widget.textOverlayModel.offset = Offset(details.globalPosition.dx,details.globalPosition.dy);
        widget.draggingCallback(true);
        setState(() {});
      },*/
      onScaleUpdate: (ScaleUpdateDetails details) {
        scale = widget.textOverlayModel.scale * details.scale;
        rotation = widget.textOverlayModel.rotation + details.rotation;
        _lastScale = details;
        widget.textOverlayModel.offset = details.focalPoint;
        widget.draggingCallback(true);
        setState(() {});
        // widget.updateCallback.call();
      },
      onScaleEnd: (ScaleEndDetails details) {
        // debugPrint("Finito lo scalo del widget.");
        widget.textOverlayModel.scale *= _lastScale.scale;
        widget.textOverlayModel.rotation += _lastScale.rotation;
        widget.updateCallback.call();
        widget.draggingCallback(false);
      },
      child: movableChild,
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() => lastWidgetSize = widgetKey.currentContext.size);
  }

  Offset reconsiderFocalPoint(Offset focalPoint, [bool add = false]) {
    final box = widget.parentWidgetKey.currentContext.findRenderObject() as RenderBox;
    final pos = box.localToGlobal(Offset.zero);
    /*print("############");
    print(box.size.width);
    print(box.size.height);
    print(-box.size.width/2);
    print(box.size.height/2-84);
    print(focalPoint.toString());
    print("--------------");*/
    //print(focalPoint.toString());
    /*
      left: widget.textOverlayModel.offset.dx - widget.devicePadding.top - (lastWidgetSize?.height ?? 0.0 / 2),
      top: widget.textOverlayModel.offset.dy - (lastWidgetSize?.width ?? 0.0 / 2),
     */
    //print(focalPoint.toString());
    //return focalPoint;
    if (widget.textOverlayModel.offset==null) {
      return Offset(
          focalPoint.dx-box.size.width/2-pos.dx,
          focalPoint.dy-pos.dy
      );
    } else {
      return Offset(
          focalPoint.dx-box.size.width/2-pos.dx,
          focalPoint.dy-pos.dy
      );
    }
  }
}
