import 'package:calendarapp/auth_Screen.dart';
import 'package:calendarapp/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //logged in
          if (snapshot.hasData) {
            return const AuthScreen();
          }

          //not logged in
          else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
