import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class CartItem {
  final String idCart;
  final String id;
  final String title;
  final double price;
  final int quantity;
  CartItem(
      {required this.idCart,
      required this.id,
      required this.price,
      required this.quantity,
      required this.title});
}

class Cart with ChangeNotifier {
  final String _authToken;
  final String _userID;
  Map<String, CartItem> _item;
  Map<String, CartItem> get item {
    return {..._item};
  }

  Cart(this._authToken, this._item, this._userID);

  Future<void> fetchAndSetCart() async {
    final String url =
        'https://shop-app-database-23004-default-rtdb.asia-southeast1.firebasedatabase.app/UserData/$_userID/carts.json?auth=$_authToken';
    try {
      final response = await http.get(Uri.parse(url));
      if (json.decode(response.body) == null) {
        return;
      }
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      Map<String, CartItem> loadedCart = {};
      extractData.forEach(
        (key, value) {
          loadedCart.addAll(
            {
              value['id']: CartItem(
                idCart: key,
                id: value['id'],
                price: value['price'],
                quantity: value['quantity'],
                title: value['title'],
              ),
            },
          );
        },
      );
      _item = loadedCart;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addItem(String productId, double price, String title) {
    if (_item.containsKey(productId)) {
      return _updateItem(productId, _item[productId]!);
    } else {
      return _addNewCart(productId, price, title);
    }
  }

  Future<void> _updateItem(String productId, CartItem updatedItem) async {
    String idCart = updatedItem.idCart;
    String url =
        'https://shop-app-database-23004-default-rtdb.asia-southeast1.firebasedatabase.app/UserData/$_userID/carts/$idCart.json?auth=$_authToken';
    try {
      await http.patch(
        Uri.parse(url),
        body: json.encode({
          'id': updatedItem.id,
          'title': updatedItem.title,
          'price': updatedItem.price,
          'quantity': updatedItem.quantity + 1,
        }),
      );
      _item.update(
        productId,
        (value) => CartItem(
          idCart: value.idCart,
          id: value.id,
          price: value.price,
          quantity: value.quantity + 1,
          title: value.title,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _addNewCart(String productId, double price, String title) async {
    String url =
        'https://shop-app-database-23004-default-rtdb.asia-southeast1.firebasedatabase.app/UserData/$_userID/carts.json?auth=$_authToken';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'id': productId,
            'title': title,
            'price': price,
            'quantity': 1
          }));
      _item.putIfAbsent(
        productId,
        () => CartItem(
          idCart: json.decode(response.body)['name'],
          id: productId,
          price: price,
          quantity: 1,
          title: title,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeOneItem(String productId) async {
    String id = _item[productId]!.idCart;
    String url =
        'https://shop-app-database-23004-default-rtdb.asia-southeast1.firebasedatabase.app/UserData/$_userID/carts/$id.json?auth=$_authToken';
    try {
      if (_item[productId]!.quantity > 1) {
        _item.update(
          productId,
          (value) => CartItem(
            idCart: value.idCart,
            id: value.id,
            price: value.price,
            quantity: value.quantity - 1,
            title: value.title,
          ),
        );
        await http.patch(
          Uri.parse(url),
          body: json.encode({
            'id': _item[productId]!.id,
            'title': _item[productId]!.title,
            'price': _item[productId]!.price,
            'quantity': _item[productId]!.quantity,
          }),
        );
      } else {
        _item.removeWhere((key, value) => key == productId);
        await http.delete(Uri.parse(url));
      }
    } catch (e) {
      rethrow;
    }

    notifyListeners();
  }

  Future<void> removeAllItem(String productId) async {
    CartItem tempCart = _item[productId]!;
    _item.removeWhere((key, value) => key == productId);
    notifyListeners();
    String url =
        'https://shop-app-database-23004-default-rtdb.asia-southeast1.firebasedatabase.app/UserData/$_userID/carts/${tempCart.idCart}.json?auth=$_authToken';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _item.addAll({productId: tempCart});
      notifyListeners();
      throw const HttpException(message: 'Error');
    }
  }

  int get itemCount {
    return _item.length;
  }

  double get totalAmount {
    double total = 0.0;
    _item.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return ((total * 100).round()) / 100;
  }

  Future<void> clear() async {
    _item.clear();
    notifyListeners();
    final loadCart = _item;
    String url =
        'https://shop-app-database-23004-default-rtdb.asia-southeast1.firebasedatabase.app/UserData/$_userID/carts.json?auth=$_authToken';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode >= 400) {
        _item = loadCart;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}
