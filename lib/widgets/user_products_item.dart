import 'package:flutter/material.dart';
import '../screens/edit_product_screen.dart';

class UserProductsItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;
  final Future<void> Function(String) removeItem;
  const UserProductsItem(
      {Key? key,
      required this.title,
      required this.imageUrl,
      required this.removeItem,
      required this.id})
      : super(key: key);

  void _deleteItem(BuildContext context) {
    final message = ScaffoldMessenger.of(context);
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
    ).then(
      (value) async {
        if (value == null) {
          return null;
        }
        if (value) {
          try {
            await removeItem(id);
            message.showSnackBar(
              const SnackBar(
                content: Text('Successfully deleted'),
                duration: Duration(seconds: 2),
              ),
            );
          } catch (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Deleting failed',
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      },
    );
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
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
