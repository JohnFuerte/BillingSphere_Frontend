import 'package:flutter/material.dart';

class SLCustomAppBar extends StatelessWidget {
  const SLCustomAppBar({super.key, required this.title, required this.color});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 30,
      color: color,
      child:  Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
      ),
    );
  }
}


