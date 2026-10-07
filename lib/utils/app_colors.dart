import 'package:flutter/material.dart';

/// Warm, earthy palette: cream, terracotta, amber and sage.
/// Change a colour here and the whole app updates.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFFC8553D); // terracotta
  static const Color primaryLight = Color(0xFFE88D4F); // soft orange
  static const Color accent = Color(0xFFF2A541); // warm amber

  // Surfaces
  static const Color background = Color(0xFFFFF8F0); // cream
  static const Color surface = Color(0xFFFFFFFF);
  static const Color sand = Color(0xFFF6E7D6);
  static const Color border = Color(0xFFF0E2D3);

  // Text
  static const Color textDark = Color(0xFF3D2C29); // deep brown
  static const Color textLight = Color(0xFF8C7A72); // warm grey

  // Status colours (solid + soft background)
  static const Color success = Color(0xFF5E8C61); // sage
  static const Color successSoft = Color(0xFFE6F0E3);
  static const Color warning = Color(0xFFD98324); // honey
  static const Color warningSoft = Color(0xFFFCEBD0);
  static const Color danger = Color(0xFFB5443A); // brick
  static const Color dangerSoft = Color(0xFFF8DEDA);

  // Shadow used by cards
  static const Color shadow = Color(0x143D2C29);
}
