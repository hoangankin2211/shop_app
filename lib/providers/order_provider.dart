import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import './cart_provider.dart';

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
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProduct, double total) {
    if (cartProduct.isEmpty) return;
    _orders.insert(
      0,
      OrderItem(
          amount: total,
          id: DateTime.now().toString(),
          datetime: DateTime.now(),
          products: cartProduct),
    );
    notifyListeners();
  }
}
