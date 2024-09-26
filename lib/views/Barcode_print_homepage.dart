import 'package:billingsphere/views/Barcode_responsive/barcode_print_mobile_body.dart';
import 'package:flutter/material.dart';

import 'Barcode_responsive/barcode_print_desktop_body.dart';
import 'responsive_layout.dart';

class BarcodePrintHomepage extends StatefulWidget {
  const BarcodePrintHomepage({super.key});

  @override
  State<BarcodePrintHomepage> createState() => _BarcodePrintHomepageState();
}

class _BarcodePrintHomepageState extends State<BarcodePrintHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const BarcodePrintM(),
        desktopBody: const BarcodePrintD(),
      ),
    );
  }
}
