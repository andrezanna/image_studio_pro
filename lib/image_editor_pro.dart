import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_editor_pro/modules/sliders.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_editor_pro/modules/all_emojies.dart';
import 'package:image_editor_pro/modules/bottombar_container.dart';
import 'package:image_editor_pro/modules/emoji.dart';
import 'package:image_editor_pro/modules/text.dart';
import 'package:image_editor_pro/modules/textview.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:random_string/random_string.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';
import 'package:firexcode/firexcode.dart';
import 'dart:math' as math;
import 'package:text_editor/text_editor.dart' as emilio;
import 'package:video_player/video_player.dart';
import 'modules/color_filter_generator.dart';
import 'modules/colors_picker.dart';
import 'text_editor/TextOverlay.dart';
import 'text_editor/text_overlay_model.dart'; // import this

TextEditingController heightcontroler = TextEditingController();
TextEditingController widthcontroler = TextEditingController();
var width = 300;
var height = 300;
List<Map> widgetJson = [];
//List fontsize = [];
//List<Color> colorList = [];
var howmuchwidgetis = 0;
//List multiwidget = [];
Color currentcolors = Colors.white;
var opicity = 0.0;
SignatureController _controller = SignatureController(penStrokeWidth: 5, penColor: Colors.green);

class ImageEditorPro extends StatefulWidget {
  final Color appBarColor;
  final Color bottomBarColor;
  final Directory pathSave;
  final File defaultMedia;
  final double pixelRatio;
  final String language;
  final bool isImage;

  ImageEditorPro({
    this.language,
    this.appBarColor,
    this.bottomBarColor,
    this.pathSave,
    this.defaultMedia,
    this.pixelRatio,
    this.isImage=true,
  });

  @override
  _ImageEditorProState createState() => _ImageEditorProState();
}

var slider = 0.0;

class _ImageEditorProState extends State<ImageEditorPro> {
  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  double oldScale=1.0;
  double oldRotation=1.0;
  Offset oldOffset=Offset(0,0);

  bool showSlider=false;

  bool isWorking=false;
// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    var points = _controller.points;
    _controller = SignatureController(penStrokeWidth: 5, penColor: color, points: points);

  }

  List<Offset> offsets = [];
  Offset offset1 = Offset.zero;
  Offset offset2 = Offset.zero;
  final scaf = GlobalKey<ScaffoldState>();
  var openbottomsheet = false;
  List<Offset> _points = <Offset>[];
  List type = [];
  List aligment = [];

  final GlobalKey container = GlobalKey();
  final GlobalKey globalKey = GlobalKey();
  File media;
  VideoPlayerController videoController;
  ScreenshotController screenshotController = ScreenshotController();
  Timer timeprediction;


  static const List<String> fontNames = <String>[
    'MuseoModerno',
    'Raunchers',
    'Poppins',
    'Redressed',
  ];
  static TextStyle defaultOverlayTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 38.0,
    fontFamily: 'MuseoModerno',
  );
  final List<TextOverlayModel> textOverlays = <TextOverlayModel>[];
  final TextEditingController textEditingController = TextEditingController();
  final GlobalKey repaintBoundaryKey = GlobalKey();
  final GlobalKey textEditingKey = GlobalKey();
  bool showTextOverlay = false;
  bool dragging = false;
  TextOverlayModel currentOverlay;


  void timers() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.defaultMedia != null && widget.defaultMedia.existsSync()) {
        loadMedia(widget.defaultMedia);
      }
    });
    Timer.periodic(Duration(milliseconds: 10), (tim) {
      setState(() {});
      timeprediction = tim;
    });
  }

  @override
  void dispose() {
    timeprediction.cancel();
    _controller.clear();
    widgetJson.clear();
    heightcontroler.clear();
    widthcontroler.clear();
    super.dispose();
  }

  @override
  void initState() {
    timers();
    _controller.clear();
    type.clear();
    //  fontsize.clear();
    offsets.clear();
    //  multiwidget.clear();
    howmuchwidgetis = 0;

    super.initState();
  }

  double flipValue = 0;
  int rotateValue = 0;
  double blurValue = 0;
  double opacityValue = 0;
  Color colorValue = Colors.transparent;

  double hueValue = 0;
  double brightnessValue = 0;
  double saturationValue = 0;

  bool enableBrush=false;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: rotateValue,
      child:  imageFilterLatest(
          hue: hueValue,
          brightness: brightnessValue,
          saturation: saturationValue,
          child: Container(
            //color: Colors.blue,
            child: Stack(

              children: [
                !widget.isImage?
                Center(
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(flipValue),
                    child: ClipRect(
                      // <-- clips to the 200x200 [Container] below

                      child: Container(
                          padding: EdgeInsets.zero,
                          // alignment: Alignment.center,
                          //width: width.toDouble(),
                          //height: height.toDouble(),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: blurValue,
                              sigmaY: blurValue,
                            ),
                            child: Container(
                              color: colorValue.withOpacity(opacityValue),
                              child: AspectRatio(
                                aspectRatio: videoController.value.aspectRatio,
                                child: VideoPlayer(videoController,
                                ),
                              ),
                            ),
                          )),
                    ),
                  ),
                ):Container(),
                Center(
                  child: AspectRatio(
                    aspectRatio: width/height,
                    child: Screenshot(
        controller: screenshotController,
        child:RepaintBoundary(
                        key: globalKey,
                        child: xStack.list(
                          [
                            widget.isImage && media != null
                                ? Center(

                                    child: Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationY(flipValue),
                                        child: ClipRect(
                                          // <-- clips to the 200x200 [Container] below

                                          child: media.path.decorationIFToContain().xContainer(
                                              padding: EdgeInsets.zero,
                                              // alignment: Alignment.center,
                                              //width: width.toDouble(),
                                              //height: height.toDouble(),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                  sigmaX: blurValue,
                                                  sigmaY: blurValue,
                                                ),
                                                child: Container(
                                                  color: colorValue.withOpacity(opacityValue),
                                                ),
                                              )),
                                        ),
                                      ),
                                  )


                                //  BackdropFilter(
                                //     filter: ImageFilter.blur(
                                //         sigmaX: 10.0, sigmaY: 10.0, tileMode: TileMode.clamp),
                                //     child: Image.file(
                                //       _image,
                                //       height: height.toDouble(),
                                //       width: width.toDouble(),
                                //       fit: BoxFit.cover,
                                //     ),
                                //   )

                                : Container(),
                            AbsorbPointer(
                              absorbing:!enableBrush,
                                child: Signat().xGesture(
                                onPanUpdate: (DragUpdateDetails details) {
                                    setState(() {
                                      //print("update");
                                      RenderBox object = context.findRenderObject();
                                      var _localPosition = object.globalToLocal(
                                          details.globalPosition);
                                      _points = List.from(_points)
                                        ..add(_localPosition);
                                    });

                                },
                                onPanEnd: (DragEndDetails details) {
                                  _points.add(null);
                                },
                              ).xContainer(padding: EdgeInsets.all(0.0)),
                            ),
                            xStack.list(
                              widgetJson.asMap().entries.map((f) {
                                return type[f.key] == 1
                                    ? EmojiView(
                                        left: offsets[f.key].dx,
                                        top: offsets[f.key].dy,
                                        ontap: () {

                                            scaf.currentState.showBottomSheet((
                                                context) {
                                              return Sliders(
                                                index: f.key,
                                                mapValue: f.value,
                                                onlySize: true,
                                              );
                                            });

                                        },
                                        /*onpanupdate: (details) {
                                          setState(() {
                                            offsets[f.key] =
                                                Offset(offsets[f.key].dx + details.delta.dx, offsets[f.key].dy + details.delta.dy);
                                          });
                                        },*/
                                        onscalestart:(details){
                                          if(details.pointerCount==1){
                                            oldScale=-1;
                                            oldRotation= widgetJson[f.key]['rotation'];
                                            oldOffset=offsets[f.key];
                                            //print("single");
                                          }else {
                                            oldScale = widgetJson[f.key]['size'];
                                            oldRotation= widgetJson[f.key]['rotation'];
                                          }
                                                //oldScale=details.;
                                        },
                                        onscaleupdate: (details){
                                          setState((){
                                            if(oldScale==-1) {
                                              //print(details.localFocalPoint);
                                              //print(details.delta);
                                              offsets[f.key] =
                                                  Offset(oldOffset.dx +
                                                      details.delta.dx,
                                                      oldOffset.dy +
                                                          details.delta.dy);
                                            }else {
                                              widgetJson[f.key]['size'] =
                                                  oldScale * details.scale;
                                            }
                                            //print(oldRotation);
                                            //print(details.rotation);
                                              widgetJson[f.key]['rotation'] =
                                                  oldRotation + details.rotation;

                                          });
                                        },

                                        mapJson: f.value,
                                      )

                                        : Container();
                              }).toList(),

                            ),
                            RepaintBoundary(
                            key: repaintBoundaryKey,
                            child: Stack(
                              children: List<Widget>.generate(
                                textOverlays.length,
                                    (int index) => TextOverlay(
                                  textOverlayModel: textOverlays.elementAt(index),
                                  updateCallback: () => setState(() {}),
                                  devicePadding: EdgeInsets.zero,//MediaQuery.of(context).padding,
                                  onTap: (textOverlay) =>
                                      startEditingTextOverlay(textOverlay),
                                  draggingCallback: (bool dragging) =>
                                      setState(() => this.dragging = dragging),
                                      parentWidgetKey: globalKey,
                                ),
                              ),
                            ),
                          ),
                          ],
                        )),
                  ),
        ),
                ),
                if(isWorking)
                  Center(child: Container(width:double.infinity,color: Colors.black54,child: Column(mainAxisSize: MainAxisSize.max,mainAxisAlignment: MainAxisAlignment.spaceEvenly,crossAxisAlignment: CrossAxisAlignment.center,children: [Text("Video in elaborazione...",style: TextStyle(color: Colors.white),),CircularProgressIndicator()],),))

              ],
            ),
          ),
      ),
    ).xCenter().xScaffold(
        backgroundColor: Colors.grey.shade400,
        key: scaf,
        appBar: AppBar(
          actions: <Widget>[

            'Salva'.text().xFlatButton(
                primary: Colors.white,
                onPressed: () {
                  if(widget.isImage) {
                    screenshotController.capture(
                        pixelRatio: MediaQuery.of(context).devicePixelRatio).then((
                        binaryIntList) async {
                      //print("Capture Done");

                      final paths = widget.pathSave ??
                          await getTemporaryDirectory();

                      final file = await File('${paths.path}/' + DateTime.now()
                          .toString() + '.jpg').create();
                      print(file.path);
                      file.writeAsBytesSync(binaryIntList);
                      //file.copySync('${paths.path}/resized.jpg');
                      Navigator.pop(context, file);
                    }).catchError((onError) {
                      print(onError);
                    });
                  }else{
                    screenshotController.capture(
                        pixelRatio: MediaQuery.of(context).devicePixelRatio).then((
                        binaryIntList) async {
                      //print("Capture Done");

                      setState((){isWorking=true;});
                      final paths = widget.pathSave ??
                          await getTemporaryDirectory();

                      final file = await File('${paths.path}/' + DateTime.now()
                          .toString() + '.jpg').create();
                      print(file.path);
                      file.writeAsBytesSync(binaryIntList);
                      final result=await _blendMedia(overlay: file,mediaFile: widget.defaultMedia);
                      print(result.existsSync());
                      setState((){isWorking=false;});

                      Navigator.pop(context, result);

                    }).catchError((onError) {
                      print(onError);
                    });
                  }
                })
          ],
          brightness: Brightness.dark,
          // backgroundColor: Colors.red,
          backgroundColor: widget.appBarColor ?? Colors.black87,
        ),
        bottomNavigationBar: openbottomsheet
            ? Container()
            : XListView(
                scrollDirection: Axis.horizontal,
              ).list(
                <Widget>[
                  BottomBarContainer(
                    colors: widget.bottomBarColor,
                    icons: FontAwesomeIcons.brush,
                    ontap: () {
                      enableBrush=!enableBrush;

                      // raise the [showDialog] widget
                      if(enableBrush) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: 'Scegli il colore!'.text(),
                              content: ColorPicker(
                                pickerColor: pickerColor,
                                onColorChanged: changeColor,
                                showLabel: true,
                                pickerAreaHeightPercent: 0.8,
                              ).xSingleChildScroolView(),
                              actions: <Widget>[
                                'Accetta'.text().xFlatButton(
                                  onPressed: () {
                                    setState(() => currentColor = pickerColor);
                                    back(context);
                                  },
                                )
                              ],
                            );
                          },
                        );
                      }
                      setState(() {

                      });
                    },
                    title: 'Pennello',
                  ),
                  BottomBarContainer(
                    colors: widget.bottomBarColor,
                    icons: Icons.text_fields,
                    ontap: () async {
                      startEditingTextOverlay(null);

                    },
                    title: 'Testo',
                  ),
/*
                  BottomBarContainer(
                    colors: widget.bottomBarColor,
                    icons: Icons.photo,
                    ontap: () {
                      showModalBottomSheet(
                          shape:
                              BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)).xShapeBorder(),
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setS) {
                                return xColumnCC.list([
                                  5.0.sizedHeight(),
                                  'Tinta'.xTextColorWhite(),
                                  10.0.sizedHeight(),
                                  xRow.list([
                                    Slider(
                                        activeColor: Colors.white,
                                        inactiveColor: Colors.grey,
                                        value: hueValue,
                                        min: -10.0,
                                        max: 10.0,
                                        onChanged: (v) {
                                          setS(() {
                                            setState(() {
                                              hueValue = v;
                                            });
                                          });
                                        }).xExpanded(),
                                    'Resetta'.xTextColorWhite().xFlatButton(onPressed: () {
                                      setS(() {
                                        setState(() {
                                          blurValue = 0.0;
                                        });
                                      });
                                    })
                                  ]),
                                  5.0.sizedHeight(),
                                  'Saturazione'.xTextColorWhite(),
                                  10.0.sizedHeight(),
                                  xRow.list([
                                    Slider(
                                        activeColor: Colors.white,
                                        inactiveColor: Colors.grey,
                                        value: saturationValue,
                                        min: -10.0,
                                        max: 10.0,
                                        onChanged: (v) {
                                          setS(() {
                                            setState(() {
                                              saturationValue = v;
                                            });
                                          });
                                        }).xExpanded(),
                                    'Resetta'.xTextColorWhite().xFlatButton(onPressed: () {
                                      setS(() {
                                        setState(() {
                                          saturationValue = 0.0;
                                        });
                                      });
                                    })
                                  ]),
                                  5.0.sizedHeight(),
                                  'Luminosità'.xTextColorWhite(),
                                  10.0.sizedHeight(),
                                  xRow.list([
                                    Slider(
                                        activeColor: Colors.white,
                                        inactiveColor: Colors.grey,
                                        value: brightnessValue,
                                        min: 0.0,
                                        max: 1.0,
                                        onChanged: (v) {
                                          setS(() {
                                            setState(() {
                                              brightnessValue = v;
                                            });
                                          });
                                        }).xExpanded(),
                                    'Resetta'.xTextColorWhite().xFlatButton(onPressed: () {
                                      setS(() {
                                        setState(() {
                                          brightnessValue = 0.0;
                                        });
                                      });
                                    })
                                  ])
                                ]);
                              },
                            ).xContainer(
                                color: Colors.black87,
                                height: 300,
                                borderRadius:
                                    BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)));
                          });
                    },
                    title: 'Filtro',
                  ),*/
                  BottomBarContainer(
                    colors: widget.bottomBarColor,
                    icons: FontAwesomeIcons.smile,
                    ontap: () {
                      var getemojis = showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Emojies();
                          });
                      getemojis.then((value) {
                        if (value['name'] != null) {
                          final box = globalKey.currentContext.findRenderObject() as RenderBox;
                          print(box.size.width);
                          print(box.size.height);
                          print(box.size.width/2-84);
                          print(box.size.height/2-84);
                          type.add(1);
                          widgetJson.add(value);
                          offsets.add(Offset(box.size.width/2-84,box.size.height/2-84));
                          //  multiwidget.add(value);
                          howmuchwidgetis++;
                        }
                      });
                    },
                    title: 'Emoji',
                  ),
                  BottomBarContainer(
                    colors: widget.bottomBarColor,
                    icons: Icons.flip,
                    ontap: () {
                      setState(() {
                        flipValue = flipValue == 0 ? math.pi : 0;
                      });
                    },
                    title: 'Inverti',
                  ),
                  BottomBarContainer(
                    colors: widget.bottomBarColor,
                    icons: Icons.rotate_left,
                    ontap: () {
                      setState(() {
                        rotateValue--;
                      });
                    },
                    title: 'Rotazione sinistra',
                  ),
                  BottomBarContainer(
                    colors: widget.bottomBarColor,
                    icons: Icons.rotate_right,
                    ontap: () {
                      setState(() {
                        rotateValue++;
                      });
                    },
                    title: 'Rotazione destra',
                  ),
                  /*BottomBarContainer(
                    colors: widget.bottomBarColor,
                    icons: Icons.blur_on,
                    ontap: () {
                      showModalBottomSheet(
                        shape: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)).xShapeBorder(),
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setS) {
                              return xColumn.list(
                                [
                                  'Colore Filtro'.toUpperCase().xTextColorWhite().toCenter(),
                                  Divider(

                                      // height: 1,
                                      ),
                                  20.0.sizedHeight(),
                                  'Colore'.xTextColorWhite(),
                                  //   10.0.sizedHeight(),
                                  xRowCC.list([
                                    BarColorPicker(
                                        width: 300,
                                        thumbColor: Colors.white,
                                        cornerRadius: 10,
                                        pickMode: PickMode.Color,
                                        colorListener: (int value) {
                                          setS(() {
                                            setState(() {
                                              colorValue = Color(value);
                                            });
                                          });
                                        }).xExpanded(),
                                    'Reset'.xTextColorWhite().xFlatButton(onPressed: () {
                                      setState(() {
                                        setS(() {
                                          colorValue = Colors.transparent;
                                        });
                                      });
                                    })
                                  ]),
                                  5.0.sizedHeight(),
                                  'Slider Blur'.xTextColorWhite(),
                                  10.0.sizedHeight(),
                                  xRow.list([
                                    Slider(
                                        activeColor: Colors.white,
                                        inactiveColor: Colors.grey,
                                        value: blurValue,
                                        min: 0.0,
                                        max: 10.0,
                                        onChanged: (v) {
                                          setS(() {
                                            setState(() {
                                              blurValue = v;
                                            });
                                          });
                                        }).xExpanded(),
                                    'Reset'.xTextColorWhite().xFlatButton(onPressed: () {
                                      setS(() {
                                        setState(() {
                                          blurValue = 0.0;
                                        });
                                      });
                                    })
                                  ]),
                                  5.0.sizedHeight(),
                                  'Slider Opacity'.xTextColorWhite(),
                                  10.0.sizedHeight(),
                                  xRow.list([
                                    Slider(
                                        activeColor: Colors.white,
                                        inactiveColor: Colors.grey,
                                        value: opacityValue,
                                        min: 0.00,
                                        max: 1.0,
                                        onChanged: (v) {
                                          setS(() {
                                            setState(() {
                                              opacityValue = v;
                                            });
                                          });
                                        }).xExpanded(),
                                    'Reset'.xTextColorWhite().xFlatButton(onPressed: () {
                                      setS(() {
                                        setState(() {
                                          opacityValue = 0.0;
                                        });
                                      });
                                    })
                                  ]),
                                ],
                              ).toContainer(
                                borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                                padding: EdgeInsets.all(20),
                                height: 400,
                                color: Colors.black87,
                              );
                            },
                          );
                        },
                      );
                    },
                    title: 'Blur',
                  ),*/
                  BottomBarContainer(
                    colors: widget.bottomBarColor,
                    icons: FontAwesomeIcons.eraser,
                    ontap: () {
                      _controller.clear();
                      //  type.clear();
                      // // fontsize.clear();
                      //  offsets.clear();
                      // // multiwidget.clear();
                      howmuchwidgetis = 0;
                    },
                    title: 'Cancella',
                  ),
                ],
              ).xContainer(
                padding: EdgeInsets.all(0.0),
                blurRadius: 10.9,
                shadowColor: widget.bottomBarColor,
                height: 70,
              ));
  }

  final picker = ImagePicker();

  void bottomsheets() {
    openbottomsheet = true;
    setState(() {});
    var future = showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return xColumn.list(
          [
            'Select Image Options'.text().xCenter(),
            10.0.sizedHeight(),
            Divider(
              height: 1,
            ),
            xRowCC.list(
              [
                xColumnCC.list(
                  [Icon(Icons.photo_library).xIconButton(), 10.0.sizedWidth(), 'Open Gallery'.text()],
                ).xContainer(
                  onTap: () async {
                    var image = await picker.getImage(source: ImageSource.gallery);
                    await loadMedia(File(image.path));
                    Navigator.pop(context);
                  },
                ),
                24.0.sizedWidth(),
                xColumnCC.list(
                  [
                    Icon(Icons.camera_alt).xIconButton(),
                    10.0.sizedWidth(),
                    'Open Camera'.text(),
                  ],
                ).xContainer(onTap: () async {
                  var image = await picker.getImage(source: ImageSource.camera);
                  var decodedImage = await decodeImageFromList(File(image.path).readAsBytesSync());

                  setState(() {
                    height = decodedImage.height;
                    width = decodedImage.width;
                    media = File(image.path);
                  });
                  setState(() => _controller.clear());
                  Navigator.pop(context);
                })
              ],
            ).xContainer(
              padding: EdgeInsets.all(20),
            )
          ],
        ).xContainer(
          padding: EdgeInsets.all(0.0),
          color: Colors.white,
          //   blurRadius: 10.9,
          //shadowColor: Colors.grey[400],
          height: 170,
        );
      },
    );
    future.then((void value) => _closeModal(value));
  }

  Future<void> loadMedia(File file) async {
    if(widget.isImage) {
      final decodedImage = await decodeImageFromList(file.readAsBytesSync());
      setState(() {
        height = decodedImage.height;
        width = decodedImage.width;
        //print(height);
        //print(width);
        media = file;
      });
    }else{

      videoController = VideoPlayerController.file(file);//Your file here
      await videoController.initialize();
      await videoController.setLooping(true);
      await videoController.play();
      height=videoController.value.size.height.floor();
      width=videoController.value.size.width.floor();
      setState((){});
    }
    _controller.clear();

  }

  void _closeModal(void value) {
    openbottomsheet = false;
    setState(() {});
  }


  void _tapHandler(TextOverlayModel overlay) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(
        milliseconds: 400,
      ), // how long it takes to popup dialog after button click
      pageBuilder: (_, __, ___) {
        // your widget implementation
        return Container(
          color: Colors.black.withOpacity(0.4),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              // top: false,
              child: Container(
                child: emilio.TextEditor(
                  fonts: fontNames,
                  text: overlay.text,
                  textStyle: overlay.textStyle,
                  textAlingment: overlay.align,
                  onEditCompleted: (style, align, text) {
                    final box = globalKey.currentContext.findRenderObject() as RenderBox;
                    final pos = box.localToGlobal(Offset.zero);

                    currentOverlay.text = text;
                    currentOverlay.textStyle = style;
                    currentOverlay.align = align;
                    currentOverlay.offset ??= Offset(
                      box.size.width/2+pos.dx,
                      box.size.height/ 2+pos.dy,
                    );

                      //type.add(2);
                      //widgetJson.add(currentOverlay.toMap());
                      // fontsize.add(20);
                      //offsets.add(Offset(150,150));
                      //  colorList.add(value['color']);
                      //    multiwidget.add(value['name']);
                      //howmuchwidgetis++;

                    addTextOverlay(currentOverlay);
                    Navigator.pop(context);
                  },
                  onCancel: () {
                    //print("onCane ${currentOverlay.id} ");
                    //widgetJson.removeWhere((element) => element['id'] == currentOverlay.id);
                    textOverlays.removeWhere(
                            (element) =>element.id == currentOverlay.id);
                    stopEditingTextOverlay();
                    Navigator.of(context).pop();
                  },
                  doneText: 'OK',
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  void addTextOverlay(TextOverlayModel newTextOverlay) =>
      setState(() => textOverlays.add(newTextOverlay));

  void startEditingTextOverlay(TextOverlayModel textOverlay) {
    debugPrint('Cominciamo ad editare il testo sopra una storia / reel.');

    if (textOverlay != null) {
      currentOverlay = textOverlay;
      textOverlays.removeWhere((element) => element.id == currentOverlay.id);
    } else {
      currentOverlay = TextOverlayModel(
        id: randomAlphaNumeric(20),
        text: '',
        textStyle: defaultOverlayTextStyle,
        offset: null,
      );
    }

    _tapHandler(currentOverlay);
  }

  void stopEditingTextOverlay() {
    currentOverlay = null;
    showTextOverlay = false;
    setState(() {});
  }

  static Future<File> _blendMedia({@required File mediaFile,@required File overlay,}) async {
      final ffmpeg = FlutterFFmpeg();
      final outputPath = mediaFile.path.substring(0, mediaFile.path.lastIndexOf('.')) + '-blended.mp4';
      print('ffmpeg -y -i \"${mediaFile.path}\" -i \"${overlay.path}\" -filter_complex \"[0:v][1:v] overlay=0:0\" -c:a copy \"$outputPath\"');
      await ffmpeg.execute(// -pix_fmt yuv420p
          '-y -i \"${mediaFile.path}\" -i \"${overlay.path}\"  -filter_complex \"[1:v]scale=$width:$height [ovrl],[0:v][ovrl]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2\" -qscale 0 -c:a copy \"$outputPath\"');

      print(outputPath);

      return File(outputPath);

  }
}

class Signat extends StatefulWidget {
  @override
  _SignatState createState() => _SignatState();
}

class _SignatState extends State<Signat> {
  @override
  void initState() {
    super.initState();
    //_controller.addListener(() => print('Value changed'));
  }

  @override
  Widget build(BuildContext context) {
    return xListView.list(
      [
        Signature(
            controller: _controller,
            height: height.toDouble(),
            width: width.toDouble(),
            backgroundColor: Colors.transparent),
      ],
    );
  }
}

Widget imageFilterLatest({brightness, saturation, hue, child}) {
  return ColorFiltered(
      colorFilter: ColorFilter.matrix(ColorFilterGenerator.brightnessAdjustMatrix(
        value: brightness,
      )),
      child: ColorFiltered(
          colorFilter: ColorFilter.matrix(ColorFilterGenerator.saturationAdjustMatrix(
            value: saturation,
          )),
          child: ColorFiltered(
            colorFilter: ColorFilter.matrix(ColorFilterGenerator.hueAdjustMatrix(
              value: hue,
            )),
            child: child,
          )));
}
