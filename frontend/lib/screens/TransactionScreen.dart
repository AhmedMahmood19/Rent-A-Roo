import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../cidgets/recommendation_card.dart';
import '../cidgets/tranCard.dart';
import '../controls/services/transactions.dart';
import 'login.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List guestTransactions = [];
  List hostTransactions = [];

  Future initValues() async {
    guestTransactions = await Transactions().getGuestTransactions();
    hostTransactions = await Transactions().getHostTransactions();

    print(guestTransactions);
    print(hostTransactions);
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Transactions',
            style: TextStyle(color: Colors.green),
          ),
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.green, //change your color here
          ),
          backgroundColor: Colors.white,
          leading: Container(),
          actions: [
            IconButton(
                onPressed: () {
                  initValues();
                  setState(() {});
                },
                icon: Icon(Icons.refresh))
          ],
          bottom: TabBar(
            labelColor: Colors.green,
            tabs: [
              Tab(text: "Host"),
              Tab(
                text: "Guest",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: hostTransactions.length,
              shrinkWrap: true,
              itemBuilder: (ctx, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TranCard(
                      listingid: hostTransactions[index]['listing_id'],
                      onPressed: () {
                        if (hostTransactions[index]['has_host_rated'] == null)
                          hostTransactions[index]['has_host_rated'] = false;

                        if (hostTransactions[index]['has_host_rated']) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Container()),
                          );
                        }
                      },
                      imageUrl:
                          "https://thumbs.dreamstime.com/b/amazing-misty-autumn-scenery-lake-sorapis-dolomites-italy-beautiful-mountains-colorful-yellow-larches-shore-193683774.jpg",
                      title: hostTransactions[index]['title'] ?? "",
                      startDate: hostTransactions[index]['checkin_date'] ?? "",
                      endDate: hostTransactions[index]['checkout_date'] ?? "",
                      startPrices:
                          hostTransactions[index]['amount_paid'].toString() ??
                              ""),
                );
              },
            ),
            ListView.builder(
              itemCount: guestTransactions.length,
              shrinkWrap: true,
              itemBuilder: (ctx, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TranCard(
                      listingid: guestTransactions[index]['listing_id'],
                      onPressed: () async {
                        if (guestTransactions[index]['has_guest_rated'] == null)
                          guestTransactions[index]['has_guest_rated'] = true;
                        if (guestTransactions[index]['has_guest_rated']) {
                          int hostRating,listRating;

                          Alert(
                              context: context,
                              title: "Rate",
                              content: Column(
                                children: <Widget>[
                                  Text('host'),
                                  RatingBar.builder(
                                    initialRating: 3,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                      hostRating=rating.toInt();
                                    },
                                  ),Text('property'),
                                  RatingBar.builder(
                                    initialRating: 3,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (listingRating) {
                                      print(listingRating);
                                      listRating=listingRating.toInt();
                                    },
                                  )
                                ],
                              ),
                              buttons: [
                                DialogButton(
                                  onPressed: () { 
                                    
                                    Navigator.pop(context);},
                                  child: Text(
                                    "confirm",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                )
                              ]).show();
                        }
                      },
                      imageUrl:
                          "https://thumbs.dreamstime.com/b/amazing-misty-autumn-scenery-lake-sorapis-dolomites-italy-beautiful-mountains-colorful-yellow-larches-shore-193683774.jpg",
                      title: guestTransactions[index]['title'] ?? "",
                      startDate: guestTransactions[index]['checkin_date'] ?? "",
                      endDate: guestTransactions[index]['checkout_date'] ?? "",
                      startPrices:
                          guestTransactions[index]['amount_paid'].toString() ??
                              ""),
                );
              },
            ),
          ],
        ),
      ),
    );
    ;
  }
}
