import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  const WaveClipper({required this.correct});
  final bool correct;

  // 画面の中央を0とした割合を受け取り、その割合に対応するX座標を返す
  double _getX(Size size, double rate) {
    final double width = size.width / 8 * 10;
    if (correct) {
      return (width * 0.3) + (width * rate);
    } else {
      return (width * 0.5) - (width * rate);
    }
  }

  // 画面の中央を0とした割合を受け取り、その割合に対応するY座標を返す
  double _getY(Size size, double rate) {
    final double height = size.height * 2;
    if (correct) {
      return (height * 0.5) - (height * rate);
    } else {
      return height * rate;
    }
  }

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(_getX(size, 0), _getY(size, 0));
    path.lineTo(_getX(size, 0.5), _getY(size, 0));
    path.lineTo(_getX(size, 0.5), _getY(size, 0.5));
    path.lineTo(_getX(size, 0), _getY(size, 0.5));
    path.quadraticBezierTo(
      _getX(size, -0.6),
      _getY(size, 0.1),
      _getX(size, 0),
      _getY(size, 0),
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
