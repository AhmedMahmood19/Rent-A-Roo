import 'package:flutter/material.dart';
import 'package:rent_a_roo/landingpage.dart';
import 'package:rent_a_roo/screens/detailsPage.dart';
import 'package:rent_a_roo/screens/editProfile.dart';
import 'package:rent_a_roo/screens/explore.dart';
import 'package:rent_a_roo/screens/login.dart';
import 'package:rent_a_roo/screens/profile.dart';
import 'package:rent_a_roo/screens/searchFormPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: LandingPage(),
    );
  }
}
