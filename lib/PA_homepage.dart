import 'package:flutter/material.dart';

import 'PA_responsive/PA_desktop_body.dart';
import 'PA_responsive/PA_mobile_body.dart';
import 'views/responsive_layout.dart';

class PAHomepage extends StatefulWidget {
  const PAHomepage({super.key});

  @override
  State<PAHomepage> createState() => _PAHomepageState();
}

class _PAHomepageState extends State<PAHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const PAMobileBody(),
        desktopBody: PADesktopBody(),
      ),
    );
  }
}
