import 'package:billingsphere/views/RA_responsive/RA_desktop_body.dart';
import 'package:billingsphere/views/RA_responsive/RA_mobile_body.dart';
import 'package:billingsphere/views/responsive_layout.dart';
import 'package:flutter/material.dart';

class RAhomepage extends StatefulWidget {
  const RAhomepage({super.key});

  @override
  State<RAhomepage> createState() => _RAhomepageState();
}

class _RAhomepageState extends State<RAhomepage> {
  @override
  Widget build(BuildContext context) {
    // final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: RAMyMobileBody(
          selectedOption: null,
        ),
        desktopBody: RAMyDesktopBody(),
      ),
    );
  }
}
