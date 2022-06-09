import 'dart:math';

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
    return Card(
      margin: const EdgeInsets.all(5),
      elevation: 5,
      child: Column(
        children: [
          ListTile(
            title: Text(widget.infoOrder.amount.toString()),
            subtitle: Text(DateFormat('dd MM yyyy hh:mm')
                .format(widget.infoOrder.datetime)),
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
          if (_expand)
            Container(
              height: widget.infoOrder.products.length * 5 + 100,
              padding: const EdgeInsets.all(20),
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
                          Text(e.price.toString() + 'x' + e.quantity.toString())
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
