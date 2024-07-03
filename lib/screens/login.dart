import 'package:flutter/material.dart';
import 'package:volmore/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                // TODO: Implement forgot password functionality
              },
              child: const Text('Forgot Password?'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async{
                // TODO: Implement login functionality
                final user = await AuthService().signInWithEmailAndPassword(
                  emailController.text,
                  passwordController.text,
                );
                if (user != null) {
                  // Navigate to the home screen
                  Navigator.of(context).pushReplacementNamed('/home');
                }
                else{
                  // Show an error dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Invalid email or password'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Submit'),
            ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/register');
            },
            child: const Text('Don\'t have an account? Register here'),
          )
          ],
        ),
      ),
    );
  }
}