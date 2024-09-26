import 'package:flutter/material.dart';

class RACustomAppBar extends StatelessWidget {
  final text;
  final color;

  const RACustomAppBar({super.key, this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 30,
      color: color,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
      ),
    );
  }
}
