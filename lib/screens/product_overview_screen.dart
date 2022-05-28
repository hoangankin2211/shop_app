import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/ProductsGrid.dart';
import 'add_product_screen.dart';
import '../widgets/badge.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

enum FilterFavorite { all, favorite }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  void showAddProductDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return const AddProductScreen();
        });
  }

  bool _showFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (selected) {
              setState(() {
                if (selected == FilterFavorite.all) {
                  _showFavorite = false;
                } else {
                  _showFavorite = true;
                }
              });
            },
            icon: const Icon(Icons.more_horiz),
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  child: Text('Favorite only'),
                  value: FilterFavorite.favorite,
                ),
                PopupMenuItem(
                  child: Text("Show all"),
                  value: FilterFavorite.all,
                ),
              ];
            },
          ),
          Consumer<Cart>(
            builder: (context, cart, _) => Badge(
                child: IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, CartScreen.routeName),
                  icon: const Icon(Icons.shopping_cart),
                ),
                value: cart.itemCount.toString(),
                color: Colors.amber),
          )
        ],
      ),
      body: ProductsGrid(showFavorite: _showFavorite),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddProductDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
