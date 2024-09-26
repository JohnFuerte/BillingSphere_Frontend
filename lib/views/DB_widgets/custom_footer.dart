import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '© ${DateTime.now().year} Fuerte Developers. All rights reserved.',
            style: GoogleFonts.poppins(
              fontSize: 12.0,
              color: Colors.grey[600],
            ),
          ),
          Text(
            'BillingSphere v1.0.0',
            style: GoogleFonts.poppins(
              fontSize: 12.0,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
