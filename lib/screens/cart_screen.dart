import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/order_provider.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = '/cart-screen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _initState = true;
  bool _isLoading = false;
  bool _isFinish = false;
  @override
  void didChangeDependencies() async {
    if (_initState) {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Cart>(context, listen: false).fetchAndSetCart();

        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        rethrow;
      }
    }
    _initState = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    final addOrder = Provider.of<Order>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                              onPressed: () async {
                                try {
                                  setState(() {
                                    _isFinish = true;
                                  });
                                  await addOrder.addOrder(
                                      cartData.item.values.toList(),
                                      cartData.totalAmount);
                                  cartData.clear();
                                  setState(() {
                                    _isFinish = false;
                                  });
                                } catch (error) {
                                  await showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        actions: [
                                          TextButton(
                                            child: const Text('OK'),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          )
                                        ],
                                        title: const Text('An error occurred'),
                                        content: Text(error.toString()),
                                      );
                                    },
                                  );
                                  rethrow;
                                }
                              },
                              child: _isFinish
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : const Text('ORDER NOW'))
                        ]),
                  ),
                ),
                Expanded(
                  child: cartData.item.isEmpty
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
                              id: cartData.item.values.toList()[index].id,
                              price: cartData.item.values.toList()[index].price,
                              quantity:
                                  cartData.item.values.toList()[index].quantity,
                              title: cartData.item.values.toList()[index].title,
                            );
                          },
                          itemCount: cartData.item.length,
                        ),
                ),
              ],
            ),
    );
  }
}
