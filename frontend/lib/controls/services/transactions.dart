import 'dart:convert';
import 'package:http/http.dart';

import '../apisCalls.dart';

class Transactions {
  Future<List> getGuestTransactions() async {
    Response res =
        await ApiCalls().getApiRequest('/transactions/guest');
    List body = jsonDecode(res.body);
    return body ?? [] ;
  }
  Future<List> getHostTransactions() async {
    Response res =
        await ApiCalls().getApiRequest('/transactions/host');
    List body = jsonDecode(res.body);
    return body ?? [];
  }

    Future delUserData() async {
    Response res =
        await ApiCalls().delApiRequest('/user/profile');
    return res;
  }
}