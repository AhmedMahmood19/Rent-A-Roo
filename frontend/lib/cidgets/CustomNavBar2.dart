import 'package:flutter/material.dart';
import 'package:rent_a_roo/controls/services/listings.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CustomNavBar2 extends StatelessWidget {
  Function onPressed;

  CustomNavBar2(
      {Key? key,
      required Function this.onPressed,
      required this.price,
      required this.listingid})
      : super(key: key);
  String price;
  int listingid;
  TextEditingController card = TextEditingController(),
      days = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: Theme.of(context).dividerColor))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          /* InkWell(
            onTap: (() {}),
            child: Container(
              margin: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.4,
              child: Center(
                child: Text(
                  'Custom Plan',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  )),
            ),
          ), */
          Text(
            'Rs-/$price',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'night',
            style: TextStyle(fontSize: 14),
          ),
          Spacer(),
          InkWell(
            onTap: () async {
            var a= await Alert(
                  context: context,
                  title: "Promote",
                  content: Column(
                    children: <Widget>[
                      TextField(
                        controller: card,
                        decoration: InputDecoration(
                          icon: Icon(Icons.account_circle),
                          labelText: 'Card number',
                        ),
                      ),
                      TextField(
                        controller: days,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          labelText: 'Days to promote',
                        ),
                      ),
                    ],
                  ),
                  buttons: [
                    DialogButton(
                      onPressed: ()async {
                        Map temp = {
                          "listing_id": listingid,
                          "days": int.parse(days.text)
                        };

                        var resp=await Listing().postPromotedListing(temp);
                        print(resp);
                        Alert(
                          context: context,
                          type: AlertType.success,
                          title: "Listing Promoted",
                          desc: "success",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Close",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              width: 120,
                            )
                          ],
                        ).show();
                      },
                      child: Text(
                        "confirm",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ]).show();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Container(
                margin: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height * 0.06,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                  child: Center(
                    child: Text(
                      'Promote',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    )),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              onPressed();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Container(
                margin: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height * 0.06,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                  child: Center(
                    child: Text(
                      'Edit',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    )),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
