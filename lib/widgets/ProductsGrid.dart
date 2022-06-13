import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorite;
  const ProductsGrid({Key? key, required this.showFavorite}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductProvider>(context);
    final listProduct =
        showFavorite ? productData.favoriteItem : productData.item;
    return listProduct.isEmpty
        ? const Center(
            child: Text(
            'Product list is empty',
            style: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ))
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, pos) {
              return ChangeNotifierProvider.value(
                value: listProduct[pos],
                child: const ProductItem(),
              );
            },
            itemCount: listProduct.length,
          );
  }
}
