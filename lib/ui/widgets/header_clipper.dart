import 'package:flutter/material.dart';

/// A custom path clipper for the account view.
class HeaderClipper extends CustomClipper<Path> {
  /// The offset between the maximum height and the start of the curve.
  final double opening;

  HeaderClipper({@required this.opening});

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - opening);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - opening);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
