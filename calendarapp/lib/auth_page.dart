//import 'package:calendarapp/calendar.dart';
import 'dart:html';

import 'package:calendarapp/calendar.dart';
import 'package:calendarapp/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

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
            return const Calendar();
          }

          //not logged in
          else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
