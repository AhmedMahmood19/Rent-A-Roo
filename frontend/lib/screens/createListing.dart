import 'package:dart_geohash/dart_geohash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:location/location.dart';
import 'package:rent_a_roo/controls/services/listings.dart';
import 'package:rent_a_roo/screens/addAmeneities.dart';

class CreateListing extends StatefulWidget {
  const CreateListing({Key? key}) : super(key: key);

  @override
  State<CreateListing> createState() => _CreateListingState();
}

class _CreateListingState extends State<CreateListing> {
  TextEditingController title = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController rooms = TextEditingController();
  TextEditingController maxNights = TextEditingController();
  TextEditingController minNights = TextEditingController();
  TextEditingController accomodates = TextEditingController();
  TextEditingController bathroom = TextEditingController();
  TextEditingController nightlyPrice = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController address = TextEditingController();
  double lat = 0;
  double long = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create listing',
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
                GeoHasher geoHasher = GeoHasher();
                print(geoHasher.encode(lat, long));
                Map map = {
                  "title": title.text,
                  "description": description.text,
                  "state": state.text,
                  "city": city.text,
                  "address": address.text,
                  "is_apartment": true,
                  "apartment_no": null,
                  "gps_location": geoHasher.encode(long, lat),
                  "is_shared": true,
                  "accommodates": int.parse(accomodates.text),
                  "bathrooms": int.parse(bathroom.text),
                  "bedrooms": int.parse(rooms.text),
                  "nightly_price": int.parse(nightlyPrice.text),
                  "min_nights": int.parse(maxNights.text),
                  "max_nights": int.parse(minNights.text),
                  "wifi": true,
                  "kitchen": true,
                  "washing_machine": true,
                  "air_conditioning": true,
                  "tv": true,
                  "hair_dryer": true,
                  "iron": true,
                  "pool": true,
                  "gym": true,
                  "smoking_allowed": true
                };

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddServices(
                            req: map,
                          )),
                );
              },
              icon: Icon(Icons.arrow_right))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: title,
              decoration: InputDecoration(
                  hintText: "Title",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.title,
                    color: Colors.grey,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: city,
              decoration: InputDecoration(
                  hintText: "City",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.location_city,
                    color: Colors.grey,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: address,
              decoration: InputDecoration(
                  hintText: "address",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.location_city,
                    color: Colors.grey,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: state,
              decoration: InputDecoration(
                  hintText: "State",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.earbuds_battery,
                    color: Colors.grey,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: description,
              maxLines: 5,
              decoration: InputDecoration(
                  hintText: "Description",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.text_format,
                    color: Colors.grey,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: rooms,
              decoration: InputDecoration(
                  hintText: "rooms",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.bed,
                    color: Colors.grey,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: bathroom,
              decoration: InputDecoration(
                  hintText: "bathrooms",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.bathroom,
                    color: Colors.grey,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: accomodates,
              decoration: InputDecoration(
                  hintText: "Accomodates",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.people,
                    color: Colors.grey,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nightlyPrice,
              decoration: InputDecoration(
                  hintText: "Nightly price",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.money,
                    color: Colors.grey,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: maxNights,
              decoration: InputDecoration(
                  hintText: "Max Nights",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.nights_stay,
                    color: Colors.grey,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: minNights,
              decoration: InputDecoration(
                  hintText: "Min nights",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.nights_stay_outlined,
                    color: Colors.grey,
                  )),
            ),
          ),
          TextButton.icon(
              onPressed: () async {
                Location location = new Location();

                bool _serviceEnabled;
                PermissionStatus _permissionGranted;
                LocationData _locationData;
                _serviceEnabled = await location.serviceEnabled();
                if (!_serviceEnabled) {
                  _serviceEnabled = await location.requestService();
                  if (!_serviceEnabled) {
                    return;
                  }
                }

                _permissionGranted = await location.hasPermission();
                if (_permissionGranted == PermissionStatus.denied) {
                  _permissionGranted = await location.requestPermission();
                  if (_permissionGranted != PermissionStatus.granted) {
                    return;
                  }
                }

                _locationData = await location.getLocation();
                lat = _locationData.latitude!;
                long = _locationData.longitude!;
                String a = GeoHasher().encode(long, lat);
                print(a);
                print(GeoHasher().decode(a).toString());
                print(_locationData.latitude);
                SnackBar snackBar = SnackBar(content: Text("Location added"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: Icon(
                Icons.location_on,
                color: Colors.green,
              ),
              label: Text(
                'Add Location',
                style: TextStyle(color: Colors.green),
              ))
        ]),
      ),
    );
  }
}
