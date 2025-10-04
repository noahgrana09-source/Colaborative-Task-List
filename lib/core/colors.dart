import "dart:ui";
import 'package:flutter/material.dart';

class AppColors {
  // Light theme colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);
  static const Color black = Color(0xFF000000);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2C2C2C);
  static const Color darkOnSurface = Color(0xFFE6E1E5);
  static const Color darkOnSurfaceVariant = Color(0xFFC7C5C5);

  // Primary action (green scale)
  static const Color lightGreen = Color(0xFF81C784);
  static const Color green = Color(0xFF4CAF50);
  static const Color darkGreen = Color(0xFF388E3C);

  // Error states
  static const Color errorLight = Color(0xFFE57373);
  static const Color error = Color(0xFFF44336);
  static const Color errorDark = Color(0xFFD32F2F);

  // Theme-aware color getters
  static Color getBackgroundColor(bool isDark) => 
      isDark ? darkBackground : white;
      
  static Color getSurfaceColor(bool isDark) => 
      isDark ? darkSurface : gray50;
      
  static Color getCardColor(bool isDark) => 
      isDark ? darkSurfaceVariant : white;
      
  static Color getTextColor(bool isDark) => 
      isDark ? darkOnSurface : gray900;
      
  static Color getSubtitleColor(bool isDark) => 
      isDark ? darkOnSurfaceVariant : gray700;
      
  static Color getHintColor(bool isDark) => 
      isDark ? gray500 : gray500;
      
  static Color getBorderColor(bool isDark) => 
      isDark ? gray700 : gray300;
}