import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../models/product.dart';
import '../utils/app_colors.dart';
import '../utils/breakpoints.dart';

/// Opens the Add / Edit form in the most natural container for the screen:
///   phones          -> bottom sheet
///   tablets/desktop -> centered dialog
/// Returns the saved [Product], or null if the user cancelled.
Future<Product?> showProductForm(
  BuildContext context, {
  Product? product,
  required List<String> categories,
}) {
  final form = ProductForm(product: product, categories: categories);
  final isWide = MediaQuery.of(context).size.width >= Breakpoints.medium;

  if (isWide) {
    return showDialog<Product>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: form,
        ),
      ),
    );
  }

  return showModalBottomSheet<Product>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheetContext) => Padding(
      // Lifts the form above the on-screen keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
      child: form,
    ),
  );
}

/// STATEFUL: owns the text controllers and the form key.
/// If [product] is null the form CREATES, otherwise it EDITS.
class ProductForm extends StatefulWidget {
  final Product? product;
  final List<String> categories;

  const ProductForm({super.key, this.product, required this.categories});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _category;
  late final TextEditingController _price;
  late final TextEditingController _qty;
  late final TextEditingController _image;
  late final TextEditingController _notes;

  bool get _isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _name = TextEditingController(text: p?.name ?? '');
    _category = TextEditingController(text: p?.category ?? '');
    _price = TextEditingController(text: p == null ? '' : p.price.toStringAsFixed(2));
    _qty = TextEditingController(text: p?.quantity.toString() ?? '');
    _image = TextEditingController(text: p?.imageUrl ?? '');
    _notes = TextEditingController(text: p?.notes ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _category.dispose();
    _price.dispose();
    _qty.dispose();
    _image.dispose();
    _notes.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label, IconData icon, {String? helper}) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c),
        );
    return InputDecoration(
      labelText: label,
      helperText: helper,
      prefixIcon: Icon(icon, color: AppColors.primaryLight),
      filled: true,
      fillColor: AppColors.background,
      enabledBorder: border(AppColors.border),
      focusedBorder: border(AppColors.primary),
      errorBorder: border(AppColors.danger),
      focusedErrorBorder: border(AppColors.danger),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final name = _name.text.trim();
    var category = _category.text.trim();
    // Re-use an existing category if only the letter case differs.
    for (final c in widget.categories) {
      if (c.toLowerCase() == category.toLowerCase()) category = c;
    }

    final imageText = _image.text.trim();
    final old = widget.product;

    final result = Product(
      id: old?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      category: category,
      price: double.parse(_price.text.trim()),
      quantity: int.parse(_qty.text.trim()),
      imageUrl: imageText.isEmpty ? seedImage(Uri.encodeComponent(name)) : imageText,
      notes: _notes.text.trim(),
      createdAt: old?.createdAt ?? DateTime.now(),
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _isEdit ? 'Edit product' : 'Add product',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  color: AppColors.textLight,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              decoration: _decoration('Product name', Icons.label_outline),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _category,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              decoration: _decoration('Category', Icons.category_outlined),
              onChanged: (_) => setState(() {}),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Category is required' : null,
            ),
            if (widget.categories.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final c in widget.categories)
                    ChoiceChip(
                      label: Text(c),
                      selected: _category.text.trim().toLowerCase() == c.toLowerCase(),
                      showCheckmark: false,
                      onSelected: (_) => setState(() => _category.text = c),
                      backgroundColor: AppColors.background,
                      selectedColor: AppColors.accent,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelStyle: const TextStyle(
                          fontSize: 12, color: AppColors.textDark),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _price,
                    textInputAction: TextInputAction.next,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: _decoration('Price', Icons.attach_money),
                    validator: (v) {
                      final n = double.tryParse((v ?? '').trim());
                      return (n == null || n < 0) ? 'Invalid price' : null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _qty,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: _decoration('Quantity', Icons.numbers),
                    validator: (v) {
                      final n = int.tryParse((v ?? '').trim());
                      return (n == null || n < 0) ? 'Invalid quantity' : null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _image,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.url,
              decoration: _decoration(
                'Image URL (optional)',
                Icons.image_outlined,
                helper: 'Leave empty to use an automatic placeholder photo',
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _notes,
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: _decoration('Notes (optional)', Icons.notes_rounded),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textLight,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(_isEdit ? 'Save changes' : 'Add product'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
