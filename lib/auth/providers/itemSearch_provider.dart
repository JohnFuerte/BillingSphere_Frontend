import 'dart:async';

import 'package:billingsphere/data/models/item/item_model.dart';
import 'package:billingsphere/data/repository/item_repository.dart';
import 'package:flutter/material.dart';

class ItemSearchProvider with ChangeNotifier {
  List<Item> itemsListInitial = []; // For Intial 100 items Fetch
  List<Item> _itemsListSearch = []; // Search item  results

  bool _isLoading = false;
  ItemsService itemsService = ItemsService();
  Timer? _debounce;

  // Getter for loading state
  bool get isLoading => _isLoading;

  // Setter for loading state
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Getter for search items list
  List<Item> get itemsListSearch => _itemsListSearch;

  // Setter for search items list with notifyListeners()
  set itemsListSearch(List<Item> items) {
    _itemsListSearch = items;
    notifyListeners();
  }

  // Add items to the list (merging both lists)
  void addItems(List<Item> items) {
    for (var item in items) {
      if (!itemsListInitial.any((existingItem) => existingItem.id == item.id)) {
        itemsListInitial.add(item);
      }
    }

    notifyListeners();
  }

  // Method for searching items
  Future<void> fetchItemsWithSearch([String searchQuery = ""]) async {
    print(".........................................................");
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Debounce the search query
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      isLoading = true;

      try {
        // Use the search query or default to an empty string
        final List<Item> items = await itemsService.searchItems(query: searchQuery);
        print("API returned ${items.length} items for query: $searchQuery");

        itemsListSearch = items;
        addItems(items);
      } catch (error) {
        print('Failed to fetch items for search: $error');
      } finally {
        isLoading = false;
      }
    });
  }

  // Search match function for dropdown
  bool matchSearch(DropdownMenuItem<String> item, String searchValue) {
    final matchingItem = itemsListSearch.firstWhere(
      (element) => element.id == item.value,
      orElse: () => Item(
        openingBalanceQty: 0,
        openingBalanceAmt: 0,
        openingBalance: [],
        id: "-1",
        itemGroup: "No Entry",
        itemBrand: "No Entry",
        itemName: "No Entry",
        printName: "No Entry",
        codeNo: "No Entry",
        barcode: "No Entry",
        taxCategory: "No Entry",
        hsnCode: "No Entry",
        storeLocation: "No Entry",
        measurementUnit: "No Entry",
        secondaryUnit: "No Entry",
        minimumStock: 0,
        maximumStock: 0,
        monthlySalesQty: 0,
        date: "No Entry",
        dealer: 0,
        subDealer: 0,
        retail: 0,
        mrp: 0,
        openingStock: "No Entry",
        status: "No Entry",
        price: 0,
      ),
    );

    // Perform search by matching each word in searchValue with itemName
    final searchWords = searchValue.toLowerCase().split(' ');
    final itemName = matchingItem.itemName.toLowerCase();
    return searchWords.every((word) => itemName.contains(word));
  }
}
