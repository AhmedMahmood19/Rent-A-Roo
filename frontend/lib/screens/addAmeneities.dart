import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_a_roo/screens/addImages.dart';

class AddServices extends StatefulWidget {
  const AddServices({Key? key}) : super(key: key);

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
  };
  final TextEditingController eCtrl = new TextEditingController();
  final TextEditingController timeCtrl = new TextEditingController();
  late List<bool> _isChecked;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddImagesScreen()),
                );
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
