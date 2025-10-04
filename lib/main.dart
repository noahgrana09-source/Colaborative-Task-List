import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'core/colors.dart';
import 'screens/login.dart';

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
      home: Login(
        isDarkMode: _isDarkMode,
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}