/// Custom class that describes ONE item in the inventory.
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl; // network image
  int quantity; // mutable, because stock goes up and down

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  /// Stock below this number is considered "low".
  static const int lowStockLimit = 5;

  bool get isLowStock => quantity > 0 && quantity <= lowStockLimit;
  bool get isOutOfStock => quantity == 0;
  double get totalValue => price * quantity;
}
