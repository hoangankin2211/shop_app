import 'package:flutter/material.dart';
import '../widgets/order_item.dart' as orderUI;
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import './app_drawer.dart';

class OrderScreen extends StatefulWidget {
  static const String routeName = '/order_screen';

  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isLoading = true;
  bool _initState = true;

  @override
  void didChangeDependencies() async {
    if (_initState) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Order>(context, listen: false).fetchAndLoadOrder();
      setState(() {
        _isLoading = false;
      });
    }
    _initState = false;
    super.didChangeDependencies();
  }

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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : orderList.isEmpty
                ? const Center(
                    child: Text('NO ORDER',
                        style:
                            TextStyle(fontFamily: 'RobotoCondensed-Regular')))
                : ListView.builder(
                    itemBuilder: (context, index) =>
                        orderUI.OrderItem(infoOrder: orderList[index]),
                    itemCount: orderList.length,
                  ),
      ),
    );
  }
}
