import "dart:ui";

class AppColors {
  // Base scale
  static const Color white = Color(0xFFFFFFFF);
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

  // Primary action (green scale)
  static const Color lightGreen = Color(0xFF81C784); // verde claro (hover, accents)
  static const Color green = Color(0xFF4CAF50);      // verde principal
  static const Color darkGreen = Color(0xFF388E3C);  // verde oscuro (botón clickeado)

  // Error states
  static const Color errorLight = Color(0xFFE57373); // error suave
  static const Color error = Color(0xFFF44336);      // error principal
  static const Color errorDark = Color(0xFFD32F2F);  // error intenso
}
