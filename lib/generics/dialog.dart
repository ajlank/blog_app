import 'package:flutter/material.dart';

Future<void> showErrorDialog(String tt, String cnt, BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(tt),
        content: Text(cnt),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Okay'),
          ),
        ],
      );
    },
  );
}
