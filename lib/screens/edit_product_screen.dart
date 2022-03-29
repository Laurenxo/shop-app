import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static String routeName = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  var _initProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
    isFavorite: false,
  );

  bool _isInit = true;

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit && ModalRoute.of(context)!.settings.arguments != null) {
      String productId = ModalRoute.of(context)!.settings.arguments as String;
      final Products products = Provider.of<Products>(context);
      if (productId != '') {
        Product product = products.findProductById(productId);
        _initProduct = Product(
          id: product.id,
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          isFavorite: product.isFavorite,
        );

        _editedProduct = product;

        _imageURLController.text = product.imageUrl;
      }

      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void _formSave() {
    bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    final products = Provider.of<Products>(
      context,
      listen: false,
    );
    if (_editedProduct.id == '') {
      products.addProduct(_editedProduct);
    } else {
      products.updateProduct(_editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editedProduct.id != '' ? 'Edit product' : 'Add product'),
        actions: [
          IconButton(
            onPressed: _formSave,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          // onChanged: _formSave,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initProduct.title,
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.newline,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide value.';
                  }
                },
                onSaved: (String? value) {
                  _editedProduct = Product(
                    title: value.toString(),
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.description,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),
              TextFormField(
                initialValue: _initProduct.price.toString(),
                decoration: const InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide value.';
                  }

                  if (double.tryParse(value) == null) {
                    return 'Please provide valid number';
                  }

                  if (double.parse(value) <= 0) {
                    return 'Please provide valid number';
                  }
                },
                onSaved: (String? value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(value!),
                    imageUrl: _editedProduct.description,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),
              TextFormField(
                initialValue: _initProduct.description,
                decoration: const InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide value.';
                  }

                  if (value.length < 10) {
                    return 'Please provide at least 10 characters';
                  }
                },
                onSaved: (String? value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    description: value.toString(),
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 10, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _imageURLController.text.isEmpty
                        ? const Text('Enter url')
                        : Image.network(_imageURLController.text),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'URL '),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageURLController,
                      onFieldSubmitted: (_) {
                        _formSave();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide value.';
                        }

                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please provide valid url';
                        }

                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please provide valid image';
                        }
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: value.toString(),
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
