import 'package:flutter/material.dart';
import '../providers/product_provider.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit_product_screen';
  final String? id;
  const EditProductScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrl = TextEditingController();

  final _priceFocusNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlNode = FocusNode();

  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  void _showAlert(BuildContext context) {
    final isValid = _form.currentState?.validate();

    if (!isValid!) return;

    _form.currentState?.save();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Are you sure'),
          content: const Text('Do you want to save changes ? '),
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
        );
      },
    ).then((value) {
      if (value) _addProduct();
    });
  }

  void _addProduct() {
    Provider.of<ProductProvider>(context, listen: false)
        .addProduct(_editedProduct);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _imageUrlNode.addListener(_updateUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.id != null) {
      _editedProduct = Provider.of<ProductProvider>(context, listen: false)
          .findById(widget.id!);
    }
    _imageUrl.text = _editedProduct.imageUrl;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionNode.dispose();
    _imageUrl.dispose();
    _imageUrlNode.dispose();
    super.dispose();
  }

  void _updateUrl() {
    if (!_imageUrlNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 10,
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: const EdgeInsets.only(left: 10, right: 10),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Form(
          key: _form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit product',
                style: TextStyle(
                  fontFamily: 'RobotoCondensed-Bold',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                style: const TextStyle(fontSize: 15),
                initialValue: _editedProduct.title,
                decoration: const InputDecoration(label: Text('Title')),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_priceFocusNode),
                validator: (value) {
                  if (value!.isEmpty) return 'This field can\'n be empty';
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: value!,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),
              TextFormField(
                initialValue: _editedProduct.price.toString(),
                decoration: const InputDecoration(label: Text('Price')),
                style: const TextStyle(fontSize: 15),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_descriptionNode),
                onSaved: (value) => _editedProduct = Product(
                  id: _editedProduct.id,
                  title: _editedProduct.title,
                  description: _editedProduct.description,
                  price: double.parse(value!),
                  imageUrl: _editedProduct.imageUrl,
                  isFavorite: _editedProduct.isFavorite,
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'This field can\'n can be empty ';
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a positive number';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _editedProduct.description,
                decoration: const InputDecoration(label: Text('Description')),
                style: const TextStyle(fontSize: 15),
                focusNode: _descriptionNode,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description.';
                  }
                  if (value.length < 10) {
                    return 'Should be at least 10 characters long.';
                  }
                  return null;
                },
                onSaved: (value) => _editedProduct = Product(
                  id: _editedProduct.id,
                  title: _editedProduct.title,
                  description: value!,
                  price: _editedProduct.price,
                  imageUrl: _editedProduct.imageUrl,
                  isFavorite: _editedProduct.isFavorite,
                ),
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
                    child: (_imageUrl.text.isEmpty ||
                            !Uri.parse(_imageUrl.text).isAbsolute)
                        ? const Text('Enter a URL')
                        : Image.network(_imageUrl.text, fit: BoxFit.fill),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(label: Text('Image URL')),
                      style: const TextStyle(fontSize: 15),
                      keyboardType: TextInputType.multiline,
                      controller: _imageUrl,
                      focusNode: _imageUrlNode,
                      onSaved: (value) => _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: value!,
                        isFavorite: _editedProduct.isFavorite,
                      ),
                      onFieldSubmitted: (_) {
                        _showAlert(context);
                      },
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter URL';
                        if (!Uri.parse(value).isAbsolute) {
                          return 'Please enter a valid URL';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => _showAlert(context),
                child: const Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Raleway'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
