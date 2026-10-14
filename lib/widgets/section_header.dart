import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Title on the left, small count badge on the right.
class SectionHeader extends StatelessWidget {
  final String title;
  final String trailing;

  const SectionHeader({super.key, required this.title, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 22, 2, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
              color: AppColors.textDark,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.sand,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              trailing,
              style: const TextStyle(fontSize: 12, color: AppColors.textLight),
            ),
          ),
        ],
      ),
    );
  }
}
