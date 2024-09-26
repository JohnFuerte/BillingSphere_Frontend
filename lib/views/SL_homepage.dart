import 'package:billingsphere/views/SL_responsive/SL_desktop_body.dart';
import 'package:billingsphere/views/SL_responsive/SL_mobile_body.dart';
import 'package:billingsphere/views/responsive_layout.dart';
import 'package:flutter/material.dart';

class SLHomePage extends StatefulWidget {
  const SLHomePage({super.key});

  @override
  State<SLHomePage> createState() => _SLHomePageState();
}

class _SLHomePageState extends State<SLHomePage> {
  @override
  Widget build(BuildContext context) {
    // final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const SLMyMobileBody(),
        desktopBody: const SLMyDesktopBody(),
      ),
    );
  }
}
