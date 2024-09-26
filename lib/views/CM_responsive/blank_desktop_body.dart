import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/material.dart';

class BlankScreen extends StatefulWidget {
  const BlankScreen({super.key});

  @override
  State<BlankScreen> createState() => _BlankScreenState();
}

class _BlankScreenState extends State<BlankScreen> {


  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 1), () {
      // Reload the browser window
      html.window.location.reload();
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}