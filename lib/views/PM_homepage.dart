import 'package:billingsphere/views/PM_responsive/payment_desktop.dart';
import 'package:billingsphere/views/PM_responsive/payment_mobile.dart';
import 'package:billingsphere/views/responsive_layout.dart';
import 'package:flutter/material.dart';

class PMHomePage extends StatefulWidget {
  const PMHomePage({super.key});

  @override
  State<PMHomePage> createState() => _PMHomePageState();
}

class _PMHomePageState extends State<PMHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const PMMyPaymentMobileBody(),
        desktopBody: const PMMyPaymentDesktopBody(),
      ),
    );
  }
}
