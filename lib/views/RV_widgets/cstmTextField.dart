import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RVCustomTextFieldWidget extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final double textFieldHeight;
  final double textFieldWidth;

  const RVCustomTextFieldWidget({
    Key? key,
    required this.labelText,
    required this.textFieldHeight,
    required this.textFieldWidth,
    required this.controller,
  }) : super(key: key);

  @override
  _RVCustomTextFieldWidgetState createState() =>
      _RVCustomTextFieldWidgetState();
}

class _RVCustomTextFieldWidgetState extends State<RVCustomTextFieldWidget> {
  FocusNode _focusNode = FocusNode();
  Color backgroundColor = Colors.transparent;
  Color textColor = Colors.black; // Initial text color

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            '${widget.labelText} :',
            style: GoogleFonts.poppins(
              color: const Color(0xFF4B0088),
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            height: widget.textFieldHeight,
            width: widget.textFieldWidth,
            child: Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  backgroundColor =
                      hasFocus ? Colors.black : Colors.transparent;
                  textColor = hasFocus ? Colors.white : Colors.black;
                });
              },
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                cursorHeight: 21,
                cursorColor: Colors.white,
                cursorWidth: 1,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(left: 8.0, bottom: 5.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
