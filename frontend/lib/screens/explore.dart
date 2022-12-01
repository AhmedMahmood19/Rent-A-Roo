import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_a_roo/controls/services/listings.dart';
import 'package:rent_a_roo/screens/detailsPage.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List data=[];

  void fetchData()async{
    data= await Listing().getPopularListing();
    print(data);
    setState(() {
      
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rent A Roo')),
      body: ListView.builder(
        itemCount: data.length,
        shrinkWrap: true,
        itemBuilder: (ctx, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailsPage(listingID: data[index]['listing_id'],)),
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
                        data[index]['state']??"",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Spacer(),
                      Icon(
                        Icons.star,
                        size: 14,
                      ),
                      Text(data[index]['rating'].toString()??"", style: TextStyle(fontSize: 18))
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(data[index]['city']??"", style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 3,
                  ),
                  
                  Text('Rs-/${data[index]['nightly_price'].toString()??""} / night', style: TextStyle(fontSize: 16)),
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
