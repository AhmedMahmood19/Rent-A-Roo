import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constants.dart';
import 'detailsPage.dart';

class SearchResultsScreen extends StatefulWidget {
  SearchResultsScreen({Key? key, required this.results, required this.promoted})
      : super(key: key);
  List results, promoted;

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Results',
          style: TextStyle(color: Colors.green),
        ),
        iconTheme: IconThemeData(
          color: Colors.green, //change your color here
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: widget.results.length == 0
          ? Center(
              child: Text('No Results Found'),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Promoted:'),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.promoted.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, int index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailsPage(
                                        listingID: widget.promoted[index]
                                            ['listing_id'],
                                      )),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                height: 250,
                                width: double.maxFinite,
                                child: Image.network(
                                  "${Constants().ip}${widget.promoted[index]['image_path'][1].toString()}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.promoted[index]['state'],
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.star,
                                    size: 14,
                                  ),
                                  Text(
                                      widget.promoted[index]['rating']
                                          .toString(),
                                      style: TextStyle(fontSize: 18))
                                ],
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(widget.promoted[index]['city'],
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                  '${widget.promoted[index]['nightly_price'].toString()}',
                                  style: TextStyle(fontSize: 16)),
                              Divider(height: 10, thickness: 1)
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Results:'),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.results.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, int index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailsPage(
                                        listingID: widget.results[index]
                                            ['listing_id'],
                                      )),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                height: 250,
                                width: double.maxFinite,
                                child: Image.network(
                                  "${Constants().ip}${widget.results[index]['image_path'][1].toString()}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.results[index]['state'],
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.star,
                                    size: 14,
                                  ),
                                  Text(
                                      widget.results[index]['rating']
                                          .toString(),
                                      style: TextStyle(fontSize: 18))
                                ],
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(widget.results[index]['city'],
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                  widget.results[index]['nightly_price']
                                      .toString(),
                                  style: TextStyle(fontSize: 16)),
                              Divider(height: 10, thickness: 1)
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
