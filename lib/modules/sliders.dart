import 'package:flutter/material.dart';

import '../image_editor_pro.dart';
import 'colors_picker.dart';

class Sliders extends StatefulWidget {
  final int index;
  final Map mapValue;
  final bool onlySize;

  const Sliders({Key key, this.mapValue, this.index, this.onlySize = false})
      : super(key: key);

  @override
  _SlidersState createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {
  @override
  void initState() {
    //  slider = widget.sizevalue;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
              child: Text('Dimensione'.toUpperCase(),
                  style: TextStyle(color: Colors.white))),
          Divider(

              // height: 1,
              ),
          Slider(
              activeColor: Colors.white,
              inactiveColor: Colors.grey,
              value: widgetJson[widget.index]['size'],
              min: 0.0,
              max: 200.0,
              onChangeEnd: (v) {
                setState(() {
                  widgetJson[widget.index]['size'] = v.toDouble();
                });
              },
              onChanged: (v) {
                setState(() {
                  slider = v;
                  // print(v.toDouble());
                  widgetJson[widget.index]['size'] = v.toDouble();
                });
              }),
          SizedBox(height: 10.0),
          if (!widget.onlySize)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(children: [
                SizedBox(height: 20.0),
                Text('Colore'),
                //   10.0.sizedHeight(),
                Row(children: [
                  BarColorPicker(
                      width: 300,
                      thumbColor: Colors.white,
                      cornerRadius: 10,
                      pickMode: PickMode.Color,
                      colorListener: (int value) {
                        setState(() {
                          widgetJson[widget.index]['color'] = Color(value);
                        });
                      }),
                  FlatButton(child: Text('Resetta'), onPressed: () {}),
                ]),
                //   20.0.sizedHeight(),
                Text('Saturazione'),
                //   10.0.sizedHeight(),
                Row(children: [
                  Expanded(
                    child: BarColorPicker(
                        width: 300,
                        thumbColor: Colors.white,
                        cornerRadius: 10,
                        pickMode: PickMode.Grey,
                        colorListener: (int value) {
                          setState(() {
                            widgetJson[widget.index]['color'] = Color(value);
                          });
                        }),
                  ),
                  FlatButton(child: Text('Resetta'), onPressed: () {}),
                ]),
              ]),
            ),
          SizedBox(height: 10.0),
          FlatButton(
            color: Colors.white,
            onPressed: () {
              widgetJson.removeAt(widget.index);
              Navigator.of(context).maybePop();
              // setState(() {});
            },
            child: Text("Rimuovi"),
          ),
        ],
      ),
    );
  }
}
