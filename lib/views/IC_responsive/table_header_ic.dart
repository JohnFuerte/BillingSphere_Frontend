import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotaTable2 extends StatefulWidget {
  const NotaTable2({super.key});

  @override
  State<NotaTable2> createState() => _NotaTableState();
}

class _NotaTableState extends State<NotaTable2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        children: [
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.023,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(),
                    top: BorderSide(),
                    left: BorderSide())),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Sr',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color(0xff4B0082),
                ),
              ),
            ),
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.25,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(),
                    top: BorderSide(),
                    left: BorderSide())),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '   Item Name',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color(0xff4B0082),
                ),
              ),
            ),
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.15,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(),
                    top: BorderSide(),
                    left: BorderSide())),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Qty',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color(0xff4B0082),
                ),
              ),
            ),
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.15,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(),
                    top: BorderSide(),
                    left: BorderSide())),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Unit',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color(0xff4B0082),
                ),
              ),
            ),
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.15,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(),
                    top: BorderSide(),
                    left: BorderSide())),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Rate',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color(0xff4B0082),
                ),
              ),
            ),
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.15,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(),
                    top: BorderSide(),
                    left: BorderSide(),
                    right: BorderSide())),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Net Amt.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color(0xff4B0082),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
