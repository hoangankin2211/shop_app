import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart-screen';
  const CartScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('build screen');
    final cartData = Provider.of<Cart>(context).item;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 15)),
                    const SizedBox(width: 10),
                    Consumer<Cart>(
                      builder: (context, cart, _) => Chip(
                        label: Text(
                          cart.totalAmount.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('ORDER NOW'),
                    )
                  ]),
            ),
          ),
          Expanded(
            child: cartData.isEmpty
                ? const Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Cart Empty!!!',
                      style: TextStyle(
                        fontFamily: 'RobotoCondensed-Bold',
                        fontSize: 30,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return CartItem(
                        id: cartData.values.toList()[index].id,
                        price: cartData.values.toList()[index].price,
                        quantity: cartData.values.toList()[index].quantity,
                        title: cartData.values.toList()[index].title,
                      );
                    },
                    itemCount: cartData.length,
                  ),
          ),
        ],
      ),
    );
  }
}
