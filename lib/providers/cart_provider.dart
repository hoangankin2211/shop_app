import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;
  CartItem(
      {required this.id,
      required this.price,
      required this.quantity,
      required this.title});
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _item = {};
  Map<String, CartItem> get item {
    return {..._item};
  }

  void addItem(String cartId, double price, String title) {
    if (_item.containsKey(cartId)) {
      _item.update(
          cartId,
          (value) => CartItem(
                id: value.id,
                price: value.price,
                quantity: value.quantity + 1,
                title: value.title,
              ));
    } else {
      _item.putIfAbsent(
        cartId,
        () => CartItem(
          id: cartId,
          price: price,
          quantity: 1,
          title: title,
        ),
      );
    }
    notifyListeners();
  }

  int get itemCount {
    return _item.length;
  }

  double get totalAmount {
    double total = 0.0;
    _item.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }
}
