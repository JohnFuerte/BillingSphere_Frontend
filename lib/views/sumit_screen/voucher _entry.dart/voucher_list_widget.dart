import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomList extends StatelessWidget {
  final String? name;
  final String? Skey;
  final VoidCallback? onTap; // Add this line
  const CustomList({super.key, this.name, this.Skey, this.onTap});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 32,
          width: w * 0.1,
          decoration: BoxDecoration(
            border:
                Border.all(width: 2, color: Colors.grey[800] ?? Colors.grey),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: Text(
                  Skey ?? "",
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Expanded(
                child: Text(
                  name ?? " ",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF4B0088),
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
