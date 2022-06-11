import 'package:flutter/material.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit product')),
      body: Form(
        child: ListView(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Title: '),
              textInputAction: TextInputAction.next,
            )
          ],
        ),
      ),
    );
  }
}
