import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/format.dart';
import 'summary_card.dart';

/// Gradient "total value" card + three summary tiles.
/// It adapts to the width it is given:
///   narrow -> hero on top, tiles underneath
///   wide   -> everything in one row
class StatsOverview extends StatelessWidget {
  final double totalValue;
  final int productCount;
  final int lowStock;
  final int outOfStock;

  const StatsOverview({
    super.key,
    required this.totalValue,
    required this.productCount,
    required this.lowStock,
    required this.outOfStock,
  });

  @override
  Widget build(BuildContext context) {
    final hero = _HeroCard(totalValue: totalValue, productCount: productCount);
    final tiles = [
      SummaryCard(
        label: 'Products',
        value: '$productCount',
        icon: Icons.inventory_2_rounded,
        color: AppColors.primary,
        softColor: AppColors.sand,
      ),
      SummaryCard(
        label: 'Low stock',
        value: '$lowStock',
        icon: Icons.warning_amber_rounded,
        color: AppColors.warning,
        softColor: AppColors.warningSoft,
      ),
      SummaryCard(
        label: 'Out of stock',
        value: '$outOfStock',
        icon: Icons.remove_shopping_cart_rounded,
        color: AppColors.danger,
        softColor: AppColors.dangerSoft,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 640) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 3, child: hero),
                for (final tile in tiles) ...[
                  const SizedBox(width: 12),
                  Expanded(child: tile),
                ],
              ],
            ),
          );
        }
        return Column(
          children: [
            hero,
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: tiles[0]),
                const SizedBox(width: 10),
                Expanded(child: tiles[1]),
                const SizedBox(width: 10),
                Expanded(child: tiles[2]),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _HeroCard extends StatelessWidget {
  final double totalValue;
  final int productCount;
  const _HeroCard({required this.totalValue, required this.productCount});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total inventory value',
                  style: TextStyle(color: Color(0xFFFFE9D6), fontSize: 13),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    formatMoney(totalValue),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'across $productCount products',
                  style: const TextStyle(color: Color(0xFFFFE9D6), fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0x33FFFFFF),
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              // LOCAL image
              child: Image.asset(
                'assets/images/logo.png',
                width: 58,
                height: 58,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
