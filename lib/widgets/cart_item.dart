import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String productId;
  final String id;
  final String title;
  final double price;
  final int quantity;

  const CartItem({
    Key? key,
    required this.productId,
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        padding: const EdgeInsets.only(
          right: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(
              Icons.delete,
              size: 24,
              color: Colors.white,
            ),
          ],
        ),
        color: Colors.red,
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text('Do you want to remove the item?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    child: const Text('Yes'),
                  ),
                ],
              );
            });
      },
      onDismissed: (_) {
        final cart = Provider.of<Cart>(
          context,
          listen: false,
        );
        cart.removeItem(productId);
      },
      key: ValueKey(id),
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: FittedBox(
                child: Text('\$$price'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          title: Text(title),
          subtitle: Text('Total \$${price * quantity}'),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
