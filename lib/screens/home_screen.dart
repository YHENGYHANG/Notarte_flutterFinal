import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../models/product.dart';
import '../utils/app_colors.dart';
import '../widgets/add_product_dialog.dart';
import '../widgets/product_card.dart';
import '../widgets/section_header.dart';
import '../widgets/summary_card.dart';

/// STATEFUL widget: the product list and the selected filter change,
/// so the screen rebuilds using setState().
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Managing a data list of a custom class
  final List<Product> _products = getInitialProducts();
  String _selectedCategory = 'All';

  // ---------- Derived data ----------
  List<String> get _categories {
    final names = _products.map((p) => p.category).toSet().toList()..sort();
    return ['All', ...names];
  }

  String get _activeCategory =>
      _categories.contains(_selectedCategory) ? _selectedCategory : 'All';

  List<Product> get _visibleProducts => _activeCategory == 'All'
      ? _products
      : _products.where((p) => p.category == _activeCategory).toList();

  int get _lowStockCount => _products.where((p) => p.isLowStock).length;
  int get _outOfStockCount => _products.where((p) => p.isOutOfStock).length;
  double get _totalValue => _products.fold(0, (sum, p) => sum + p.totalValue);

  // ---------- Actions ----------
  void _increase(Product p) => setState(() => p.quantity++);

  void _decrease(Product p) {
    if (p.quantity > 0) setState(() => p.quantity--);
  }

  void _delete(Product p) {
    final index = _products.indexOf(p);
    setState(() => _products.remove(p));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.textDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          content: Text('${p.name} deleted'),
          action: SnackBarAction(
            label: 'UNDO',
            textColor: AppColors.accent,
            onPressed: () => setState(() => _products.insert(index, p)),
          ),
        ),
      );
  }

  Future<void> _addProduct() async {
    final newProduct = await showDialog<Product>(
      context: context,
      builder: (_) => const AddProductDialog(),
    );
    if (newProduct != null) {
      setState(() => _products.insert(0, newProduct));
    }
  }

  // ---------- Header parts (scroll together with the list) ----------
  Widget _buildHero() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(color: Color(0x40C8553D), blurRadius: 22, offset: Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total inventory value',
                  style: TextStyle(color: Color(0xFFFFE9D6), fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${_totalValue.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'across ${_products.length} products',
                  style: const TextStyle(color: Color(0xFFFFE9D6), fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // LOCAL image
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0x33FFFFFF),
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                'assets/images/logo.png',
                width: 62,
                height: 62,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: SummaryCard(
              label: 'Products',
              value: '${_products.length}',
              icon: Icons.inventory_2_rounded,
              color: AppColors.primary,
              softColor: AppColors.sand,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SummaryCard(
              label: 'Low stock',
              value: '$_lowStockCount',
              icon: Icons.warning_amber_rounded,
              color: AppColors.warning,
              softColor: AppColors.warningSoft,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SummaryCard(
              label: 'Out of stock',
              value: '$_outOfStockCount',
              icon: Icons.remove_shopping_cart_rounded,
              color: AppColors.danger,
              softColor: AppColors.dangerSoft,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final name = _categories[i];
          final selected = name == _activeCategory;
          return ChoiceChip(
            label: Text(name),
            selected: selected,
            showCheckmark: false,
            onSelected: (_) => setState(() => _selectedCategory = name),
            backgroundColor: AppColors.surface,
            selectedColor: AppColors.primary,
            side: BorderSide(
              color: selected ? AppColors.primary : AppColors.border,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            labelStyle: TextStyle(
              fontSize: 13,
              color: selected ? Colors.white : AppColors.textDark,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(int visibleCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHero(),
        _buildSummaryRow(),
        SectionHeader(title: 'Your Products', trailing: '$visibleCount items'),
        _buildFilters(),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildEmpty() {
    return const Padding(
      padding: EdgeInsets.all(40),
      child: Center(
        child: Text(
          'No products here yet.\nTap "Add Product" to create one.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textLight),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleProducts;

    return Scaffold(
      backgroundColor: AppColors.background,

      // ---------- APP BAR ----------
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
          // LOCAL image
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/logo.png',
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
        title: const Text(
          'Inventory Management',
          style: TextStyle(fontFamily: 'Lobster', fontSize: 26),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reset data',
            onPressed: () => setState(() {
              _products
                ..clear()
                ..addAll(getInitialProducts());
              _selectedCategory = 'All';
            }),
          ),
          const SizedBox(width: 6),
        ],
      ),

      // ---------- BODY ----------
      // Center + ConstrainedBox keeps the content a nice width on wide screens.
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          // ListView.builder only builds the cards that are visible.
          // Index 0 is the header, the rest are product cards.
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: visible.isEmpty ? 2 : visible.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return _buildHeader(visible.length);
              if (visible.isEmpty) return _buildEmpty();
              final product = visible[index - 1];
              return ProductCard(
                product: product,
                onIncrease: () => _increase(product),
                onDecrease: () => _decrease(product),
                onDelete: () => _delete(product),
              );
            },
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textDark,
        elevation: 4,
        onPressed: _addProduct,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Product',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
