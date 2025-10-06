import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../core/colors.dart';
import '../core/styles.dart';
import '../components/theme_toggle.dart';
import '../services/auth_service.dart';
import 'register.dart';
import 'home.dart';

class Login extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const Login({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  /// Maneja el inicio de sesión con email y contraseña
  Future<void> _handleEmailSignIn() async {
    // Validar que los campos no estén vacíos
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog('Por favor completa todos los campos');
      return;
    }

    // Mostrar indicador de carga
    setState(() => _isLoading = true);

    try {
      // Intentar iniciar sesión
      final user = await _authService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Ocultar indicador de carga
      setState(() => _isLoading = false);

      if (user != null) {
        // Inicio de sesión exitoso
        print('Usuario autenticado: ${user.email}');
        _showSuccessDialog('¡Bienvenido de nuevo!');
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
        }
      } else {
        // Error en el inicio de sesión
        _showErrorDialog('Email o contraseña incorrectos');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog('Error inesperado: $e');
    }
  }

  /// Maneja el inicio de sesión con Google
  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final user = await _authService.signInWithGoogle();
      
      setState(() => _isLoading = false);

      if (user != null) {
        print('Usuario autenticado con Google: ${user.email}');
        _showSuccessDialog('¡Bienvenido ${user.displayName}!');
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
        }
      } else {
        _showErrorDialog('Inicio de sesión con Google cancelado');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog('Error al iniciar sesión con Google: $e');
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
  void _showSuccessDialog(String message) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: const Text('Éxito'),
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

  void _navigateToRegister() {
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => Register(
          isDarkMode: widget.isDarkMode,
          onThemeToggle: widget.onThemeToggle,
        ),
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
                  
                  // Theme Toggle Switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                          Icons.task_alt_rounded,
                          color: AppColors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'TaskLink',
                        style: AppStyles.getTitle(widget.isDarkMode),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Organizá tus tareas con tu equipo',
                        style: AppStyles.getSubtitle(widget.isDarkMode),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 60),
                  
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              style: AppStyles.getLabel(widget.isDarkMode),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.getSurfaceColor(widget.isDarkMode),
                                borderRadius: AppStyles.borderRadius8,
                                border: Border.all(
                                  color: AppColors.getBorderColor(widget.isDarkMode),
                                ),
                              ),
                              child: PlatformTextField(
                                controller: _emailController,
                                hintText: 'tu@email.com',
                                keyboardType: TextInputType.emailAddress,
                                material: (_, _) => MaterialTextFieldData(
                                  style: AppStyles.getInputText(widget.isDarkMode),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: AppStyles.getHintText(widget.isDarkMode),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                                cupertino: (_, _) => CupertinoTextFieldData(
                                  style: AppStyles.getInputText(widget.isDarkMode),
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  placeholder: 'tu@email.com',
                                  placeholderStyle: AppStyles.getHintText(widget.isDarkMode),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Password Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Contraseña',
                              style: AppStyles.getLabel(widget.isDarkMode),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.getSurfaceColor(widget.isDarkMode),
                                borderRadius: AppStyles.borderRadius8,
                                border: Border.all(
                                  color: AppColors.getBorderColor(widget.isDarkMode),
                                ),
                              ),
                              child: PlatformTextField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                hintText: 'Ingresa tu contraseña',
                                material: (_, _) => MaterialTextFieldData(
                                  style: AppStyles.getInputText(widget.isDarkMode),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: AppStyles.getHintText(widget.isDarkMode),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: AppColors.getHintColor(widget.isDarkMode),
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible = !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                cupertino: (_, _) => CupertinoTextFieldData(
                                  style: AppStyles.getInputText(widget.isDarkMode),
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  placeholder: 'Ingresa tu contraseña',
                                  placeholderStyle: AppStyles.getHintText(widget.isDarkMode),
                                  suffix: CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: Icon(
                                      _isPasswordVisible
                                          ? CupertinoIcons.eye_slash
                                          : CupertinoIcons.eye,
                                      color: AppColors.getHintColor(widget.isDarkMode),
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Login Button
                        SizedBox(
                          height: 50,
                          child: _isLoading
                              ? Center(
                                  child: PlatformCircularProgressIndicator(),
                                )
                              : PlatformElevatedButton(
                                  onPressed: _handleEmailSignIn,
                                  child: Text(
                                    'Iniciar Sesión',
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
                                'o continúa con',
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
                        
                        // Google Sign In Button
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: SignInButton(
                            Buttons.Google,
                            text: "Continuar con Google",
                            onPressed: _isLoading ? null : _handleGoogleSignIn,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppStyles.borderRadius8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿No tienes cuenta?',
                        style: TextStyle(
                          color: AppColors.getSubtitleColor(widget.isDarkMode),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: _navigateToRegister,
                        child: const Text(
                          ' Regístrate',
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}