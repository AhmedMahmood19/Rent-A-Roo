import 'dart:convert';
import 'package:http/http.dart';
import 'package:rent_a_roo/controls/apisCalls.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';


class Auth {
  Future<Response> login(String userName, String password) async {
    var preferences = await StreamingSharedPreferences.instance;
    dynamic bodyData = {
      "username": userName,
      "password": password
    };

    String route = "/user/login";

    var response = await ApiCalls(loginToken: LoginToken(token: ""))
        .postApiRequest(route, bodyData);
    //print(response.body.toString());

    var tokenMap = jsonDecode(response.body);
    if (tokenMap != null && tokenMap['access_token'] != null) {
      await preferences.setString('loginToken', tokenMap['access_token']);
     
    }

    return response;
  }



  Future<Response> forgotPassword({required Map bodyData}) async {
    // BODY DATA REQUIRES REGISTRATION ID GIVEN AS KEY
    // username
    Response res = await ApiCalls(loginToken: LoginToken(token: ""))
        .postApiRequest('/transaction/forgotpassword', bodyData);
    //Map body = jsonDecode(res.body);
    return res;
  }

  Future<Response> signUp(Map body) async {
    String route = "/user/register";
    

    var response = await ApiCalls(loginToken: LoginToken(token: ""))
        .postApiSignUpRequest(route, body);
    //print(response.body.toString());

    //var tokenMap = jsonDecode(response.body);

    return response;
  }

  getLoginTokenString() async {
    var preferences = await StreamingSharedPreferences.instance;
    var loginToken =
        preferences.getString('loginToken', defaultValue: '').getValue();

    print(
        '$loginToken get login token string function call!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    return loginToken != null ? loginToken : "";
  }

  Future setPasswordBit(String bit) async {
    var preferences = await StreamingSharedPreferences.instance;
    await preferences.setString('changePass', bit);
  }

  Future logout() async {
    var preferences = await StreamingSharedPreferences.instance;
    preferences.setString('loginToken', '');
  }
}