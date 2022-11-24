import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ReviewsScreens extends StatefulWidget {
  const ReviewsScreens({Key? key}) : super(key: key);

  @override
  State<ReviewsScreens> createState() => _ReviewsScreensState();
}

class _ReviewsScreensState extends State<ReviewsScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reviews',
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: 4,
        shrinkWrap: true,
        itemBuilder: (ctx, int) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('M Qasim')
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                    "It was supposed to be a dream vacation. They had planned it over a year in advance so that it would be perfect in every way. It had been what they had been looking forward to through all the turmoil and negativity around them."),
                Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
