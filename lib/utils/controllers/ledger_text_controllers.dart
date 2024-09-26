import 'package:flutter/material.dart';

class LedgerFormController {
  TextEditingController userIDController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController printNameController = TextEditingController();
  TextEditingController aliasNameController = TextEditingController();
  TextEditingController ledgerGroupController = TextEditingController();
  TextEditingController bilwiseAccountingController = TextEditingController();
  TextEditingController creditDaysController = TextEditingController();
  TextEditingController openingBalanceController = TextEditingController();
  TextEditingController debitBalanceController = TextEditingController();
  TextEditingController creditLimitController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController ledgerCodeController = TextEditingController();
  TextEditingController mailingNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController faxController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactPersonController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  TextEditingController accNameController = TextEditingController();
  TextEditingController accNoController = TextEditingController();
  TextEditingController panNoController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController gstDatedController = TextEditingController();
  TextEditingController cstNoController = TextEditingController();
  TextEditingController cstNoDatedController = TextEditingController();
  TextEditingController lstNoController = TextEditingController();
  TextEditingController lstNoDatedController = TextEditingController();
  TextEditingController registrationTypeController = TextEditingController();
  TextEditingController registrationTypeDatedController =
      TextEditingController();
  TextEditingController serviceTypeController = TextEditingController();
  TextEditingController serviceTypeDatedController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController smscontroller = TextEditingController();

  // Function to dispose controllers
  void dispose() {
    userIDController.dispose();
    nameController.dispose();
    printNameController.dispose();
    aliasNameController.dispose();
    ledgerGroupController.dispose();
    bilwiseAccountingController.dispose();
    creditDaysController.dispose();
    openingBalanceController.dispose();
    debitBalanceController.dispose();
    creditLimitController.dispose();
    remarksController.dispose();
    statusController.dispose();
    ledgerCodeController.dispose();
    mailingNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    regionController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    telController.dispose();
    faxController.dispose();
    emailController.dispose();
    contactPersonController.dispose();
    bankNameController.dispose();
    branchNameController.dispose();
    ifscCodeController.dispose();
    accNameController.dispose();
    accNoController.dispose();
    panNoController.dispose();
    gstController.dispose();
    cstNoController.dispose();
    lstNoController.dispose();
  }
}
