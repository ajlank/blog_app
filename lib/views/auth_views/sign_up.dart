import 'package:blog_app/base/styles/text_styles.dart';
import 'package:blog_app/controller/auth_controller/auth_error_notifier.dart';
import 'package:blog_app/generics/dialog.dart';
import 'package:blog_app/utils/constants/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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

  Future<void> signUpUser() async {
    try {
      final userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
      Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        context.read<AuthErrorNotifier>().setPasswordError(
          'Password is too weak! at least 6 digits required',
        );
      } else if (e.code == 'email-already-in-use') {
        context.read<AuthErrorNotifier>().setEmailError(
          'Email already exists! try another',
        );
      } else if (e.code == 'invalid-email') {
        context.read<AuthErrorNotifier>().setEmailError(
          'Invalid email (correct: example@something.com)',
        );
      } else {
        return await showErrorDialog('An error occurred', e.code, context);
      }
    } catch (e) {
      return await showErrorDialog('An error occured', e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(boxShadow: []),
            height: size.height * .44,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Sign Up', style: TextStyles.profileHeaderText),

                SizedBox(height: 25),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                (context.watch<AuthErrorNotifier>().emailEmailError.isNotEmpty)
                    ? Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12, top: 5),
                            child: Text(
                              context
                                  .watch<AuthErrorNotifier>()
                                  .emailEmailError,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
                SizedBox(height: 15),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                (context.watch<AuthErrorNotifier>().passwordError.isNotEmpty)
                    ? Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12, top: 5),
                            child: Text(
                              context.watch<AuthErrorNotifier>().passwordError,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(height: 12),
                Container(
                  width: size.width * .60,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 136, 196, 212),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      await signUpUser();
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(color: Colors.white, fontSize: 19),
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  },
                  child: const Text('Already registered? login here'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
