import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_a_roo/controls/services/listings.dart';
import 'package:rent_a_roo/screens/addAmeneities.dart';

import 'editAmeneties.dart';

class EditListingData extends StatefulWidget {
   EditListingData({Key? key,required this.listingID}) : super(key: key);
  int listingID;

  @override
  State<EditListingData> createState() => _EditListingDataState();
}

class _EditListingDataState extends State<EditListingData> {
  TextEditingController title=TextEditingController();
    TextEditingController location=TextEditingController();
  TextEditingController description=TextEditingController();
  TextEditingController rooms=TextEditingController();
  TextEditingController maxNights=TextEditingController();
  TextEditingController minNights=TextEditingController();
    TextEditingController accomodates=TextEditingController();
  TextEditingController bathroom=TextEditingController();
  TextEditingController nightlyPrice=TextEditingController();
    TextEditingController city=TextEditingController();
  TextEditingController state=TextEditingController();
  TextEditingController address=TextEditingController();
  Map details={};
    Future initValues() async
  {
     details = await Listing().getListing(widget.listingID); 

    print(details);
    title.text=details['title'];
    description.text=details['description'];
    city.text=details['city'];
    state.text=details['state'];    
    address.text=details['address'];
    bathroom.text=details['bathrooms'].toString();
    accomodates.text=details['accommodates'].toString();
    nightlyPrice.text=details['nightly_price'].toString();
    rooms.text=details['bedrooms'].toString();
    minNights.text=details['min_nights'].toString();
    maxNights.text=details['max_nights'].toString();
    location.text=details['apartment_no'].toString();
    



  }
@override
  void initState() {
    // TODO: implement initState
    initValues().whenComplete((){
      setState(() {
        
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Listing Details',style: TextStyle(color: Colors.green),),
        elevation: 0,
        backgroundColor: Colors.white,

        actions: [
          IconButton(
              onPressed: () async{
                Map map={
  "title": title.text,
  "description": description.text,
  "state": state.text,
  "city": city.text,
  "address": address.text,
  "is_apartment": details['is_apartment'],
  "apartment_no": '1',
  "gps_location": "geoloc",
  "is_shared": details['is_shared'],
  "accommodates": int.parse(accomodates.text),
  "bathrooms": int.parse(bathroom.text),
  "bedrooms": int.parse(rooms.text),
  "nightly_price": int.parse(nightlyPrice.text),
  "min_nights": int.parse(maxNights.text),
  "max_nights": int.parse(minNights.text),
  "wifi": details['wifi'],
  "kitchen": details['kitchen'],
  "washing_machine": details['washing_machine'],
  "air_conditioning": details['air_conditioning'],
  "tv": details['tv'],
  "hair_dryer": details['hair_dryer'],
  "iron": details['iron'],
  "pool": details['pool'],
  "gym": details['gym'],
  "smoking_allowed": details['smoking_allowed']
};


                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditServices(req: map,listingID: widget.listingID,)),
                );
              },
              icon: Icon(Icons.arrow_right),color: Colors.green,)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
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
              controller: location,
              decoration: InputDecoration(
                  hintText: "Location",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.location_on,
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
          ), Padding(
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
        ]),
      ),
    );
  }
}
