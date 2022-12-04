import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_a_roo/screens/reviewsScreen.dart';

import '../cidgets/customNavBar.dart';
import '../controls/services/listings.dart';
import 'EditListingData.dart';

class MyListingDetailsPage extends StatefulWidget {
   MyListingDetailsPage({Key? key,required this.listingID}) : super(key: key);
  int listingID;
  @override
  State<MyListingDetailsPage> createState() => _MyListingDetailsPageState();
}

class _MyListingDetailsPageState extends State<MyListingDetailsPage> {
  int _current = 0;

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
  Map details={};
    Future initValues() async
  {
     details = await Listing().getListing(widget.listingID); 

    print(details);
    
  }

  @override
  void initState() {

       initValues().whenComplete((){
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
                    details['title']??"",
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
                        Text(details['rating'].toString()??""),
                        Spacer(),
                        Text('|'),
                        Spacer(),
                        Icon(Icons.location_pin),
                        Text(details['city']??""),
                        Spacer(),
                        Text('|'),
                        Spacer(),
                        Text('FAQs'),
                        Spacer(),
                        Text('|'),
                        Spacer(),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReviewsScreens(listingid: widget.listingID,)),
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
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "${details['first_name']??""} ${details['last_name']??""}",
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_right_alt)
                    ],
                  ),
                  Divider(),
                  Text(
                    details['description']??"",
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
                  Row(
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
                  )
                ],
              ),
            )
          ]),
        ),
        bottomNavigationBar: CustomNavBar(
          price: details['nightly_price'].toString()??"",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  maintainState: false, builder: (context) => EditListingData(listingID: 1,)),
            );
          },
        ));
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
                        carouselInfo[itemIndex]['img'].toString(),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        //  subject['images']['large'],
                      ),
                    ),
                  ),
                );
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: carouselInfo.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 6.0,
                height: 6.0,
                margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black45)
                        .withOpacity(_current == entry.key ? 0.5 : 0.3)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
