import 'package:flutter/material.dart';

import 'NU_responsive/NU_desktop_body.dart';
import 'NU_responsive/NU_mobile_body.dart';
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
        mobileBody: const NUMobileBody(),
        desktopBody: const NUDesktopBody(),
      ),
    );
  }
}


