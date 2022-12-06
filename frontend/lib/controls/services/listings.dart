import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../apisCalls.dart';

class Listing {
  Future<Map> getListing(int listingid) async {
    Response res = await ApiCalls().getApiRequest('/listing/$listingid');
    Map body = jsonDecode(res.body);
    return body ?? {};
  }

  Future<List> postSearchListing(bool isPromoted, Map data) async {
    Response res = await ApiCalls()
        .postApiSignUpRequest('/listing/search/$isPromoted', data);
    print(res.body);
    List body = jsonDecode(res.body);
    return body ?? [];
  }
  Future<Map> postFav(int listingid) async {
    Response res = await ApiCalls()
        .postApiRequest('/listing/favourite/${listingid}',{});
    print(res.body);
    Map body = jsonDecode(res.body);
    return body ??{};
  }

  Future<Map> postListing(Map data) async {
    Response res =
        await ApiCalls().postApiSignUpRequest('/listing/create', data);
    Map body = jsonDecode(res.body);
    return body ?? {};
  }

  Future<Map> editListing(int listingID, Map data) async {
    Response res = await ApiCalls().putApiRequest('/listing/$listingID', data);
    Map body = jsonDecode(res.body);
    return body ?? {};
  }

  Future<List> getPopularListing() async {
    Response res = await ApiCalls().getApiRequest('/listing/popular-listings');
    List body = jsonDecode(res.body);
    return body ?? [];
  }

    Future<List> getQAList(int listingid) async {
    Response res = await ApiCalls().getApiRequest('/q-and-a-list/${listingid}');
    List body = jsonDecode(res.body);
    return body ?? [];
  }

  Future<List> getFavListing() async {
    Response res = await ApiCalls().getApiRequest('/listing/my-favourites');
    List body = jsonDecode(res.body);
    return body ?? [];
  }
  Future<List> getMyListing() async {
    Response res = await ApiCalls().getApiRequest('/listing/my-listings');
    List body = jsonDecode(res.body);
    return body ?? [];
  }

    Future<List> getReviewsList(int listingid) async {
    Response res = await ApiCalls().getApiRequest('/r-and-r-list/${listingid}');
    List body = jsonDecode(res.body);
    return body ?? [];
  }

  Future<Map> postPromotedListing(Map temp) async {
    Response res = await ApiCalls().postApiSignUpRequest('/listing/promote',temp);
    Map body = jsonDecode(res.body);
    return body ?? {};
  }
  Future<Map> postListingAnswer(Map temp) async {
    Response res = await ApiCalls().postApiSignUpRequest('/answer-question/host',temp);
    Map body = jsonDecode(res.body);
    return body ?? {};
  }
    Future<Map> postListingQuestion(Map temp) async {
    Response res = await ApiCalls().postApiSignUpRequest('/ask-question/guest',temp);
    Map body = jsonDecode(res.body);
    return body ?? {};
  }

  Future updateUserData(dynamic body) async {
    Response res = await ApiCalls().putApiRequest('/user/profile', body);
    return res;
  }

  Future<Response> updatePhoto(Uint8List file,int listingid) async {
    Map files = {};
    files["body"] = "image";
    files["file"] = file;
    var res = await ApiCalls()
        .postApiRequestForm('/listing/image/${listingid}', {}, [], [files]);
    return res;
  }

  Future delListing(int listingid) async {
    Response res = await ApiCalls().delApiRequest('/listing/$listingid');
    return res;
  }
    Future delFav(int listingid) async {
    Response res = await ApiCalls().delApiRequest('/listing/unfavourite/${listingid}');
    return res;
  }
}
