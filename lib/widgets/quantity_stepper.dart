import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Pill-shaped  [-] 12 [+]  control. [large] is used on the detail screen.
class QuantityStepper extends StatelessWidget {
  final int value;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final bool large;

  const QuantityStepper({
    super.key,
    required this.value,
    required this.onIncrease,
    required this.onDecrease,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.sand,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove,
            large: large,
            onTap: value > 0 ? onDecrease : null,
          ),
          SizedBox(
            width: large ? 56 : 30,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: large ? 18 : 14,
                color: AppColors.textDark,
              ),
            ),
          ),
          _StepButton(icon: Icons.add, large: large, onTap: onIncrease),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final bool large;
  final VoidCallback? onTap;

  const _StepButton({required this.icon, required this.large, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: EdgeInsets.all(large ? 12 : 7),
        child: Icon(
          icon,
          size: large ? 22 : 16,
          color: onTap == null ? const Color(0xFFD6C5B8) : AppColors.primary,
        ),
      ),
    );
  }
}
