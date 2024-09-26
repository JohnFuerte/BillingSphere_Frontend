import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DButtons extends StatelessWidget {
  const DButtons({
    Key? key,
    required this.text,
    this.isDisabled = false,
    this.onPressed,
    this.alignment,
  }) : super(key: key);

  final String text;
  final VoidCallback? onPressed;
  final Alignment? alignment;
  final bool? isDisabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        height: 30,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return const Color.fromARGB(
                      255, 247, 241, 187); // Regular color
                }
                return const Color.fromARGB(
                    255, 247, 241, 187); // Regular color
              },
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1.0),
                side: const BorderSide(color: Colors.black),
              ),
            ),
          ),
          onPressed: onPressed,
          child: Align(
            alignment: alignment ?? Alignment.centerLeft,
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDisabled!
                    ? const Color.fromARGB(255, 115, 108, 47)
                    : Colors.black,
              ),
              textAlign: TextAlign.center,
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
