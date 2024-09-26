import 'package:flutter/material.dart';

class SundryFormController {
  final TextEditingController sundryController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  void dispose() {
    sundryController.dispose();
    amountController.dispose();
  }
}
