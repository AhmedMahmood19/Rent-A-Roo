import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent_a_roo/landingpage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddImagesScreen extends StatefulWidget {
  const AddImagesScreen({Key? key}) : super(key: key);

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
  List files = [];

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
              },
              icon: Icon(Icons.arrow_right))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          files.length == 0
              ? Container()
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: files.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(children: [
                        Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          child: Image.file(
                            files[index],
                            fit: BoxFit.fill,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              files.remove(files[index]);
                              setState(() {});
                            },
                            icon: Icon(Icons.cancel))
                      ]),
                    );
                  }),
          files.length == 3
              ? Container()
              : IconButton(
                  onPressed: () async {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) files.add(File(image.path));

                    print(files);
                    setState(() {});
                  },
                  icon: Icon(Icons.add_a_photo))
        ]),
      ),
    );
  }
}
