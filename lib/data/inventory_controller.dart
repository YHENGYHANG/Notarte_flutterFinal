import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import 'sample_data.dart';

enum SortOption { newest, nameAZ, priceHigh, priceLow, stockLow }

extension SortOptionLabel on SortOption {
  String get label => switch (this) {
        SortOption.newest => 'Newest first',
        SortOption.nameAZ => 'Name (A–Z)',
        SortOption.priceHigh => 'Price: high to low',
        SortOption.priceLow => 'Price: low to high',
        SortOption.stockLow => 'Stock: low to high',
      };
}

/// Holds the product list and exposes the four CRUD operations.
/// It is a [ChangeNotifier]: screens listen to it and rebuild automatically
/// whenever the data changes. Every change is also saved on the device.
class InventoryController extends ChangeNotifier {
  static const _storageKey = 'inventory_products_v1';

  final List<Product> _products = [];

  // ------------------------------------------------------------ READ
  List<Product> get products => List.unmodifiable(_products);

  Product? getById(String id) {
    for (final p in _products) {
      if (p.id == id) return p;
    }
    return null;
  }

  int indexOf(String id) => _products.indexWhere((p) => p.id == id);

  /// Sorted list of distinct category names.
  List<String> get categories =>
      (_products.map((p) => p.category).toSet().toList()..sort());

  int countIn(String category) => category == 'All'
      ? _products.length
      : _products.where((p) => p.category == category).length;

  double get totalValue => _products.fold(0.0, (sum, p) => sum + p.totalValue);
  int get lowStockCount =>
      _products.where((p) => p.status == StockStatus.lowStock).length;
  int get outOfStockCount =>
      _products.where((p) => p.status == StockStatus.outOfStock).length;

  /// Search + filter + sort in one place.
  List<Product> query({
    String search = '',
    String category = 'All',
    SortOption sort = SortOption.newest,
  }) {
    final q = search.trim().toLowerCase();
    final result = _products.where((p) {
      final matchesCategory = category == 'All' || p.category == category;
      final matchesSearch = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);
      return matchesCategory && matchesSearch;
    }).toList();

    switch (sort) {
      case SortOption.newest:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case SortOption.nameAZ:
        result.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      case SortOption.priceHigh:
        result.sort((a, b) => b.price.compareTo(a.price));
      case SortOption.priceLow:
        result.sort((a, b) => a.price.compareTo(b.price));
      case SortOption.stockLow:
        result.sort((a, b) => a.quantity.compareTo(b.quantity));
    }
    return result;
  }

  // ---------------------------------------------------------- CREATE
  void add(Product product) {
    _products.insert(0, product);
    _commit();
  }

  // ---------------------------------------------------------- UPDATE
  void update(Product updated) {
    final i = indexOf(updated.id);
    if (i == -1) return;
    _products[i] = updated;
    _commit();
  }

  /// Quick +1 / -1 stock change used by the quantity stepper.
  void adjustQuantity(String id, int delta) {
    final i = indexOf(id);
    if (i == -1) return;
    final next = _products[i].quantity + delta;
    if (next < 0) return;
    _products[i] = _products[i].copyWith(quantity: next);
    _commit();
  }

  // ---------------------------------------------------------- DELETE
  void remove(String id) {
    _products.removeWhere((p) => p.id == id);
    _commit();
  }

  /// Used by "Undo" after a delete: puts the product back where it was.
  void restore(Product product, int index) {
    final safeIndex = index.clamp(0, _products.length);
    _products.insert(safeIndex, product);
    _commit();
  }

  void resetToSample() {
    _products
      ..clear()
      ..addAll(getSampleProducts());
    _commit();
  }

  // ------------------------------------------------------ PERSISTENCE
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw != null) {
        final list = jsonDecode(raw) as List<dynamic>;
        _products
          ..clear()
          ..addAll(
              list.map((e) => Product.fromJson(e as Map<String, dynamic>)));
        return;
      }
    } catch (_) {
      // Corrupted or unavailable storage: fall back to sample data.
    }
    _products
      ..clear()
      ..addAll(getSampleProducts());
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _storageKey,
        jsonEncode(_products.map((p) => p.toJson()).toList()),
      );
    } catch (_) {
      // Saving is best-effort; the app keeps working in memory.
    }
  }

  void _commit() {
    notifyListeners();
    _save();
  }
}
