import 'dart:html';

import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'dart:async';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiresDate;
  String? _userID;
  Timer? _authTime;

  bool get isAuth {
    return token != null;
  }

  String? get userID {
    return _userID;
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
      _autoLogout();
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

  void logOut() {
    _expiresDate = null;
    _token = null;
    _userID = null;
    _authTime?.cancel();
    notifyListeners();
  }

  void _autoLogout() {
    _authTime?.cancel();
    final timeToExpiry = _expiresDate!.difference(DateTime.now()).inSeconds;
    _authTime = Timer(Duration(seconds: timeToExpiry), logOut);
  }

  bool isEmpty(String? a) {
    return a?.length == 1;
  }
}
