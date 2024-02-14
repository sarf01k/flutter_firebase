import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learning_firebase/auth_screen.dart';
import 'package:learning_firebase/firebase_options.dart';
import 'package:learning_firebase/home.dart';
import 'package:learning_firebase/utils.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: true,
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      home: const LearnFirebase(),
    )
  );
}

class LearnFirebase extends StatelessWidget {
  const LearnFirebase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              );
            } else if (snapshot.hasData) {
              return const Home();
            } else if (snapshot.hasError) {
                return const Dialog(
                  child: Center(
                    child: Text("Dialog"),
                  ),
                );
            } else {
              return const AuthScreen();
            }
          }
        ),
      ),
    );
  }
}