import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_a_roo/screens/addImages.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../controls/services/listings.dart';
import '../landingpage.dart';

class AddServices extends StatefulWidget {
  AddServices({Key? key, required this.req}) : super(key: key);
  Map req = {};
  @override
  State<AddServices> createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  Map<String, bool?> values = {
    'WIFI': false,
    'KITCHEN': false,
    'WASHING MACHINE': false,
    'AIR CONDITIONING': false,
    'TV': false,
    'HAIR_DRYER': false,
    'IRON': false,
    'POOL': false,
    'GYM': false,
    'SMOKING ALLOWED': false,
    'IS_APARTMENT': false,
    'IS_SHARED': false,
  };
  final TextEditingController eCtrl = new TextEditingController();
  final TextEditingController timeCtrl = new TextEditingController();
  late List<bool> _isChecked;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                Map map = {
                  "title": widget.req['title'],
                  "description": widget.req['description'],
                  "state": widget.req['state'],
                  "city": widget.req['city'],
                  "address": widget.req['address'],
                  "is_apartment": values['IS_APARTMENT'],
                  "apartment_no": widget.req['apartment_no'],
                  "gps_location": "geoloc",
                  "is_shared": values['IS_SHARED'],
                  "accommodates": widget.req['accommodates'],
                  "bathrooms": widget.req['bathrooms'],
                  "bedrooms": widget.req['bedrooms'],
                  "nightly_price": widget.req['nightly_price'],
                  "min_nights": widget.req['min_nights'],
                  "max_nights": widget.req['max_nights'],
                  "wifi": values['WIFI'],
                  "kitchen": values['KITCHEN'],
                  "washing_machine": values['WASHING MACHINE'],
                  "air_conditioning": values['AIR CONDITIONING'],
                  "tv": values['TV'],
                  "hair_dryer": values['HAIR_DRYER'],
                  "iron": values['IRON'],
                  "pool": values['POOL'],
                  "gym": values['GYM'],
                  "smoking_allowed": values['SMOKING ALLOWED']
                };
                var resp = await Listing().postListing(map);
                print(resp);

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
              icon: Icon(
                Icons.arrow_right,
                color: Colors.green,
              )),
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.green,
            )),
        title: Text(
          "Add Services",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
        toolbarHeight: 90,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: values.keys.map((String key) {
                return Row(
                  children: [
                    Container(
                      height: 100,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.green,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.circle,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                        title: Text(
                          key.toLowerCase(),
                        ),
                        value: values[key],
                        onChanged: (val) {
                          setState(
                            () {
                              values[key] = val!;
                              print(values);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
