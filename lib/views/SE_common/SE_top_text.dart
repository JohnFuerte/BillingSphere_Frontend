import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SETopText extends StatelessWidget {
  const SETopText(
      {super.key, this.width, this.height, required this.text, this.padding});
  final width;
  final height;
  final String text;
  final padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: width,
        height: height,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xff4B0082),
          ),
          softWrap: false,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
