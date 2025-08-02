import 'package:blog_app/utils/constants/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Column(
        children: [
          Text('Home Page'),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: const Text('log out'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(profileRoute);
            },
            child: const Text('Profile view'),
          ),
        ],
      ),
    );
  }
}
