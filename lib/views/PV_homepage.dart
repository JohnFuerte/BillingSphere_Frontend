import 'package:billingsphere/views/PV_responsive/PV_desktop_body.dart';
import 'package:billingsphere/views/PV_responsive/PV_mobile_body.dart';
import 'package:billingsphere/views/responsive_layout.dart';
import 'package:flutter/material.dart';

class PVHomePage extends StatefulWidget {
  const PVHomePage({super.key});

  @override
  State<PVHomePage> createState() => _PVHomePageState();
}

class _PVHomePageState extends State<PVHomePage> {
  @override
  Widget build(BuildContext context) {
    // final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const PVMyMobileBody(),
        desktopBody: const PVMyDesktopBody(),
      ),
    );
  }
}
