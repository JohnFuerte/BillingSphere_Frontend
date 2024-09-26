// ignore: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomTextFields extends StatelessWidget {
  final String? text;
  final TextEditingController? controller;
  final onSaved;

  int? flex1;
  int? flex2;
  CustomTextFields(
      {this.text,
      this.flex1,
      this.flex2,
      super.key,
      this.controller,
      this.onSaved}) {
    flex1 ??= 1;
    flex2 ??= 1;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: flex1!,
          child: Text(
            text!,
            style: GoogleFonts.poppins(
              color: Colors.purple,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          flex: flex2!,
          child: TextFormField(
            controller: controller,
            onSaved: onSaved,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(8.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


