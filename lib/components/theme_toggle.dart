import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../core/colors.dart';

class ThemeToggle extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggle;

  const ThemeToggle({
    super.key,
    required this.isDarkMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.wb_sunny_outlined,
          color: AppColors.getSubtitleColor(isDarkMode),
          size: 20,
        ),
        const SizedBox(width: 8),
        PlatformSwitch(
          value: isDarkMode,
          onChanged: (_) => onToggle(),
          activeColor: AppColors.green,
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.nights_stay_outlined,
          color: AppColors.getSubtitleColor(isDarkMode),
          size: 20,
        ),
      ],
    );
  }
}