import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/app_colors.dart';

/// STATEFUL widget: owns text controllers and an error message that change
/// while the user types, so it needs a State object.
class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _qtyController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label, IconData icon) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c),
        );
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primaryLight),
      filled: true,
      fillColor: AppColors.background,
      enabledBorder: border(AppColors.border),
      focusedBorder: border(AppColors.primary),
    );
  }

  void _submit() {
    final name = _nameController.text.trim();
    final category = _categoryController.text.trim();
    final price = double.tryParse(_priceController.text);
    final qty = int.tryParse(_qtyController.text);

    if (name.isEmpty || category.isEmpty || price == null || qty == null) {
      setState(() => _error = 'Please fill in all fields correctly.');
      return;
    }

    final product = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      category: category,
      price: price,
      quantity: qty,
      imageUrl: 'https://picsum.photos/seed/${name.hashCode}/200',
    );
    Navigator.of(context).pop(product);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text(
        'Add Product',
        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
      ),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 4),
              TextField(
                controller: _nameController,
                decoration: _decoration('Name', Icons.label_outline),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _categoryController,
                decoration: _decoration('Category', Icons.category_outlined),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _priceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: _decoration('Price', Icons.attach_money),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _qtyController,
                      keyboardType: TextInputType.number,
                      decoration: _decoration('Qty', Icons.numbers),
                    ),
                  ),
                ],
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: AppColors.danger, fontSize: 13),
                  ),
                ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: AppColors.textLight),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
