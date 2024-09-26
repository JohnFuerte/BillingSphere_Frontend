import 'package:billingsphere/views/DB_widgets/custom_button.dart';
import 'package:billingsphere/views/PM_homepage.dart';
import 'package:billingsphere/views/RA_homepage.dart';
import 'package:billingsphere/views/RV_homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../PEresponsive/PE_desktop_body.dart';
import '../../SE_responsive/SE_desktop_body.dart';

class Transaction extends StatelessWidget {
  const Transaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transactions',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
              decoration: TextDecoration.underline,
              decorationColor: Colors.red,
              decorationThickness: 2.0,
            ),
          ),
          const SizedBox(height: 5),
          CustomButton(
            text: 'a)    Sales',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SEMyDesktopBody(),
                ),
              );
            },
            width: MediaQuery.of(context).size.width / 3,
          ),
          const SizedBox(height: 5),
          CustomButton(
            text: 'b)    Receipt',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RVHomePage(),
                ),
              );
            },
            width: MediaQuery.of(context).size.width / 3,
          ),
          const SizedBox(height: 5),
          CustomButton(
            text: 'c)    Purchase',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PEMyDesktopBody(),
                ),
              );
            },
            width: MediaQuery.of(context).size.width / 3,
          ),
          const SizedBox(height: 5),
          CustomButton(
            text: 'd)    Payment',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PMHomePage(),
                ),
              );
            },
            width: MediaQuery.of(context).size.width / 3,
          ),
          const SizedBox(height: 5),
          CustomButton(
            text: 'e)    Receivable',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RAhomepage(),
                ),
              );
            },
            width: MediaQuery.of(context).size.width / 3,
          ),
          const SizedBox(height: 5),
          CustomButton(
            text: 'f)     Payable',
            onPressed: () {},
            width: MediaQuery.of(context).size.width / 3,
          ),
        ],
      ),
    );
  }
}
