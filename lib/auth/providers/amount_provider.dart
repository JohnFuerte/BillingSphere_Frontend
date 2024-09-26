import 'package:flutter/material.dart';

class AmountProvider extends ChangeNotifier {
  double _amount = 0;

  double get amount => _amount;

  void updateAmount(double newAmount) {
    _amount = newAmount;
    notifyListeners();
  }

  // void resetAmount() {
  //   _amount = 0;
  //   notifyListeners();
  // }
}


