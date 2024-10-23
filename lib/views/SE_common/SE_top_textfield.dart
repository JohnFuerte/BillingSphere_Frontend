import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SETopTextfield extends StatefulWidget {
  const SETopTextfield({
    super.key,
    this.width,
    this.height,
    this.padding,
    required this.hintText,
    this.controller,
    this.onSaved,
    this.onChanged, // Added onChanged
    this.readOnly = false, // Added readOnly with default value
    this.alignment,
    this.maxLines,
    this.onTap,
  });

  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final TextEditingController? controller;
  final FormFieldSetter<String>? onSaved;
  final FormFieldSetter<String>? onChanged; // onChanged option
  final bool readOnly; // readOnly option
  final String hintText;
  final TextAlign? alignment;
  final int? maxLines;
  final VoidCallback? onTap;

  @override
  State<SETopTextfield> createState() => _SETopTextfieldState();
}

class _SETopTextfieldState extends State<SETopTextfield> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(0),
          color: Colors.transparent,
        ),
        child: Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: TextFormField(
            readOnly:
                widget.readOnly, // Making the field read-only if specified
            onTap: widget.onTap,
            textAlign: widget.alignment ?? TextAlign.start,
            maxLines: widget.maxLines ?? 1,
            controller: widget.controller,
            onSaved: widget.onSaved,
            onChanged: widget.onChanged, // Handle the onChanged callback
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hintText,
              contentPadding: const EdgeInsets.only(left: 1, bottom: 8),
            ),
          ),
        ),
      ),
    );
  }
}
