import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent_a_roo/controls/services/listings.dart';
import 'package:rent_a_roo/controls/services/user.dart';
import 'package:rent_a_roo/landingpage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/foundation.dart';

class AddImagesScreen extends StatefulWidget {
  AddImagesScreen({
    Key? key,required this.listingid
  }) : super(key: key);
  int listingid;
  @override
  State<AddImagesScreen> createState() => _AddImagesScreenState();
}

var alertStyle = AlertStyle(
  animationType: AnimationType.fromTop,
  isCloseButton: false,
  isOverlayTapDismiss: false,
  descStyle: TextStyle(fontWeight: FontWeight.bold),
  animationDuration: Duration(milliseconds: 400),
  alertBorder: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
    side: BorderSide(
      color: Colors.grey,
    ),
  ),
  titleStyle: TextStyle(
    color: Colors.red,
  ),
);

class _AddImagesScreenState extends State<AddImagesScreen> {
  List imgList = [];
  Uint8List? bytes;
  Uint8List? uploadedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Select Images',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () async {
              
                if (imgList != null && imgList.isNotEmpty) {
                  var resp;
                  for (int i = 0; i < imgList.length; i++) {
                    resp = await Listing().updatePhoto(imgList[i]!,widget.listingid);
                    print(resp.body);
                  }

                  if (resp.statusCode == 201) {
                    var a = await Alert(
                      context: context,
                      style: alertStyle,
                      type: AlertType.success,
                      title: "Success !",
                      desc: "Listing successful.",
                      buttons: [
                        DialogButton(
                          radius: BorderRadius.circular(5.0),
                          child: Text(
                            "Ok",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LandingPage()),
                            )
                          },
                          // color: glt.themeColor,
                        ),
                      ],
                    ).show();
                  } else {
                    var a = await Alert(
                      context: context,
                      style: alertStyle,
                      type: AlertType.success,
                      title: "Failed!",
                      desc: "Listing unsuccessful.",
                      buttons: [
                        DialogButton(
                          radius: BorderRadius.circular(5.0),
                          child: Text(
                            "Ok",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => {Navigator.pop(context)},
                          // color: glt.themeColor,
                        ),
                      ],
                    ).show();
                  }
                }
              },
              icon: Icon(
                Icons.arrow_right,
                color: Colors.green,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          imgList.length == 0
              ? Container()
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: imgList.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(children: [
                        Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          child: Image.memory(
                            imgList[index],
                            fit: BoxFit.fill,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              imgList.remove(imgList[index]);
                              setState(() {});
                            },
                            icon: Icon(Icons.cancel))
                      ]),
                    );
                  }),
          imgList.length == 3
              ? Container()
              : IconButton(
                  onPressed: () async {
                    /* final ImagePicker _picker = ImagePicker();
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) files.add(File(image.path));
                    //bytes = File(image!.path).readAsBytesSync();
                    print(files);*/
                    _startFilePicker();
                    setState(() {});
                  },
                  icon: Icon(Icons.add_a_photo))
        ]),
      ),
    );
  }

  _startFilePicker() async {
    FileUploadInputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      // read file content as dataURL
      final files = uploadInput.files;
      if (files != null) {
        if (files.length == 1) {
          final file = files[0];
          FileReader reader = FileReader();

          reader.onLoadEnd.listen((e) {
            setState(() {
              if (reader.result is Uint8List) {
                uploadedImage = reader.result as Uint8List;
                imgList.add(uploadedImage);
                //print(uploadedImage);
              }

              // bytes=Uint8List(uploadedImage.length);
            });
          });
          // print(bytes);

          reader.onError.listen((fileEvent) {
            setState(() {
              print("Some Error occured while reading the file");
            });
          });

          reader.readAsArrayBuffer(file);
        }
      }
    });
  }
}
