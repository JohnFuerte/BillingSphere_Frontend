import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PETextFields extends StatelessWidget {
  const PETextFields({
    super.key,
    this.width,
    this.height,
    this.controller,
    this.onSaved,
    this.readOnly,
    // required this.onEditingComplete,
    // required this.focusNode,
  });
  final width;
  final height;
  final controller;
  final onSaved;
  final bool? readOnly;
  // final VoidCallback onEditingComplete;
  // final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(0),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 14.0),
          child: TextFormField(
            // focusNode: focusNode,
            readOnly: readOnly ?? false,
            onSaved: onSaved,
            controller: controller,
            onEditingComplete: () {
              // onEditingComplete.call();
            },
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 1, bottom: 8),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
