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
  final _imageUrl = TextEditingController();

  final _priceFocusNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlNode = FocusNode();

  final _form = GlobalKey<FormState>();

  String title = '';
  String imageUrl = '';
  double price = 0;
  String description = '';

  void _addNewProduct(BuildContext context) {
    _form.currentState?.save();

    if (title.isEmpty || imageUrl.isEmpty) {
      return;
    }
    Provider.of<ProductProvider>(context, listen: false).addProduct(
      Product(
        id: DateTime.now().toString(),
        imageUrl: imageUrl,
        title: title,
        description: description,
        price: price,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _imageUrlNode.addListener(_updateUrl);
    super.initState();
  }

  void _updateUrl() {
    if (!_imageUrlNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionNode.dispose();
    _imageUrl.dispose();
    _imageUrlNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        height: MediaQuery.of(context).size.height * 0.6,
        color: Colors.white30,
        child: Form(
          key: _form,
          child: Column(
            children: [
              const Text(
                'Add new Product',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'RobotoCondensed-Bold',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                autofocus: true,
                decoration: const InputDecoration(label: Text('Title')),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_priceFocusNode),
                onSaved: (value) {
                  title = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text('Price')),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_descriptionNode),
                onSaved: (value) => price = double.parse(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text('Description')),
                focusNode: _descriptionNode,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onSaved: (value) => description = value!,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 4),
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45),
                    ),
                    child: _imageUrl.text.isEmpty
                        ? const Text('Enter a URL')
                        : Image.network(_imageUrl.text),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(label: Text('Image URL')),
                      keyboardType: TextInputType.multiline,
                      controller: _imageUrl,
                      focusNode: _imageUrlNode,
                      onSaved: (value) => imageUrl = value!,
                      onFieldSubmitted: (_) {
                        _addNewProduct(context);
                      },
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextButton(
                  onPressed: () => _addNewProduct(context),
                  child: const Text('Save'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
