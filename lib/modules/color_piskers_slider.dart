import 'package:flutter/material.dart';

import 'colors_picker.dart';

class ColorPiskersSlider extends StatefulWidget {
  @override
  _ColorPiskersSliderState createState() => _ColorPiskersSliderState();
}

class _ColorPiskersSliderState extends State<ColorPiskersSlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(20),
      height: 240,
      child: Column(
        children: [
          Center(child: Text('Slider Filter Color'.toUpperCase())),
          Divider(
              // height: 1,
              ),
          SizedBox(height: 20.0),
          Text('Slider Color'),
          //   10.0.sizedHeight(),
          Row(children: [
            Expanded(
              child: BarColorPicker(
                  width: 300,
                  thumbColor: Colors.white,
                  cornerRadius: 10,
                  pickMode: PickMode.Color,
                  colorListener: (int value) {
                    setState(() {
                      //  currentColor = Color(value);
                    });
                  }),
            ),
            FlatButton(child: Text('Resetta'), onPressed: () {}),
          ]),
          SizedBox(
            height: 5,
          ),
          Text('Slider Opicity'),
          SizedBox(
            height: 10,
          ),
          Row(children: [
            Expanded(
                child:
                    Slider(value: 0.1, min: 0.0, max: 1.0, onChanged: (v) {})),
            FlatButton(child: Text('Resetta'), onPressed: () {}),
          ]),
        ],
      ),
    );
  }
}
