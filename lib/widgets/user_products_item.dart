import 'package:flutter/material.dart';

class UserProductsItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  const UserProductsItem(
      {Key? key, required this.title, required this.imageUrl})
      : super(key: key);

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
              onPressed: () {},
              icon: const Icon(Icons.edit),
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete),
                color: Colors.red)
          ],
        ),
      ),
    );
  }
}
