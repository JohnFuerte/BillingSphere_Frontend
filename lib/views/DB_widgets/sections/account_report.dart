import 'package:billingsphere/views/DB_widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../GST_Report/GST_report_desktop.dart';
import '../../Sales_Register/sales_register_desktop.dart';

class AccountReport extends StatelessWidget {
  const AccountReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Reports',
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
            text: '1)  Trial Balance',
            onPressed: () {},
            width: MediaQuery.of(context).size.width / 3,
          ),
          const SizedBox(height: 5),
          CustomButton(
            text: '2)  Ledger Stmnt.',
            onPressed: () {},
            width: MediaQuery.of(context).size.width / 3,
          ),
          const SizedBox(height: 5),
          CustomButton(
            text: '3)  Voucher Regi.',
            onPressed: () {},
            width: MediaQuery.of(context).size.width / 3,
          ),
          Text(
            'Inventory Reports',
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
            text: '6)  Stock Status',
            onPressed: () {},
            width: MediaQuery.of(context).size.width / 3,
          ),
          const SizedBox(height: 5),
          CustomButton(
            text: '7)  Stock Vouchers',
            onPressed: () {},
            width: MediaQuery.of(context).size.width / 3,
          ),
          const SizedBox(height: 5),
          CustomButton(
            text: '8)  Sales Register',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GstReportDesktop(),
                ),
              );
            },
            width: MediaQuery.of(context).size.width / 3,
          ),
        ],
      ),
    );
  }
}
