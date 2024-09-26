import 'package:billingsphere/views/BP_responsive/BP_desktop.dart';
import 'package:billingsphere/views/BP_responsive/BP_mobile_body.dart';
import 'package:billingsphere/views/BP_responsive/BP_responsive_layout.dart';
import 'package:flutter/material.dart';

class BPHomePage extends StatefulWidget {
  const BPHomePage({super.key});

  @override
  State<BPHomePage> createState() => _BPHomePageState();
}

class _BPHomePageState extends State<BPHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BPResponsiveLayourt(
        mobileBody: BPMyMobileBody(),
        desktopApp: BPMyDesktopBody(),
      ),
    );
  }
}
