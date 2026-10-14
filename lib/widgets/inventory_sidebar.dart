import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Left navigation panel used on wide screens (laptops / desktops).
class InventorySidebar extends StatelessWidget {
  final List<String> categories; // includes 'All'
  final String selected;
  final int Function(String category) countFor;
  final ValueChanged<String> onSelected;
  final VoidCallback onReset;

  const InventorySidebar({
    super.key,
    required this.categories,
    required this.selected,
    required this.countFor,
    required this.onSelected,
    required this.onReset,
  });

  static const _cream = Color(0xFFFFF1E3);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      color: AppColors.textDark,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 44,
                      height: 44,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Inventory',
                      style: TextStyle(
                        fontFamily: 'Lobster',
                        fontSize: 28,
                        color: _cream,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text(
                'CATEGORIES',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.4,
                  color: Color(0xFFB8A59B),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: categories.length,
                itemBuilder: (context, i) {
                  final name = categories[i];
                  final isSelected = name == selected;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Material(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => onSelected(name),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              Icon(
                                name == 'All'
                                    ? Icons.apps_rounded
                                    : Icons.category_outlined,
                                size: 20,
                                color: _cream,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  name == 'All' ? 'All products' : name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: _cream,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0x26FFFFFF),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${countFor(name)}',
                                  style: const TextStyle(
                                      color: _cream, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
              child: TextButton.icon(
                onPressed: onReset,
                icon: const Icon(Icons.restart_alt_rounded, size: 20),
                label: const Text('Reset sample data'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFB8A59B),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
