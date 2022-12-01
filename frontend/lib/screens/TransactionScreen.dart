import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../cidgets/recommendation_card.dart';
import '../cidgets/tranResCard.dart';
import '../controls/services/transactions.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
    List guestTransactions=[];
     List hostTransactions=[];

  Future initValues() async
  {
     guestTransactions = await Transactions().getGuestTransactions(); 
     hostTransactions = await Transactions().getHostTransactions(); 

    print(guestTransactions);
    print(hostTransactions);
    
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
      title: Text('Transactions'),
    ),
    body: TabBarView(
      children: [
ListView.builder(
        itemCount: hostTransactions.length,
        shrinkWrap: true,
        itemBuilder: (ctx, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TranResCard(
                imageUrl:
                    "https://thumbs.dreamstime.com/b/amazing-misty-autumn-scenery-lake-sorapis-dolomites-italy-beautiful-mountains-colorful-yellow-larches-shore-193683774.jpg",
                title: hostTransactions[index]['title']??"",
                location: hostTransactions[index]['checkin_date']??"",
                startPrices: hostTransactions[index]['amount_paid'].toString()??""),
          );
        },
      ),ListView.builder(
        itemCount: guestTransactions.length,
        shrinkWrap: true,
        itemBuilder: (ctx, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RecommendCard(
                imageUrl:
                    "https://thumbs.dreamstime.com/b/amazing-misty-autumn-scenery-lake-sorapis-dolomites-italy-beautiful-mountains-colorful-yellow-larches-shore-193683774.jpg",
                title: guestTransactions[index]['title']??"",
                location: guestTransactions[index]['checkin_date']??"",
                startPrices: guestTransactions[index]['amount_paid'].toString()??""),
          );
        },
      ),
      ],
    ),
  ),
);;
  }
}