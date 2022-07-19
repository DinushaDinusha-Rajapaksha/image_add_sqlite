import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_application_image/model/Utility.dart';
import 'package:flutter_application_image/db/DBHelper.dart';
import 'package:flutter_application_image/model/photo.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  runApp(const SaveImageDemoSQLlite());
}

class SaveImageDemoSQLlite extends StatefulWidget {
  const SaveImageDemoSQLlite({Key? key}) : super(key: key);

  final String title = "Flutter save Image in SQLlite";

  @override
   _SaveImageDemoSQLliteState createState() => _SaveImageDemoSQLliteState();
}

class _SaveImageDemoSQLliteState   extends State<SaveImageDemoSQLlite> {
late Future<File> imageFile;
  late Image image;
  late DBHelper dbHelper;
  late List<photo> images;
  @override
  void initState() {
    super.initState();
    images = [];
    dbHelper = DBHelper();
    refreshImages();
  }

  refreshImages(){
    dbHelper.getPhotos().then((imgs) {
      setState(() {
      images.clear();
      images.addAll(imgs);
      });

    });
  }

  

  
  pickImageFromGallery() {
    
    ImagePicker().pickImage(source: ImageSource.gallery).then((imgFile) async {
      print("here");
      // String imgString = Utility.base64String(imgFile.readAsBytesSync());
      //final file = File(imgFile!.path);

    String imgString = Utility.base64String(await imgFile!.readAsBytes());
      //String imgString = Utility.base64String(file.readAsBytesSync());
      print(imgString);

      photo photo1 = photo(0, imgString);
      dbHelper.save(photo1);
      refreshImages();
    });
  }
  

  

  /*Future<File?> captureAndSaveImage() async {

final pickedImage = await ImagePicker().getImage(source: 
ImageSource.camera);
if (pickedImage == null) return null;
try {
final directory = await getExternalStorageDirectory();
if (directory != null) return 
File(pickedImage.path).copy('${directory.path}/name.png');
 } catch (e) {
return null;
 }
}
*/

/*Future<String?> convertImgToBase64() async {
    try {
      var imgFile;
      print("hello");
      File img = File(imgFile!.path);
      final splitted = imgFile!.path.split('.');
      final ext = splitted.last;
      final response = await img.readAsBytes();
      return "data:image/$ext;base64,${base64Encode(response)}";
    } catch (e) {
      //print(e.toString());
      return null;
    }
  }
  */

    gridView(){
      return Padding(
        padding: EdgeInsets.all(5.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: images.map((photo) {
            print("photo name");
            print(photo.photoName);
          return Utility.imageFromBase64String(photo.photoName ?? "");
        }).toList(),
          ),
        );
    }

  
// This widget is the root of your application.



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar:AppBar(
        title: Text("Gallery"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
            pickImageFromGallery();
             // File? file = await captureAndSaveImage();
             //convertImgToBase64();
            },
          )
            ],
        ),
        body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: gridView(),
            )
          ],
          ) ,
          ),
         ),
     theme: ThemeData(
       
        primarySwatch: Colors.teal,
      ),
      
    );
  }
}




