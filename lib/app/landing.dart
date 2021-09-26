import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:humors/app/ui/sign_in/ui/sign_in.dart';
import 'package:humors/services/api.dart';
import 'package:humors/services/auth.dart';
import 'package:provider/provider.dart';

import 'ui/base/base.dart';

class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          }

          return Provider<Connector>(
            create: (context) => MoodConnector(),
            child: BasePage()
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
