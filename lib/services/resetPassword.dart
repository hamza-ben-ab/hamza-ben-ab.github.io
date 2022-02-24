import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  String _token;

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final url =
        'https://identitytoolkit..com/v1/accounts:$urlSegment?key=AIzaSyAwZ5icrRsXMj2heMIpIxVFEaOzR_SH2b0';
    final response = await http.post(
      url,
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        //"Access-Control-Allow-Credentials": true,  Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      },
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    final responseData = json.decode(response.body);
    print(responseData);
    _token = responseData['idToken'];
    print('************************' + _token.toString());
    try {
      if (urlSegment == "signUp") {
        sharedPreferences.setString("token", _token.toString());
      }
    } catch (e) {
      print(e);
    }
    print("true");
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> changePassword(String newPassword) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(newPassword);
    _token = sharedPreferences.getString("token");
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyAwZ5icrRsXMj2heMIpIxVFEaOzR_SH2b0';
    try {
      await http.post(
        url,
        headers: {
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          //"Access-Control-Allow-Credentials": true,  Required for cookies, authorization headers with HTTPS
          "Access-Control-Allow-Headers":
              "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS"
        },
        body: json.encode(
          {
            'idToken': _token,
            'password': newPassword,
            'returnSecureToken': true,
          },
        ),
      );
    } catch (error) {
      throw error;
    }
  }
}
