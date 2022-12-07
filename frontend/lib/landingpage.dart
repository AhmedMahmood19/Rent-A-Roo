import 'package:flutter/material.dart';
import 'package:rent_a_roo/screens/EditListingData.dart';
import 'package:rent_a_roo/screens/TransactionScreen.dart';
import 'package:rent_a_roo/screens/bookingPage.dart';
import 'package:rent_a_roo/screens/detailsPage.dart';
import 'package:rent_a_roo/screens/favourites.dart';
import 'package:rent_a_roo/screens/homescreen.dart';
import 'package:rent_a_roo/screens/myListingDetails.dart';
import 'package:rent_a_roo/screens/myListings.dart';
import 'package:rent_a_roo/screens/profile.dart';
import 'package:rent_a_roo/screens/reservationScreen.dart';

import 'LanguageMap/languageMapService.dart';

class LandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  int _currentTab = 0;
  List<Widget> _children = [
    HomeScreen(),
    TransactionScreen(),
    ReservationScreen(),
    FavouritesPage(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFE7EBEE),
      body: SafeArea(
        child: _children[_currentTab],
      ),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 5,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey[800],
          type: BottomNavigationBarType.fixed,
          onTap: (int value) {
            setState(() {
              _currentTab = value;
            });
          },
          currentIndex: _currentTab,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 30,
              ),
              label: LanguageMapService.getTranslation("Explore"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.hourglass_full,
                //color: Colors.black,
                size: 30,
              ),
              label: LanguageMapService.getTranslation("Transactions"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.hourglass_bottom_outlined,
                //color: Colors.black,
                size: 30,
              ),
              label: LanguageMapService.getTranslation("Reservations"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                size: 30,
              ),
              label: LanguageMapService.getTranslation("Favourites"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              label: LanguageMapService.getTranslation("Profile"),
            )
          ]),
    );
  }
}
