import 'package:flutter/material.dart';

class Wave extends StatelessWidget {
  const Wave({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(color: Theme.of(context).primaryColor, height: 200),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0, 175);

    // The values of the calculations would be path.quadraticBezierTo(100, 75, 200, 150) if the height is 200 and the width is 400;
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.50 - 25,
        size.width * 0.50, size.height * 0.75);

    // The values of the calculations would be path.quadraticBezierTo(300, 225, 400, 150) if the height is 200 and the width is 400;
    path.quadraticBezierTo(
        size.width * 0.75, size.height + 25, size.width, size.height * 0.75);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}