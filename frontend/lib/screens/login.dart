import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_a_roo/landingpage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../controls/services/auth.dart';
import 'editProfile.dart';
import 'homepage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
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

class _LoginState extends State<Login> {
  bool _inscription = false;
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

  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController aboutme = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 130,
                  width: 130,
                  child: Image(
                    image: NetworkImage(
                        'https://static.vecteezy.com/system/resources/previews/005/215/495/original/kangaroo-icon-black-color-illustration-vector.jpg'),
                    fit: BoxFit.scaleDown,
                  ),
                ),
                Text(
                  "Welcome To Rent-A-Roo",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 40,
                ),
                Visibility(
                  visible: _inscription,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: customDecoration(),
                    child: TextField(
                      controller: firstname,
                      decoration: InputDecoration(
                          hintText: "First Name",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Colors.green,
                          )),
                    ),
                  ),
                ),
                Visibility(
                  visible: _inscription,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: customDecoration(),
                    child: TextField(
                      controller: lastname,
                      decoration: InputDecoration(
                          hintText: "Last Name",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Colors.green,
                          )),
                    ),
                  ),
                ),
                Visibility(
                  visible: _inscription,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: customDecoration(),
                    child: TextField(
                      controller: aboutme,
                      decoration: InputDecoration(
                          hintText: "About Me",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(
                            Icons.text_format_outlined,
                            color: Colors.green,
                          )),
                    ),
                  ),
                ),
                Visibility(
                  visible: _inscription,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: customDecoration(),
                    child: TextField(
                      controller: phone,
                      decoration: InputDecoration(
                          hintText: "Phone number",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(
                            Icons.smartphone,
                            color: Colors.green,
                          )),
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
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: customDecoration(),
                  child: TextField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Password",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.green,
                        )),
                  ),
                ),
                Visibility(
                  visible: !_inscription,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forgot password ?",
                          style: TextStyle(color: Colors.transparent, fontSize: 12),
                        )),
                  ),
                ),
                SizedBox(
                  height: _inscription ? 30 : 0,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () async {
                    if (_inscription == false) {
                      var resp = await Auth().login(email.text, password.text);

                      var resbody = jsonDecode(resp.body);
                      print(resp.body);
                      if (resp.statusCode == 200) {
                        var a = await Alert(
                          context: context,
                          style: alertStyle,
                          type: AlertType.success,
                          title: "Success !",
                          desc: "Login successful.",
                          buttons: [
                            DialogButton(
                              radius: BorderRadius.circular(5.0),
                              child: Text(
                                "Ok",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
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
                        await Alert(
                            context: context,
                            style: alertStyle,
                            type: AlertType.error,
                            title: "Error !",
                            desc: resbody["errorMessage"],
                            buttons: [
                              DialogButton(
                                radius: BorderRadius.circular(5.0),
                                child: Text(
                                  "Ok",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(),
                                  
                                },
                               // color: glt.themeColor,
                              ),
                            ],
                          ).show();
                      }
                    } else {
                      Map body = {
                        "email": email.text,
                        "password": password.text,
                        "first_name": firstname.text,
                        "last_name": lastname.text,
                        "phone_no": phone.text,
                        "about_me": aboutme.text
                      }; //new Map();
                      /*body['email'] = email.text;
                      body['password'] = password.text;
                      body["firstName"] = firstname.text;
                      body["lastName"] = lastname.text;
                      body["phoneNo"] = phone.text;
                      body["aboutMe"] = aboutme.text;*/

                      var resp = await Auth().signUp(body);
                      print(resp.body);
                      var resbody = jsonDecode(resp.body);
                      if (resp.statusCode == 201) {
                        _inscription=false;
                        setState(() {
                          
                        });
                        await Alert(
                          context: context,
                          style: alertStyle,
                          type: AlertType.success,
                          title: "Success !",
                          desc: "Registered successfully",
                          buttons: [
                            DialogButton(
                              radius: BorderRadius.circular(5.0),
                              child: Text(
                                "Ok",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                //alrt.dismiss();
                                Navigator.pop(context, 'registered');
                                // Navigator.pop(context);
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => LoginScreen()));
                              },
                              //color: glt.themeColor,
                            ),
                          ],
                        );
                        //alrt.show();
                      } else {
                        await Alert(
                          context: context,
                          style: alertStyle,
                          type: AlertType.error,
                          title: "Error !",
                          desc: resbody["errorMessage"],
                          buttons: [
                            DialogButton(
                              radius: BorderRadius.circular(5.0),
                              child: Text(
                                "Ok",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              //color: glt.themeColor,
                            ),
                          ],
                        ).show();
                      }
                    }
                  },
                  splashColor: Colors.white,
                  hoverColor: Colors.green,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 2),
                          color: Colors.grey,
                          blurRadius: 5,
                        )
                      ],
                    ),
                    child: Center(
                        child: Text(
                      !_inscription ? "Continue" : "Login",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    )),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _inscription = !_inscription;
                    });
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: InkWell(
                        child: RichText(
                          text: TextSpan(
                              text: _inscription
                                  ? "Do you have an account ? "
                                  : "New User ?",
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                              children: [
                                TextSpan(
                                  text: _inscription
                                      ? "Sign in"
                                      : " Create an account",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                )
                              ]),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
