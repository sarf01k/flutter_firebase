import 'package:flutter/material.dart';
import 'package:learning_firebase/sign_in.dart';
import 'package:learning_firebase/sign_up.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
    ? SignIn(onClickedSignUp: toggle)
    : SignUp(onClickedSignUp: toggle);

    void toggle() {
      setState(() {
        isLogin = !isLogin;
      });
    }
}