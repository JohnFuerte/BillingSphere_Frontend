import 'package:flutter/material.dart';

import 'IC_responsive/IC_desktop_body.dart';
import 'IC_responsive/IC_mobile_body.dart';
import 'responsive_layout.dart';

class ICHomepage extends StatefulWidget {
  const ICHomepage({super.key});

  @override
  State<ICHomepage> createState() => _ICHomepageState();
}

class _ICHomepageState extends State<ICHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const ICMobileBody(),
        desktopBody: const ICDesktopBody(),
      ),
    );
  }
}
