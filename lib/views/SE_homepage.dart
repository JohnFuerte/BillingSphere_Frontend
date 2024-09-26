import 'package:billingsphere/views/SE_responsive/SE_desktop_body.dart';
import 'package:billingsphere/views/SE_responsive/SE_mobile_body.dart';
import 'package:billingsphere/views/responsive_layout.dart';
import 'package:flutter/material.dart';

class SEHomePage extends StatefulWidget {
  const SEHomePage({super.key});

  @override
  State<SEHomePage> createState() => _SEHomePageState();
}

class _SEHomePageState extends State<SEHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const SEMyMobileBody(),
        desktopBody: const SEMyDesktopBody(),
      ),
    );
  }
}
