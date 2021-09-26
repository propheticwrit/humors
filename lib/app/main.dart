import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:humors/services/auth.dart';
import 'package:provider/provider.dart';

import 'landing.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Humors());
}

class Humors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        title: 'Mood',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LandingPage(),
      ),
    );
  }
}