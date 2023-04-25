import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  _ShopScreenState createState() => _ShopScreenState();
}
class _ShopScreenState extends State<ShopScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Screen'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/');
            }),
      ),
      body: Center(
        child: Text(
          'Shop',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
