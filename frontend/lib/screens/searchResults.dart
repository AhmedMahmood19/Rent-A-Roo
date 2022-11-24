import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'detailsPage.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({Key? key}) : super(key: key);

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search results')),
      body: ListView.builder(
        itemCount: 4,
        shrinkWrap: true,
        itemBuilder: (ctx, int) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailsPage()),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    height: 250,
                    width: double.maxFinite,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'San Jose del Cabo',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Spacer(),
                      Icon(
                        Icons.star,
                        size: 14,
                      ),
                      Text('5', style: TextStyle(fontSize: 18))
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text('viewed 150 times', style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 3,
                  ),
                  Text('Dec 1-5', style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 3,
                  ),
                  Text('\$500 night', style: TextStyle(fontSize: 16)),
                  Divider(height: 10, thickness: 1)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
