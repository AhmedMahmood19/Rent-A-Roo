import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_a_roo/screens/addImages.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../controls/services/listings.dart';
import '../landingpage.dart';
import 'homescreen.dart';

class ListServices extends StatefulWidget {
  ListServices({Key? key, required this.req})
      : super(key: key);
  Map req = {};
  @override
  State<ListServices> createState() => _ListServicesState();
}

class _ListServicesState extends State<ListServices> {
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
  void initValues() async {
    values = {
      'WIFI': widget.req['WIFI']??false,
      'KITCHEN': widget.req['KITCHEN']??false,
      'WASHING MACHINE': widget.req['WASHING MACHINE']??false,
      'AIR CONDITIONING': widget.req['AIR CONDITIONING']??false,
      'TV': widget.req['TV']??false,
      'HAIR_DRYER': widget.req['HAIR_DRYER']??false,
      'IRON': widget.req['IRON']??false,
      'POOL': widget.req['POOL']??false,
      'GYM': widget.req['GYM']??false,
      'SMOKING ALLOWED': widget.req['SMOKING ALLOWED']??false,
      'IS_APARTMENT': widget.req['IS APARTMENT']??false,
      'IS_SHARED': widget.req['IS_SHARED']??false,
    };
    setState(() {});
  }

  void initState() {
    initValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.green,
            )),
        title: Text(
          "Ameneties",
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
                        enabled: false,
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
