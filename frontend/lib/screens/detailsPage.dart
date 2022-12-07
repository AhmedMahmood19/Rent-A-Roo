import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_a_roo/screens/bookingPage.dart';
import 'package:rent_a_roo/screens/q&aScreen.dart';
import 'package:rent_a_roo/screens/reviewsScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cidgets/CustomNavBar2.dart';
import '../cidgets/customNavBar.dart';
import '../constants.dart';
import '../controls/services/listings.dart';
import 'EditListingData.dart';
import 'Q8A.dart';
import 'ViewHostProfile.dart';
import 'listAmeneties.dart';

class DetailsPage extends StatefulWidget {
  DetailsPage({Key? key, required this.listingID}) : super(key: key);
  int listingID;
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int _current = 0;
  List imgList = [];
  var carouselInfo = [
    {
      'img':
          'https://images.unsplash.com/photo-1597655601841-214a4cfe8b2c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bW91bnRhaW4lMjBzY2VuZXJ5fGVufDB8fDB8fA%3D%3D&w=1000&q=80',
      'flag': '2',
    },
    {
      'img':
          'https://images.unsplash.com/photo-1597655601841-214a4cfe8b2c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bW91bnRhaW4lMjBzY2VuZXJ5fGVufDB8fDB8fA%3D%3D&w=1000&q=80',
      'flag': '2',
    }
  ];
  Map details = {};
  Future initValues() async {
    details = await Listing().getListing(widget.listingID);

    print(details);
    imgList = await details['image_path'];
    setState(() {});
  }

  @override
  void initState() {
    initValues().whenComplete(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          },icon: Icon(Icons.arrow_back),color: Colors.green,),
          elevation: 0,
          
          actions: [
            IconButton(
                onPressed: () async {
                  print(imgList);
                  var resp = await Listing().postFav(widget.listingID);
                  print(resp);
                  SnackBar snackBar = SnackBar(
                      content: Text(resp['Detail'] ??
                          "Already favourite or own listing"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                icon: Icon(
                  Icons.favorite_border,
                  color: Colors.green,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            carousel(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    details['title'] ?? "",
                    style: TextStyle(
                      fontSize: 28,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.star),
                        Text(details['rating'].toString() ?? ""),
                        Spacer(),
                        Text('|'),
                        Spacer(),
                        Icon(Icons.location_pin),
                        Text(details['city'] ?? ""),
                        Spacer(),
                        Text('|'),
                        Spacer(),
                        InkWell(
                            onTap: () {
                              if (details['is_host'] == true) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Q7AScreen(
                                            listingid: widget.listingID,
                                          )),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Q8AScreen(
                                            listingid: widget.listingID,
                                          )),
                                );
                              }
                            },
                            child: Text('FAQs')),
                        Spacer(),
                        Text('|'),
                        Spacer(),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReviewsScreens(
                                          listingid: widget.listingID,
                                        )),
                              );
                            },
                            child: Text('Reviews'))
                      ],
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HostProfile(
                                hostid: details['host_id'],
                                img: details['host_image_path'])),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 25,
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              child: Image.network(
                                  "${Constants().ip}${details['host_image_path']}")),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "${details['first_name'] ?? ""} ${details['last_name'] ?? ""}",
                          style: TextStyle(fontSize: 20),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_right_alt)
                      ],
                    ),
                  ),
                  Divider(),
                  Text(
                    details['description'] ?? "",
                    maxLines: 20,
                  ),
                  Divider(),
                  details["gps_location"] == null?Container():InkWell(
                    onTap: () async {
                      if (details["gps_location"] != null) {
                        GeoHash geohash = GeoHash(details["gps_location"]);
                        final Uri _url = Uri.parse(
                            'https://www.google.com/maps/search/?api=1&query=${geohash.latitude()},${geohash.longitude()}');
                        await launchUrl(_url);
                      }
                      else
                      {
                         final Uri _url = Uri.parse(
                            'https://www.google.com/maps/search/?api=1&query=24.856837,67.264594');
                        await launchUrl(_url);
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        color: Colors.white,
                        child: Image.asset(
                          'assets/khimap.jpg',
                          fit: BoxFit.cover,
                        ),
                        width: double.infinity,
                        height: 150,
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {
                      Map temp = {
                        'WIFI': details['wifi'],
                        'KITCHEN': details['kitchen'],
                        'WASHING MACHINE': details['washing_machine'],
                        'AIR CONDITIONING': details['air_conditioning'],
                        'TV': details['tv'],
                        'HAIR_DRYER': details['hair_dryer'],
                        'IRON': details['iron'],
                        'POOL': details['pool'],
                        'GYM': details['gym'],
                        'SMOKING ALLOWED': details['smoking_allowed'],
                        'IS_APARTMENT': details['is_apartment'],
                        'IS_SHARED': details['is_shared'],
                      };
                      print(temp);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListServices(
                                  req: temp,
                                )),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          'Ameneties',
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_right_alt),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ]),
        ),
        bottomNavigationBar: details['is_host'] == true
            ? CustomNavBar2(
                listingid: widget.listingID,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        maintainState: false,
                        builder: (context) => EditListingData(
                              listingID: widget.listingID,
                            )),
                  );
                },
                price: details['nightly_price'].toString() ?? "")
            : CustomNavBar(
                price: details['nightly_price'].toString() ?? "",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        maintainState: false,
                        builder: (context) => BookingPage(
                              listingID: widget.listingID,
                            )),
                  );
                },
              ));
  }

  Widget carousel() {
    CarouselController _controller = CarouselController();
    return Container(
      height: 200,
      width: double.maxFinite,
      child: CarouselSlider.builder(
          options: CarouselOptions(
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            viewportFraction: 1,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
          ),
          itemCount: details==null 
          || details.isEmpty?0:details['image_path'].length,
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) {
            return InkWell(
              onTap: () async {},
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: details==null || details.isEmpty?Container():Image.network(
                    "${Constants().ip}${details['image_path'][itemIndex]??""}",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    //  subject['images']['large'],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
