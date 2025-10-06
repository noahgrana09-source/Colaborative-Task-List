import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../core/colors.dart';
import '../core/styles.dart';
import '../components/theme_toggle.dart';
import '../services/auth_service.dart';
import 'login.dart';

class Home extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const Home({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _authService = AuthService();

  /// Maneja el cierre de sesión
  Future<void> _handleSignOut() async {
    // Mostrar diálogo de confirmación
    final shouldSignOut = await showPlatformDialog<bool>(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          PlatformDialogAction(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context, false),
          ),
          PlatformDialogAction(
            child: Text(
              'Cerrar Sesión',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    // Si el usuario confirmó, cerrar sesión
    if (shouldSignOut == true) {
      await _authService.signOut();
      
      // Navegar al login y remover todas las pantallas anteriores
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          platformPageRoute(
            context: context,
            builder: (context) => Login(
              isDarkMode: widget.isDarkMode,
              onThemeToggle: widget.onThemeToggle,
            ),
          ),
          (route) => false, // Remover todas las rutas anteriores
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return PlatformScaffold(
      backgroundColor: AppColors.getBackgroundColor(widget.isDarkMode),
      appBar: PlatformAppBar(
        title: Text(
          'TaskLink',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        material: (_, __) => MaterialAppBarData(
          backgroundColor: AppColors.green,
          elevation: 0,
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          backgroundColor: AppColors.green,
        ),
        trailingActions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ThemeToggle(
              isDarkMode: widget.isDarkMode,
              onToggle: widget.onThemeToggle,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome Card
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.getCardColor(widget.isDarkMode),
                      borderRadius: AppStyles.borderRadius16,
                      border: Border.all(
                        color: AppColors.getBorderColor(widget.isDarkMode),
                      ),
                      boxShadow: [AppStyles.getCardShadow(widget.isDarkMode)],
                    ),
                    child: Column(
                      children: [
                        // Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.green.withOpacity(0.1),
                            borderRadius: AppStyles.borderRadius16,
                          ),
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.green,
                            size: 48,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Welcome Text
                        Text(
                          '¡Bienvenido!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: AppColors.getTextColor(widget.isDarkMode),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // User Info
                        if (user?.displayName != null) ...[
                          Text(
                            user!.displayName!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColors.getTextColor(widget.isDarkMode),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                        ],
                        
                        Text(
                          user?.email ?? 'Usuario',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.getSubtitleColor(widget.isDarkMode),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Email Verification Status
                        if (user != null && !user.emailVerified) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.errorLight.withOpacity(0.1),
                              borderRadius: AppStyles.borderRadius8,
                              border: Border.all(
                                color: AppColors.errorLight,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_rounded,
                                  color: AppColors.error,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Email no verificado',
                                    style: TextStyle(
                                      color: AppColors.error,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        
                        if (user != null && user.emailVerified) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.green.withOpacity(0.1),
                              borderRadius: AppStyles.borderRadius8,
                              border: Border.all(
                                color: AppColors.green,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.verified_rounded,
                                  color: AppColors.green,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Email verificado',
                                    style: TextStyle(
                                      color: AppColors.green,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Info Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.getCardColor(widget.isDarkMode),
                      borderRadius: AppStyles.borderRadius12,
                      border: Border.all(
                        color: AppColors.getBorderColor(widget.isDarkMode),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Información de la cuenta',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.getTextColor(widget.isDarkMode),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: user?.email ?? 'No disponible',
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.person_outline,
                          label: 'Nombre',
                          value: user?.displayName ?? 'No configurado',
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.badge_outlined,
                          label: 'ID de Usuario',
                          value: user?.uid.substring(0, 8) ?? 'N/A',
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Sign Out Button
                  SizedBox(
                    height: 50,
                    child: PlatformElevatedButton(
                      onPressed: _handleSignOut,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            context.platformIcon(
                              material: Icons.logout_rounded,
                              cupertino: CupertinoIcons.square_arrow_right,
                            ),
                            color: AppColors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Cerrar Sesión',
                            style: AppStyles.getButtonText(widget.isDarkMode),
                          ),
                        ],
                      ),
                      material: (_, _) => MaterialElevatedButtonData(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppStyles.borderRadius8,
                          ),
                          elevation: 2,
                        ),
                      ),
                      cupertino: (_, _) => CupertinoElevatedButtonData(
                        borderRadius: AppStyles.borderRadius8,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Footer Text
                  Text(
                    'Esta es tu pantalla principal.\nAquí irán tus tareas y proyectos.',
                    style: TextStyle(
                      color: AppColors.getSubtitleColor(widget.isDarkMode),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.getSubtitleColor(widget.isDarkMode),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.getSubtitleColor(widget.isDarkMode),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.getTextColor(widget.isDarkMode),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}