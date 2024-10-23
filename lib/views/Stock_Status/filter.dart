class FilterCriteria {
  String? stockGrouping;
  String? valuation;
  String? group;
  String? brand;
  String? itemName;
  String? rack;
  String? taxCategory;
  bool showIndividualItemStock = false;
  bool includeZeroValueItem = false;
  bool showReorderLevelOnly = false;
  bool showItemWithNegativeQty = false;
  bool displayPrintNameOfItem = false;
  bool showItemWithCQtyOnly = false;
  bool showRateWithTax = false;
  bool showCodeNo = false;
  bool showRateValuation = false;

  FilterCriteria({
    this.stockGrouping,
    this.valuation,
    this.group,
    this.brand,
    this.itemName,
    this.rack,
    this.taxCategory,
  });
}

class DropDownValue {
  static const List<String> stockGrouping = [
    "Brand_Wise",
    "HSN_Code",
    "Item_Group",
    "Item_Type_Wise",
    "No_Grouping",
    "Rack/Bin",
    "Tax_Category",
  ];
}
