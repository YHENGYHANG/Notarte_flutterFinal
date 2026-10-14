import 'package:flutter/material.dart';
import '../data/inventory_controller.dart';
import '../models/product.dart';
import '../utils/app_colors.dart';
import '../utils/breakpoints.dart';
import '../utils/inventory_actions.dart';
import '../widgets/empty_state.dart';
import '../widgets/inventory_sidebar.dart';
import '../widgets/inventory_toolbar.dart';
import '../widgets/product_card.dart';
import '../widgets/section_header.dart';
import '../widgets/stats_overview.dart';
import 'product_detail_screen.dart';

/// Main screen. STATEFUL: it owns the search text, selected category and sort.
/// The product data itself lives in [InventoryController].
///
/// Responsive layouts:
///   < 1000 px  (phone / tablet)  : AppBar + scrolling page + FAB
///   >= 1000 px (laptop / desktop): sidebar + top bar + scrolling content
/// The product grid picks 1-4 columns automatically from the available width.
class HomeScreen extends StatefulWidget {
  final InventoryController controller;
  const HomeScreen({super.key, required this.controller});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _category = 'All';
  SortOption _sort = SortOption.newest;

  InventoryController get _c => widget.controller;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// If the selected category no longer exists (everything deleted), use All.
  String get _activeCategory =>
      _c.categories.contains(_category) ? _category : 'All';

  List<String> get _categoryNames => ['All', ..._c.categories];

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _category = 'All';
    });
  }

  void _openDetail(Product p) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            ProductDetailScreen(controller: _c, productId: p.id),
      ),
    );
  }

  // ------------------------------------------------------------- build
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _c,
      builder: (context, _) {
        final products = _c.query(
          search: _searchController.text,
          category: _activeCategory,
          sort: _sort,
        );
        return LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= Breakpoints.expanded;
            return wide ? _buildWide(products) : _buildNarrow(products);
          },
        );
      },
    );
  }

  // ---------------------------------------------- phone / tablet layout
  Widget _buildNarrow(List<Product> products) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/logo.png',
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Inventory Management',
            style: TextStyle(fontFamily: 'Lobster', fontSize: 26),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (_) => resetFlow(context, _c),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'reset', child: Text('Reset sample data')),
            ],
          ),
        ],
      ),
      body: _buildContent(products, wide: false),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textDark,
        elevation: 4,
        onPressed: () => addProductFlow(context, _c),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Product',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  // ---------------------------------------------- laptop / desktop layout
  Widget _buildWide(List<Product> products) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          InventorySidebar(
            categories: _categoryNames,
            selected: _activeCategory,
            countFor: _c.countIn,
            onSelected: (name) => setState(() => _category = name),
            onReset: () => resetFlow(context, _c),
          ),
          Expanded(
            child: Column(
              children: [
                _buildWideTopBar(),
                Expanded(child: _buildContent(products, wide: true)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWideTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        children: [
          Expanded(
            child: InventorySearchField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(width: 12),
          SortMenuButton(
            value: _sort,
            showLabel: true,
            onSelected: (s) => setState(() => _sort = s),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => addProductFlow(context, _c),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.textDark,
                elevation: 0,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------- shared scrolling body
  Widget _buildContent(List<Product> products, {required bool wide}) {
    final pad = wide ? 24.0 : 16.0;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        // Keeps content readable on very large monitors.
        constraints: const BoxConstraints(maxWidth: 1400),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Roughly one column per 400px of available width (1 to 4).
            final available = constraints.maxWidth - pad * 2;
            final columns = (available / 400).floor().clamp(1, 4);

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(pad, 16, pad, 0),
                    child: StatsOverview(
                      totalValue: _c.totalValue,
                      productCount: _c.products.length,
                      lowStock: _c.lowStockCount,
                      outOfStock: _c.outOfStockCount,
                    ),
                  ),
                ),
                if (!wide) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(pad, 16, pad, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InventorySearchField(
                              controller: _searchController,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SortMenuButton(
                            value: _sort,
                            onSelected: (s) => setState(() => _sort = s),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: CategoryChips(
                        categories: _categoryNames,
                        selected: _activeCategory,
                        horizontalPadding: pad,
                        onSelected: (name) =>
                            setState(() => _category = name),
                      ),
                    ),
                  ),
                ],
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: pad),
                    child: SectionHeader(
                      title: _activeCategory == 'All'
                          ? 'Your Products'
                          : _activeCategory,
                      trailing: '${products.length} items',
                    ),
                  ),
                ),
                if (products.isEmpty)
                  SliverToBoxAdapter(child: _buildEmpty())
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: pad),
                    // Builder-style grid: only visible cards are built.
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisExtent: 132,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final p = products[index];
                          return ProductCard(
                            key: ValueKey(p.id),
                            product: p,
                            onTap: () => _openDetail(p),
                            onIncrease: () => _c.adjustQuantity(p.id, 1),
                            onDecrease: () => _c.adjustQuantity(p.id, -1),
                            onEdit: () => editProductFlow(context, _c, p),
                            onDelete: () => deleteProductFlow(context, _c, p),
                          );
                        },
                        childCount: products.length,
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 110)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    if (_c.products.isEmpty) {
      return EmptyState(
        icon: Icons.inventory_2_outlined,
        title: 'Your inventory is empty',
        message: 'Add your first product to get started.',
        actionLabel: 'Add product',
        onAction: () => addProductFlow(context, _c),
      );
    }
    return EmptyState(
      icon: Icons.search_off_rounded,
      title: 'No matching products',
      message: 'Try a different search or category.',
      actionLabel: 'Clear filters',
      onAction: _clearFilters,
    );
  }
}
