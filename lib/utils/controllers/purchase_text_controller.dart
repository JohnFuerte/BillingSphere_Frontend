import 'package:flutter/material.dart';

class PurchaseFormController {
  final TextEditingController noController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController date2Controller = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController partyController = TextEditingController();
  final TextEditingController ledgerController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController billNumberController = TextEditingController();
  final TextEditingController? remarksController = TextEditingController();
  final TextEditingController sellingPriceController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController sgstController = TextEditingController();
  final TextEditingController cgstController = TextEditingController();
  final TextEditingController igstController = TextEditingController();
  final TextEditingController netAmountController = TextEditingController();
  final TextEditingController sundryNameController = TextEditingController();
  final TextEditingController sundryAmountController = TextEditingController();
  final TextEditingController cashAmountController = TextEditingController();
  final TextEditingController dueAmountController = TextEditingController();

  void dispose() {
    noController.dispose();
    dateController.dispose();
    date2Controller.dispose();
    typeController.dispose();
    partyController.dispose();
    ledgerController.dispose();
    placeController.dispose();
    billNumberController.dispose();
    remarksController!.dispose();
    itemNameController.dispose();
    qtyController.dispose();
    rateController.dispose();
    unitController.dispose();
    amountController.dispose();
    taxController.dispose();
    discountController.dispose();
    sgstController.dispose();
    cgstController.dispose();
    igstController.dispose();
    netAmountController.dispose();
    sundryNameController.dispose();
    sundryAmountController.dispose();
    sellingPriceController.dispose();
    cashAmountController.dispose();
    dueAmountController.dispose();
  }
}
