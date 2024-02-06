import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                signOut();
              }
            )
          )
        ],
      ),
      body: const SafeArea(
        child: Center(
          child: Text("Yo!"),
        )
      ),
    );
  }

  Future signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (error) {
      logger.e("Error signing out:\n$error");
    }
  }
}