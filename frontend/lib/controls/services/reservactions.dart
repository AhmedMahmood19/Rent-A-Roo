import 'dart:convert';
import 'package:http/http.dart';

import '../apisCalls.dart';

class Reservations {
  Future<List> getGuestReservations() async {
    Response res =
        await ApiCalls().getApiRequest('/reservations/guest');
    List body = jsonDecode(res.body);
    return body ?? [] ;
  }
  Future<List> getHostReservations() async {
    Response res =
        await ApiCalls().getApiRequest('/reservations/host');
    List body = jsonDecode(res.body);
    return body ?? [];
  }

    Future delUserData() async {
    Response res =
        await ApiCalls().delApiRequest('/user/profile');
    return res;
  }
}