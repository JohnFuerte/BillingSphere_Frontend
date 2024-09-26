import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PETextFieldsNo extends StatelessWidget {
  const PETextFieldsNo({
    super.key,
    this.width,
    this.height,
    this.onSaved,
    this.controller,
    // required this.focusNode,
    // required this.onEditingComplete,
  });
  final width;
  final height;
  final onSaved;
  final controller;
  // final FocusNode focusNode;
  // final VoidCallback onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(0),
          color: Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
          child: TextFormField(
            onEditingComplete: () {
              // onEditingComplete.call(); // Updated to call function if not null
              // print('Focus Node: $focusNode');
            },
            // focusNode: focusNode,
            controller: controller,
            onSaved: onSaved,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 1, bottom: 8)),
          ),
        ),
      ),
    );
  }
}
