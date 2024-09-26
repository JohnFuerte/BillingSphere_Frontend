import 'package:flutter/material.dart';


import 'DC_responsive/DC_desktop_body.dart';
import 'DC_responsive/DC_mobile_body.dart';
import 'responsive_layout.dart';

class DCHomepage extends StatefulWidget {
  const DCHomepage({super.key});

  @override
  State<DCHomepage> createState() => _DCHomepageState();
}

class _DCHomepageState extends State<DCHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const DCMobileBody(),
        desktopBody: const DCDesktopBody(),
      ),
    );
  }
}
