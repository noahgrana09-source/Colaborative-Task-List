import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../core/colors.dart';
import '../core/styles.dart';
import '../components/theme_toggle.dart';
import '../services/auth_service.dart';
import 'home.dart';

class Register extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const Register({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  /// Maneja el registro con email y contraseña
  Future<void> _handleEmailRegister() async {
    // Validar que los campos no estén vacíos
    if (_emailController.text.trim().isEmpty || 
        _passwordController.text.isEmpty || 
        _confirmPasswordController.text.isEmpty) {
      _showErrorDialog('Por favor completa todos los campos');
      return;
    }

    // Validar que las contraseñas coincidan
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog('Las contraseñas no coinciden');
      return;
    }

    // Validar longitud mínima de contraseña
    if (_passwordController.text.length < 6) {
      _showErrorDialog('La contraseña debe tener al menos 6 caracteres');
      return;
    }

    // Mostrar indicador de carga
    setState(() => _isLoading = true);

    try {
      // Intentar registrar al usuario
      final user = await _authService.registerWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Ocultar indicador de carga
      setState(() => _isLoading = false);

      if (user != null) {
        // Registro exitoso
        print('Usuario registrado: ${user.email}');
        
        // Opcional: Enviar email de verificación
        await _authService.sendEmailVerification();
        
        _showSuccessDialog(
          '¡Cuenta creada exitosamente!\n\nHemos enviado un email de verificación a tu correo.',
          onConfirm: () {
            // Volver a la pantalla de login
            Navigator.pop(context); // Cerrar diálogo
            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                platformPageRoute(
                  context: context,
                  builder: (context) => Home(
                    isDarkMode: widget.isDarkMode,
                    onThemeToggle: widget.onThemeToggle,
                  ),
                ),
                (route) => false,
              );
            } // Volver a login
          },
        );
      } else {
        // Error en el registro
        _showErrorDialog('No se pudo crear la cuenta. Verifica tus datos.');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog('Error inesperado: $e');
    }
  }

  /// Maneja el registro con Google
  Future<void> _handleGoogleRegister() async {
    setState(() => _isLoading = true);

    try {
      final user = await _authService.signInWithGoogle();
      
      setState(() => _isLoading = false);

      if (user != null) {
        print('Usuario registrado con Google: ${user.email}');
        _showSuccessDialog(
          '¡Bienvenido ${user.displayName}!',
          onConfirm: () {
            Navigator.pop(context); // Cerrar diálogo
            if (mounted){
              Navigator.of(context).pushAndRemoveUntil(
                platformPageRoute(
                  context: context,
                  builder: (context) => Home(
                    isDarkMode: widget.isDarkMode,
                    onThemeToggle: widget.onThemeToggle,
                  ),
                ),
                (route) => false,
            );
        } // Volver a login
          },
        );
      } else {
        _showErrorDialog('Registro con Google cancelado');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog('Error al registrarse con Google: $e');
    }
  }

  /// Muestra un diálogo de error
  void _showErrorDialog(String message) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          PlatformDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  /// Muestra un diálogo de éxito
  void _showSuccessDialog(String message, {VoidCallback? onConfirm}) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: const Text('Éxito'),
        content: Text(message),
        actions: [
          PlatformDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
              onConfirm?.call();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      backgroundColor: AppColors.getBackgroundColor(widget.isDarkMode),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  
                  // Back Button and Theme Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PlatformIconButton(
                        icon: Icon(
                          context.platformIcon(
                            material: Icons.arrow_back,
                            cupertino: CupertinoIcons.back,
                          ),
                          color: AppColors.getTextColor(widget.isDarkMode),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        material: (_, _) => MaterialIconButtonData(
                          padding: EdgeInsets.zero,
                        ),
                        cupertino: (_, _) => CupertinoIconButtonData(
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      ThemeToggle(
                        isDarkMode: widget.isDarkMode,
                        onToggle: widget.onThemeToggle,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Logo/Title Section
                  Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: AppStyles.borderRadius16,
                          boxShadow: [AppStyles.getCardShadow(widget.isDarkMode)],
                        ),
                        child: const Icon(
                          Icons.person_add_rounded,
                          color: AppColors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Crear Cuenta',
                        style: AppStyles.getTitle(widget.isDarkMode),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Únete a TaskLink y organizá tus tareas con tu equipo',
                        style: AppStyles.getSubtitle(widget.isDarkMode),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Form Section
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email Field
                        _buildTextField(
                          label: 'Email',
                          controller: _emailController,
                          hintText: 'tu@email.com',
                          isDarkMode: widget.isDarkMode,
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Password Field
                        _buildPasswordField(
                          label: 'Contraseña',
                          controller: _passwordController,
                          hintText: 'Mínimo 6 caracteres',
                          isVisible: _isPasswordVisible,
                          onToggleVisibility: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          isDarkMode: widget.isDarkMode,
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Confirm Password Field
                        _buildPasswordField(
                          label: 'Confirmar contraseña',
                          controller: _confirmPasswordController,
                          hintText: 'Repite tu contraseña',
                          isVisible: _isConfirmPasswordVisible,
                          onToggleVisibility: () {
                            setState(() {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                            });
                          },
                          isDarkMode: widget.isDarkMode,
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Register Button
                        SizedBox(
                          height: 50,
                          child: _isLoading
                              ? Center(
                                  child: PlatformCircularProgressIndicator(),
                                )
                              : PlatformElevatedButton(
                                  onPressed: _handleEmailRegister,
                                  child: Text(
                                    'Crear Cuenta',
                                    style: AppStyles.getButtonText(widget.isDarkMode),
                                  ),
                                  material: (_, _) => MaterialElevatedButtonData(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.green,
                                      foregroundColor: AppColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: AppStyles.borderRadius8,
                                      ),
                                      elevation: 2,
                                    ),
                                  ),
                                  cupertino: (_, _) => CupertinoElevatedButtonData(
                                    borderRadius: AppStyles.borderRadius8,
                                    color: AppColors.green,
                                  ),
                                ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColors.getBorderColor(widget.isDarkMode),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'o regístrate con',
                                style: AppStyles.getLabel(widget.isDarkMode),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColors.getBorderColor(widget.isDarkMode),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Google Sign Up Button
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: SignInButton(
                            Buttons.Google,
                            text: "Registrate con Google",
                            onPressed: _isLoading ? null : _handleGoogleRegister,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppStyles.borderRadius8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿Ya tienes cuenta?',
                        style: TextStyle(
                          color: AppColors.getSubtitleColor(widget.isDarkMode),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          ' Inicia Sesión',
                          style: TextStyle(
                            color: AppColors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.getLabel(isDarkMode),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.getSurfaceColor(isDarkMode),
            borderRadius: AppStyles.borderRadius8,
            border: Border.all(
              color: AppColors.getBorderColor(isDarkMode),
            ),
          ),
          child: PlatformTextField(
            controller: controller,
            hintText: hintText,
            keyboardType: TextInputType.emailAddress,
            material: (_, _) => MaterialTextFieldData(
              style: AppStyles.getInputText(isDarkMode),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: AppStyles.getHintText(isDarkMode),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            cupertino: (_, __) => CupertinoTextFieldData(
              style: AppStyles.getInputText(isDarkMode),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              placeholder: hintText,
              placeholderStyle: AppStyles.getHintText(isDarkMode),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.getLabel(isDarkMode),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.getSurfaceColor(isDarkMode),
            borderRadius: AppStyles.borderRadius8,
            border: Border.all(
              color: AppColors.getBorderColor(isDarkMode),
            ),
          ),
          child: PlatformTextField(
            controller: controller,
            obscureText: !isVisible,
            hintText: hintText,
            material: (_, _) => MaterialTextFieldData(
              style: AppStyles.getInputText(isDarkMode),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: AppStyles.getHintText(isDarkMode),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.getHintColor(isDarkMode),
                    size: 20,
                  ),
                  onPressed: onToggleVisibility,
                ),
              ),
            ),
            cupertino: (_, _) => CupertinoTextFieldData(
              style: AppStyles.getInputText(isDarkMode),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              placeholder: hintText,
              placeholderStyle: AppStyles.getHintText(isDarkMode),
              suffix: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onToggleVisibility,
                child: Icon(
                  isVisible
                      ? CupertinoIcons.eye_slash
                      : CupertinoIcons.eye,
                  color: AppColors.getHintColor(isDarkMode),
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}