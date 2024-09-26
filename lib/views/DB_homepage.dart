import 'package:billingsphere/views/DB_responsive/DB_desktop_body.dart';
import 'package:billingsphere/views/DB_responsive/DB_mobile_body.dart';
import 'package:billingsphere/views/responsive_layout.dart';
import 'package:flutter/material.dart';
class DBHomePage extends StatelessWidget {
  const DBHomePage({super.key});
  static const String routeName = "desktop";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const DBMyMobileBody(),
        desktopBody: const DBMyDesktopBody(),
      ),
    );
  }
}
