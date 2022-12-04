import 'dart:convert';
import 'package:http/http.dart';

import '../apisCalls.dart';

class User {
  Future<Map> getUserData() async {
    Response res =
        await ApiCalls().getApiRequest('/user/profile');
    Map body = jsonDecode(res.body);
    return body ?? {};
  }
    Future<Map> getProfile(int id) async {
    Response res =
        await ApiCalls().getApiRequest('/user/profile/${id}');
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