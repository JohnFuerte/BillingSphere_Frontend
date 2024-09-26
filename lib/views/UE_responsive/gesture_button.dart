import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GestureButton extends StatefulWidget {
  final text;
  const GestureButton({super.key, this.text});

  @override
  State<GestureButton> createState() => _GestureButtonState();
}

class _GestureButtonState extends State<GestureButton> {
  bool _isClicked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            _isClicked = !_isClicked;
          });
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color:
                _isClicked ? Colors.amber : Color.fromARGB(255, 248, 236, 133),
            border: Border.all(
                color: _isClicked ? Colors.black : Colors.grey, width: 2.0),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}
