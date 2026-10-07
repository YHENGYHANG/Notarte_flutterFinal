import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const InventoryApp());
}

/// Root widget (stateless: nothing here changes).
class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins', // default font for the whole app
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const HomeScreen(),
    );
  }
}
