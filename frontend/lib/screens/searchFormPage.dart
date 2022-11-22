import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchFormPage extends StatefulWidget {
  const SearchFormPage({Key? key}) : super(key: key);

  @override
  State<SearchFormPage> createState() => _SearchFormPageState();
}

class _SearchFormPageState extends State<SearchFormPage> {
  Map<String, bool?> values = {
    'WIFI': null,
    'KITCHEN': null,
    'WASHING MACHINE': null,
    'AIR CONDITIONING': null,
    'TV': null,
    'HAIR_DRYER': null,
    'IRON': null,
    'POOL': null,
    'GYM': null,
    'SMOKING ALLOWED': null,
  };
  Map<String, bool> values2 = {
    'IS APARTMENT': true,
    'IS SHARED': true,
  };

  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController minPerNight = TextEditingController();
  TextEditingController maxPerNight = TextEditingController();
  TextEditingController accomodation = TextEditingController();
  TextEditingController bathrooms = TextEditingController();
  TextEditingController noOfNights = TextEditingController();
  TextEditingController minRate = TextEditingController();
  TextEditingController maxRate = TextEditingController();
  TextEditingController minNoOfRate = TextEditingController();
  TextEditingController maxNoOfRate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Form'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_right,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(children: [
            TextField(
              controller: state,
              decoration: InputDecoration(
                  hintText: "State",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.my_location,
                    color: Colors.grey,
                  )),
            ),
            TextField(
              controller: city,
              decoration: InputDecoration(
                  hintText: "City",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.location_city_outlined,
                    color: Colors.grey,
                  )),
            ),
            TextField(
              controller: minPerNight,
              decoration: InputDecoration(
                  hintText: "Min Nightly Range",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.price_change,
                    color: Colors.grey,
                  )),
            ),
            TextField(
              controller: maxPerNight,
              decoration: InputDecoration(
                  hintText: "Min Nightly Range",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.price_change,
                    color: Colors.grey,
                  )),
            ),
            TextField(
              controller: accomodation,
              decoration: InputDecoration(
                  hintText: "Accomodates",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.people,
                    color: Colors.grey,
                  )),
            ),
            TextField(
              controller: bathrooms,
              decoration: InputDecoration(
                  hintText: "Bathrooms",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.bathroom,
                    color: Colors.grey,
                  )),
            ),
            TextField(
              controller: noOfNights,
              decoration: InputDecoration(
                  hintText: "No of nights",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.bed,
                    color: Colors.grey,
                  )),
            ),
            TextField(
              controller: minRate,
              decoration: InputDecoration(
                  hintText: "Min rating",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.star_border_outlined,
                    color: Colors.grey,
                  )),
            ),
            TextField(
              controller: maxRate,
              decoration: InputDecoration(
                  hintText: "Max rating",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.star_border,
                    color: Colors.grey,
                  )),
            ),
            TextField(
              controller: minNoOfRate,
              decoration: InputDecoration(
                  hintText: "Min no of rating",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.star_rate_outlined,
                    color: Colors.grey,
                  )),
            ),
            TextField(
              controller: maxNoOfRate,
              decoration: InputDecoration(
                  hintText: "Max no of rating",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.star_rate,
                    color: Colors.grey,
                  )),
            ),
            ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: values.keys.map((String key) {
                return new CheckboxListTile(
                  tristate: true,
                  title: new Text(key.toLowerCase()),
                  value: values[key],
                  onChanged: (bool? value) {
                    setState(() {
                      values[key] = value;
                    });
                  },
                );
              }).toList(),
            ),
            ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: values2.keys.map((String key) {
                return new CheckboxListTile(
                  title: new Text(key.toLowerCase()),
                  value: values2[key],
                  onChanged: (bool? value) {
                    if (value != null)
                      setState(() {
                        values2[key] = value;
                      });
                  },
                );
              }).toList(),
            ),
          ]),
        ),
      ),
    );
  }
}
