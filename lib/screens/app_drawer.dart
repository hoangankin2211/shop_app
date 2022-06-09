import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import './product_overview_screen.dart';
import './orders_screen.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(title: const Text('MENU')),
          ListTile(
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ProductOverviewScreen.routeName),
            title: const Icon(Icons.shop),
            trailing: const Text('SHOP'),
          ),
          ListTile(
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrderScreen.routeName),
            title: const Icon(Icons.payment),
            trailing: const Text('ORDER'),
          ),
        ],
      ),
      elevation: 5,
    );
  }
}
