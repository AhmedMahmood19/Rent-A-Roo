import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../cidgets/recommendation_card.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
  length: 2,
  child: Scaffold(
    appBar: AppBar(
      bottom: TabBar(
        tabs: [
          Tab(text: "Host",),
          Tab(text: "Guest",),
        ],
      ),
      title: Text('Reservation'),
    ),
    body: TabBarView(
      children: [
ListView.builder(
        itemCount: 4,
        shrinkWrap: true,
        itemBuilder: (ctx, int) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RecommendCard(
                imageUrl:
                    "https://thumbs.dreamstime.com/b/amazing-misty-autumn-scenery-lake-sorapis-dolomites-italy-beautiful-mountains-colorful-yellow-larches-shore-193683774.jpg",
                title: "Nice",
                location: "20-2-2020",
                startPrices: "200"),
          );
        },
      ),       ListView.builder(
        itemCount: 4,
        shrinkWrap: true,
        itemBuilder: (ctx, int) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RecommendCard(
                imageUrl:
                    "https://thumbs.dreamstime.com/b/amazing-misty-autumn-scenery-lake-sorapis-dolomites-italy-beautiful-mountains-colorful-yellow-larches-shore-193683774.jpg",
                title: "Nice",
                location: "20-2-2020",
                startPrices: "200"),
          );
        },
      ),
      ],
    ),
  ),
);;
  }
}