
import 'package:flutter/material.dart';

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start from top left
    path.lineTo(0, size.height);

    // Curve upward in the center
    path.quadraticBezierTo(
      size.width / 2, size.height - 62, // control point
      size.width, size.height,          // end point
    );

    // Top-right corner
    path.lineTo(size.width, 0);

    // Close the path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
