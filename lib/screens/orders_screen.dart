import 'package:flutter/material.dart';
import '../widgets/order_item.dart' as orderUI;
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import './app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const String routeName = '/order_screen';

  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context, listen: false);
    final orderList = orderData.orders;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
      ),
      drawer: const DrawerScreen(),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: orderList.isEmpty
            ? const Center(
                child: Text('NO ORDER',
                    style: TextStyle(fontFamily: 'RobotoCondensed-Regular')))
            : ListView.builder(
                itemBuilder: (context, index) =>
                    orderUI.OrderItem(infoOrder: orderList[index]),
                itemCount: orderList.length,
              ),
      ),
    );
  }
}
