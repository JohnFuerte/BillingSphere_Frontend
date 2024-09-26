import 'package:flutter/material.dart';

class UnitFormController {
  final TextEditingController secondaryUnitController = TextEditingController();

  void dispose() {
    secondaryUnitController.dispose();
  }
}
