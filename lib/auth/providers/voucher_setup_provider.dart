import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class VoucherSetupProvider extends ChangeNotifier {
  late SharedPreferences _prefs;

  VoucherSetupProvider() {
    _init();
  }

  void _init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadSettings();
  }

  final Map<String, dynamic> _settings = {
    "name": "",
    "printName": "",
    "shortName": "",
    "isActive": "",
    "numbering": "",
    "startFrom": "",
    "verifyPayment": "",
    "resetOn": "",
    "paddding": 1,
    "askVoucher": "",
    "remarks": "",
    "defaultPayment": "",
    "showedSavedNo": "",
    "tileColor": "",
    "printTemplate": "",
    "altPrintTemplate": "",
    "printAfterSave": "",
    "noOfCopies": "",
    "askTemplate": "",
    "showPrintPrompt": "",
    "showPreview": "",
    "printBothTemplate": "",
    "termsAndConditions": "",
    "showBankDetails": "",
    "printPrefix": "",
    "discount": "",
    "discount2": "",
    "taxVoucher": "",
    "rateIncludeTax": "",
    "displayTaxAmt": "",
    "transportDetails": "",
    "promptAfterSave": "",
    "itemGrouping": "",
    "mrpColumn": "",
    "itemCodeColumn": "",
    "batchColumn": "",
    "freeQtyColumn": "",
    "2ndQtyColumn": "",
    "baseRateColumn": "",
    "captureImage": "",
    "captureSignature": "",
    "autoRoundOff": "",
    "clubSameType": "",
    "sundryTaxInfo": "",
    "netRateColumn": "",
    "paymentOnSave": "",
    "customLedgerGroup": "",
    "skipBatchSelection": "",
    "sundryDiscInfo": "",
    "stockColumn": "",
    "cashDenomination": "",
    "customItemGroup": "",
    "retailCustInput": "",
    "unitSelection": "",
    "sundryVisible": "",
    "refRequired1": "",
    "refRequired2": "",
    "refNoCaption1": "",
    "refNoCaption2": "",
    "rateDeciAuto": "",
    "autoProduction": "",
    "ignoreSplitBiils": "",
    "postingAC": "",
    "confirmOnSave": "",
  };

  // Getters
  String get name => _settings["name"];
  String get printName => _settings["printName"];
  String get shortName => _settings["shortName"];
  String get isActive => _settings["isActive"];
  String get numbering => _settings["numbering"];
  String get startFrom => _settings["startFrom"];
  String get verifyPayment => _settings["verifyPayment"];
  String get resetOn => _settings["resetOn"];
  int get paddding => _settings["paddding"];
  String get askVoucher => _settings["askVoucher"];
  String get remarks => _settings["remarks"];
  String get defaultPayment => _settings["defaultPayment"];
  String get showedSavedNo => _settings["showedSavedNo"];
  String get tileColor => _settings["tileColor"];
  String get printTemplate => _settings["printTemplate"];
  String get altPrintTemplate => _settings["altPrintTemplate"];
  String get printAfterSave => _settings["printAfterSave"];
  String get noOfCopies => _settings["noOfCopies"];
  String get askTemplate => _settings["askTemplate"];
  String get showPrintPrompt => _settings["showPrintPrompt"];
  String get showPreview => _settings["showPreview"];
  String get printBothTemplate => _settings["printBothTemplate"];
  String get termsAndConditions => _settings["termsAndConditions"];
  String get showBankDetails => _settings["showBankDetails"];
  String get printPrefix => _settings["printPrefix"];
  String get discount => _settings["discount"];
  String get discount2 => _settings["discount2"];
  String get taxVoucher => _settings["taxVoucher"];
  String get rateIncludeTax => _settings["rateIncludeTax"];
  String get displayTaxAmt => _settings["displayTaxAmt"];
  String get transportDetails => _settings["transportDetails"];
  String get promptAfterSave => _settings["promptAfterSave"];
  String get itemGrouping => _settings["itemGrouping"];
  String get mrpColumn => _settings["mrpColumn"];
  String get itemCodeColumn => _settings["itemCodeColumn"];
  String get batchColumn => _settings["batchColumn"];
  String get freeQtyColumn => _settings["freeQtyColumn"];
  String get tndQtyColumn => _settings["2ndQtyColumn"];
  String get baseRateColumn => _settings["baseRateColumn"];
  String get captureImage => _settings["captureImage"];
  String get captureSignature => _settings["captureSignature"];
  String get autoRoundOff => _settings["autoRoundOff"];
  String get clubSameType => _settings["clubSameType"];
  String get sundryTaxInfo => _settings["sundryTaxInfo"];
  String get netRateColumn => _settings["netRateColumn"];
  String get paymentOnSave => _settings["paymentOnSave"];
  String get customLedgerGroup => _settings["customLedgerGroup"];
  String get skipBatchSelection => _settings["skipBatchSelection"];
  String get sundryDiscInfo => _settings["sundryDiscInfo"];
  String get stockColumn => _settings["stockColumn"];
  String get cashDenomination => _settings["cashDenomination"];
  String get customItemGroup => _settings["customItemGroup"];
  String get retailCustInput => _settings["retailCustInput"];
  String get unitSelection => _settings["unitSelection"];
  String get sundryVisible => _settings["sundryVisible"];
  String get refRequired1 => _settings["refRequired1"];
  String get refRequired2 => _settings["refRequired2"];
  String get refNoCaption1 => _settings["refNoCaption1"];
  String get refNoCaption2 => _settings["refNoCaption2"];
  String get rateDeciAuto => _settings["rateDeciAuto"];
  String get autoProduction => _settings["autoProduction"];
  String get ignoreSplitBiils => _settings["ignoreSplitBiils"];
  String get postingAC => _settings["postingAC"];
  String get confirmOnSave => _settings["confirmOnSave"];

  // Function to set the settings at once
  void setSettings(Map<String, dynamic> settings) {
    _settings.addAll(settings);
    _saveSettings();
    notifyListeners();
  }

  // Save settings to SharedPreferences as a JSON string
  void _saveSettings() {
    _prefs.setString("voucher_setup", jsonEncode(_settings));
  }

  // Load settings from SharedPreferences
  void _loadSettings() {
    final String? settingsString = _prefs.getString("voucher_setup");
    if (settingsString != null) {
      _settings.addAll(jsonDecode(settingsString));
    }
  }
}
