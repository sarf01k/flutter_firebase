import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:learning_firebase/main.dart';
import 'package:learning_firebase/utils.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class SignUp extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const SignUp({Key? key, required this.onClickedSignUp}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w400
                          ),
                          filled: true,
                          fillColor: const Color(0xFFD3D3D3),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20)
                          )
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                            ? "Enter a valid email"
                            : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w400
                          ),
                          filled: true,
                          fillColor: const Color(0xFFD3D3D3),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20)
                          )
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                          value != null && value.length < 6
                            ? "Enter min. 6 characters"
                            : null,
                      ),
                      const SizedBox(height: 18),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            isLoading = true;
                          });
                          signUp().then((_) {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        },
                        child: Container(
                          width: constraints.maxWidth,
                          height: 55,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(25)
                          ),
                          child: Center(
                            child: isLoading
                              ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                              : const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                )
                              )
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Color(0xFF000000)
                          ),
                          text: "Already have an account? ",
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickedSignUp,
                              text: "Log In",
                              style: const TextStyle(
                                decoration: TextDecoration.underline
                              )
                            )
                          ]
                        )
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message, Colors.red);
      logger.e("Error signing up:\n$e");
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}