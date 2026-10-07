import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Extracted custom widget: one small statistic tile.
class SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color softColor;

  const SummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.softColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 14, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(color: softColor, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}
