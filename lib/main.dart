import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';

// Firebase configuration
const firebaseConfig = FirebaseOptions(
  apiKey: "AIzaSyDt-StAE6fQ8BEXI9kQsTZS-7SvGpEWGX0",
  authDomain: "shopping-list-8fde8.firebaseapp.com",
  databaseURL: "https://shopping-list-8fde8-default-rtdb.firebaseio.com",
  projectId: "shopping-list-8fde8",
  storageBucket: "shopping-list-8fde8.firebasestorage.app",
  messagingSenderId: "181461429838",
  appId: "1:181461429838:web:3003e01f47e212eb5d9d1f",
);

class Product {
  Product({
    required this.name,
    this.quantity = 1,
    this.inCart = false,
  });

  final String name;
  int quantity;
  bool inCart;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'inCart': inCart,
    };
  }

  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 1,
      inCart: json['inCart'] ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

typedef CartChangedCallback = void Function(Product product, bool inCart);
typedef QuantityChangedCallback = void Function(Product product, int quantity);

class ShoppingListItem extends StatelessWidget {
  ShoppingListItem({
    required this.product,
    required this.onCartChanged,
    required this.onQuantityChanged,
  }) : super(key: ObjectKey(product));

  final Product product;
  final CartChangedCallback onCartChanged;
  final QuantityChangedCallback onQuantityChanged;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return product.inCart //
        ? Colors.black54
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!product.inCart) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    final quantityController =
        TextEditingController(text: product.quantity.toString());

    return ListTile(
      onTap: () {
        onCartChanged(product, !product.inCart);
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(
          product.name[0],
          style: TextStyle(
            color: product.inCart ? Colors.white : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        product.name,
        style: _getTextStyle(context),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus button
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () {
              if (product.quantity > 0) {
                onQuantityChanged(product, product.quantity - 1);
              }
            },
            iconSize: 24,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          // Quantity text field
          SizedBox(
            width: 50,
            child: TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              onSubmitted: (value) {
                final newQuantity = int.tryParse(value) ?? 1;
                onQuantityChanged(product, newQuantity);
              },
            ),
          ),
          const SizedBox(width: 8),
          // Plus button
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              onQuantityChanged(product, product.quantity + 1);
            },
            iconSize: 24,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          // Cart checkbox
          product.inCart
              ? const Icon(Icons.check_circle, color: Colors.green)
              : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
        ],
      ),
    );
  }
}

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final List<Product> _products = [
    Product(name: 'Eggs'),
    Product(name: 'Flour'),
    Product(name: 'Chocolate chips'),
  ];
  final _shoppingCart = <Product>{};
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleCartChanged(Product product, bool inCart) {
    setState(() {
      product.inCart = inCart;
      if (inCart) {
        _shoppingCart.add(product);
      } else {
        _shoppingCart.remove(product);
      }
    });
  }

  void _handleQuantityChanged(Product product, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        // Remove item from list if quantity is 0
        _products.remove(product);
        _shoppingCart.remove(product);
      } else {
        product.quantity = newQuantity;
      }
    });
  }

  void _addItem(String name) {
    if (name.trim().isEmpty) return;

    setState(() {
      _products.add(Product(name: name.trim()));
      _textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total quantity of items in cart
    final totalInCart = _shoppingCart.fold<int>(
      0,
      (sum, product) => sum + product.quantity,
    );
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'In Cart: $totalInCart',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _products.isEmpty
                ? const Center(
                    child: Text('No items yet. Add items below!'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return ShoppingListItem(
                        product: product,
                        onCartChanged: _handleCartChanged,
                        onQuantityChanged: _handleQuantityChanged,
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Add to list',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: 'Enter item name',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        onSubmitted: (value) {
                          _addItem(value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () {
                    _addItem(_textController.text);
                  },
                  tooltip: 'Add Item',
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: ShoppingList(),
    ),
  );
}
