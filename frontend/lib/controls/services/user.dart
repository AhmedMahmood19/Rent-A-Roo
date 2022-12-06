import 'dart:convert';
import 'dart:typed_data';
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

    Future<Response> updatePhoto(Uint8List file) async {
    Map files = {};
    files["name"] = "image";
    files["file"] = file;
    var res = await ApiCalls()
        .postApiRequestForm('/user/profile/image', {}, [], [files]);
    return res;
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