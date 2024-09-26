import 'package:billingsphere/views/PEresponsive/PE_desktop_body.dart';
import 'package:billingsphere/views/PEresponsive/PE_mobile_body.dart';
import 'package:billingsphere/views/responsive_layout.dart';
import 'package:flutter/material.dart';

class PEHomePage extends StatefulWidget {
  const PEHomePage({super.key});

  @override
  State<PEHomePage> createState() => _PEHomePageState();
}

class _PEHomePageState extends State<PEHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const PEMyMobileBody(),
        desktopBody: const PEMyDesktopBody(),
      ),
    );
  }
}
