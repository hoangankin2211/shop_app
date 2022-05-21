import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem(
      {Key? key, required this.id, required this.imageUrl, required this.title})
      : super(key: key);
  final String id;
  final String imageUrl;
  final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: id);
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: GridTile(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            leading: IconButton(
              icon: const Icon(
                Icons.favorite,
                size: 20,
              ),
              onPressed: () {},
            ),
            backgroundColor: Colors.black45,
            title: Text(
              title,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                size: 20,
              ),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}
