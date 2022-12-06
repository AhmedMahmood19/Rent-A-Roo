import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_a_roo/controls/services/listings.dart';
import 'package:rent_a_roo/screens/searchResults.dart';

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
    'IS SHARED': false,
  };

  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController minPerNight = TextEditingController();
  TextEditingController maxPerNight = TextEditingController();
  TextEditingController accomodation = TextEditingController();
  TextEditingController bathrooms = TextEditingController();
  TextEditingController bedrooms = TextEditingController();
  TextEditingController noOfNights = TextEditingController();
  TextEditingController minRate = TextEditingController();
  TextEditingController maxRate = TextEditingController();
  TextEditingController minNoOfRate = TextEditingController();
  TextEditingController maxNoOfRate = TextEditingController();
  TextEditingController orderBy = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    /*accomodation.text = '0';
    bathrooms.text = '0';
    bedrooms.text = '0';
    noOfNights.text = '0';
    minPerNight.text = '0';
    maxPerNight.text = '0';
    minRate.text = '0';
    maxPerNight.text = '0';
    minNoOfRate.text = '0';
    maxNoOfRate.text = '0';*/
    super.initState();
  }

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Form',
          style: TextStyle(color: Colors.green),
        ),
        iconTheme: IconThemeData(
          color: Colors.green, //change your color here
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () async {
                if (_form.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );

                  Map temp = {
                    /*  "state": state.text,
                    "city": city.text,
                    "is_apartment": values2['IS APARTMENT'],
                    "is_shared": values2['IS SHARED'],
                    "accommodates": int.parse(accomodation.text),
                    "bathrooms": int.parse(bathrooms.text),
                    "bedrooms": int.parse(bedrooms.text),
                    "wifi": values['WIFI'],
                    "kitchen": values['KITCHEN'],
                    "washing_machine": values['WASHING MACHINE'],
                    "air_conditioning": values['AIR CONDITIONING'],
                    "tv": values['TV'],
                    "hair_dryer": values['HAIR_DRYER'],
                    "iron": values['IRON'],
                    "pool": values['POOL'],
                    "gym": values['GYM'],
                    "smoking_allowed": values['SMOKING ALLOWED'],
                    "nights": int.parse(noOfNights.text),
                    "min_nightly_price": int.parse(minPerNight.text),
                    "max_nightly_price": int.parse(maxPerNight.text),
                    "min_rating": int.parse(minRate.text),
                    "max_rating": int.parse(maxPerNight.text),
                    "min_total_ratings": int.parse(minNoOfRate.text),
                    "max_total_ratings": int.parse(maxNoOfRate.text),*/
                    "is_ascending": true,
                    "order_by": orderBy.text
                  };
                  if (state.text.isNotEmpty) temp["state"] = state.text;
                  if (city.text.isNotEmpty) temp["city"] = city.text;
                  temp["is_apartment"] = values2['IS APARTMENT'];
                  temp["is_shared"] = values2['IS SHARED'];
                  if (accomodation.text.isNotEmpty)
                    temp["accommodates"] = int.parse(accomodation.text);
                  if (bathrooms.text.isNotEmpty)
                    temp["bathrooms"] = int.parse(bathrooms.text);
                  if (bedrooms.text.isNotEmpty)
                    temp["bedrooms"] = int.parse(bedrooms.text);
                  if (values["WIFI"] != null) temp["wifi"] = values["WIFI"];
                  if (values["KITCHEN"] != null)
                    temp["kitchen"] = values["KITCHEN"];
                  if (values["WASHING MACHINE"] != null)
                    temp["washing_machine"] = values["WASHING MACHINE"];
                  if (values["AIR CONDITIONING"] != null)
                    temp["air_conditioning"] = values["AIR CONDITIONING"];
                  if (values["TV"] != null) temp["tv"] = values["TV"];
                  if (values["HAIR_DRYER"] != null)
                    temp["hair_dryer"] = values["HAIR_DRYER"];
                  if (values["IRON"] != null) temp["iron"] = values["IRON"];
                  if (values["POOL"] != null) temp["pool"] = values["POOL"];
                  if (values["GYM"] != null) temp["gym"] = values["GYM"];
                  if (values["SMOKING ALLOWED"] != null)
                    temp["smoking_allowed"] = values["SMOKING ALLOWED"];
                  if (noOfNights.text.isNotEmpty)
                    temp["nights"] = int.parse(noOfNights.text);
                  if (minPerNight.text.isNotEmpty)
                    temp["min_nightly_price"] = int.parse(minPerNight.text);
                  if (maxPerNight.text.isNotEmpty)
                    temp["max_nightly_price"] = int.parse(maxPerNight.text);
                  if (minRate.text.isNotEmpty)
                    temp["min_rating"] = int.parse(minRate.text);
                  if (maxRate.text.isNotEmpty)
                    temp["max_rating"] = int.parse(maxRate.text);
                  if (minNoOfRate.text.isNotEmpty)
                    temp["min_total_ratings"] = int.parse(minNoOfRate.text);
                  if (maxNoOfRate.text.isNotEmpty)
                    temp["max_total_ratings"] = int.parse(maxNoOfRate.text);

                  Map temp2 = {
                    "state": "",
                    "city": "",
                    "is_apartment": true,
                    "is_shared": true,
                    "accommodates": 0,
                    "bathrooms": 0,
                    "bedrooms": 0,
                    "wifi": true,
                    "kitchen": true,
                    "washing_machine": true,
                    "air_conditioning": true,
                    "tv": true,
                    "hair_dryer": true,
                    "iron": true,
                    "pool": true,
                    "gym": true,
                    "smoking_allowed": true,
                    "nights": 0,
                    "min_nightly_price": 0,
                    "max_nightly_price": 0,
                    "min_rating": 0,
                    "max_rating": 0,
                    "min_total_ratings": 0,
                    "max_total_ratings": 0,
                    "is_ascending": true,
                    "order_by": "city"
                  };
                  print(temp);
                  var resp = await Listing().postSearchListing(false, temp);
                  print(resp);
                  var resp2 = await Listing().postSearchListing(true, temp);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchResultsScreen(
                            results: resp, promoted: resp2)),
                  );
                }
              },
              icon: Icon(
                Icons.arrow_right,
                color: Colors.green,
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
            Form(
              key: _form,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: orderBy,
                decoration: InputDecoration(
                    hintText: "Order by: city/state/rating/nightly_price",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(
                      Icons.filter,
                      color: Colors.grey,
                    )),
              ),
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
              controller: bedrooms,
              decoration: InputDecoration(
                  hintText: "Bedrooms",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.bed,
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
