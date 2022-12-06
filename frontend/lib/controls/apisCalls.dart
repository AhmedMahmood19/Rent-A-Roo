import 'dart:convert';
import 'dart:io';
 import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:rent_a_roo/controls/services/auth.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class ApiCalls {
  final LoginToken? loginToken;

  ApiCalls({this.loginToken});

  ///CONSTANTS FOR API CALLS
  ///eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJjbGllbnQiLCJpYXQiOjE2MTQ5NTE5MTl9.NhFa1eFf4Z1DNxmXUSVWt9VWDdsGch_w31yD5a5Muew
  // final String baseApiUrl = "https://.pk";
  final String baseApiUrl = "http://192.168.217.128:8000";

  Future<http.Response> postApiRequest(String route, dynamic bodyData) async {
    print(bodyData);
    var token = await Auth().getLoginTokenString();
    final Map<String, String> header = {
      "Authorization": "Bearer ${token}",
      //'Content-Type': 'application/json; charset=UTF-8',
    };

    return await http.post(
      Uri.parse(baseApiUrl + route),
      headers: header,
      body: bodyData,
    );
  }

  Future<http.Response> postApiRequestForm(
      String route,
      Map<String, String> bodyData,
      List<Map> files,
      List<Map> filesBytes) async {
   var token = await Auth().getLoginTokenString();
    var request = http.MultipartRequest('POST', Uri.parse(baseApiUrl+route));
    request.headers['Authorization'] = "Bearer ${token}";
    request.fields.addAll(bodyData);
    files.forEach((element) {
      var file = element["file"] as File;
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      final mimeTypeData =
          lookupMimeType("temp.png", headerBytes: [0xFF, 0xD8])?.split('/');
      request.files.add(http.MultipartFile.fromBytes(
          'file', file.readAsBytesSync(),
          filename: "temp.png",
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1])));
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    });

    filesBytes.forEach((element) {
      final mimeTypeData =
          lookupMimeType("temp.png", headerBytes: [0xFF, 0xD8])?.split('/');
      request.files.add(http.MultipartFile.fromBytes(
          'file', element["file"],
          filename: "temp.png",
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1])));
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    });

    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    var response = await request.send();

    final res = await http.Response.fromStream(response);

    return res;
  }

  Future<http.Response> postApiSignUpRequest(
      String route, dynamic bodyData) async {
    print(bodyData);
    var token = await Auth().getLoginTokenString();
    final Map<String, String> header = {
      "Authorization": "Bearer ${token}",
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final temp = jsonEncode(bodyData);

    return await http.post(
      Uri.parse(baseApiUrl + route),
      headers: header,
      body: temp,
    );
  }

  Future<http.Response> getApiRequest(String route, {Map? queryParams}) async {
    var token = await Auth().getLoginTokenString();
    final Map<String, String> header = {
      "Authorization": "Bearer ${token}",
      // 'Content-Type': 'application/json; charset=UTF-8',
    };

    final Map<String, dynamic> queries =
        jsonDecode(jsonEncode(queryParams ?? {}));
    http.Response res = await http.get(
      Uri.parse(baseApiUrl + route),
      headers: header,
    );
    return res;
  }

  Future<http.Response> putApiRequest(String route, dynamic bodyData) async {
    var token = await Auth().getLoginTokenString();
    final Map<String, String> header = {
      "Authorization": "Bearer ${token}",
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final temp = jsonEncode(bodyData);

    return await http.put(Uri.parse(baseApiUrl + route),
        headers: header, body: temp);
  }

  Future<http.Response> putApiReserveRequest(String route) async {
    var token = await Auth().getLoginTokenString();
    final Map<String, String> header = {
      "Authorization": "Bearer ${token}",
      'Content-Type': 'application/json; charset=UTF-8',
    };

    return await http.put(
      Uri.parse(baseApiUrl + route),
      headers: header,
    );
  }

  Future<http.Response> delApiRequest(String route) async {
    var token = await Auth().getLoginTokenString();
    final Map<String, String> header = {
      "Authorization": "Bearer ${token}",
      // 'Content-Type': 'application/json; charset=UTF-8',
    };

    return await http.delete(
      Uri.parse(baseApiUrl + route),
      headers: header,
    );
  }

  /* Stream<LoginToken> streamTokenFromCache() {
    return StreamingSharedPreferences.instance
        .then((prefs) => LoginToken(
            token: prefs.getString('loginToken', defaultValue: '').getValue()))
        .asStream();
  }*/
  Stream<LoginToken> streamTokenFromCache() async* {
    LoginToken oldToken = LoginToken(token: "");
    while (true) {
      await Future.delayed(const Duration(milliseconds: 10));
      var pref = await StreamingSharedPreferences.instance;
      var appVersion =
          pref.getString('versionLock', defaultValue: '0').getValue();
      LoginToken token = LoginToken(
          token: pref.getString('loginToken', defaultValue: '').getValue(),
          changePass: pref.getString('changePass', defaultValue: '').getValue(),
          appVersion: appVersion != null ? appVersion : "0");
      if (token.token != oldToken.token ||
          oldToken.appVersion != token.appVersion ||
          oldToken.changePass != token.changePass) {
        print("New Token");
        oldToken = LoginToken(
          token: token.token,
          appVersion: token.appVersion,
          changePass: token.changePass,
        );
        yield token;
      }
    }
  }
}

class LoginToken {
  final String token;
  final String changePass;
  final String appVersion;
  LoginToken(
      {required this.token, this.changePass = "0", this.appVersion = "0"});

  factory LoginToken.fromMap(Map data) {
    if (data != null
        ? data.isNotEmpty
            ? true
            : false
        : false)
      return LoginToken(
        token: data['token'],
        //changePass: data["data"]['changepassword'],
      );
    else
      return LoginToken(
        token: "-1",
      );
  }
}
