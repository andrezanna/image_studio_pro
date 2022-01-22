import 'dart:io';
import 'package:image_editor_pro/image_editor_pro.dart';
import 'package:firexcode/firexcode.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomePage().xMaterialApp();
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
  VideoPlayerController videoController;

  Future<void> getimageditor() => Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ImageEditorPro(
          appBarColor: Colors.black87,
          bottomBarColor: Colors.black87,
          pathSave: null,
          defaultMedia: _defaultImage,
          isImage: false,
        );
      })).then((geteditimage)async{
        if (geteditimage != null) {
          try {
            Share.shareFiles([geteditimage.path]);
            print('BOBOBOBOBOBOBOB##################################');
            videoController = VideoPlayerController.file(geteditimage);
            if ((geteditimage as File).existsSync()) {
              print(geteditimage.path);
            }
            setState(() {
              _image = geteditimage;
              print("MALALAAAAAAAAAAAAA ${_image.toString()}");
            });
            await videoController.initialize();

            
            videoController.play();
          }catch(e){
            print("ERRRRRRR"+e);
          }
        }
      }).catchError((er) {
        print(er);
      });

  @override
  Widget build(BuildContext context) {
    return condition(
            condtion: _image == null,
            isTrue: XColumn(crossAxisAlignment: CrossAxisAlignment.center)
                .list([
                  TextField(
                    controller: controllerDefaultImage,
                    readOnly: true,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'No default image',
                    ),
                  ),
                  16.0.sizedHeight(),
                  'Set Default Image'.text().xRaisedButton(
                    onPressed: () async {
                      final imageGallery = await ImagePicker().getVideo(source: ImageSource.gallery);
                      if (imageGallery != null) {
                        _defaultImage = File(imageGallery.path);
                        setState(() => controllerDefaultImage.text = _defaultImage.path);
                      }
                    },
                  ),
                  'Open Editor'.text().xRaisedButton(
                    onPressed: () {
                      getimageditor();
                    },
                  ),
                ])
                .xCenter()
                .xap(value: 16),
            isFalse: _image == null ? Container() : VideoPlayer(videoController).toCenter())
        .xScaffold(
      appBar: 'Image Editor Pro example'.xTextColorWhite().xAppBar(),
      floatingActionButton: Icons.add.xIcons().xFloationActiobButton(
            color: Colors.red,
            onTap: () {
              videoController.play();
// TODO: I don't know what I'm doing in here
            },
          ),
    );
  }
}

Widget condition({bool condtion, Widget isTrue, Widget isFalse}) {
  return condtion ? isTrue : isFalse;
}
