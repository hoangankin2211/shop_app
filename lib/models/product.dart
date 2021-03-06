import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  void setFavoriteValue(bool value) {
    isFavorite = value;
    notifyListeners();
  }

  Future<void> toggleFavoriteButton(
      BuildContext context, String authToken, String userId) async {
    bool oldFavoriteValue = isFavorite;
    setFavoriteValue(!isFavorite);

    final url =
        'https://shop-app-database-23004-default-rtdb.asia-southeast1.firebasedatabase.app/UserData/$userId/favoriteProduct/$id.json?auth=$authToken';
    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        setFavoriteValue(oldFavoriteValue);
        throw HttpException(
            message: 'response.statusCode = ${response.statusCode}');
      }
    } catch (error) {
      setFavoriteValue(oldFavoriteValue);
      rethrow;
    }
  }
}
