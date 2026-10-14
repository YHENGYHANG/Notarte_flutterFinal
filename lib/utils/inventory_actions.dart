import 'package:flutter/material.dart';
import '../data/inventory_controller.dart';
import '../models/product.dart';
import '../widgets/product_form.dart';
import 'app_colors.dart';

/// User-facing CRUD flows (form / confirmation / snackbar) shared by the
/// home screen and the detail screen.

void _showSnack(
  ScaffoldMessengerState messenger,
  String message, {
  SnackBarAction? action,
}) {
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(message),
        action: action,
      ),
    );
}

/// CREATE
Future<void> addProductFlow(BuildContext context, InventoryController c) async {
  final messenger = ScaffoldMessenger.of(context);
  final product = await showProductForm(context, categories: c.categories);
  if (product == null) return;
  c.add(product);
  _showSnack(messenger, '${product.name} added');
}

/// UPDATE
Future<void> editProductFlow(
  BuildContext context,
  InventoryController c,
  Product product,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final updated = await showProductForm(
    context,
    product: product,
    categories: c.categories,
  );
  if (updated == null) return;
  c.update(updated);
  _showSnack(messenger, '${updated.name} updated');
}

/// DELETE (with confirmation and Undo). Returns true if it was deleted.
Future<bool> deleteProductFlow(
  BuildContext context,
  InventoryController c,
  Product product,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Delete product?',
          style: TextStyle(fontWeight: FontWeight.bold)),
      content: Text('“${product.name}” will be removed from your inventory.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          style: TextButton.styleFrom(foregroundColor: AppColors.textLight),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.danger,
            foregroundColor: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (confirmed != true) return false;

  final index = c.indexOf(product.id);
  c.remove(product.id);
  _showSnack(
    messenger,
    '${product.name} deleted',
    action: SnackBarAction(
      label: 'UNDO',
      textColor: AppColors.accent,
      onPressed: () => c.restore(product, index),
    ),
  );
  return true;
}

/// Reset to sample data (asks first).
Future<void> resetFlow(BuildContext context, InventoryController c) async {
  final messenger = ScaffoldMessenger.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Reset data?',
          style: TextStyle(fontWeight: FontWeight.bold)),
      content: const Text(
          'All your products will be replaced with the original sample data.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          style: TextButton.styleFrom(foregroundColor: AppColors.textLight),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Reset'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  c.resetToSample();
  _showSnack(messenger, 'Sample data restored');
}
