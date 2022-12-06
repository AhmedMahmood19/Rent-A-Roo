import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_roo/controls/services/reservactions.dart';

import '../constants.dart';
import '../controls/apisCalls.dart';
import '../controls/services/user.dart';
import 'login.dart';

class HostProfile extends StatefulWidget {
  HostProfile({super.key, required this.hostid, required this.img});
  int hostid;
  String img;
  @override
  State<HostProfile> createState() => _HostProfileState();
}

class _HostProfileState extends State<HostProfile> {
  Future fetchData() async {
    Map userDetails = await User().getProfile(widget.hostid);

    print(userDetails);
    if (!mounted) return;
    setState(() {
      userMap = {
        'firstName': userDetails['first_name'] ?? "",
        'lastName': userDetails['last_name'] ?? "",
        'phone': userDetails['phone_no'] ?? "",
        'avgHost': userDetails['avg_host_rating'] ?? "",
        'avgGuest': userDetails['avg_guest_rating'] ?? "",
        'aboutme': userDetails['about_me'] ?? "",
        "image_path": userDetails['image_path'] ?? "",
      };
      print(userMap);
      firstname.text = userMap['firstName'];
      lastname.text = userMap['lastName'];
      phone.text = userMap['phone'];
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
  TextEditingController hostRating = TextEditingController();
  TextEditingController guestRating = TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchData();
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
          'Host Profile',
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
        child: Column(children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Image.network(
                "${Constants().ip}${userMap['image_path']}",
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            decoration: customDecoration(),
            child: TextField(
              enabled: false,
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
              enabled: false,
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
              enabled: false,
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
              enabled: false,
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
        ]),
      ),
    );
  }
}
