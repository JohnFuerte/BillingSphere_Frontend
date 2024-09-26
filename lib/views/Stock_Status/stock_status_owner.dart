// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/item/item_model.dart';
import '../../data/models/itemGroup/item_group_model.dart';
import '../../data/models/measurementLimit/measurement_limit_model.dart';
import '../../data/repository/item_group_repository.dart';
import '../../data/repository/item_repository.dart';
import '../../data/repository/measurement_limit_repository.dart';
import 'stock_status_monthly.dart';

class StockStatusOwner extends StatefulWidget {
  final String store;
  final String selectedCompany;
  const StockStatusOwner({
    super.key,
    required this.store,
    required this.selectedCompany,
  });

  @override
  State<StockStatusOwner> createState() => _StockStatusOwnerState();
}

class _StockStatusOwnerState extends State<StockStatusOwner> {
  List<Item> itemsList = [];
  String? selectedItemId;
  ItemsService itemsService = ItemsService();
  ItemsGroupService itemsGroupService = ItemsGroupService();
  MeasurementLimitService measurementLimitService = MeasurementLimitService();
  // List<String>? company = [];
  // items.removeWhere((element) => element.companyCode != widget.store);

  Future<void> fetchItems() async {
    setState(() {
      isLoading = true;
    });

    try {
      final List<Item> items = await itemsService.fetchITEMS();

      items.removeWhere((element) => element.companyCode != widget.store);

      for (var i = 0; i < items.length; i++) {
        // print(items[i].companyCode);
      }

      setState(() {
        itemsList = items;
        selectedItemId = itemsList.isNotEmpty ? itemsList.first.id : 'Select';
      });
      isLoading = false;

      // print(itemsList);
    } catch (error) {
      print('Error: $error');
    }
  }

  Map<String, List<Item>> groupItemsByCategory() {
    Map<String, List<Item>> groupedItems = {};
    for (Item item in itemsList) {
      if (!groupedItems.containsKey(item.itemGroup)) {
        groupedItems[item.itemGroup] = [];
      }
      groupedItems[item.itemGroup]!.add(item);
    }
    return groupedItems;
  }

  double calculateTotalPrice(List<Item> items) {
    double totalPrice = 0;
    for (Item item in items) {
      totalPrice += item.maximumStock * item.price!;
    }
    return totalPrice;
  }

  Future<Map<String, String>> fetchItemGroupNames(
      List<String> itemGroupIds) async {
    Map<String, String> itemGroupNames = {};
    for (String id in itemGroupIds) {
      ItemsGroup? itemGroup = await itemsGroupService.fetchItemGroupById(id);
      if (itemGroup != null) {
        itemGroupNames[id] = itemGroup.name;
      }
    }
    return itemGroupNames;
  }

  Future<Map<String, String>> fetchMeasurementUnit(
      List<String> measurementUnit) async {
    Map<String, String> itemMeasurementUnit = {};
    for (String id in measurementUnit) {
      MeasurementLimit? measurement =
          await measurementLimitService.fetchMeasurementById(id);
      if (measurement != null) {
        itemMeasurementUnit[id] = measurement.measurement;
      }
    }
    return itemMeasurementUnit;
  }

  bool isLoading = false;

  void _initializeData() async {
    await fetchItems();
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stock Status',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 33, 65, 243),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 33, 65, 243),
                ),
              ),
            )
          : itemsList.isEmpty
              ? const Center(
                  child: Text('No Item'),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Stock Status (Item Group Wise)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    FutureBuilder<Map<String, String>>(
                      future: fetchItemGroupNames(
                        groupItemsByCategory().keys.toList(),
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Text(''),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData) {
                          return const Text('No Item Available');
                        } else {
                          Map<String, String> itemGroupNames =
                              snapshot.data ?? {};
                          return Expanded(
                            child: ListView(
                              children: groupItemsByCategory().entries.map(
                                (entry) {
                                  String categoryId = entry.key;
                                  String categoryName =
                                      itemGroupNames[categoryId] ??
                                          'Unknown Category';
                                  List<Item> items = entry.value;
                                  double totalCategoryPrice =
                                      calculateTotalPrice(items);
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              categoryName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              NumberFormat('#,##0.00')
                                                  .format(totalCategoryPrice),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      itemsList.isEmpty
                                          ? const Center(
                                              child: Text('No Item Available'),
                                            )
                                          : SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.grey[200],
                                                ),
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: ListView.builder(
                                                  itemCount: items.length +
                                                      1, // Add 1 for the header row
                                                  itemBuilder:
                                                      (context, index) {
                                                    if (index == 0) {
                                                      // Header row
                                                      return Container(
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 33, 65, 243),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(0),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8),
                                                        child: const Row(
                                                          children: [
                                                            Expanded(
                                                              child: Center(
                                                                child: Text(
                                                                  'Particulars',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Center(
                                                                child: Text(
                                                                  'Min.Qty',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Center(
                                                                child: Text(
                                                                  'Stock',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Center(
                                                                child: Text(
                                                                  'Unit',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Center(
                                                                child: Text(
                                                                  'Qty',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Center(
                                                                child: Text(
                                                                  'Rate',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Center(
                                                                child: Text(
                                                                  'Sub Total',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    } else {
                                                      final item =
                                                          items[index - 1];
                                                      bool isSelected = false;

                                                      return InkWell(
                                                        onTap: () {
                                                          // Handle item tap here
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      OtherScreen(
                                                                itemId: item.id,
                                                                itemName: item
                                                                    .itemName,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: index % 2 ==
                                                                    0
                                                                ? Colors.white
                                                                : Colors.blue
                                                                    .shade100,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        0),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 8),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                  child: Center(
                                                                      child: Text(
                                                                          item.itemName))), // Particulars
                                                              Expanded(
                                                                  child: Center(
                                                                      child: Text(item
                                                                          .minimumStock
                                                                          .toString()))), // Min.Qty

                                                              // If company code contains 10405 then show stock else don't show
                                                              Expanded(
                                                                child: Center(
                                                                  child: Text(item
                                                                          .maximumStock
                                                                          .toString() ??
                                                                      '0'), // Stock
                                                                ),
                                                              ),

                                                              // Stock
                                                              Expanded(
                                                                child: Center(
                                                                  child: FutureBuilder<
                                                                      Map<String,
                                                                          String>>(
                                                                    future:
                                                                        fetchMeasurementUnit([
                                                                      item.measurementUnit
                                                                    ]),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      if (snapshot
                                                                              .connectionState ==
                                                                          ConnectionState
                                                                              .waiting) {
                                                                        return const Text(
                                                                            '');
                                                                      } else if (snapshot
                                                                          .hasError) {
                                                                        return Text(
                                                                            'Error: ${snapshot.error}');
                                                                      } else {
                                                                        final measurementUnitNames =
                                                                            snapshot.data ??
                                                                                {};
                                                                        final unitName =
                                                                            measurementUnitNames[item.measurementUnit] ??
                                                                                'Unknown Unit';
                                                                        return Text(
                                                                            unitName); // Unit
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                              ),

                                                              const Expanded(
                                                                child: Center(
                                                                  child: Text(
                                                                      ''), // Stock
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Center(
                                                                  child: Text(item
                                                                          .mrp
                                                                          .toString() ??
                                                                      '0'), // Stock
                                                                ),
                                                              ),

                                                              // Rate
                                                              Expanded(
                                                                child: Center(
                                                                  child: Text((item
                                                                              .maximumStock *
                                                                          item.price!)
                                                                      .toString()), // Sub Total
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                    ],
                                  );
                                },
                              ).toList(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
    );
  }
}
