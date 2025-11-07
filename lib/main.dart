import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';

// Firebase configuration
const firebaseConfig = FirebaseOptions(
  apiKey: "",
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

// List selection screen shown on app startup
class ListSelectionScreen extends StatefulWidget {
  const ListSelectionScreen({super.key});

  @override
  State<ListSelectionScreen> createState() => _ListSelectionScreenState();
}

class _ListSelectionScreenState extends State<ListSelectionScreen> {
  List<String> _savedListIds = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedLists();
  }

  Future<void> _loadSavedLists() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedListIds = prefs.getStringList('saved_lists') ?? [];
      _loading = false;
    });
  }

  Future<void> _createNewSharedList() async {
    final listId = const Uuid().v4();
    await _saveListId(listId);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ShoppingList(listId: listId, isShared: true),
        ),
      );
    }
  }

  Future<void> _createLocalList() async {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              const ShoppingList(listId: 'local', isShared: false),
        ),
      );
    }
  }

  Future<void> _openList(String listId) async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ShoppingList(listId: listId, isShared: true),
      ),
    );
  }

  Future<void> _saveListId(String listId) async {
    final prefs = await SharedPreferences.getInstance();
    final lists = prefs.getStringList('saved_lists') ?? [];
    if (!lists.contains(listId)) {
      lists.add(listId);
      await prefs.setStringList('saved_lists', lists);
    }
  }

  Future<void> _deleteList(String listId) async {
    final prefs = await SharedPreferences.getInstance();
    final lists = prefs.getStringList('saved_lists') ?? [];
    lists.remove(listId);
    await prefs.setStringList('saved_lists', lists);
    setState(() {
      _savedListIds = lists;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Shopping List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Your Lists',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_savedListIds.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Text(
                  'No saved lists yet.\nCreate a new list below!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _savedListIds.length,
                  itemBuilder: (context, index) {
                    final listId = _savedListIds[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.shopping_cart),
                        title: const Text('Shared List'),
                        subtitle: Text('ID: ${listId.substring(0, 8)}...'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteList(listId),
                        ),
                        onTap: () => _openList(listId),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _createNewSharedList,
              icon: const Icon(Icons.share),
              label: const Text('Create New Shared List'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _createLocalList,
              icon: const Icon(Icons.phone_android),
              label: const Text('Create Local List (Not Shared)'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShoppingList extends StatefulWidget {
  const ShoppingList({
    super.key,
    required this.listId,
    required this.isShared,
  });

  final String listId;
  final bool isShared;

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final List<Product> _products = [];
  final _shoppingCart = <Product>{};
  final _textController = TextEditingController();
  DatabaseReference? _listRef;

  @override
  void initState() {
    super.initState();
    if (widget.isShared) {
      _initializeFirebase();
    } else {
      _loadLocalList();
    }
  }

  Future<void> _initializeFirebase() async {
    _listRef =
        FirebaseDatabase.instance.ref('lists/${widget.listId}/products');

    // Listen for changes
    _listRef!.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _products.clear();
          _shoppingCart.clear();
          data.forEach((key, value) {
            final product = Product.fromJson(value);
            _products.add(product);
            if (product.inCart) {
              _shoppingCart.add(product);
            }
          });
        });
      }
    });
  }

  void _loadLocalList() {
    setState(() {
      _products.addAll([
        Product(name: 'Eggs'),
        Product(name: 'Flour'),
        Product(name: 'Chocolate chips'),
      ]);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _syncToFirebase() async {
    if (_listRef == null) return;

    final Map<String, dynamic> productsMap = {};
    for (var product in _products) {
      productsMap[product.name] = product.toJson();
    }
    await _listRef!.set(productsMap);
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
    if (widget.isShared) {
      _syncToFirebase();
    }
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
    if (widget.isShared) {
      _syncToFirebase();
    }
  }

  void _addItem(String name) {
    if (name.trim().isEmpty) return;

    setState(() {
      _products.add(Product(name: name.trim()));
      _textController.clear();
    });
    if (widget.isShared) {
      _syncToFirebase();
    }
  }

  Future<void> _shareList() async {
    if (!widget.isShared) {
      // Convert to shared list first
      final listId = const Uuid().v4();
      final prefs = await SharedPreferences.getInstance();
      final lists = prefs.getStringList('saved_lists') ?? [];
      lists.add(listId);
      await prefs.setStringList('saved_lists', lists);

      // Navigate to new shared list
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ShoppingList(listId: listId, isShared: true),
          ),
        );
      }
      return;
    }

    // Show email dialog
    final emailController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share List'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter email address to share with:'),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'email@example.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, emailController.text),
            child: const Text('Send'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      // Create shareable link
      final shareUrl =
          'https://perelguttrios.github.io/Shopping-List/?list=${widget.listId}';

      // Open email client with pre-filled message
      final emailUri = Uri(
        scheme: 'mailto',
        path: result,
        query:
            'subject=${Uri.encodeComponent('Shopping List Invitation')}&body=${Uri.encodeComponent('Join my shopping list!\n\nClick here to open: $shareUrl')}',
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Share link: $shareUrl')),
          );
        }
      }
    }
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
        title: Text(widget.isShared
            ? 'Shared Shopping List'
            : 'Local Shopping List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareList,
            tooltip: 'Share List',
          ),
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
          if (widget.isShared)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.blue[50],
              child: const Row(
                children: [
                  Icon(Icons.cloud_done, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This list is synced across all devices',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(options: firebaseConfig);
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shared Shopping List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ListSelectionScreen(),
    );
  }
}
