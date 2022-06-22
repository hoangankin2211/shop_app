import 'package:flutter/material.dart';
import './cart_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  const OrderItem(
      {Key? key,
      required this.amount,
      required this.id,
      required this.datetime,
      required this.products});
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndLoadOrder() async {
    String url =
        'https://shop-app-database-23004-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      List<OrderItem> loadedItem = [];
      extractData.forEach((key, value) {
        List<CartItem> listCart = [];

        final extractedListCart = value['product'] as List<dynamic>;
        for (var cart in extractedListCart) {
          listCart.add(CartItem(
              idCart: cart['idCart'],
              id: cart['id'],
              price: cart['price'],
              quantity: cart['quantity'],
              title: cart['title']));
        }
        loadedItem.add(
          OrderItem(
            amount: value['amount'],
            id: key,
            datetime: DateTime.parse(value['datetime']),
            products: listCart,
          ),
        );
      });
      _orders = loadedItem;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    if (cartProduct.isEmpty) return;
    final time = DateTime.now();
    String url =
        'https://shop-app-database-23004-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'amount': total,
            'datetime': time.toString(),
            'product': cartProduct
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'price': e.price,
                      'quantity': e.quantity,
                      'idCart': e.idCart
                    })
                .toList(),
          },
        ),
      );
      String address = json.decode(response.body)['name'];
      _orders.insert(
        0,
        OrderItem(
          amount: total,
          id: address,
          datetime: time,
          products: cartProduct,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
