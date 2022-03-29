import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/user_product_item.dart';

import '../providers/products.dart';
import '../widgets/app_drawer.dart';

class UserProductScreen extends StatelessWidget {
  static String routeName = '/user-product';

  const UserProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your product'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemBuilder: (_, i) => Column(
          children: [
            UserProductItem(
              id: productData.items[i].id,
              title: productData.items[i].title,
              imageUrl: productData.items[i].imageUrl,
            ),
            const Divider(),
          ],
        ),
        itemCount: productData.items.length,
      ),
    );
  }
}
