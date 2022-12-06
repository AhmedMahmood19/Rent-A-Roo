import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../controls/services/listings.dart';

class Q8AScreen extends StatefulWidget {
  Q8AScreen({super.key, required this.listingid});
  int listingid;

  @override
  State<Q8AScreen> createState() => _Q8AScreenState();
}

class _Q8AScreenState extends State<Q8AScreen> {
  List<TextEditingController> ans = [];

  List data = [];

  Future initValues() async {
    data = await Listing().getQAList(widget.listingid);
    for (int i = 0; i < data.length; i++) {
      ans.add(TextEditingController());
    }
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
          'Q&A',
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () async {
                TextEditingController question = TextEditingController();
                Alert(
                    context: context,
                    title: "Ask Away!",
                    content: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                       
                        TextField(
                          controller: question,
                          decoration: InputDecoration(
                            icon: Icon(Icons.reviews),
                            labelText: 'question',
                          ),
                        ),
                      ],
                    ),
                    buttons: [
                      DialogButton(
                        onPressed: () async {
                          Map map = {"listing_id": widget.listingid, "question": question.text};
                          var resp = await Listing().postListingQuestion(map);
                          print(resp);
                          await initValues();
                          Navigator.pop(context);
                          setState(() {
                            
                          });
                        },
                        child: Text(
                          "submit",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )
                    ]).show();
              },
              icon: Icon(Icons.question_answer,color:Colors.green,))
        ],
      ),
      body: data.length == 0
          ? Center(child: Text('No Questions Yet'))
          : ListView.builder(
              itemCount: data.length,
              shrinkWrap: true,
              itemBuilder: (ctx, int index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     /* Row(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.grey,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                              '${data[index]['first_name'] ?? "Deleted"} ${data[index]['last_name'] ?? "User"}')
                        ],
                      ),*/
                      SizedBox(
                        height: 10,
                      ),
                      Text('Q: ${data[index]['question'] ?? ""}'),
                      SizedBox(
                        height: 5,
                      ),
                      data[index]['answer'] != null
                          ? Text('A: ${data[index]['answer'] ?? ""}')
                          : Container(),
                      Divider(),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
