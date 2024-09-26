import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTableText1 extends StatelessWidget {
  final String text;
  const MyTableText1({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.white)),
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          textAlign: TextAlign.end,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
