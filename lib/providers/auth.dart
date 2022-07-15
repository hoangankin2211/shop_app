import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiresDate;
  String? _userID;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiresDate != null &&
        _expiresDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

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
      if (dataResponse['error'] != null) {
        throw HttpException(message: dataResponse['error']['message']);
      }
      _token = dataResponse['idToken'];
      _userID = dataResponse['localId'];
      _expiresDate = DateTime.now().add(
        Duration(seconds: int.parse(dataResponse['expiresIn'])),
      );
      notifyListeners();
    } catch (e) {
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
      if (dataResponse['error'] != null) {
        throw HttpException(message: dataResponse['error']['message']);
      }
    } catch (e) {
      rethrow;
    }
  }
}
