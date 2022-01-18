import 'package:flutter/material.dart';
class TextOverlayModel {
  final String id;
  String text;
  TextStyle textStyle;
  TextAlign align;

  double scale = 1.0;
  double rotation = 0.0;

  Offset offset;
  ScaleStartDetails scaleStart;

  TextOverlayModel({
    @required this.id,
    @required this.text,
    @required this.textStyle,
    @required this.offset,
    this.align = TextAlign.center,
  });

  Map toMap(){
    var map=<String,dynamic>{};
    map['id']=id;
    map['text']=text;
    map['textStyle']=textStyle;
    map['offset']=offset;
    map['scale']=scale;
    map['rotation']=rotation;
    return map;
}
}
