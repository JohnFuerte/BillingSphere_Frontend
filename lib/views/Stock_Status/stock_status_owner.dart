import 'package:billingsphere/auth/providers/category_provider.dart';
import 'package:billingsphere/data/models/brand/item_brand_model.dart';
import 'package:billingsphere/data/repository/item_brand_repository.dart';
import 'package:billingsphere/utils/constant.dart';
import 'package:billingsphere/views/Stock_Status/filter.dart';
import 'package:billingsphere/views/Stock_Status/report_status.dart';
import 'package:billingsphere/views/Stock_Status/stock_status_monthly.dart';
import 'package:billingsphere/views/sumit_screen/voucher%20_entry.dart/voucher_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/models/item/item_model.dart';
import '../../data/models/itemGroup/item_group_model.dart';
import '../../data/models/measurementLimit/measurement_limit_model.dart';
import '../../data/repository/item_group_repository.dart';
import '../../data/repository/item_repository.dart';
import '../../data/repository/measurement_limit_repository.dart';

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
  ItemsBrandsService itemsBrandsService = ItemsBrandsService();
  MeasurementLimitService measurementLimitService = MeasurementLimitService();
  ValueNotifier<String> selectedId = ValueNotifier<String>('');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  final Map<String, String> _measurementUnitCache = {};

  String? selctedfillter;
  int currentPage = 1;
  int limit = 20;
  final ScrollController _categoryScrollController = ScrollController();

  Future<void> fetchItems({String? categoryId}) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final List<Item> newItems = await itemsService.fetchItemsWithPagination(
        currentPage,
      );

      if (categoryId != null) {
        newItems.removeWhere((element) =>
            element.companyCode != widget.store ||
            element.itemGroup != categoryId);
      } else {
        newItems.removeWhere((element) => element.companyCode != widget.store);
      }

      selectedItemId = itemsList.isNotEmpty ? itemsList.first.id : 'Select';

      if (newItems.isNotEmpty) {
        itemsList.addAll(newItems);
        currentPage++;
      } else {
        print(
            "No More data found for this Category............................................");
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
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

  Map<String, List<Item>> groupItemsByBrand() {
    Map<String, List<Item>> groupedItemsbrands = {};
    for (Item item in itemsList) {
      if (!groupedItemsbrands.containsKey(item.itemBrand)) {
        groupedItemsbrands[item.itemBrand] = [];
      }
      groupedItemsbrands[item.itemBrand]!.add(item);
    }
    return groupedItemsbrands;
  }

  double calculateTotalPrice(List<Item> items) {
    double totalPrice = 0;
    for (Item item in items) {
      totalPrice += item.maximumStock * item.mrp!;
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

  Future<Map<String, String>> fetchBrandItemGroupNames(
      List<String> itemGroupIds) async {
    Map<String, String> itembrand = {};
    for (String id in itemGroupIds) {
      ItemsBrand? itemsBrand = await itemsBrandsService.fetchItemBrandById(id);
      if (itemsBrand != null) {
        itembrand[id] = itemsBrand.name;
      }
    }
    return itembrand;
  }

  Future<String> getMeasurementUnit(String id) async {
    if (_measurementUnitCache.containsKey(id)) {
      return _measurementUnitCache[id]!;
    } else {
      MeasurementLimit? measurement =
          await measurementLimitService.fetchMeasurementById(id);
      if (measurement != null) {
        _measurementUnitCache[id] = measurement.measurement;
        return measurement.measurement;
      } else {
        return 'Unknown Unit';
      }
    }
  }

  @override
  void initState() {
    super.initState();

    fetchItems();
  }

  Future<Map<String, String>> fetchFuture() {
    if (selctedfillter == "Brand_Wise") {
      return fetchBrandItemGroupNames(groupItemsByBrand().keys.toList());
    } else if (selctedfillter == "Item-Group") {
      return fetchItemGroupNames(groupItemsByCategory().keys.toList());
    } else {
      return fetchItemGroupNames(groupItemsByCategory().keys.toList());
    }
  }

  Future<Map<String, String>> fetchFutureWithDelay() async {
    final data = await fetchFuture();
    await Future.delayed(const Duration(seconds: 2));
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          return _buildMobileWidget();
        } else if (constraints.maxWidth >= 600 && constraints.maxWidth < 1200) {
          return _buildMobileWidget();
        } else {
          return _buildDesktopWidget();
        }
      },
    );
  }

  // For Mobile & Table

  Widget _buildMobileWidget() {
    final List<Map<String, dynamic>> menuItems = [
      {
        'text': 'Report',
        'icon': Icons.report,
        'onTap': () async {
          FilterCriteria? filterCriteria = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReportStatus(),
            ),
          );

          if (filterCriteria != null) {
            setState(() {
              selctedfillter = filterCriteria.stockGrouping;
            });
          }
          Navigator.pop(context);
        }
      },
      {'text': 'Print', 'icon': Icons.print},
      {'text': 'Export Excel', 'icon': Icons.file_download_outlined},
    ];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title:
            const Text("Stock Status", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
            icon: const Icon(
              Icons.menu,
            ),
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      endDrawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        child: ListView(
          children: [
            ...menuItems.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  dense: true,
                  leading: Icon(item['icon'], color: Colors.black54),
                  title: Text(
                    item['text'],
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF6C0082),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: item['onTap'],
                ),
              );
            }),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Text(
              'Stock Status As On 31/03/2025',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 1200,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: HeaderCell(
                                flex: 5,
                                text: "Particulars",
                                fontWeight: FontWeight.bold,
                                bordor: Border.all(),
                                textColor: Colors.purple,
                              ),
                            ),
                            HeaderCell(
                              flex: 2,
                              text: "Min.Qty",
                              fontWeight: FontWeight.bold,
                              textColor: Colors.purple,
                              align: TextAlign.right,
                              bordor: Border.all(),
                            ),
                            HeaderCell(
                              flex: 2,
                              text: "Stock",
                              fontWeight: FontWeight.bold,
                              textColor: Colors.purple,
                              align: TextAlign.right,
                              bordor: Border.all(),
                            ),
                            HeaderCell(
                              flex: 1,
                              text: "Unit",
                              fontWeight: FontWeight.bold,
                              textColor: Colors.purple,
                              align: TextAlign.center,
                              bordor: Border.all(),
                            ),
                            HeaderCell(
                              flex: 1,
                              text: "Qty",
                              fontWeight: FontWeight.bold,
                              textColor: Colors.purple,
                              align: TextAlign.center,
                              bordor: Border.all(),
                            ),
                            HeaderCell(
                              flex: 2,
                              text: "Rate",
                              fontWeight: FontWeight.bold,
                              textColor: Colors.purple,
                              align: TextAlign.right,
                              bordor: Border.all(),
                            ),
                            HeaderCell(
                              flex: 2,
                              text: "SubTotal",
                              fontWeight: FontWeight.bold,
                              textColor: Colors.purple,
                              align: TextAlign.right,
                              bordor: Border.all(),
                            ),
                            HeaderCell(
                              flex: 2,
                              text: "Total",
                              fontWeight: FontWeight.bold,
                              textColor: Colors.purple,
                              align: TextAlign.right,
                              bordor: Border.all(),
                            ),
                          ],
                        ),
                        FutureBuilder<Map<String, String>>(
                          future: fetchFutureWithDelay(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Constants.loadingIndicator;
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text("Error Loading: ${snapshot.error}"),
                              );
                            } else if (snapshot.data!.isEmpty) {
                              return const Expanded(
                                child: Center(
                                  child: Text("No Data Available"),
                                ),
                              );
                            } else {
                              Map<String, String> itemGroupNames =
                                  snapshot.data!;
                              return Expanded(
                                child: SingleChildScrollView(
                                  controller: _categoryScrollController,
                                  child: Column(
                                    children:
                                        itemGroupNames.entries.map((entry) {
                                      String categoryId = entry.key;
                                      String categoryName = entry.value;

                                      return ChangeNotifierProvider<
                                          CategoryItemProvider>.value(
                                        value: CategoryItemProvider()
                                          ..fetchItems(
                                              store: widget.store,
                                              itemsService: itemsService,
                                              categoryId: categoryId,
                                              selectedFillter: selctedfillter),
                                        child: Consumer<CategoryItemProvider>(
                                          builder: (context, categoryProvider,
                                              child) {
                                            if (categoryProvider.isLoading &&
                                                categoryProvider
                                                    .itemsList.isEmpty) {
                                              return const SizedBox();
                                            }

                                            double totalCategoryPrice =
                                                calculateTotalPrice(
                                                    categoryProvider.itemsList);

                                            // Scroll Listener
                                            _categoryScrollController
                                                .addListener(() {
                                              if (_categoryScrollController
                                                          .offset >=
                                                      _categoryScrollController
                                                          .position
                                                          .maxScrollExtent &&
                                                  !_categoryScrollController
                                                      .position.outOfRange &&
                                                  !categoryProvider.isLoading) {
                                                if (categoryProvider
                                                        .currentPage <=
                                                    categoryProvider.limit) {
                                                  categoryProvider.fetchItems(
                                                    store: widget.store,
                                                    itemsService: itemsService,
                                                    categoryId: categoryId,
                                                    selectedFillter:
                                                        selctedfillter,
                                                  );
                                                }
                                              }
                                            });

                                            return Column(
                                              children: [
                                                CategoryCell(
                                                  categoryName: categoryName,
                                                  total: NumberFormat(
                                                          '#,##0.00')
                                                      .format(
                                                          totalCategoryPrice),
                                                ),
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: categoryProvider
                                                      .itemsList.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item =
                                                        categoryProvider
                                                            .itemsList[index];
                                                    return _buildItemRow(
                                                        context,
                                                        item,
                                                        index,
                                                        selectedId, () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  OtherScreen(
                                                                      itemId: item
                                                                          .id,
                                                                      itemName:
                                                                          item.itemName)));
                                                    });
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 800,
                child: Row(
                  children: [
                    HeaderCell(
                      align: TextAlign.left,
                      flex: 5,
                      text: "Total",
                      fontWeight: FontWeight.bold,
                    ),
                    HeaderCell(
                      flex: 2,
                      text: "",
                    ),
                    HeaderCell(
                      flex: 2,
                      text: "209",
                      fontWeight: FontWeight.bold,
                      align: TextAlign.right,
                    ),
                    HeaderCell(
                      flex: 1,
                      text: "",
                    ),
                    HeaderCell(
                      flex: 1,
                      text: "",
                    ),
                    HeaderCell(
                      flex: 2,
                      text: "",
                    ),
                    HeaderCell(
                      flex: 2,
                      text: "",
                    ),
                    HeaderCell(
                      flex: 2,
                      text: "500000",
                      fontWeight: FontWeight.bold,
                      align: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // For Desktop
  Widget _buildDesktopWidget() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Stock Status"),
        backgroundColor: Colors.blue,
      ),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stock Status As On 31/03/2025',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(border: Border.all()),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              HeaderCell(
                                flex: 5,
                                text: "Particulars",
                                fontWeight: FontWeight.bold,
                                bordor: Border.all(),
                                textColor: Colors.purple,
                              ),
                              HeaderCell(
                                flex: 2,
                                text: "Min.Qty",
                                fontWeight: FontWeight.bold,
                                textColor: Colors.purple,
                                align: TextAlign.right,
                                bordor: Border.all(),
                              ),
                              HeaderCell(
                                flex: 2,
                                text: "Stock",
                                fontWeight: FontWeight.bold,
                                textColor: Colors.purple,
                                align: TextAlign.right,
                                bordor: Border.all(),
                              ),
                              HeaderCell(
                                flex: 1,
                                text: "Unit",
                                fontWeight: FontWeight.bold,
                                textColor: Colors.purple,
                                align: TextAlign.center,
                                bordor: Border.all(),
                              ),
                              HeaderCell(
                                flex: 1,
                                text: "Qty",
                                fontWeight: FontWeight.bold,
                                textColor: Colors.purple,
                                align: TextAlign.center,
                                bordor: Border.all(),
                              ),
                              HeaderCell(
                                flex: 2,
                                text: "Rate",
                                fontWeight: FontWeight.bold,
                                textColor: Colors.purple,
                                align: TextAlign.right,
                                bordor: Border.all(),
                              ),
                              HeaderCell(
                                flex: 2,
                                text: "SubTotal",
                                fontWeight: FontWeight.bold,
                                textColor: Colors.purple,
                                align: TextAlign.right,
                                bordor: Border.all(),
                              ),
                              HeaderCell(
                                flex: 2,
                                text: "Total",
                                fontWeight: FontWeight.bold,
                                textColor: Colors.purple,
                                align: TextAlign.right,
                                bordor: Border.all(),
                              ),
                            ],
                          ),
                          FutureBuilder<Map<String, String>>(
                            future: fetchFutureWithDelay(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Expanded(
                                  child: Center(
                                    child: Constants.loadingBar,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child:
                                      Text("Error Loading: ${snapshot.error}"),
                                );
                              } else if (snapshot.data!.isEmpty) {
                                return const Expanded(
                                  child: Center(
                                    child: Text("No Data Available"),
                                  ),
                                );
                              } else {
                                Map<String, String> itemGroupNames =
                                    snapshot.data!;
                                return Expanded(
                                  child: SingleChildScrollView(
                                    controller: _categoryScrollController,
                                    child: Column(
                                      children:
                                          itemGroupNames.entries.map((entry) {
                                        String categoryId = entry.key;
                                        String categoryName = entry.value;

                                        return ChangeNotifierProvider<
                                            CategoryItemProvider>.value(
                                          value: CategoryItemProvider()
                                            ..fetchItems(
                                                store: widget.store,
                                                itemsService: itemsService,
                                                categoryId: categoryId,
                                                selectedFillter:
                                                    selctedfillter),
                                          child: Consumer<CategoryItemProvider>(
                                            builder: (context, categoryProvider,
                                                child) {
                                              if (categoryProvider.isLoading &&
                                                  categoryProvider
                                                      .itemsList.isEmpty) {
                                                return const SizedBox();
                                              }

                                              double totalCategoryPrice =
                                                  calculateTotalPrice(
                                                      categoryProvider
                                                          .itemsList);

                                              // Scroll Listener
                                              _categoryScrollController
                                                  .addListener(() {
                                                if (_categoryScrollController
                                                            .offset >=
                                                        _categoryScrollController
                                                            .position
                                                            .maxScrollExtent &&
                                                    !_categoryScrollController
                                                        .position.outOfRange &&
                                                    !categoryProvider
                                                        .isLoading) {
                                                  if (categoryProvider
                                                          .currentPage <=
                                                      categoryProvider.limit) {
                                                    categoryProvider.fetchItems(
                                                      store: widget.store,
                                                      itemsService:
                                                          itemsService,
                                                      categoryId: categoryId,
                                                      selectedFillter:
                                                          selctedfillter,
                                                    );
                                                  }
                                                }
                                              });

                                              return Column(
                                                children: [
                                                  CategoryCell(
                                                    categoryName: categoryName,
                                                    total: NumberFormat(
                                                            '#,##0.00')
                                                        .format(
                                                            totalCategoryPrice),
                                                  ),
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: categoryProvider
                                                        .itemsList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final item =
                                                          categoryProvider
                                                              .itemsList[index];
                                                      return _buildItemRow(
                                                          context,
                                                          item,
                                                          index,
                                                          selectedId, () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    OtherScreen(
                                                                        itemId: item
                                                                            .id,
                                                                        itemName:
                                                                            item.itemName)));
                                                      });
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  const Row(
                    children: [
                      HeaderCell(
                        align: TextAlign.left,
                        flex: 5,
                        text: "Total",
                        fontWeight: FontWeight.bold,
                      ),
                      HeaderCell(
                        flex: 2,
                        text: "",
                      ),
                      HeaderCell(
                        flex: 2,
                        text: "209",
                        fontWeight: FontWeight.bold,
                        align: TextAlign.right,
                      ),
                      HeaderCell(
                        flex: 1,
                        text: "",
                      ),
                      HeaderCell(
                        flex: 1,
                        text: "",
                      ),
                      HeaderCell(
                        flex: 2,
                        text: "",
                      ),
                      HeaderCell(
                        flex: 2,
                        text: "",
                      ),
                      HeaderCell(
                        flex: 2,
                        text: "500000",
                        fontWeight: FontWeight.bold,
                        align: TextAlign.right,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Side Box -Right Side
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomList(
                      Skey: "F2",
                      name: "Report",
                      onTap: () async {
                        FilterCriteria? filterCriteria = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReportStatus(),
                          ),
                        );

                        if (filterCriteria != null) {
                          setState(() {
                            selctedfillter = filterCriteria.stockGrouping;
                          });
                        }
                      }),
                  CustomList(
                    Skey: "P",
                    name: "Print",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "V",
                    name: "View",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "X",
                    name: "Export-Excel",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "F3",
                    name: "Find",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "N",
                    name: "Next",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                  CustomList(
                    Skey: "",
                    name: "",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

// For Create Inside Data Row
  Widget _buildItemRow(
    BuildContext context,
    Item item,
    int index,
    ValueNotifier<String> selectedId,
    VoidCallback onDoubleTap,
  ) {
    return InkWell(
      onTap: () {
        selectedId.value = item.id;
      },
      onDoubleTap: onDoubleTap,
      child: ValueListenableBuilder<String>(
        valueListenable: selectedId,
        builder: (context, selectedValue, child) {
          bool isSelected = selectedValue == item.id;

          return Row(
            children: [
              RowCell(
                flex: 5,
                text: item.itemName,
                align: TextAlign.left,
                containercolor: isSelected ? const Color(0xFF4169E1) : null,
                textColor: isSelected ? Colors.yellow : Colors.black,
              ),
              RowCell(
                flex: 2,
                text: item.minimumStock.toString(),
                align: TextAlign.right,
                containercolor: isSelected ? const Color(0xFF4169E1) : null,
                textColor: isSelected ? Colors.white : Colors.black,
              ),
              RowCell(
                flex: 2,
                text: item.maximumStock.toString(),
                align: TextAlign.right,
                containercolor: isSelected ? const Color(0xFF4169E1) : null,
                textColor: isSelected ? Colors.white : Colors.black,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF4169E1) : null,
                    border: Border.all(),
                  ),
                  child: FutureBuilder<String>(
                    future: getMeasurementUnit(
                        item.measurementUnit), // Use cached fetch
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('');
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final unitName = snapshot.data ?? 'Unknown Unit';
                        return Text(
                          unitName,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              RowCell(
                flex: 1,
                text: "",
                align: TextAlign.center,
                containercolor: isSelected ? const Color(0xFF4169E1) : null,
                textColor: isSelected ? Colors.white : Colors.black,
              ),
              RowCell(
                flex: 2,
                text: item.mrp.toString(),
                align: TextAlign.right,
                containercolor: isSelected ? const Color(0xFF4169E1) : null,
                textColor: isSelected ? Colors.white : Colors.black,
              ),
              RowCell(
                flex: 2,
                text: (item.maximumStock * item.mrp).toString(),
                containercolor: isSelected ? const Color(0xFF4169E1) : null,
                textColor: isSelected ? Colors.white : Colors.black,
                align: TextAlign.right,
              ),
              RowCell(
                flex: 2,
                text: "",
                align: TextAlign.right,
                containercolor: isSelected ? const Color(0xFF4169E1) : null,
                textColor: isSelected ? Colors.white : Colors.black,
              ),
            ],
          );
        },
      ),
    );
  }
}

class CategoryCell extends StatelessWidget {
  final String categoryName, total;
  const CategoryCell(
      {super.key, required this.categoryName, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HeaderCell(
          flex: 5,
          text: categoryName,
          fontWeight: FontWeight.w600,
          bordor: Border.all(),
          textColor: Colors.purple.shade400,
        ),
        HeaderCell(
          flex: 2,
          text: "",
          bordor: Border.all(),
        ),
        HeaderCell(
          flex: 2,
          text: "",
          bordor: Border.all(),
        ),
        HeaderCell(
          flex: 1,
          text: "",
          bordor: Border.all(),
        ),
        HeaderCell(
          flex: 1,
          text: "",
          bordor: Border.all(),
        ),
        HeaderCell(
          flex: 2,
          text: "",
          bordor: Border.all(),
        ),
        HeaderCell(
          flex: 2,
          text: "",
          bordor: Border.all(),
        ),
        HeaderCell(
          flex: 2,
          text: total,
          fontWeight: FontWeight.w600,
          align: TextAlign.right,
          bordor: Border.all(),
          textColor: Colors.purple.shade400,
        ),
      ],
    );
  }
}

class HeaderCell extends StatelessWidget {
  final int flex;
  final String text;
  final TextAlign? align;
  final Color? textColor;
  final FontWeight? fontWeight;
  final Border? bordor;
  const HeaderCell(
      {super.key,
      required this.flex,
      required this.text,
      this.align,
      this.textColor,
      this.bordor,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
              border: bordor ?? Border.all(color: Colors.transparent)),
          child: Text(
            text,
            textAlign: align,
            overflow: TextOverflow.ellipsis,
            style:
                GoogleFonts.poppins(color: textColor, fontWeight: fontWeight),
          ),
        ));
  }
}

class RowCell extends StatelessWidget {
  final int flex;
  final String text;
  final TextAlign? align;
  final Color? textColor;
  final FontWeight? fontWeight;
  final Border? bordor;
  final Color? containercolor;
  const RowCell(
      {super.key,
      required this.flex,
      required this.text,
      this.align,
      this.textColor,
      this.fontWeight,
      this.bordor,
      this.containercolor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex,
        child: Container(
          padding: const EdgeInsets.only(left: 17, top: 8, bottom: 8, right: 8),
          decoration: BoxDecoration(
              color: containercolor, border: bordor ?? Border.all()),
          child: Text(
            text,
            textAlign: align,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
                color: textColor ?? Colors.black,
                fontWeight: fontWeight ?? FontWeight.w600),
          ),
        ));
  }
}

class HeaderCell2 extends StatelessWidget {
  final String text;
  final TextAlign? align;
  final Color? textColor;
  final FontWeight? fontWeight;
  final Border? bordor;
  const HeaderCell2(
      {super.key,
      required this.text,
      this.align,
      this.textColor,
      this.bordor,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: bordor ?? Border.all(color: Colors.transparent)),
      child: Text(
        text,
        textAlign: align,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.poppins(
            color: textColor ?? Colors.black, fontWeight: fontWeight),
      ),
    );
  }
}
