import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_a_roo/screens/bookingPage.dart';
import 'package:rent_a_roo/screens/reviewsScreen.dart';

import '../cidgets/CustomNavBar2.dart';
import '../cidgets/customNavBar.dart';
import '../constants.dart';
import '../controls/services/listings.dart';
import 'EditListingData.dart';
import 'Q8A.dart';
import 'listAmeneties.dart';

class ViewListing extends StatefulWidget {
  ViewListing({Key? key, required this.listingID}) : super(key: key);
  int listingID;
  @override
  State<ViewListing> createState() => _ViewListingState();
}

class _ViewListingState extends State<ViewListing> {
  int _current = 0;

  var carouselInfo = [
    {
      'img':"http://127.0.0.1:8000/static/images/ac5735895.webp",
      'flag': '2',
    },
    {
      'img':"http://127.0.0.1:8000/static/images/ac5735895.webp",
      'flag': '2',
    }
  ];
  Map details = {};
  Future initValues() async {
    details = await Listing().getListing(widget.listingID);

    print(details);
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
          elevation: 0,
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          },icon: Icon(Icons.arrow_back),color: Colors.green,),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Q8AScreen(
                                          listingid: widget.listingID,
                                        )),
                              );
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
                  Row(
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
                  Divider(),
                  Text(
                    details['description'] ?? "",
                    maxLines: 20,
                  ),
                  Divider(),
                  ClipRRect(
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
                    child: InkWell(
                      onTap: (){
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
                    ),
                  )
                ],
              ),
            )
          ]),
        ),
        bottomNavigationBar: Container(
          height: 80,
           decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: Theme.of(context).dividerColor))),
          child:Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("Rs-/"+details['nightly_price'].toString() ?? "",style: TextStyle(fontSize: 22),),
          ))
          );
  }

  Widget carousel() {
    CarouselController _controller = CarouselController();
    return Column(
      children: [
        Container(
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
              itemCount: carouselInfo.length,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) {
                return InkWell(
                  onTap: () async {},
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Image.network(
                          "${Constants().ip}${details['image_path'][itemIndex]}",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        //  subject['images']['large'],
                      ),
                    ),
                  ),
                );
              }),
        ),
     
      ],
    );
  }
}
