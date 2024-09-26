import 'package:flutter/material.dart';

class TaxRateFormController {
  final TextEditingController rateController = TextEditingController();
  final TextEditingController taxtypeController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController igstController = TextEditingController();
  final TextEditingController sgstController = TextEditingController();
  final TextEditingController cgstController = TextEditingController();
  final TextEditingController cessController = TextEditingController();
  final TextEditingController cess2Controller = TextEditingController();
  final TextEditingController addcessController = TextEditingController();
  final TextEditingController taxmrpController = TextEditingController();
  final TextEditingController exemptedController = TextEditingController();

  void dispose() {
    rateController.dispose();
    taxtypeController.dispose();
    statusController.dispose();
    igstController.dispose();
    sgstController.dispose();
    cgstController.dispose();
    cessController.dispose();
    cess2Controller.dispose();
    addcessController.dispose();
    taxmrpController.dispose();
    exemptedController.dispose();
  }
}
