import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          title: Text(product.title),
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (context, product, _) => IconButton(
              onPressed: () {
                product.toggleFavorite();
              },
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
            ),
          ),
          trailing: Consumer<Cart>(
            builder: (_, cart, ch) => IconButton(
              onPressed: () {
                cart.addItem(product.id, product.title, product.price);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Item added'),
                    duration: const Duration(
                      seconds: 2,
                    ),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
