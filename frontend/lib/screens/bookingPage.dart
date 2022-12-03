import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rent_a_roo/controls/services/reservactions.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../landingpage.dart';

class BookingPage extends StatefulWidget {
   BookingPage({super.key,required this.listingID});
  int listingID;
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {

var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.red,
    ),
  );

  BoxDecoration customDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 2),
          color: Colors.grey,
          blurRadius: 5,
        )
      ],
    );
  }
  TextEditingController cardNum=TextEditingController();
    DateRangePickerController _datePickerController = DateRangePickerController();
    String date="2022-12-03T05:49:54.380Z";
    List<DateTime> restricted =[];


      List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  } 
  void initValues()async{
    List data = await Reservations().getReservedDates(widget.listingID);
    print(data);
    for(int i=0;i<data.length;i++)
    {
      restricted.addAll(getDaysInBetween(DateTime.parse(data[i]['checkin_date']),DateTime.parse(data[i]['checkout_date'])));
    }
    print(restricted);


  }
    @override
  void initState() {
    initValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confirm Booking',style: TextStyle(color: Colors.green),),
        iconTheme: IconThemeData(
    color: Colors.green, //change your color here
  ),
        elevation: 0,
        backgroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          SfDateRangePicker(
            
            controller: _datePickerController,
                  minDate: DateTime.now(),
            selectionMode: DateRangePickerSelectionMode.range,
             enableMultiView: true,
            viewSpacing: 20,
            headerStyle: DateRangePickerHeaderStyle(
              textAlign: TextAlign.center
            ),
             monthViewSettings: DateRangePickerMonthViewSettings(blackoutDates:restricted),
    view: DateRangePickerView.month,
    
  ),
          Container(
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: customDecoration(),
                      child: TextField(
                        controller: cardNum,
                        decoration: InputDecoration(
                            hintText: "Card Number",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.add_card,
                              color: Colors.green,
                            )),
                      ),
                    ),
                  
                    Container(
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0,4,10,4),
              child: TextButton(onPressed: ()async {
                String start=_datePickerController.selectedRange!.startDate!.toIso8601String()+"Z";
                String end=_datePickerController.selectedRange!.endDate!.toIso8601String()+"Z";
                Map temp={'listing_id':widget.listingID,
                'checkin_date':start,
                'checkout_date':end
                };
                var resp=await Reservations().postReservation(temp) ;
                print(resp);           



                  if (resp['Status'] == 'Success') {
                            var a = await Alert(
                          context: context,
                          style: alertStyle,
                          type: AlertType.success,
                          title: "Amount Due: ",
                          desc: resp['amount_due'].toString()??"",
                          buttons: [
                            DialogButton(
                              radius: BorderRadius.circular(5.0),
                              child: Text(
                                "Ok",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => {
                                Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LandingPage()),
                                    )
                              },
                             // color: glt.themeColor,
                            ),
                          ],
                        ).show();
                  }

              }, child: Text('Confirm',style: TextStyle(color: Colors.white),)),
            ),
          ),
        ]),
      ),
    );
  }
}