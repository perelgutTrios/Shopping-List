import 'package:flutter/material.dart';import 'package:flutter/material.dart';

import 'package:flutter/services.dart';import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_database/firebase_database.dart';class Product {

import 'package:shared_preferences/shared_preferences.dart';  Product({required this.name, this.quantity = 1});

import 'package:uuid/uuid.dart';

import 'package:url_launcher/url_launcher.dart';  final String name;

  int quantity;

// Firebase configuration for web

const firebaseConfig = FirebaseOptions(  @override

  apiKey: "AIzaSyDemoKey-ReplaceWithYourKey",  bool operator ==(Object other) =>

  authDomain: "your-app.firebaseapp.com",      identical(this, other) ||

  databaseURL: "https://your-app-default-rtdb.firebaseio.com",      other is Product &&

  projectId: "your-project-id",          runtimeType == other.runtimeType &&

  storageBucket: "your-app.appspot.com",          name == other.name;

  messagingSenderId: "123456789",

  appId: "1:123456789:web:abcdef123456",  @override

);  int get hashCode => name.hashCode;

}

class Product {

  Product({typedef CartChangedCallback = void Function(Product product, bool inCart);

    required this.name,typedef QuantityChangedCallback = void Function(Product product, int quantity);

    this.quantity = 1,

    this.inCart = false,class ShoppingListItem extends StatelessWidget {

  });  ShoppingListItem({

    required this.product,

  final String name;    required this.inCart,

  int quantity;    required this.onCartChanged,

  bool inCart;    required this.onQuantityChanged,

  }) : super(key: ObjectKey(product));

  Map<String, dynamic> toJson() {

    return {  final Product product;

      'name': name,  final bool inCart;

      'quantity': quantity,  final CartChangedCallback onCartChanged;

      'inCart': inCart,  final QuantityChangedCallback onQuantityChanged;

    };

  }  Color _getColor(BuildContext context) {

    // The theme depends on the BuildContext because different

  factory Product.fromJson(Map<dynamic, dynamic> json) {    // parts of the tree can have different themes.

    return Product(    // The BuildContext indicates where the build is

      name: json['name'] ?? '',    // taking place and therefore which theme to use.

      quantity: json['quantity'] ?? 1,

      inCart: json['inCart'] ?? false,    return inCart //

    );        ? Colors.black54

  }        : Theme.of(context).primaryColor;

  }

  @override

  bool operator ==(Object other) =>  TextStyle? _getTextStyle(BuildContext context) {

      identical(this, other) ||    if (!inCart) return null;

      other is Product &&

          runtimeType == other.runtimeType &&    return const TextStyle(

          name == other.name;      color: Colors.black54,

      decoration: TextDecoration.lineThrough,

  @override    );

  int get hashCode => name.hashCode;  }

}

  @override

typedef CartChangedCallback = void Function(Product product, bool inCart);  Widget build(BuildContext context) {

typedef QuantityChangedCallback = void Function(Product product, int quantity);    final quantityController =

        TextEditingController(text: product.quantity.toString());

class ShoppingListItem extends StatelessWidget {

  ShoppingListItem({    return ListTile(

    required this.product,      onTap: () {

    required this.onCartChanged,        onCartChanged(product, !inCart);

    required this.onQuantityChanged,      },

  }) : super(key: ObjectKey(product));      leading: CircleAvatar(

        backgroundColor: _getColor(context),

  final Product product;        child: Text(

  final CartChangedCallback onCartChanged;          product.name[0],

  final QuantityChangedCallback onQuantityChanged;          style: TextStyle(

            color: inCart ? Colors.white : Colors.white,

  Color _getColor(BuildContext context) {            fontWeight: FontWeight.bold,

    return product.inCart ? Colors.black54 : Theme.of(context).primaryColor;          ),

  }        ),

      ),

  TextStyle? _getTextStyle(BuildContext context) {      title: Text(

    if (!product.inCart) return null;        product.name,

    return const TextStyle(        style: _getTextStyle(context),

      color: Colors.black54,      ),

      decoration: TextDecoration.lineThrough,      trailing: Row(

    );        mainAxisSize: MainAxisSize.min,

  }        children: [

          // Minus button

  @override          IconButton(

  Widget build(BuildContext context) {            icon: const Icon(Icons.remove_circle_outline),

    final quantityController =            onPressed: () {

        TextEditingController(text: product.quantity.toString());              if (product.quantity > 0) {

                onQuantityChanged(product, product.quantity - 1);

    return ListTile(              }

      onTap: () {            },

        onCartChanged(product, !product.inCart);            iconSize: 24,

      },            padding: EdgeInsets.zero,

      leading: CircleAvatar(            constraints: const BoxConstraints(),

        backgroundColor: _getColor(context),          ),

        child: Text(          const SizedBox(width: 8),

          product.name[0],          // Quantity text field

          style: const TextStyle(          SizedBox(

            color: Colors.white,            width: 50,

            fontWeight: FontWeight.bold,            child: TextField(

          ),              controller: quantityController,

        ),              keyboardType: TextInputType.number,

      ),              textAlign: TextAlign.center,

      title: Text(              inputFormatters: [FilteringTextInputFormatter.digitsOnly],

        product.name,              decoration: const InputDecoration(

        style: _getTextStyle(context),                border: OutlineInputBorder(),

      ),                contentPadding:

      trailing: Row(                    EdgeInsets.symmetric(horizontal: 8, vertical: 8),

        mainAxisSize: MainAxisSize.min,              ),

        children: [              onSubmitted: (value) {

          IconButton(                final newQuantity = int.tryParse(value) ?? 1;

            icon: const Icon(Icons.remove_circle_outline),                onQuantityChanged(product, newQuantity);

            onPressed: () {              },

              if (product.quantity > 0) {            ),

                onQuantityChanged(product, product.quantity - 1);          ),

              }          const SizedBox(width: 8),

            },          // Plus button

            iconSize: 24,          IconButton(

            padding: EdgeInsets.zero,            icon: const Icon(Icons.add_circle_outline),

            constraints: const BoxConstraints(),            onPressed: () {

          ),              onQuantityChanged(product, product.quantity + 1);

          const SizedBox(width: 8),            },

          SizedBox(            iconSize: 24,

            width: 50,            padding: EdgeInsets.zero,

            child: TextField(            constraints: const BoxConstraints(),

              controller: quantityController,          ),

              keyboardType: TextInputType.number,          const SizedBox(width: 8),

              textAlign: TextAlign.center,          // Cart checkbox

              inputFormatters: [FilteringTextInputFormatter.digitsOnly],          inCart

              decoration: const InputDecoration(              ? const Icon(Icons.check_circle, color: Colors.green)

                border: OutlineInputBorder(),              : const Icon(Icons.radio_button_unchecked, color: Colors.grey),

                contentPadding:        ],

                    EdgeInsets.symmetric(horizontal: 8, vertical: 8),      ),

              ),    );

              onSubmitted: (value) {  }

                final newQuantity = int.tryParse(value) ?? 1;}

                onQuantityChanged(product, newQuantity);

              },class ShoppingList extends StatefulWidget {

            ),  const ShoppingList({super.key});

          ),

          const SizedBox(width: 8),  @override

          IconButton(  State<ShoppingList> createState() => _ShoppingListState();

            icon: const Icon(Icons.add_circle_outline),}

            onPressed: () {

              onQuantityChanged(product, product.quantity + 1);class _ShoppingListState extends State<ShoppingList> {

            },  final List<Product> _products = [

            iconSize: 24,    Product(name: 'Eggs'),

            padding: EdgeInsets.zero,    Product(name: 'Flour'),

            constraints: const BoxConstraints(),    Product(name: 'Chocolate chips'),

          ),  ];

          const SizedBox(width: 8),  final _shoppingCart = <Product>{};

          product.inCart  final _textController = TextEditingController();

              ? const Icon(Icons.check_circle, color: Colors.green)

              : const Icon(Icons.radio_button_unchecked, color: Colors.grey),  @override

        ],  void dispose() {

      ),    _textController.dispose();

    );    super.dispose();

  }  }

}

  void _handleCartChanged(Product product, bool inCart) {

// List selection screen shown on app startup    setState(() {

class ListSelectionScreen extends StatefulWidget {      if (inCart) {

  const ListSelectionScreen({super.key});        _shoppingCart.add(product);

      } else {

  @override        _shoppingCart.remove(product);

  State<ListSelectionScreen> createState() => _ListSelectionScreenState();      }

}    });

  }

class _ListSelectionScreenState extends State<ListSelectionScreen> {

  List<String> _savedListIds = [];  void _handleQuantityChanged(Product product, int newQuantity) {

  bool _loading = true;    setState(() {

      if (newQuantity <= 0) {

  @override        // Remove item from list if quantity is 0

  void initState() {        _products.remove(product);

    super.initState();        _shoppingCart.remove(product);

    _loadSavedLists();      } else {

  }        product.quantity = newQuantity;

      }

  Future<void> _loadSavedLists() async {    });

    final prefs = await SharedPreferences.getInstance();  }

    setState(() {

      _savedListIds = prefs.getStringList('saved_lists') ?? [];  void _addItem(String name) {

      _loading = false;    if (name.trim().isEmpty) return;

    });

  }    setState(() {

      _products.add(Product(name: name.trim()));

  Future<void> _createNewSharedList() async {      _textController.clear();

    final listId = const Uuid().v4();    });

    await _saveListId(listId);  }

    if (mounted) {

      Navigator.of(context).pushReplacement(  @override

        MaterialPageRoute(  Widget build(BuildContext context) {

          builder: (context) => ShoppingList(listId: listId, isShared: true),    // Calculate total quantity of items in cart

        ),    final totalInCart = _shoppingCart.fold<int>(

      );      0,

    }      (sum, product) => sum + product.quantity,

  }    );

    

  Future<void> _createLocalList() async {    return Scaffold(

    if (mounted) {      appBar: AppBar(

      Navigator.of(context).pushReplacement(        title: const Text('Shopping List'),

        MaterialPageRoute(        actions: [

          builder: (context) => const ShoppingList(listId: 'local', isShared: false),          Padding(

        ),            padding: const EdgeInsets.only(right: 16.0),

      );            child: Center(

    }              child: Text(

  }                'In Cart: $totalInCart',

                style: const TextStyle(fontSize: 16),

  Future<void> _openList(String listId) async {              ),

    Navigator.of(context).pushReplacement(            ),

      MaterialPageRoute(          ),

        builder: (context) => ShoppingList(listId: listId, isShared: true),        ],

      ),      ),

    );      body: Column(

  }        children: [

          Expanded(

  Future<void> _saveListId(String listId) async {            child: _products.isEmpty

    final prefs = await SharedPreferences.getInstance();                ? const Center(

    final lists = prefs.getStringList('saved_lists') ?? [];                    child: Text('No items yet. Add items below!'),

    if (!lists.contains(listId)) {                  )

      lists.add(listId);                : ListView.builder(

      await prefs.setStringList('saved_lists', lists);                    padding: const EdgeInsets.symmetric(vertical: 8.0),

    }                    itemCount: _products.length,

  }                    itemBuilder: (context, index) {

                      final product = _products[index];

  Future<void> _deleteList(String listId) async {                      return ShoppingListItem(

    final prefs = await SharedPreferences.getInstance();                        product: product,

    final lists = prefs.getStringList('saved_lists') ?? [];                        inCart: _shoppingCart.contains(product),

    lists.remove(listId);                        onCartChanged: _handleCartChanged,

    await prefs.setStringList('saved_lists', lists);                        onQuantityChanged: _handleQuantityChanged,

    setState(() {                      );

      _savedListIds = lists;                    },

    });                  ),

  }          ),

          Container(

  @override            padding: const EdgeInsets.all(16.0),

  Widget build(BuildContext context) {            decoration: BoxDecoration(

    if (_loading) {              color: Colors.grey[100],

      return const Scaffold(              border: Border(

        body: Center(child: CircularProgressIndicator()),                top: BorderSide(color: Colors.grey[300]!),

      );              ),

    }            ),

            child: Row(

    return Scaffold(              children: [

      appBar: AppBar(                Expanded(

        title: const Text('Select Shopping List'),                  child: Column(

      ),                    crossAxisAlignment: CrossAxisAlignment.start,

      body: Padding(                    mainAxisSize: MainAxisSize.min,

        padding: const EdgeInsets.all(16.0),                    children: [

        child: Column(                      const Text(

          crossAxisAlignment: CrossAxisAlignment.stretch,                        'Add to list',

          children: [                        style: TextStyle(

            const Text(                          fontSize: 12,

              'Your Lists',                          fontWeight: FontWeight.w500,

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),                          color: Colors.grey,

            ),                        ),

            const SizedBox(height: 16),                      ),

            if (_savedListIds.isEmpty)                      const SizedBox(height: 4),

              const Padding(                      TextField(

                padding: EdgeInsets.symmetric(vertical: 32.0),                        controller: _textController,

                child: Text(                        decoration: const InputDecoration(

                  'No saved lists yet.\nCreate a new list below!',                          hintText: 'Enter item name',

                  textAlign: TextAlign.center,                          border: OutlineInputBorder(),

                  style: TextStyle(color: Colors.grey),                          contentPadding: EdgeInsets.symmetric(

                ),                            horizontal: 12,

              )                            vertical: 8,

            else                          ),

              Expanded(                        ),

                child: ListView.builder(                        onSubmitted: (value) {

                  itemCount: _savedListIds.length,                          _addItem(value);

                  itemBuilder: (context, index) {                        },

                    final listId = _savedListIds[index];                      ),

                    return Card(                    ],

                      child: ListTile(                  ),

                        leading: const Icon(Icons.shopping_cart),                ),

                        title: const Text('Shared List'),                const SizedBox(width: 8),

                        subtitle: Text('ID: ${listId.substring(0, 8)}...'),                FloatingActionButton(

                        trailing: IconButton(                  onPressed: () {

                          icon: const Icon(Icons.delete),                    _addItem(_textController.text);

                          onPressed: () => _deleteList(listId),                  },

                        ),                  tooltip: 'Add Item',

                        onTap: () => _openList(listId),                  child: const Icon(Icons.add),

                      ),                ),

                    );              ],

                  },            ),

                ),          ),

              ),        ],

            const SizedBox(height: 16),      ),

            const Divider(),    );

            const SizedBox(height: 16),  }

            ElevatedButton.icon(}

              onPressed: _createNewSharedList,

              icon: const Icon(Icons.share),void main() {

              label: const Text('Create New Shared List'),  runApp(

              style: ElevatedButton.styleFrom(    const MaterialApp(

                padding: const EdgeInsets.all(16),      home: ShoppingList(),

              ),    ),

            ),  );

            const SizedBox(height: 12),}

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
    _listRef = FirebaseDatabase.instance.ref('lists/${widget.listId}/products');
    
    // Listen for changes
    _listRef!.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _products.clear();
          data.forEach((key, value) {
            _products.add(Product.fromJson(value));
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
    });
    if (widget.isShared) {
      _syncToFirebase();
    }
  }

  void _handleQuantityChanged(Product product, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        _products.remove(product);
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
      final shareUrl = 'https://perelguttrios.github.io/Shopping-List/?list=${widget.listId}';
      
      // Open email client with pre-filled message
      final emailUri = Uri(
        scheme: 'mailto',
        path: result,
        query: 'subject=${Uri.encodeComponent('Shopping List Invitation')}'
            '&body=${Uri.encodeComponent('Join my shopping list!\n\nClick here to open: $shareUrl')}',
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
    final totalInCart = _products.where((p) => p.inCart).fold<int>(
      0,
      (sum, product) => sum + product.quantity,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isShared ? 'Shared Shopping List' : 'Local Shopping List'),
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
