import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color purple = Color(0xff602eaa);
const Color black = Colors.black;
const Color blue = Colors.blue;
const Color yello = Colors.yellow;
const Color green = Colors.green;
const Color red = Colors.red;
const Color white = Colors.white;

TextStyle kLoginTitleStyle(Size size) => GoogleFonts.ubuntu(
      fontSize: size.height * 0.060,
      fontWeight: FontWeight.bold,
    );

TextStyle kLoginSubtitleStyle(Size size) => GoogleFonts.ubuntu(
      fontSize: size.height * 0.030,
    );

TextStyle kLoginTermsAndPrivacyStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: 15, color: Colors.grey, height: 1.5);

TextStyle kHaveAnAccountStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: size.height * 0.022, color: Colors.black);

TextStyle kLoginOrSignUpTextStyle(
  Size size,
) =>
    GoogleFonts.ubuntu(
      fontSize: size.height * 0.022,
      fontWeight: FontWeight.w500,
      color: purple,
    );

TextStyle kTextFormFieldStyle() => const TextStyle(color: Colors.black);
