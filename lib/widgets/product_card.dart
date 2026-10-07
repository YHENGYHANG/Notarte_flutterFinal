import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/app_colors.dart';

/// Extracted custom widget: one Card for one Product.
/// STATELESS: the parent owns the data and passes callbacks to say what happened.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onIncrease,
    required this.onDecrease,
    required this.onDelete,
  });

  Color get _statusColor {
    if (product.isOutOfStock) return AppColors.danger;
    if (product.isLowStock) return AppColors.warning;
    return AppColors.success;
  }

  Color get _statusSoft {
    if (product.isOutOfStock) return AppColors.dangerSoft;
    if (product.isLowStock) return AppColors.warningSoft;
    return AppColors.successSoft;
  }

  String get _statusText {
    if (product.isOutOfStock) return 'Out of stock';
    if (product.isLowStock) return 'Low stock';
    return 'In stock';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 16, offset: Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          // ---------- NETWORK IMAGE (with loading + local fallback) ----------
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              product.imageUrl,
              width: 78,
              height: 78,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  width: 78,
                  height: 78,
                  color: AppColors.sand,
                  child: const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ),
                );
              },
              // No internet? Show a LOCAL image instead.
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/placeholder.png',
                width: 78,
                height: 78,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // ---------- TEXT (Expanded = takes the remaining width) ----------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  product.category,
                  style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusSoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // ---------- QUANTITY STEPPER + DELETE ----------
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: onDelete,
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.delete_outline_rounded,
                      size: 20, color: AppColors.textLight),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.sand,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _StepButton(icon: Icons.remove, onTap: onDecrease),
                    SizedBox(
                      width: 34,
                      child: Text(
                        '${product.quantity}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    _StepButton(icon: Icons.add, onTap: onIncrease),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Small private widget used only inside this file (+ / - button).
class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }
}
