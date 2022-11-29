import 'dart:convert';
import 'package:http/http.dart';

import '../apisCalls.dart';

class Listing {
  Future<Map> postListing(Map data) async {
    Response res =
        await ApiCalls().postApiSignUpRequest('/listing/create',data);
    Map body = jsonDecode(res.body);
    return body ?? {};
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