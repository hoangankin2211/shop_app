import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  void toggleFavoriteButton(BuildContext context) {
    isFavorite = !isFavorite;
    Provider.of<ProductProvider>(context, listen: false)
        .updateProduct(id, this);
    notifyListeners();
  }
}
