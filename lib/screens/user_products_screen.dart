import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './app_drawer.dart';
import '../providers/product_provider.dart';
import '../widgets/user_products_item.dart';
import './add_product_screen.dart';

class UserProductsScreen extends StatefulWidget {
  static const String routeName = './user_products_screen';

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  State<UserProductsScreen> createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  void showAddProductDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return const AddProductScreen();
        });
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Products'),
        actions: [
          IconButton(
            onPressed: () => showAddProductDialog(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const DrawerScreen(),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (context, index) => Column(
            children: [
              UserProductsItem(
                imageUrl: productData.item[index].imageUrl,
                title: productData.item[index].title,
              ),
              const Divider(),
            ],
          ),
          itemCount: productData.item.length,
        ),
      ),
    );
  }
}
