import 'package:flutter/material.dart';
import 'colors.dart' as colors;

class AppStyles {
  // Theme-aware text styles
  static TextStyle getTitle(bool isDark) => TextStyle(
    color: colors.AppColors.getTextColor(isDark),
    fontSize: 32,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle getSubtitle(bool isDark) => TextStyle(
    color: colors.AppColors.getSubtitleColor(isDark),
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.4,
  );

  static TextStyle getButtonText(bool isDark) => const TextStyle(
    color: colors.AppColors.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static TextStyle getLabel(bool isDark) => TextStyle(
    color: colors.AppColors.getSubtitleColor(isDark),
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  static TextStyle getInputText(bool isDark) => TextStyle(
    color: colors.AppColors.getTextColor(isDark),
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
  );

  static TextStyle getHintText(bool isDark) => TextStyle(
    color: colors.AppColors.getHintColor(isDark),
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
  );

  // Shadows
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x0F000000),
    blurRadius: 16,
    offset: Offset(0, 4),
  );

  static const BoxShadow darkCardShadow = BoxShadow(
    color: Color(0x20000000),
    blurRadius: 16,
    offset: Offset(0, 4),
  );

  static const BoxShadow subtleShadow = BoxShadow(
    color: Color(0x08000000),
    blurRadius: 8,
    offset: Offset(0, 2),
  );

  // Border radius
  static const BorderRadius borderRadius8 = BorderRadius.all(Radius.circular(8));
  static const BorderRadius borderRadius12 = BorderRadius.all(Radius.circular(12));
  static const BorderRadius borderRadius16 = BorderRadius.all(Radius.circular(16));
  
  // Get shadow based on theme
  static BoxShadow getCardShadow(bool isDark) => 
      isDark ? darkCardShadow : cardShadow;
}