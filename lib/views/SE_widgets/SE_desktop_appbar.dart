// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SEDesktopAppbar extends StatelessWidget {
  String text1;
  String text2;
  Widget? menu;
  double? flex1;
  double? flex2;
  SEDesktopAppbar({
    super.key,
    required this.text1,
    required this.text2,
    this.menu,
    this.flex1,
    this.flex2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 0.5),
      child: Row(
        children: [
          Expanded(
            flex: flex1 != null ? flex1!.toInt() : 4,
            child: Container(
              height: 50,
              color: const Color(0xff79442F),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 300),
                  Align(
                    alignment: Alignment.center,
                    child: Text(text1,
                        // 'Tax Invoice GST',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: flex2 != null ? flex2!.toInt() : 6,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.82,
              height: 50,
              decoration: const BoxDecoration(color: Color(0xFF008000)
                  // gradient: LinearGradient(
                  //   begin: Alignment.centerLeft,
                  //   end: Alignment.centerRight,
                  //   colors: [
                  //     Color.fromARGB(255, 13, 23, 33),
                  //     Color.fromARGB(255, 37, 65, 101),
                  //   ],
                  // ),
                  ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  text2,
                  // 'Sales Entry',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          menu ?? Container(),
        ],
      ),
    );
  }
}
