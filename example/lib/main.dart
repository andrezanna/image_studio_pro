import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_editor_pro/image_editor_pro.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controllerDefaultImage = TextEditingController();
  File _defaultImage;
  File _image;
  bool isImage = true;
  VideoPlayerController videoController;

  Future<void> getimageditor() =>
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ImageEditorPro(
          appBarColor: Colors.black87,
          bottomBarColor: Colors.black87,
          pathSave: null,
          defaultMedia: _defaultImage,
          isImage: isImage,
        );
      })).then((geteditimage) async {
        if (geteditimage != null) {
          try {
            print('BOBOBOBOBOBOBOB##################################');
            //isImage=true;
            if (!isImage) {
              videoController = VideoPlayerController.file(geteditimage);
              if ((geteditimage as File).existsSync()) {
                print(geteditimage.path);
              }
            }
            setState(() {
              _image = geteditimage;
              print("MALALAAAAAAAAAAAAA ${_image.toString()}");
            });
          } catch (e) {
            print("ERRRRRRR" + e);
          }
        }
      }).catchError((er) {
        print(er);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              'Image Editor Pro example',
              style: TextStyle(color: Colors.white),
            ),
            leading: InkWell(
              onTap: () {
                setState(() {
                  _image = null;
                });
              },
              child: Text("BACK"),
            )),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () async {
            await videoController.initialize();
            await videoController.play();
// TODO: I don't know what I'm doing in here
          },
          child: Icon(Icons.add),
        ),
        body: condition(
            condtion: _image == null,
            isTrue: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  TextField(
                    controller: controllerDefaultImage,
                    readOnly: true,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'No default image',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  RaisedButton(
                    child: Text('Set Default Image'),
                    onPressed: () async {
                      final imageGallery = await ImagePicker()
                          .getImage(source: ImageSource.gallery);
                      if (imageGallery != null) {
                        isImage = true;
                        _defaultImage = File(imageGallery.path);
                        setState(() =>
                            controllerDefaultImage.text = _defaultImage.path);
                      }
                    },
                  ),
                  RaisedButton(
                    child: Text('Set Default Video'),
                    onPressed: () async {
                      final imageGallery = await ImagePicker()
                          .getVideo(source: ImageSource.gallery);
                      if (imageGallery != null) {
                        isImage = false;
                        _defaultImage = File(imageGallery.path);
                        setState(() =>
                            controllerDefaultImage.text = _defaultImage.path);
                      }
                    },
                  ),
                  RaisedButton(
                    child: Text('Open Editor'),
                    onPressed: () {
                      getimageditor();
                    },
                  ),
                ])),
            isFalse: _image == null
                ? Container()
                : Center(
                    child: Container(
                        color: Colors.black,
                        child: isImage
                            ? Image.file(_image)
                            : AspectRatio(
                                aspectRatio: videoController.value.aspectRatio,
                                child: Center(
                                    child: VideoPlayer(videoController)))))));
  }
}

Widget condition({bool condtion, Widget isTrue, Widget isFalse}) {
  return condtion ? isTrue : isFalse;
}
