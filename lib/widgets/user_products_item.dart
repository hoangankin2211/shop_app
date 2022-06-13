import 'package:flutter/material.dart';
import '../screens/edit_product_screen.dart';

class UserProductsItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;
  final Function(String) removeItem;
  const UserProductsItem(
      {Key? key,
      required this.title,
      required this.imageUrl,
      required this.removeItem,
      required this.id})
      : super(key: key);

  void _deleteItem(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('YES')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('NO')),
          ],
          title: const Text('Are your sure ?'),
          content: const Text('Do you want to delete product ?'),
        );
      },
    ).then((value) {
      if (value) removeItem(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 80,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return EditProductScreen(id: id);
                  },
                );
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
                onPressed: () => _deleteItem(context),
                icon: const Icon(Icons.delete),
                color: Colors.red)
          ],
        ),
      ),
    );
  }
}
