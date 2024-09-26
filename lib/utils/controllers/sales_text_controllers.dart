import 'package:flutter/material.dart';

class SalesEntryFormController {
  TextEditingController noController = TextEditingController();
  TextEditingController dateController1 = TextEditingController();
  TextEditingController dateController2 = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController partyController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController dcNoController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController roundOffController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController sgstController = TextEditingController();
  TextEditingController cgstController = TextEditingController();
  TextEditingController igstController = TextEditingController();
  TextEditingController netAmountController = TextEditingController();
  TextEditingController? remarkController = TextEditingController();
  TextEditingController cashAmountController = TextEditingController();
  TextEditingController dueAmountController = TextEditingController();

  get selectedValue => null;

  void dispose() {
    noController.dispose();
    dateController1.dispose();
    dateController2.dispose();
    typeController.dispose();
    partyController.dispose();
    placeController.dispose();
    dcNoController.dispose();
    itemNameController.dispose();
    qtyController.dispose();
    rateController.dispose();
    unitController.dispose();
    roundOffController.dispose();
    amountController.dispose();
    taxController.dispose();
    discountController.dispose();
    sgstController.dispose();
    cgstController.dispose();
    igstController.dispose();
    netAmountController.dispose();
    remarkController?.dispose();
    cashAmountController.dispose();
    dueAmountController.dispose();
  }
}
