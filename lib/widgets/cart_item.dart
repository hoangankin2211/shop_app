import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;

  const CartItem({
    Key? key,
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    print('buildItem');
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 5,
          child: ListTile(
            leading: SizedBox(
              height: 70,
              width: 50,
              child: CircleAvatar(
                child: Text('\$' + price.toString()),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: ' +
                ((quantity * price * 100).round() / 100).toString() +
                ' \$'),
            trailing: SizedBox(
              width: constraints.maxWidth * 0.3,
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: IconButton(
                            onPressed: () => cart.addItem(id, price, title),
                            icon: const Icon(Icons.add, size: 20),
                          ),
                        ),
                        Expanded(
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(quantity.toString() + 'x'))),
                        Expanded(
                          child: IconButton(
                            onPressed: () => cart.removeOneItem(id),
                            icon: const Icon(Icons.remove, size: 20),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () => cart.removeAllItem(id),
                      child: const Text('Delete'),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
