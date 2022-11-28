import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_a_roo/screens/addAmeneities.dart';

class CreateListing extends StatefulWidget {
  const CreateListing({Key? key}) : super(key: key);

  @override
  State<CreateListing> createState() => _CreateListingState();
}

class _CreateListingState extends State<CreateListing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddServices()),
                );
              },
              icon: Icon(Icons.arrow_right))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Title",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.title,
                    color: Colors.grey,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Location",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: Colors.grey,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: 5,
              decoration: InputDecoration(
                  hintText: "Description",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.text_format,
                    color: Colors.grey,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "rooms",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.bed,
                    color: Colors.grey,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Accomodates",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.people,
                    color: Colors.grey,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Nightly rate",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.money,
                    color: Colors.grey,
                  )),
            ),
          ),
        ]),
      ),
    );
  }
}
