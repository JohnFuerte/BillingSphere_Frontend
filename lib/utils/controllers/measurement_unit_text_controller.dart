import 'package:flutter/material.dart';

class MeaseurementUnitFormController {
  final TextEditingController measurementUnitController =
      TextEditingController();

  void dispose() {
    measurementUnitController.dispose();
  }
}
