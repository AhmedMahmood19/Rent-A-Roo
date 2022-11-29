import 'package:flutter/material.dart';
import 'package:rent_a_roo/screens/favourites.dart';
import 'package:rent_a_roo/screens/homescreen.dart';
import 'package:rent_a_roo/screens/profile.dart';

class LandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  int _currentTab = 0;
  List<Widget> _children = [
    HomeScreen(),
    FavouritesPage(),
        Container(),

    Container(),
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
              label: "EXPLORER",
            ),
                BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite_border,
                //color: Colors.black,
                size: 30,
              ),
              label: "Transactions",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite_border,
                //color: Colors.black,
                size: 30,
              ),
              label: "Reservations",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.house,
                size: 30,
              ),
              label: "PROPERTIES",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
                size: 30,
              ),
              label: "PROFILE",
            )
          ]),
    );
  }
}
