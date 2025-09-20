import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'core/colors.dart';
import 'core/styles.dart';
import 'screens/login.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformApp(
      title: 'TaskLink',
      home: PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text("TaskLink", style: AppStyles.titles,),
          backgroundColor: AppColors.gray100,
        ),
        backgroundColor: AppColors.white,
        body: Login(),
      ),
    );
  }
}