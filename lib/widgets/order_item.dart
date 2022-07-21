import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/order_provider.dart' as providerOrder;

class OrderItem extends StatefulWidget {
  const OrderItem({Key? key, required this.infoOrder}) : super(key: key);
  final providerOrder.OrderItem infoOrder;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expand = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _expand = !_expand;
        });
      },
      child: Card(
        margin: const EdgeInsets.all(5),
        elevation: 10,
        child: Column(
          children: [
            ListTile(
              title: Text(
                '\$' + widget.infoOrder.amount.toString(),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                DateFormat('dd-MM-yyyy hh:mm')
                    .format(widget.infoOrder.datetime),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _expand = !_expand;
                  });
                },
                icon: _expand
                    ? const Icon(Icons.expand_less)
                    : const Icon(Icons.expand_more),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              height: _expand ? widget.infoOrder.products.length * 20 + 10 : 0,
              padding: const EdgeInsets.only(right: 30, left: 30),
              child: ListView(
                children: widget.infoOrder.products
                    .map(
                      (e) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            e.price.toString() + 'x' + e.quantity.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
