import 'package:billingsphere/views/BP_responsive/BP_dimesnsions.dart';
import 'package:flutter/material.dart';

class BPResponsiveLayourt extends StatelessWidget {
  final Widget mobileBody;
  final Widget desktopApp;
  const BPResponsiveLayourt(
      {super.key, required this.mobileBody, required this.desktopApp});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        if (constrains.maxWidth < BPmobileWidth) {
          return mobileBody;
        } else {
          return desktopApp;
        }
      },
    );
  }
}
