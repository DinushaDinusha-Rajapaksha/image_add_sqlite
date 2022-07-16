import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_application_image/model/Utility.dart';
import 'package:flutter_application_image/db/DBHelper.dart';
import 'package:flutter_application_image/model/photo.dart';

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
    ImagePicker().pickImage(source: ImageSource.gallery).then((imgFile) {
      String imgString = Utility.base64String(imgFile.readAsBytesSync());
      photo photo1 = photo(0, imgString, id: null, photoName: '');
      dbHelper.save(photo1);
      refreshImages();
    });
  }
    gridView(){
      return Padding(
        padding: EdgeInsets.all(5.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: images.map((photo) {
          return Utility.imageFromBase64String(photo.photoName);
        }).toList(),
          ),
        );
    }
  
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var widget;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              pickImageFromGallery();
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
      
    );
  }
}