import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'components/my_textfield.dart';
import 'components/my_button.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              //logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(height: 50),

              //username
              MyTextField(
                controller: emailController,
                hintText: 'Username',
                obscureText: false,
              ),

              //const SizedBox(height: 10),

              //password
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              //sign in button
              MyButton(onTap: signUserIn),
              const SizedBox(height: 50),

              MyButton(
                onTap: signUserIn,
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
