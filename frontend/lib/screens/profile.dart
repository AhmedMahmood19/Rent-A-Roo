import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rent_a_roo/controls/services/auth.dart';
import 'package:rent_a_roo/screens/createListing.dart';
import 'package:rent_a_roo/screens/homepage.dart';
import 'package:rent_a_roo/screens/login.dart';
import 'package:rent_a_roo/screens/myListings.dart';

import '../LanguageMap/languageMapService.dart';
import '../constants.dart';
import '../controls/services/user.dart';
import 'editProfile.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final textStyleState = TextStyle(fontSize: 11.0, color: Colors.white);

  final textStyleTop = TextStyle(
      fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white);

  final textStyle2 = TextStyle(color: Colors.white);

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
        'phone': userDetails['phone_n0'] ?? "",
        'avgHost': userDetails['avg_host_rating'] ?? "",
        'avgGuest': userDetails['avg_guest_rating'] ?? "",
        'aboutme': userDetails['about_me'] ?? "",
        'image_path': userDetails['image_path'] ?? "",
      };
      print(userMap);
    });
  }

  Map userMap = Map();
  String dropdownvalue = 'English';
  var items = ['English', 'Urdu'];
  @override
  void initState() {
    super.initState();

    fetchData();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "${Constants().ip}${userMap['image_path']}"),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${userMap['firstName']} ${userMap['lastName']}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black87),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          ClipRRect(
            child: Container(
              margin: const EdgeInsets.only(bottom: 5.0),
              decoration: BoxDecoration(
                color: Colors.black12,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black87,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 5.0,
                  ),
                ],
              ),
              width: 50,
              height: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              LanguageMapService.getTranslation("Profile"),
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfile()),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      LanguageMapService.getTranslation("Personal Information"),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w300),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.person_outline,
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.black12,
            ),
            width: 50,
            height: 1,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyListings()),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      LanguageMapService.getTranslation("My Listings"),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w300),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.house,
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.black12,
            ),
            width: 50,
            height: 1,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateListing()),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      LanguageMapService.getTranslation("Add property"),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w300),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.add_circle_outline,
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.black12,
            ),
            width: 50,
            height: 1,
          ),
          TextButton(
            onPressed: () {
              Auth().logout();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      LanguageMapService.getTranslation("Log out"),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w300),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.exit_to_app,
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.black12,
            ),
            width: 50,
            height: 1,
          ),          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Text(LanguageMapService.getTranslation('Set language'),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w300)),
                Spacer(),
                DropdownButton(
                  isExpanded: false,
                  value: dropdownvalue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                      LanguageMapService.setTranslation(dropdownvalue);
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
