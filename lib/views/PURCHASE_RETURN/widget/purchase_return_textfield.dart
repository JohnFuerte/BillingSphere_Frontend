import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PRTopTextfield extends StatefulWidget {
  const PRTopTextfield({
    super.key,
    this.width,
    this.height,
    this.padding,
    required this.hintText,
    this.controller,
    this.onSaved,
    // this.focusNode,
    this.alignment,
    this.maxLines,
    // this.onEditingComplete,
    this.onTap,
  });
  final width;
  final height;
  final padding;
  final controller;
  final onSaved;
  final String hintText;
  // final FocusNode? focusNode;
  final TextAlign? alignment;
  final int? maxLines;
  // final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;

  @override
  State<PRTopTextfield> createState() => _PRTopTextfieldState();
}

class _PRTopTextfieldState extends State<PRTopTextfield> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(0),
        // color: widget.focusNode!.hasFocus ? Colors.black : Colors.transparent,
        color: Colors.transparent,
      ),
      child: Padding(
        padding: widget.padding,
        child: TextFormField(
          canRequestFocus: true,
          onTap: widget.onTap,
          textAlign: widget.alignment ?? TextAlign.start,
          maxLines: widget.maxLines ?? 1,
          controller: widget.controller,
          // focusNode: widget.focusNode,
          onSaved: widget.onSaved,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          onEditingComplete: () {
            // widget.onEditingComplete
            //     ?.call(); // Updated to call function if not null
            // print('Focus Node: ${widget.focusNode}');
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter some text';
            }
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
            contentPadding: const EdgeInsets.only(left: 1, bottom: 8),
          ),
        ),
      ),
    );
  }
}
