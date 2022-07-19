import 'package:shared_preferences/shared_preferences.dart';

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
    if (token == null) {
      return false;
    } else {
      return true;
    }
  }

  String? get userID {
    return _userID;
  }

  String? get token {
    if (_expiresDate != null &&
        _token != null &&
        _expiresDate!.isAfter(DateTime.now())) {
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

      final pref = await SharedPreferences.getInstance();
      final userDataLogin = json.encode({
        'token': _token,
        'expiresDate': _expiresDate!.toIso8601String(),
        'userID': _userID,
      });
      pref.setString('userDataLogin', userDataLogin);
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

  Future<void> logOut() async {
    final pref = await SharedPreferences.getInstance();

    pref.clear();

    _expiresDate = null;
    _token = null;
    _userID = null;

    _authTime?.cancel();
    _authTime = null;

    notifyListeners();

    // if (token == null) {
    //   print('Token is null');
    //   print(isAuth);
    // }
  }

  void _autoLogout() {
    _authTime?.cancel();
    final timeToExpiry = _expiresDate!.difference(DateTime.now()).inSeconds;
    _authTime = Timer(Duration(seconds: timeToExpiry), logOut);
  }

  Future<bool> tryLoginAgain() async {
    final pref = await SharedPreferences.getInstance();

    if (!pref.containsKey('userDataLogin')) {
      return false;
    }

    final userData = pref.getString('userDataLogin');

    final extractedUserData = json.decode(userData!) as Map<String, dynamic>;

    final extractedExpiresDate =
        DateTime.parse(extractedUserData['expiresDate'] as String);
    if (extractedExpiresDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'] as String;
    _expiresDate = extractedExpiresDate;
    _userID = extractedUserData['userID'] as String;

    notifyListeners();
    _autoLogout();
    return true;
  }
}
