import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class ProductItem extends StatefulWidget {
  final Function(bool) setLoading;
  const ProductItem({Key? key, required this.setLoading}) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
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
            fit: BoxFit.fill,
          ),
          footer: SizedBox(
            height: 35,
            child: GridTileBar(
              leading: Consumer<Product>(
                builder: (context, product, _) => SizedBox(
                  width: 15,
                  child: IconButton(
                    icon: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      size: 15,
                    ),
                    onPressed: () async {
                      try {
                        await product.toggleFavoriteButton(context);

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
                              onPressed: () =>
                                  product.toggleFavoriteButton(context),
                              textColor: Colors.redAccent,
                            ),
                          ),
                        );
                      } catch (error) {
                        showDialog(
                          context: (context),
                          builder: (_) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: Text(error.toString()),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                )
                              ],
                            );
                          },
                        );
                        rethrow;
                      }
                    },
                  ),
                ),
              ),
              backgroundColor: Colors.black45,
              title: Text(
                product.title,
                style: const TextStyle(fontSize: 12, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              trailing: SizedBox(
                width: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.shopping_cart,
                    size: 16,
                  ),
                  onPressed: () async {
                    try {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actions: [
                                TextButton(
                                  child: const Text('YES'),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text('NO'),
                                )
                              ],
                              title: const Text('Confirm'),
                              content: const Text(
                                  'Are you sure to add this product to cart ?'),
                            );
                          }).then((isAccept) async {
                        if (isAccept) {
                          widget.setLoading(true);
                          await cart.addItem(
                              product.id, product.price, product.title);
                          widget.setLoading(false);
                          message.clearSnackBars();
                          message.showSnackBar(SnackBar(
                            content: const Text(
                              'Add product to cart successful',
                              textAlign: TextAlign.start,
                              style: TextStyle(color: Colors.lightGreen),
                            ),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'UNDO',
                              onPressed: () => cart.removeOneItem(product.id),
                              textColor: Colors.white54,
                            ),
                            backgroundColor: Colors.black54,
                          ));
                        }
                      });
                    } catch (error) {
                      rethrow;
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
