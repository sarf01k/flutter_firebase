import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learning_firebase/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const LearnFirebase());
}

class LearnFirebase extends StatelessWidget {
  const LearnFirebase({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Hey!"),
      ),
    );
  }
}