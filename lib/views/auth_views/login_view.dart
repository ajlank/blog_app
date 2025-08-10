import 'package:blog_app/controller/notification_notifier.dart';
import 'package:blog_app/utils/constants/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    try {
      final userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (userCred.user != null) {
        context.read<NotificationNotifier>().setNotifRecieverId(
          userCred.user!.uid,
        );
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(profileRoute, (_) => false);
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userConfirmed = GetStorage().read("userConfirmId");
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login'),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(hintText: 'Enter your email'),
            ),
            TextField(
              keyboardType: TextInputType.text,
              controller: _passwordController,
              decoration: InputDecoration(hintText: 'Enter your password'),
            ),
            TextButton(
              onPressed: () async {
                await loginUser();
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(signUpRoute, (route) => false);
              },
              child: const Text('Not registered yet? register here'),
            ),
          ],
        ),
      ),
    );
  }
}
