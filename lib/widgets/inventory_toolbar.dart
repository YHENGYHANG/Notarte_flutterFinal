import 'package:flutter/material.dart';
import '../data/inventory_controller.dart';
import '../utils/app_colors.dart';

/// Search box. The parent owns the controller and rebuilds on change.
class InventorySearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const InventorySearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c),
        );
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search products…',
        hintStyle: const TextStyle(color: AppColors.textLight),
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textLight),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        enabledBorder: border(AppColors.border),
        focusedBorder: border(AppColors.primary),
      ),
    );
  }
}

/// Sort dropdown. Shows only an icon on small screens, icon + label on wide.
class SortMenuButton extends StatelessWidget {
  final SortOption value;
  final ValueChanged<SortOption> onSelected;
  final bool showLabel;

  const SortMenuButton({
    super.key,
    required this.value,
    required this.onSelected,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortOption>(
      tooltip: 'Sort',
      initialValue: value,
      onSelected: onSelected,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      itemBuilder: (_) => [
        for (final option in SortOption.values)
          PopupMenuItem(value: option, child: Text(option.label)),
      ],
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sort_rounded, color: AppColors.primary),
            if (showLabel) ...[
              const SizedBox(width: 8),
              Text(value.label, style: const TextStyle(fontSize: 13)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Horizontal scrolling category filter (used on phones / tablets).
class CategoryChips extends StatelessWidget {
  final List<String> categories; // includes 'All'
  final String selected;
  final ValueChanged<String> onSelected;
  final double horizontalPadding;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
    this.horizontalPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final name = categories[i];
          final isSelected = name == selected;
          return ChoiceChip(
            label: Text(name),
            selected: isSelected,
            showCheckmark: false,
            onSelected: (_) => onSelected(name),
            backgroundColor: AppColors.surface,
            selectedColor: AppColors.primary,
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            labelStyle: TextStyle(
              fontSize: 13,
              color: isSelected ? Colors.white : AppColors.textDark,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          );
        },
      ),
    );
  }
}
