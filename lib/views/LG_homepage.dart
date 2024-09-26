import 'package:billingsphere/views/LG_responsive/LG_desktop_body.dart';
import 'package:billingsphere/views/LG_responsive/LG_mobile_body.dart';
import 'package:billingsphere/views/responsive_layout.dart';
import 'package:flutter/material.dart';

class LGHomePage extends StatefulWidget {
  const LGHomePage({super.key});

  @override
  State<LGHomePage> createState() => _LGHomePageState();
}

class _LGHomePageState extends State<LGHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const LGMyMobileBody(),
        desktopBody: const LGMyDesktopBody(),
      ),
    );
  }
}
