import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {

  @override
  _LoadingScreenState createState() => _LoadingScreenState();

  final double size;
  final Color color;

  LoadingScreen({required this.size, required this.color});
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return SpinKitRing(
      size: widget.size,
      color: widget.color,
    );
  }
}