
import 'package:billingsphere/views/NI_responsive.dart/NI_desktopBody.dart';
import 'package:billingsphere/views/NI_responsive.dart/NI_mobileBody.dart';
import 'package:billingsphere/views/responsive_layout.dart';
import 'package:flutter/material.dart';


class NIHomePage extends StatelessWidget {
  const NIHomePage({super.key});
  static const String routeName = "desktop";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const NIMyMobileBody(),
        desktopBody: const NIMyDesktopBody(),
      ),
    );
  }
}
