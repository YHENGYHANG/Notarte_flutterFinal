import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// STATELESS widget: it only shows what it is given.
class SectionHeader extends StatelessWidget {
  final String title;
  final String trailing;

  const SectionHeader({super.key, required this.title, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
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
