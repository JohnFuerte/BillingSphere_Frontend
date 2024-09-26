import 'package:flutter/material.dart';

class OnChangeLedgerProvider extends ChangeNotifier {
  String _ledger = "";

  String get ledger => _ledger;

  void setLedger(String id) {
    _ledger = id;

    notifyListeners();

    print(_ledger);
  }

  // Clear
  void clear() {
    _ledger = '';

    notifyListeners();
  }

  @override
  void dispose() {
    clear();
    super.dispose();
  }
}
