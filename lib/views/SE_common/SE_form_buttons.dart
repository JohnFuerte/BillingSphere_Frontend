import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SEFormButton extends StatelessWidget {
  const SEFormButton(
      {super.key,
      this.width,
      this.height,
      required this.buttonText,
      this.onPressed});

  final width;
  final height;
  final String buttonText;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: SizedBox(
        width: width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 255, 243, 132),
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1.0),
                side: const BorderSide(color: Colors.black),
              ),
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              buttonText,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


