import 'package:flutter/material.dart';
import '../providers/product_provider.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final titleControl = TextEditingController();
  final idControl = TextEditingController();
  final imageUrl = TextEditingController();

  void _addNewProduct(
      {required String id, required String title, required String imageURL}) {
    if (id.isEmpty || title.isEmpty || imageURL.isEmpty) {
      return;
    }
    Provider.of<ProductProvider>(context, listen: false).addProduct(
      Product(
        id: id,
        imageUrl: imageURL,
        title: title,
        description: 'Test',
        price: 1000,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        color: Colors.white30,
        child: Column(
          children: [
            TextField(
              controller: idControl,
              autofocus: true,
              decoration: const InputDecoration(label: Text('Title')),
            ),
            TextField(
              controller: titleControl,
              decoration: const InputDecoration(label: Text('ID')),
            ),
            TextField(
              controller: imageUrl,
              decoration: const InputDecoration(label: Text('ImageURL: ')),
            ),
            TextButton(
              onPressed: () => _addNewProduct(
                id: idControl.text,
                title: titleControl.text,
                imageURL: imageUrl.text,
              ),
              child: const Text('Add new product'),
            )
          ],
        ),
      ),
    );
  }
}
