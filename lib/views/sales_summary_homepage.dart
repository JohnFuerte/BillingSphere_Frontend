import 'package:billingsphere/views/sales_summary_responsive/sales_summary_desktop_body.dart';
import 'package:billingsphere/views/sales_summary_responsive/sales_summary_mobile_body.dart';
import 'package:billingsphere/views/responsive_layout.dart';
import 'package:flutter/material.dart';

class SalesSummaryhomepage extends StatefulWidget {
  const SalesSummaryhomepage({super.key});

  @override
  State<SalesSummaryhomepage> createState() => _SalesSummaryhomepageState();
}

class _SalesSummaryhomepageState extends State<SalesSummaryhomepage> {
  @override
  Widget build(BuildContext context) {
    // final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: SalesSummaryMyMobileBody(),
        desktopBody: SalesSummaryMyDesktopBody(),
      ),
    );
  }
}
