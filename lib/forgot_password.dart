import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_firebase/home.dart';
import 'package:learning_firebase/main.dart';
import 'package:learning_firebase/utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Reset Password"
        ),
      ),
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
                      const Center(
                        child: Text(
                          "Enter your email to receive a password reset link",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 18),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            isLoading = true;
                          });
                          resetPassword().then((_) {
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
                              : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.mail_outline, color: Colors.white,),
                                    SizedBox(width: 5),
                                    Text(
                                      "Register Password",
                                      style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    )
                                  )
                                ],
                              )
                          ),
                        ),
                      ),
                    ],
                  )
                );
              }
            ),
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    final User? user = FirebaseAuth.instance.currentUser;

    try {
      if (user != null) {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim()
        );
        Utils.showSnackBar("Password Reset Email Sent", Colors.green);
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      } else {
        Utils.showSnackBar("Account with this email does not exist", Colors.red);
      }
    } on FirebaseAuthException catch (e) {
      logger.e("Error signing in:\n$e");
      logger.e(user);
      Utils.showSnackBar(e.message, Colors.red);
      Navigator.of(context).pop();
    }
  }
}