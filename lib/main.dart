import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';

import 'data/inventory_controller.dart';
import 'screens/home_screen.dart';
import 'utils/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = InventoryController();
  await controller.load(); // read saved products (or sample data)
  runApp(InventoryApp(controller: controller));
}

/// Lets horizontal lists (category chips) be dragged with a mouse on web/desktop.
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class InventoryApp extends StatelessWidget {
  final InventoryController controller;
  const InventoryApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Management',
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: HomeScreen(controller: controller),
    );
  }
}
