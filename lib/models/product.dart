enum StockStatus { inStock, lowStock, outOfStock }

/// Immutable data class for ONE inventory item.
/// To "update" a product we create a modified copy with [copyWith].
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final int quantity;
  final String imageUrl;
  final String notes;
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.notes,
    required this.createdAt,
  });

  /// Stock at or below this number is considered "low".
  static const int lowStockLimit = 5;

  StockStatus get status {
    if (quantity == 0) return StockStatus.outOfStock;
    if (quantity <= lowStockLimit) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  double get totalValue => price * quantity;

  Product copyWith({
    String? name,
    String? category,
    double? price,
    int? quantity,
    String? imageUrl,
    String? notes,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      notes: notes ?? this.notes,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'price': price,
        'quantity': quantity,
        'imageUrl': imageUrl,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        price: (json['price'] as num).toDouble(),
        quantity: (json['quantity'] as num).toInt(),
        imageUrl: json['imageUrl'] as String,
        notes: (json['notes'] as String?) ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
