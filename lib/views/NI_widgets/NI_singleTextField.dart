import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NISingleTextField extends StatelessWidget {
  final String labelText;
  final int flex1;
  final int flex2;
  final TextEditingController controller;

  const NISingleTextField({
    super.key,
    required this.labelText,
    required this.flex1,
    required this.flex2,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: flex1,
            child: Text(
              labelText,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color(0xFF510986)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: flex2,
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 40,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(0),
              ),
              child: TextFormField(
                controller: controller,
                onSaved: (newValue) {
                  controller.text = newValue!;
                },
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                cursorHeight: 20,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 5.0, bottom: 8.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
