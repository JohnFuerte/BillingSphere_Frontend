import 'package:billingsphere/views/RV_responsive/RV_desktopBody.dart';
import 'package:billingsphere/views/RV_responsive/RV_mobileBody.dart';
import 'package:billingsphere/views/responsive_layout.dart';
import 'package:flutter/material.dart';

class RVHomePage extends StatefulWidget {
  const RVHomePage({super.key});

  @override
  State<RVHomePage> createState() => _RVHomePageState();
}

class _RVHomePageState extends State<RVHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const RVMobileBody(),
        desktopBody: const RVDesktopBody(),
      ),
    );
  }
}
