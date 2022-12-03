import 'dart:convert';
import 'package:http/http.dart';

import '../apisCalls.dart';

class Reservations {
  Future<List> getGuestReservations() async {
    Response res = await ApiCalls().getApiRequest('/reservations/guest');
    List body = jsonDecode(res.body);
    return body ?? [];
  }

  Future<List> getHostReservations() async {
    Response res = await ApiCalls().getApiRequest('/reservations/host');
    List body = jsonDecode(res.body);
    return body ?? [];
  }

  Future<Map> getGuestProfile(int reservationID) async {
    Response res =
        await ApiCalls().getApiRequest('/guest-profile/host/$reservationID');
    Map body = jsonDecode(res.body);
    return body ?? {};
  }

    Future<Map> getStatus(int reservationID) async {
    Response res =
        await ApiCalls().getApiRequest('/reservation-status/guest/$reservationID');
    Map body = jsonDecode(res.body);
    return body ?? {};
  }


  Future<List> getReservedDates(int listingid) async {
    Response res =
        await ApiCalls().getApiRequest('/reserved-dates/guest/$listingid');
    List body = jsonDecode(res.body);
    return body ?? [];
  }

  Future<Map> postReservation(Map data) async {
    Response res =
        await ApiCalls().postApiSignUpRequest('/reserve/guest', data);
    Map body = jsonDecode(res.body);
    return body ?? {};
  }

    Future<Map> decideReservation(int reservationid,bool IsAccepted) async {
    Response res =
        await ApiCalls().putApiReserveRequest("/reservation-status/host/$reservationid/$IsAccepted");
    Map body = jsonDecode(res.body);
    return body ?? {};
  }

  Future delUserData() async {
    Response res = await ApiCalls().delApiRequest('/user/profile');
    return res;
  }
}
