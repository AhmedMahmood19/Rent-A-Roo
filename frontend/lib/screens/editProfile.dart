import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_roo/controls/services/auth.dart';

import '../constants.dart';
import '../controls/apisCalls.dart';
import '../controls/services/user.dart';
import 'login.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Uint8List? uploadedImage;

  Future fetchData() async {
    Map userDetails = await User().getUserData();
    print(userDetails);
    if (!mounted) return;
    setState(() {
      userMap = {
        'email': userDetails['email'] ?? "",
        'password': userDetails['password'] ?? "",
        'firstName': userDetails['first_name'] ?? "",
        'lastName': userDetails['last_name'] ?? "",
        'phone': userDetails['phone_no'] ?? "",
        'avgHost': userDetails['avg_host_rating'] ?? "",
        'avgGuest': userDetails['avg_guest_rating'] ?? "",
        'aboutme': userDetails['about_me'] ?? "",
        "image_path": userDetails['image_path'] ?? "",
      };
      // print(userMap);
      firstname.text = userMap['firstName'];
      lastname.text = userMap['lastName'];
      password.text = userMap['password'];
      phone.text = userMap['phone'];
      email.text = userMap['email'];
      aboutme.text = userMap['aboutme'];
      hostRating.text = userMap['avgHost'].toString();
      guestRating.text = userMap['avgGuest'].toString();
    });
  }

  Map userMap = Map();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController aboutme = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController hostRating = TextEditingController();
  TextEditingController guestRating = TextEditingController();

  @override
  void initState() {
    fetchData();

    super.initState();

    // });
  }

  BoxDecoration customDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 2),
          color: Colors.grey,
          blurRadius: 5,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit profile',
          style: TextStyle(color: Colors.green),
        ),
        iconTheme: IconThemeData(
          color: Colors.green, //change your color here
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(children: [
            InkWell(
              onTap: () async {
                if(uploadedImage==null)
                await _startFilePicker();
                setState(() {
                  
                });
                if (uploadedImage != null) {
                  var resp;

                  resp = await User().updatePhoto(uploadedImage!);
                  print(resp.body);
                  uploadedImage=null;
                }
                 fetchData();
                 setState(() {
                   
                 });
              },
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.black,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Image.network(
                      "${Constants().ip}${userMap['image_path']}",
                      fit: BoxFit.fill,
                    )),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              decoration: customDecoration(),
              child: TextField(
                controller: firstname,
                decoration: InputDecoration(
                  hintText: "First Name",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              decoration: customDecoration(),
              child: TextField(
                controller: lastname,
                decoration: InputDecoration(
                  hintText: "Last Name",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              decoration: customDecoration(),
              child: TextField(
                controller: email,
                decoration: InputDecoration(
                  hintText: "Email",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.mail_outline,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              decoration: customDecoration(),
              child: TextField(
                controller: password,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              decoration: customDecoration(),
              child: TextField(
                controller: phone,
                decoration: InputDecoration(
                  hintText: "Phone Number",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              decoration: customDecoration(),
              child: TextField(
                enabled: false,
                controller: hostRating,
                decoration: InputDecoration(
                  hintText: "Host Rating",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.star,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              decoration: customDecoration(),
              child: TextField(
                enabled: false,
                controller: guestRating,
                decoration: InputDecoration(
                  hintText: "Guest Rating",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.star_border_outlined,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              decoration: customDecoration(),
              child: TextField(
                minLines: 1,
                maxLines: 5,
                controller: aboutme,
                decoration: InputDecoration(
                  hintText: "About me",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.description,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            TextButton(
                onPressed: () async {
                  Map body = {
                    "email": email.text,
                    "password": password.text,
                    "first_name": firstname.text,
                    "last_name": lastname.text,
                    "phone_no": phone.text,
                    "about_me": aboutme.text
                  };
                  var resp = await User().updateUserData(body);
                  setState(() {});
                },
                child: Text('update')),
            TextButton(
                onPressed: () async {
                  var resp = await User().delUserData();

                  print(resp.statusCode);
                  setState(() {});
                  if (resp.statusCode == 200) {
                    Auth().logout();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  } else {
                    SnackBar snackBar =
                        SnackBar(content: Text(resp.body.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Text('delete user'))
          ]),
        ),
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
              
                //print(uploadedImage);
              }

              // bytes=Uint8List(uploadedImage.length);
            }
            
            );
            setState(() {
              
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
