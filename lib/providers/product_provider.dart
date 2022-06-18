// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../models/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<Product> _item = [];
  List<Product> get item {
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
    const url =
        'https://shop-app-database-23004-default-rtdb.asia-southeast1.firebasedatabase.app/poduct.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodID, product) {
        loadedProducts.add(Product(
          id: prodID,
          description: product['description'],
          imageUrl: product['imageUrl'],
          price: product['price'],
          title: product['title'],
          isFavorite: product['isFavorite'],
        ));
      });
      _item = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product value) async {
    const String url =
        'https://shop-app-database-23004-default-rtdb.asia-southeast1.firebasedatabase.app/poduct.json';
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

  void updateProduct(String id, Product value) {
    int index = _item.indexWhere((element) => element.id == value.id);
    _item.removeAt(index);
    _item.insert(
      index,
      Product(
        id: id,
        description: value.description,
        imageUrl: value.imageUrl,
        price: value.price,
        title: value.title,
        isFavorite: value.isFavorite,
      ),
    );
    notifyListeners();
  }

  void deleteProduct(String id) {
    _item.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
