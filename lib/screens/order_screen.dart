import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../providers/order.dart';
import '../widgets/order_item.dart' as ord;

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your order'),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) =>
            ord.OrderItem(order: orderData.orders[index]),
        itemCount: orderData.orders.length,
      ),
      drawer: const AppDrawer(),
    );
  }
}
