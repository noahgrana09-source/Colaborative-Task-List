import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'core/colors.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformApp(
      title: 'TaskLink',
      material: (_, _) => MaterialAppData(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.green,
          primaryColor: AppColors.green,
          scaffoldBackgroundColor: AppColors.getBackgroundColor(false),
          fontFamily: 'Roboto',
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.green,
          primaryColor: AppColors.green,
          scaffoldBackgroundColor: AppColors.getBackgroundColor(true),
          fontFamily: 'Roboto',
        ),
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      ),
      cupertino: (_, _) => CupertinoAppData(
        theme: CupertinoThemeData(
          brightness: _isDarkMode ? Brightness.dark : Brightness.light,
          primaryColor: AppColors.green,
          scaffoldBackgroundColor: AppColors.getBackgroundColor(_isDarkMode),
        ),
      ),
      // AuthWrapper detecta si hay un usuario logueado
      home: AuthWrapper(
        isDarkMode: _isDarkMode,
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}

/// Wrapper que detecta si hay un usuario autenticado
/// y muestra la pantalla correspondiente
class AuthWrapper extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const AuthWrapper({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    // StreamBuilder escucha los cambios en el estado de autenticación
    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Mientras carga, mostrar splash screen
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PlatformScaffold(
            backgroundColor: AppColors.getBackgroundColor(isDarkMode),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.task_alt_rounded,
                      color: AppColors.white,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'TaskLink',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      color: AppColors.getTextColor(isDarkMode),
                    ),
                  ),
                  const SizedBox(height: 32),
                  PlatformCircularProgressIndicator(),
                ],
              ),
            ),
          );
        }

        // Si hay un usuario autenticado, mostrar Home
        if (snapshot.hasData && snapshot.data != null) {
          return Home(
            isDarkMode: isDarkMode,
            onThemeToggle: onThemeToggle,
          );
        }

        // Si no hay usuario, mostrar Login
        return Login(
          isDarkMode: isDarkMode,
          onThemeToggle: onThemeToggle,
        );
      },
    );
  }
}