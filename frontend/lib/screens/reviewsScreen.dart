import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../controls/services/listings.dart';

class ReviewsScreens extends StatefulWidget {
   ReviewsScreens({Key? key,required this.listingid}) : super(key: key);
  int listingid;

  @override
  State<ReviewsScreens> createState() => _ReviewsScreensState();
}

class _ReviewsScreensState extends State<ReviewsScreens> {


   List data = [];

  Future initValues() async {
    data = await Listing().getReviewsList(widget.listingid);
    print(data);
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
        title: Text(
          'Reviews',
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: data.length==0?Center(child:Text('No Reviews Yet')):ListView.builder(
        itemCount: data.length,
        shrinkWrap: true,
        itemBuilder: (ctx, int index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Row(
                  children: [
                   /* CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),*/
                    Row(
                      children: [
                        Text('${data[index]['first_name']??"Deleted"} ${data[index]['last_name']??"User"}'),
                        SizedBox(width: 10,),
                        RatingBarIndicator(
                          rating: data[index]['rating'].toDouble(),
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 13.0,
                          direction: Axis.horizontal,
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                data[index]['review']??""),
                Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
