import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/app_colors.dart';

/// Small coloured badge: In stock / Low stock / Out of stock.
class StockChip extends StatelessWidget {
  final StockStatus status;
  const StockChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color, soft) = switch (status) {
      StockStatus.inStock => ('In stock', AppColors.success, AppColors.successSoft),
      StockStatus.lowStock => ('Low stock', AppColors.warning, AppColors.warningSoft),
      StockStatus.outOfStock => ('Out of stock', AppColors.danger, AppColors.dangerSoft),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: soft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
