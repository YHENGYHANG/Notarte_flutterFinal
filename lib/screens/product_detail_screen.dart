import 'package:flutter/material.dart';
import '../data/inventory_controller.dart';
import '../models/product.dart';
import '../utils/app_colors.dart';
import '../utils/format.dart';
import '../utils/inventory_actions.dart';
import '../widgets/product_image.dart';
import '../widgets/quantity_stepper.dart';
import '../widgets/stock_chip.dart';

/// READ (single item). Layout adapts:
///   narrow -> image on top, info below
///   wide   -> image left, info right
/// It listens to the controller, so edits show up instantly.
class ProductDetailScreen extends StatelessWidget {
  final InventoryController controller;
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.controller,
    required this.productId,
  });

  Future<void> _delete(BuildContext context, Product product) async {
    final deleted = await deleteProductFlow(context, controller, product);
    if (deleted && context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final product = controller.getById(productId);
        if (product == null) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: Text('This product no longer exists.')),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.textDark,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: const Text('Product details',
                style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                tooltip: 'Edit',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => editProductFlow(context, controller, product),
              ),
              IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline_rounded),
                color: AppColors.danger,
                onPressed: () => _delete(context, product),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 640;
                      final image = AspectRatio(
                        aspectRatio: wide ? 1 : 4 / 3,
                        child: ProductImage(url: product.imageUrl, radius: 24),
                      );
                      final info = _buildInfo(context, product);
                      if (wide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 5, child: image),
                            const SizedBox(width: 28),
                            Expanded(flex: 6, child: info),
                          ],
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [image, const SizedBox(height: 20), info],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfo(BuildContext context, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: StockChip(status: product.status),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.category_outlined,
                size: 16, color: AppColors.textLight),
            const SizedBox(width: 6),
            Text(product.category,
                style: const TextStyle(color: AppColors.textLight)),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          formatMoney(product.price),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: AppColors.primary,
          ),
        ),
        const Text('per unit',
            style: TextStyle(color: AppColors.textLight, fontSize: 12)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 12,
            spacing: 16,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Stock level',
                      style: TextStyle(color: AppColors.textLight, fontSize: 12)),
                  const SizedBox(height: 6),
                  QuantityStepper(
                    large: true,
                    value: product.quantity,
                    onIncrease: () => controller.adjustQuantity(product.id, 1),
                    onDecrease: () => controller.adjustQuantity(product.id, -1),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Total value',
                      style: TextStyle(color: AppColors.textLight, fontSize: 12)),
                  const SizedBox(height: 6),
                  Text(
                    formatMoney(product.totalValue),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (product.notes.isNotEmpty) ...[
          const SizedBox(height: 20),
          const Text('Notes',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 6),
          Text(product.notes,
              style: const TextStyle(color: AppColors.textLight, height: 1.5)),
        ],
        const SizedBox(height: 16),
        Text('Added on ${formatDate(product.createdAt)}',
            style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => editProductFlow(context, controller, product),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Edit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _delete(context, product),
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                label: const Text('Delete'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.danger),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
