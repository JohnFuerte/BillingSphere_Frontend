import 'package:flutter/material.dart';

import '../../data/models/item/item_model.dart';
import '../../data/repository/item_repository.dart';

class CategoryItemProvider extends ChangeNotifier {
  List<Item> itemsList = [];
  int currentPage = 1;
  bool isLoading = false;
  final int limit = 20;

  Future<void> fetchItems({
    required String store,
    required ItemsService itemsService,
    String? categoryId,
    String? selectedFillter,
  }) async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    print(
        "Fetching items for category: $categoryId with filter: $selectedFillter");
    print("Current page: $currentPage");

    try {
      final List<Item> newItems = await itemsService.fetchItemsWithPagination(
        currentPage,
      );

      // Apply filtering based on selected filter criteria
      if (selectedFillter != null) {
        if (selectedFillter == "Brand_Wise") {
          newItems.removeWhere((element) =>
              element.companyCode != store || element.itemBrand != categoryId);
        } else if (selectedFillter == "Item_Group") {
          newItems.removeWhere((element) =>
              element.companyCode != store || element.itemGroup != categoryId);
        }
      } else {
        newItems.removeWhere((element) =>
            element.companyCode != store || element.itemGroup != categoryId);
      }
      if (newItems.isNotEmpty) {
        itemsList.addAll(newItems);
        currentPage++;
        print('Fetched ${newItems.length} items from page $currentPage');
      } else {
        print('No more data for category. No items returned.');
      }
    } catch (error) {
      print('Final Error. $error.........');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
