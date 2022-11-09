// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_import, implementation_imports, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

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
                      decoration: InputDecoration(
                          hintText: "Username",
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
                          style: TextStyle(color: Colors.green, fontSize: 12),
                        )),
                  ),
                ),
                SizedBox(
                  height: _inscription ? 30 : 0,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {},
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
