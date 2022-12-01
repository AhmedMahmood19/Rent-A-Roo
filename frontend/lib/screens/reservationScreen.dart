import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../cidgets/recommendation_card.dart';
import '../cidgets/tranResCard.dart';
import '../controls/services/reservactions.dart';
import '../controls/services/transactions.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
    List guestReservation=[];
     List hostReservations=[];

  Future initValues() async
  {
     guestReservation = await Reservations().getGuestReservations(); 
     hostReservations = await Reservations().getHostReservations(); 

    print(guestReservation);
    print(hostReservations);
    
  }
  @override
  void initState()  {
    
   initValues().whenComplete((){
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
      actions: [IconButton(onPressed: (){

        setState(() {
          
        });
      }, icon: Icon(Icons.refresh))],
      bottom: TabBar(
        tabs: [
          Tab(text: "Host",),
          Tab(text: "Guest",),
        ],
      ),
      title: Text('Reservations'),
    ),
    body: TabBarView(
      children: [
ListView.builder(
        itemCount: hostReservations.length,
        shrinkWrap: true,
        itemBuilder: (ctx, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TranResCard(
                imageUrl:
                    "https://thumbs.dreamstime.com/b/amazing-misty-autumn-scenery-lake-sorapis-dolomites-italy-beautiful-mountains-colorful-yellow-larches-shore-193683774.jpg",
                title: hostReservations[index]['title']??"",
                location: hostReservations[index]['checkin_date']??"",
                startPrices: hostReservations[index]['amount_due'].toString()??""),
          );
        },
      ),ListView.builder(
        itemCount: guestReservation.length,
        shrinkWrap: true,
        itemBuilder: (ctx, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RecommendCard(
                imageUrl:
                    "https://thumbs.dreamstime.com/b/amazing-misty-autumn-scenery-lake-sorapis-dolomites-italy-beautiful-mountains-colorful-yellow-larches-shore-193683774.jpg",
                title: guestReservation[index]['title']??"",
                location: guestReservation[index]['checkin_date']??"",
                startPrices: guestReservation[index]['amount_due'].toString()??""),
          );
        },
      ),
      ],
    ),
  ),
);;
  }
}