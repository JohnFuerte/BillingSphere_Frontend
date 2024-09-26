import 'package:flutter/material.dart';

class OnChangeItenProvider extends ChangeNotifier {
  String _itemID = "";

  String get itemID => _itemID;

  void updateItemID(String id) {
    _itemID = id;

    notifyListeners();

    print(_itemID);
  }

  // Clear
  void clear() {
    _itemID = '';

    notifyListeners();
    print("Provider state cleared");
  }

  @override
  void dispose() {
    clear();
    super.dispose();
  }
}
