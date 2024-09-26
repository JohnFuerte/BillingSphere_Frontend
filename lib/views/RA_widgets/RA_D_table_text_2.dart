import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTableText2 extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  const MyTableText2({
    super.key,
    required this.text,
    required this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 38,
        decoration: BoxDecoration(border: Border.all(color: Colors.white)),
        padding: const EdgeInsets.all(8.0),
        child: Text(text,
            textAlign: textAlign,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}
