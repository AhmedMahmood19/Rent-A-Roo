import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../LanguageMap/languageMapService.dart';
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

    for (int i = 0; i < 0; i++) {
      if (guestTransactions[i]["has_guest_rated"] == null)
        guestTransactions[i]["has_guest_rated"] = true;

      if (hostTransactions[i]["has_host_rated"] == null)
        hostTransactions[i]["has_host_rated"] = true;
    }
    print(guestTransactions);
    print(hostTransactions);
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            LanguageMapService.getTranslation('Transactions'),
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
                onPressed: () async {
                  await initValues();
                  setState(() {});
                },
                icon: Icon(Icons.refresh))
          ],
          bottom: TabBar(
            labelColor: Colors.green,
            tabs: [
              Tab(text: LanguageMapService.getTranslation('Host')),
              Tab(
                text: LanguageMapService.getTranslation('Guest'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            hostTransactions.length == 0
                ? Center(
                    child: Text('No Transactions Found'),
                  )
                : ListView.builder(
                    itemCount: hostTransactions.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TranCard(
                            flag: hostTransactions[index]['has_host_rated'] ==
                                    null
                                ? true
                                : hostTransactions[index]['has_host_rated'],
                            listingid: hostTransactions[index]['listing_id'],
                            onPressed: () {
                              if (hostTransactions[index]['has_host_rated'] ==
                                  null)
                                hostTransactions[index]['has_host_rated'] =
                                    true;

                              if (hostTransactions[index]['has_host_rated'] ==
                                  false) {
                                int guestRating = 0;

                                Alert(
                                    context: context,
                                    title: "Rate",
                                    content: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text('guest'),
                                        RatingBar.builder(
                                          initialRating: 3,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                            guestRating = rating.toInt();
                                          },
                                        ),
                                      ],
                                    ),
                                    buttons: [
                                      DialogButton(
                                        onPressed: () async {
                                          Map map = {
                                            "transaction_id":
                                                hostTransactions[index]
                                                    ['transaction_id'],
                                            "rating_of_guest": guestRating,
                                          };
                                          var resp = await Transactions()
                                              .postHostReview(map);
                                          print(resp);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "confirm",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      )
                                    ]).show();
                              }
                            },
                            imageUrl:
                                "https://thumbs.dreamstime.com/b/amazing-misty-autumn-scenery-lake-sorapis-dolomites-italy-beautiful-mountains-colorful-yellow-larches-shore-193683774.jpg",
                            title: hostTransactions[index]['title'] ?? "",
                            startDate: DateTime.parse(
                                        hostTransactions[index]['checkin_date']).toLocal()
                                    .toString() ??
                                "",
                            endDate: DateTime.parse(hostTransactions[index]
                                        ['checkout_date']).toLocal()
                                    .toString() ??
                                "",
                            startPrices: hostTransactions[index]['amount_paid']
                                    .toString() ??
                                ""),
                      );
                    },
                  ),
            guestTransactions.length == 0
                ? Center(
                    child: Text('No Transactions Found'),
                  )
                : ListView.builder(
                    itemCount: guestTransactions.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TranCard(
                            flag: guestTransactions[index]['has_guest_rated'] ==
                                    null
                                ? true
                                : guestTransactions[index]['has_guest_rated'],
                            listingid: guestTransactions[index]['listing_id'],
                            onPressed: () async {
                              if (guestTransactions[index]['has_guest_rated'] ==
                                  null)
                                guestTransactions[index]['has_guest_rated'] =
                                    true;
                              if (guestTransactions[index]['has_guest_rated'] ==
                                  false) {
                                int hostRating = 0, listRating = 0;
                                TextEditingController review =
                                    TextEditingController();
                                Alert(
                                    context: context,
                                    title: "Rate",
                                    content: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text('host'),
                                        RatingBar.builder(
                                          initialRating: 3,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                            hostRating = rating.toInt();
                                          },
                                        ),
                                        Text('property'),
                                        RatingBar.builder(
                                          initialRating: 3,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (listingRating) {
                                            print(listingRating);
                                            listRating = listingRating.toInt();
                                          },
                                        ),
                                        TextField(
                                          controller: review,
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.reviews),
                                            labelText: 'Review',
                                          ),
                                        ),
                                      ],
                                    ),
                                    buttons: [
                                      DialogButton(
                                        onPressed: () async {
                                          Map map = {
                                            "transaction_id":
                                                guestTransactions[index]
                                                    ['transaction_id'],
                                            "rating_of_host": hostRating,
                                            "rating_of_listing": listRating,
                                            "review_of_listing": review.text
                                          };
                                          var resp = await Transactions()
                                              .postGuestReview(map);
                                          print(resp);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "confirm",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      )
                                    ]).show();
                              }
                            },
                            imageUrl:
                                "https://thumbs.dreamstime.com/b/amazing-misty-autumn-scenery-lake-sorapis-dolomites-italy-beautiful-mountains-colorful-yellow-larches-shore-193683774.jpg",
                            title: guestTransactions[index]['title'] ?? "",
                            startDate: DateTime.parse(guestTransactions[index]
                                        ['checkin_date']).toLocal()
                                    .toString() ??
                                "",
                            endDate: DateTime.parse(guestTransactions[index]
                                        ['checkout_date']).toLocal()
                                    .toString() ??
                                "",
                            startPrices: guestTransactions[index]['amount_paid']
                                    .toString() ??
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
