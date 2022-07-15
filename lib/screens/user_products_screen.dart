import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './app_drawer.dart';
import '../providers/product_provider.dart';
import '../widgets/user_products_item.dart';
import 'edit_product_screen.dart';

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
        return const EditProductScreen(id: null);
      },
    );
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
      body: RefreshIndicator(
        onRefresh: () {
          return Provider.of<ProductProvider>(context).fetchAndSetProduct();
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: productData.items.isEmpty
              ? const Center(
                  child: Text(
                    'There is no product yet',
                    style: TextStyle(
                      fontFamily: 'Raleway-Bold',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView.builder(
                  itemBuilder: (context, index) => Column(
                    children: [
                      UserProductsItem(
                        id: productData.items[index].id,
                        imageUrl: productData.items[index].imageUrl,
                        title: productData.items[index].title,
                        removeItem: productData.deleteProduct,
                      ),
                      const Divider(),
                    ],
                  ),
                  itemCount: productData.items.length,
                ),
        ),
      ),
    );
  }
}
