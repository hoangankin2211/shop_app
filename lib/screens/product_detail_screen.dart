import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail-screen';
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context)!.settings.arguments as String;
    final productData = Provider.of<ProductProvider>(context, listen: false)
        .findById(productID);

    return Scaffold(
      appBar: AppBar(
        title: Text(productData.title),
      ),
    );
  }
}
