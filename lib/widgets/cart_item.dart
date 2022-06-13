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
    final cart = Provider.of<Cart>(context);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        margin: const EdgeInsets.all(7),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          size: 45,
          color: Colors.white,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: Theme.of(context).errorColor,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (dismiss) => cart.removeAllItem(id),
      confirmDismiss: (direction) {
        bool isDelete = false;
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              alignment: Alignment.center,
              title: const Text('Are you sure ?'),
              content:
                  const Text('Do you want to remove the item from the cart ? '),
              actions: [
                TextButton(
                  onPressed: () {
                    isDelete = true;
                    Navigator.of(context).pop();
                  },
                  child: const Text('YES'),
                ),
                TextButton(
                  onPressed: () {
                    isDelete = false;
                    Navigator.of(context).pop();
                  },
                  child: const Text('NO'),
                ),
              ],
            );
          },
        ).then((value) {
          return isDelete;
        });
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Card(
            margin: const EdgeInsets.all(7),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Align(
                        child: IconButton(
                          onPressed: () => cart.addItem(id, price, title),
                          icon: const Icon(Icons.add, size: 20),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(quantity.toString() + 'x'),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        child: IconButton(
                          onPressed: () => cart.removeOneItem(id),
                          icon: const Icon(Icons.remove, size: 20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
