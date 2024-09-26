import 'package:flutter/material.dart';

class Buttons extends StatefulWidget {
  final text;
  final color;
  final onPressed;

  const Buttons({this.text, this.color, this.onPressed});

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: widget.onPressed,
        child: Text(
          widget.text,
          style: TextStyle(color: widget.color, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Color.fromARGB(255, 249, 249, 207),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
