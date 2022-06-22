import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import './product_item.dart';

class ProductsGrid extends StatefulWidget {
  final bool showFavorite;
  const ProductsGrid({Key? key, required this.showFavorite}) : super(key: key);

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  bool _isLoading = false;

  void setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductProvider>(context);
    final listProduct =
        widget.showFavorite ? productData.favoriteItem : productData.item;
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
        : Stack(
            children: [
              if (_isLoading) const Center(child: CircularProgressIndicator()),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, pos) {
                  return ChangeNotifierProvider.value(
                    value: listProduct[pos],
                    child: ProductItem(setLoading: setLoading),
                  );
                },
                itemCount: listProduct.length,
              ),
            ],
          );
  }
}
