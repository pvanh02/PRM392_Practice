import 'dart:async';

// ============================================================================
// EXERCISE 1: Product Model & Repository
// Goal: Understand Futures and Streams (broadcast controllers).
// ============================================================================

/// 1. Define Product Model { id, name, price }
class Product {
  final int id;
  final String name;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  String toString() {
    return 'Product(ID: $id, Name: "$name", Price: \$${price.toStringAsFixed(2)})';
  }
}

/// 2. Implement ProductRepository with Future & Stream behaviors
class ProductRepository {
  // In-memory data store representing database entries
  final List<Product> _products = [
    Product(id: 1, name: 'MacBook Pro M3', price: 1999.00),
    Product(id: 2, name: 'iPhone 15 Pro', price: 1099.00),
    Product(id: 3, name: 'iPad Pro', price: 799.00),
  ];

  // 3. Use StreamController.broadcast() to emit new items to multiple listeners
  final StreamController<Product> _liveAddedController = StreamController<Product>.broadcast();

  /// Simulates fetching all products from a remote database with network delay.
  Future<List<Product>> getAll() async {
    // Simulating 1-second network latency using Future.delayed
    await Future.delayed(const Duration(seconds: 1));
    return List.unmodifiable(_products);
  }

  /// Exposes the live updates stream so components can listen in real-time.
  Stream<Product> liveAdded() {
    return _liveAddedController.stream;
  }

  /// Adds a new product to the repository and broadcasts it to all listeners.
  void addProduct(Product product) {
    _products.add(product);
    // Emitting the newly added product through the broadcast controller
    _liveAddedController.add(product);
  }

  /// Clean up resource controllers when they are no longer needed
  void dispose() {
    _liveAddedController.close();
  }
}

/// Runner for Exercise 1
Future<void> runExercise1() async {
  print('======================================================================');
  print('EXERCISE 1: Product Model & Repository');
  print('======================================================================');

  final repository = ProductRepository();

  // Step A: Fetch all products asynchronously
  print('[Main] Fetching initial products...');
  final initialProducts = await repository.getAll();
  print('[Main] Initial products fetched:');
  for (var product in initialProducts) {
    print('  -> $product');
  }

  // Step B: Set up real-time stream subscription
  print('\n[Main] Registering listener for live product additions...');
  final subscription = repository.liveAdded().listen(
    (product) {
      print('  [STREAM RECEIVED] New product added in real-time: $product');
    },
    onDone: () => print('  [STREAM] Stream closed.'),
  );

  // Step C: Simulate real-time product addition (e.g. from an admin panel)
  await Future.delayed(const Duration(milliseconds: 500));
  print('\n[Admin Panel] Adding a new product: "AirPods Pro"...');
  repository.addProduct(Product(id: 4, name: 'AirPods Pro', price: 249.00));

  await Future.delayed(const Duration(milliseconds: 500));
  print('[Admin Panel] Adding another product: "Apple Watch Ultra 2"...');
  repository.addProduct(Product(id: 5, name: 'Apple Watch Ultra 2', price: 799.00));

  // Allow events to be processed before cleaning up
  await Future.delayed(const Duration(milliseconds: 500));

  // Dispose resources
  await subscription.cancel();
  repository.dispose();
  print('======================================================================\n');
}
