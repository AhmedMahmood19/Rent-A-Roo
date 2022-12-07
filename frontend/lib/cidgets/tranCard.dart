import 'package:flutter/material.dart';

import '../screens/viewListing.dart';

class TranCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String startDate;
  final String endDate;
  final String startPrices;
  final int listingid;
  final bool flag;

  Function onPressed;

  TranCard(
      {required this.imageUrl,
      required this.title,
      required this.startDate,
      required this.endDate,
      required this.startPrices,
      required this.listingid,
      required this.onPressed,
      required this.flag});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () {
          print("Go to offer!");
        },
        child: Container(
            width: 365,
            height: 200,
            child: Row(
              children: <Widget>[
                /*SizedBox(
                  width: 130,
                  height: 200,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),*/
                Container(
                  width: 365,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Flexible(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0,0,0,0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  color: Colors.grey[500],
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  startDate,
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  color: Colors.grey[500],
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  endDate,
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Rs-/$startPrices",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ViewListing(listingID: listingid)),
                                  );
                                },
                                child: Text('View Listing')),
                            TextButton(
                                onPressed: flag == true
                                    ? null
                                    : () {
                                        onPressed();
                                      },
                                child: Text('Rate'))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
