import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  final Map<bool, Widget> _contentSnackBar = {
    true: Container(
        height: 20,
        width: 10,
        alignment: Alignment.center,
        child: const CircularProgressIndicator()),
    false:
        const Text('Add product to cart successful', textAlign: TextAlign.start)
  };

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    var message = ScaffoldMessenger.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: GridTile(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            leading: Consumer<Product>(
              builder: (context, product, _) => IconButton(
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_outline,
                  size: 20,
                ),
                onPressed: () {
                  product.toggleFavoriteButton(context);

                  ScaffoldMessenger.of(context).hideCurrentSnackBar();

                  String content = '';
                  if (product.isFavorite) {
                    content = 'Added to the favorite list';
                  } else {
                    content = 'Deleted from the favorite list';
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        content,
                        textAlign: TextAlign.start,
                      ),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () => product.toggleFavoriteButton(context),
                        textColor: Colors.redAccent,
                      ),
                    ),
                  );
                },
              ),
            ),
            backgroundColor: Colors.black45,
            title: Text(
              product.title,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                size: 20,
              ),
              onPressed: () async {
                message.hideCurrentSnackBar();
                try {
                  message.showSnackBar(SnackBar(
                    content: _contentSnackBar[true]!,
                    duration: const Duration(seconds: 10),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () => cart.removeOneItem(product.id),
                      textColor: Colors.redAccent,
                    ),
                    backgroundColor: Colors.black54,
                  ));
                  await cart.addItem(product.id, product.price, product.title);
                } catch (error) {
                  rethrow;
                } finally {
                  message.hideCurrentSnackBar();
                  message.showSnackBar(SnackBar(
                    content: _contentSnackBar[false]!,
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () => cart.removeOneItem(product.id),
                      textColor: Colors.redAccent,
                    ),
                    backgroundColor: Colors.black54,
                  ));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
