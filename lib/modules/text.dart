import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'colors_picker.dart';

class TextEditorImage extends StatefulWidget {
  @override
  _TextEditorImageState createState() => _TextEditorImageState();
}

class _TextEditorImageState extends State<TextEditorImage> {
  TextEditingController name = TextEditingController();
  Color currentColor = Colors.black;
  double slider = 24.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: <Widget>[
            align == TextAlign.left
                ? ListTile(
                    title: Icon(
                      FontAwesomeIcons.alignRight,
                      color: Colors.white,
                    ),
                    onTap: () {
                      setState(() {
                        align = null;
                      });
                    })
                : ListTile(
                    title: Icon(FontAwesomeIcons.alignLeft),
                    onTap: () {
                      setState(() {
                        align = TextAlign.left;
                      });
                    }),
            align == TextAlign.center
                ? ListTile(
                    title: Icon(
                      FontAwesomeIcons.alignCenter,
                      color: Colors.white,
                    ),
                    onTap: () {
                      setState(() {
                        align = null;
                      });
                    })
                : ListTile(
                    title: Icon(
                      FontAwesomeIcons.alignCenter,
                    ),
                    onTap: () {
                      setState(() {
                        align = TextAlign.center;
                      });
                    }),
            align == TextAlign.right
                ? ListTile(
                    title: Icon(
                      FontAwesomeIcons.alignRight,
                      color: Colors.white,
                    ),
                    onTap: () {
                      setState(() {
                        align = null;
                      });
                    })
                : IconButton(
                    icon: Icon(FontAwesomeIcons.alignRight),
                    onPressed: () {
                      setState(() {
                        align = TextAlign.right;
                      });
                    }),
          ],
        ),
        bottomNavigationBar: FlatButton(
          color: Colors.black,
          padding: EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () {
            Navigator.pop(context, {
              'name': name.text,
              'color': currentColor,
              'size': slider.toDouble(),
              'align': align
            });
          },
          child: Text('Aggiungi Testo',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              )),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                height: MediaQuery.of(context).size.height / 2.2,
                child: TextField(
                  controller: name,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Inserisci il testo',
                    hintStyle: TextStyle(color: Colors.white),
                    alignLabelWithHint: true,
                  ),
                  scrollPadding: EdgeInsets.all(20.0),
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: 99999,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  autofocus: true,
                ),
              ),
              Container(
                color: Colors.white,
                child: Column(children: [
                  //   20.0.sizedHeight(),
                  Text('Colore'),
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
                              currentColor = Color(value);
                            });
                          }),
                    ),
                    FlatButton(child: Text('Resetta'), onPressed: () {})
                  ]),
                  //   20.0.sizedHeight(),
                  Text('Trasparenza'),
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
                              currentColor = Color(value);
                            });
                          }),
                    ),
                    FlatButton(child: Text('Resetta'), onPressed: () {})
                  ]),
                  Container(
                      color: Colors.black,
                      child: Column(children: [
                        SizedBox(height: 10.0),
                        Center(
                          child: Text(
                            'Dimensione'.toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Slider(
                            activeColor: Colors.white,
                            inactiveColor: Colors.grey,
                            value: slider,
                            min: 0.0,
                            max: 100.0,
                            onChangeEnd: (v) {
                              setState(() {
                                slider = v;
                              });
                            },
                            onChanged: (v) {
                              setState(() {
                                slider = v;
                              });
                            }),
                      ]))
                ]),
              ),
            ]),
          ),
        ));
  }

  TextAlign align;
}
