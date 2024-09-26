import 'package:flutter/material.dart';

class HsnFormController {
  final TextEditingController hsnController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void dispose() {
    hsnController.dispose();
    unitController.dispose();
    descriptionController.dispose();
  }
}
