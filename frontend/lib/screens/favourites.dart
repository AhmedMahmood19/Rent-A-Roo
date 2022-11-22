import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../cidgets/recommendation_card.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favourites')),
      body: ListView.builder(
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
    );
  }
}
