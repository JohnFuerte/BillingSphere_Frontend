import 'package:flutter/material.dart';

class StoreLocationFormController {
  final TextEditingController locationUnitController = TextEditingController();

  void dispose() {
    locationUnitController.dispose();
  }
}
