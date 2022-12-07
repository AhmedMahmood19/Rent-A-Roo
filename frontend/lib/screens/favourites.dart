import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../LanguageMap/languageMapService.dart';
import '../cidgets/recommendation_card.dart';
import '../constants.dart';
import '../controls/services/listings.dart';
import 'detailsPage.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}



class _FavouritesPageState extends State<FavouritesPage> {

    List data=[];

 Future initValues() async {
    data = await Listing().getFavListing();
    setState(() {
      
    });
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
      appBar: AppBar(title: Text(
          LanguageMapService.getTranslation('Favourites'),
          style: TextStyle(color: Colors.green),
        ),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.green, //change your color here
        ),
        backgroundColor: Colors.white,
        leading: Container(),
      ),
      body: data.length==0?Center(child: Text(LanguageMapService.getTranslation('No Favorites')),): ListView.builder(
        itemCount: data==null?0: data.length,
        shrinkWrap: true,
        itemBuilder: (ctx, int index) {
          return Stack(
            children:[ Padding(
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
                        child: Image.network("${Constants().ip}${data[index]['image_path'][0].toString()}",fit: BoxFit.cover,),
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(onPressed: ()async{
                  var resp= Listing().delFav(data[index]['listing_id']);
                  print(resp);
                  
                  await initValues();
                  setState(() {
                    
                  });
                  SnackBar snackBar = SnackBar(content: Text(LanguageMapService.getTranslation("Listing removed from favorites")));
                   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }, icon: Icon(Icons.favorite))),
            )
            ]
          );
        },
      ),
    );
  }
}
