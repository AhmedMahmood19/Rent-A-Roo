import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rent_a_roo/cidgets/recommendation_card.dart';
import 'package:rent_a_roo/screens/explore.dart';
import 'package:rent_a_roo/screens/searchFormPage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = PageController(
    initialPage: 1,
  );

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchFormPage()),
                  );
                },
                splashColor: Colors.white,
                hoverColor: Colors.green,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black87),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(Icons.search),
                        Text(
                          "Search for places to stay",
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Image.asset(
                        "assets/images/landing_page_img.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                            child: Text("Explore",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                        Center(
                            child: Text("New Destinations",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white))),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExplorePage()),
                          );
                        },
                        elevation: 3,
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 40),
                            margin: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Text(
                              "Explore",
                              style: TextStyle(color: Colors.red),
                            )),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Text('Recommended'),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 4,
                shrinkWrap: true,
                itemBuilder: (ctx, int index) {
                  return RecommendCard(
                      imageUrl:
                          "https://cdn.britannica.com/67/19367-050-885866B4/Valley-Taurus-Mountains-Turkey.jpg",
                      title: "Nice",
                      location: "20-2-2020",
                      startPrices: "200");
                },
              ),

/*               Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                height: 400,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "DARI DAREK",
                            style: TextStyle(color: Color(0xfff35e0b)),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10, right: 10, left: 10),
                      child: Text(
                        "Rencontrez des gens partout en Algérie et découverez les plus beaux endroits du pays. Avec DARI DAREK, trouvez les",
                        style:
                            TextStyle(fontSize: 13, color: Color(0xffd3d3d3)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: PageView(
                          scrollDirection: Axis.horizontal,
                          controller: controller,
                          children: <Widget>[
                            buildScrollActivities("les meilleures vacances",
                                "assets/images/3.jpg"),
                            buildScrollActivities(
                                "Logement familial", "assets/images/4.jpg"),
                            buildScrollActivities(
                                "Endroits calmes", "assets/images/1.jpg"),
                            buildScrollActivities("Les meilleures appartements",
                                "assets/images/2.jpg"),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ) */
            ],
          ),
        ),
      ),
    );
  }
}
