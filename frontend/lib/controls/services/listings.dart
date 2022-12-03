import 'dart:convert';
import 'package:http/http.dart';

import '../apisCalls.dart';

class Listing {

    Future<Map> getListing(int listingid) async {
    Response res =
        await ApiCalls().getApiRequest('/listing/$listingid');
    Map body = jsonDecode(res.body);
    return body ?? {};
  }

      Future<List> postSearchListing(bool isPromoted, Map data) async {
    Response res =
        await ApiCalls().postApiSignUpRequest('/listing/search/$isPromoted',data);
        print(res.body);
    List body = jsonDecode(res.body);
    return body ?? [];
  }

  Future<Map> postListing(Map data) async {
    Response res =
        await ApiCalls().postApiSignUpRequest('/listing/create',data);
    Map body = jsonDecode(res.body);
    return body ?? {};
  }
    Future<Map> editListing(int listingID,Map data) async {
    Response res =
        await ApiCalls().putApiRequest('/listing/$listingID',data);
    Map body = jsonDecode(res.body);
    return body ?? {};
  }

    Future<List> getPopularListing() async {
    Response res =
        await ApiCalls().getApiRequest('/listing/popular-listings');
    List body = jsonDecode(res.body);
    return body ?? [];
  }

      Future<List> getPromotedListing() async {
    Response res =
        await ApiCalls().getApiRequest('/listing/promoted');
    List body = jsonDecode(res.body);
    return body ?? [];
  }


  Future updateUserData(dynamic body) async {
    Response res =
        await ApiCalls().putApiRequest('/user/profile', body);
    return res;
  }

    Future delUserData() async {
    Response res =
        await ApiCalls().delApiRequest('/user/profile');
    return res;
  }
}