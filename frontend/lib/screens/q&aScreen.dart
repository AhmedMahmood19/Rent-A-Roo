import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../controls/services/listings.dart';

class Q7AScreen extends StatefulWidget {
  Q7AScreen({super.key, required this.listingid});
  int listingid;

  @override
  State<Q7AScreen> createState() => _Q7AScreenState();
}

class _Q7AScreenState extends State<Q7AScreen> {
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
                    /*  Row(
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
                          ? Text('A: ${data[index]['answer']??""}')
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                              child: TextField(
                                controller: ans[index],
                              ),
                            ),
                      data[index]['answer'] != null
                          ? Container()
                          : TextButton(
                              onPressed: () async {
                                Map temp = {"question_id": data[index]['question_id'], "answer": ans[index].text};
                                var resp = await Listing().postListingAnswer(temp);
                                print(resp);
                                await initValues();
                                setState(() {});
                              },
                              child: Text(
                                'Submit',
                                style: TextStyle(color: Colors.green),
                              )),
                      Divider(),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
