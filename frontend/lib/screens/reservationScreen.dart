import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_a_roo/screens/addImages.dart';
import 'package:rent_a_roo/screens/viewGuestProfile.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../cidgets/recommendation_card.dart';
import '../cidgets/resCard.dart';
import '../cidgets/tranCard.dart';
import '../controls/services/reservactions.dart';
import '../controls/services/transactions.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  List guestReservation = [];
  List hostReservations = [];

  Future initValues() async {
    guestReservation = await Reservations().getGuestReservations();
    hostReservations = await Reservations().getHostReservations();

    print(guestReservation);
    print(hostReservations);
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
            'Reservations',
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
              Tab(
                text: "Host",
              ),
              Tab(
                text: "Guest",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: hostReservations.length,
              shrinkWrap: true,
              itemBuilder: (ctx, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ResCard(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewGuestProfile(
                                    reservationID: hostReservations[index]
                                        ['reservation_id'],
                                  )),
                        );
                      },
                      buttonTxt: 'View Guest',
                      listingid: hostReservations[index]['listing_id'],
                      imageUrl:
                          "https://thumbs.dreamstime.com/b/amazing-misty-autumn-scenery-lake-sorapis-dolomites-italy-beautiful-mountains-colorful-yellow-larches-shore-193683774.jpg",
                      title: hostReservations[index]['title'] ?? "",
                      startDate: hostReservations[index]['checkin_date'] ?? "",
                      endDate: "2022-12-03T08:28:23.098Z",
                      startPrices:
                          hostReservations[index]['amount_due'].toString() ??
                              ""),
                );
              },
            ),
            ListView.builder(
              itemCount: guestReservation.length,
              shrinkWrap: true,
              itemBuilder: (ctx, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ResCard(
                      onPressed: () async {
                         var resp =
                            await Reservations().getStatus(guestReservation[index]['reservation_id']);
                            
                        print(resp);
                     
                          var a = await Alert(
                            context: context,
                            style: alertStyle,
                            type: resp['status']=='Pending'?AlertType.warning:resp['status']=='Accepted'?AlertType.success:AlertType.error,
                            title: "Status",
                            desc: resp['status'],
                            buttons: [
                              DialogButton(
                                radius: BorderRadius.circular(5.0),
                                child: Text(
                                  "Ok",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => {Navigator.pop(context)},
                                // color: glt.themeColor,
                              ),
                            ],
                          ).show();
                        
                      },
                      buttonTxt: 'Check Status',
                      listingid: guestReservation[index]['listing_id'],
                      imageUrl:
                          "https://thumbs.dreamstime.com/b/amazing-misty-autumn-scenery-lake-sorapis-dolomites-italy-beautiful-mountains-colorful-yellow-larches-shore-193683774.jpg",
                      title: guestReservation[index]['title'] ?? "",
                      startDate: guestReservation[index]['checkin_date'] ?? "",
                      endDate: guestReservation[index]['checkout_date'] ?? "",
                      startPrices:
                          guestReservation[index]['amount_due'].toString() ??
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
