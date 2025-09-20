import 'package:flutter/material.dart';
import '../core/colors.dart';
//import '../core/styles.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder:(context, constraints) {
          final componentsWidth = constraints.maxWidth - constraints.maxWidth * 0.2;
          return SizedBox(
            width: componentsWidth,
            child: 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: PlatformTextField(
                      hintText: "Username or email",
                    ),
                  ),
                  
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: PlatformTextField(
                      hintText: "Password",
                      obscureText: true,
                    ),
                  ),

                  Divider(color: AppColors.gray600,),

                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        SignInButton(
                          Buttons.Google,
                          text: "Sign in with Google",
                          onPressed: (){},
                        ),
                        PlatformElevatedButton(
                          color: AppColors.green,
                          child: Text("Registrate"),                     
                        )
                      ],
                    )
                  ),             
                ],
              ),
          );
        },
      ),
    );
  }
}