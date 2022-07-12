import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expirDate;
  String? _userID;

  // Auth(this._token, this._expirDate, this._userID);

  Future<void> signIn(String email, String password) async {
    const _url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyD6aZDpoCCGI4qiDeWift1jddROO-vL5oY';
    try {
      final response = await http.post(
        Uri.parse(_url),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final dataResponse = json.decode(response.body);
      print(dataResponse);
    } catch (e) {
      // TODO
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    const _url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyD6aZDpoCCGI4qiDeWift1jddROO-vL5oY';
    try {
      final response = await http.post(
        Uri.parse(_url),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final dataResponse = json.decode(response.body);
      print(dataResponse);
    } catch (e) {
      // TODO
      rethrow;
    }
  }
}
