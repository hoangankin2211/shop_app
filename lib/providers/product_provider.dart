// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../models/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class ProductProvider with ChangeNotifier {
  final String _authToken;
  final String _userId;
  List<Product> _item;

  ProductProvider(this._item, this._authToken, this._userId);

  List<Product> get items {
    return [..._item];
  }

  List<Product> get favoriteItem {
    return _item.where((element) => element.isFavorite == true).toList();
  }

  Product findById(String id) {
    return _item.firstWhere((element) => element.id == id);
  }

  bool isExisted(String id) {
    int index = _item.indexWhere((element) => element.id == id);
    if (index == -1) return false;
    return true;
  }

  Future<void> fetchAndSetProduct() async {
    final url =
        'https://shop-app-database-23004-default-rtdb.asia-southeast1.firebasedatabase.app/poduct.json?auth=$_authToken';
    final urlFavoriteData =
        'https://shop-app-database-23004-default-rtdb.asia-southeast1.firebasedatabase.app/UserData/$_userId/favoriteProduct.json?auth=$_authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final responseFavorite = await http.get(Uri.parse(urlFavoriteData));

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final favoriteData = json.decode(responseFavorite.body) == null
          ? null
          : json.decode(responseFavorite.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodID, product) {
        loadedProducts.add(Product(
          id: prodID,
          description: product['description'],
          imageUrl: product['imageUrl'],
          price: product['price'],
          title: product['title'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodID] ?? false,
        ));
      });
      _item = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product value) async {
    final url =
        'https://shop-app-database-23004-default-rtdb.asia-southeast1.firebasedatabase.app/poduct.json?auth=$_authToken';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': value.title,
            'description': value.description,
            'price': value.price,
            'imageUrl': value.imageUrl,
            'isFavorite': value.isFavorite,
          }));

      _item.add(
        Product(
          id: json.decode(response.body).toString(),
          description: value.description,
          imageUrl: value.imageUrl,
          price: value.price,
          title: value.title,
          isFavorite: value.isFavorite,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product value) async {
    final url =
        'https://shop-app-database-23004-default-rtdb.asia-southeast1.firebasedatabase.app/poduct/$id.json?auth=$_authToken';
    try {
      await http.patch(
        Uri.parse(url),
        body: json.encode({
          'title': value.title,
          'description': value.description,
          'price': value.price,
          'imageUrl': value.imageUrl,
          'isFavorite': value.isFavorite,
        }),
      );
      int index = _item.indexWhere((element) => element.id == value.id);
      _item[index] = value;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shop-app-database-23004-default-rtdb.asia-southeast1.firebasedatabase.app/poduct/$id.json?auth=$_authToken';
    final existingProductIndex =
        _item.indexWhere((element) => element.id == id);

    Product existingProduct = _item[existingProductIndex];
    _item.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _item.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw const HttpException(message: 'Error');
    }
    existingProduct.dispose();
  }
}
