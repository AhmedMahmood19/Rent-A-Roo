import 'package:flutter/material.dart';
import 'package:rent_a_roo/landingpage.dart';
import 'package:rent_a_roo/screens/TransactionScreen.dart';
import 'package:rent_a_roo/screens/addAmeneities.dart';
import 'package:rent_a_roo/screens/addImages.dart';
import 'package:rent_a_roo/screens/bookingPage.dart';
import 'package:rent_a_roo/screens/createListing.dart';
import 'package:rent_a_roo/screens/detailsPage.dart';
import 'package:rent_a_roo/screens/editProfile.dart';
import 'package:rent_a_roo/screens/explore.dart';
import 'package:rent_a_roo/screens/login.dart';
import 'package:rent_a_roo/screens/myListingDetails.dart';
import 'package:rent_a_roo/screens/profile.dart';
import 'package:rent_a_roo/screens/reviewsScreen.dart';
import 'package:rent_a_roo/screens/searchFormPage.dart';
import 'package:rent_a_roo/screens/searchResults.dart';

import 'cidgets/tranCard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
    // Define the default brightness and colors.
    primaryColor: Colors.green,

    // Define the default font family.
    fontFamily: 'Georgia',

    // Define the default `TextTheme`. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
   
  ),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home:  Login()
    );
  }
}
