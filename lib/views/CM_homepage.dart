import 'package:flutter/material.dart';

import 'CM_responsive/CM_desktop_body.dart';
import 'CM_responsive/CM_mobile_body.dart';
import 'responsive_layout.dart';

class CMHomepage extends StatefulWidget {
  const CMHomepage({super.key});

  @override
  State<CMHomepage> createState() => _CMHomepageState();
}

class _CMHomepageState extends State<CMHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const CMMobileBody(),
        desktopBody: const CMDesktopBody(),
      ),
    );
  }
}