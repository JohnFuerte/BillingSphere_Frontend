import 'dart:async';

import 'package:billingsphere/data/repository/item_brand_repository.dart';
import 'package:billingsphere/data/repository/item_group_repository.dart';
import 'package:billingsphere/data/repository/store_location_repository.dart';
import 'package:billingsphere/views/NI_responsive.dart/NI_desktopBody.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horizontal_data_table/scroll/linked_scroll_controller/linked_scroll_controller.dart';

import '../../data/models/brand/item_brand_model.dart';
import '../../data/models/item/item_model.dart';
import '../../data/models/itemGroup/item_group_model.dart';
import '../../data/models/storeLocation/store_location_model.dart';
import '../../data/repository/item_repository.dart';
import '../DB_homepage.dart';
import '../DB_responsive/DB_desktop_body.dart';
import '../sumit_screen/voucher _entry.dart/voucher_list_widget.dart';
import 'NI_edit.dart';

class ItemHome extends StatefulWidget {
  const ItemHome({super.key});

  @override
  State<ItemHome> createState() => _ItemHomeState();
}

class _ItemHomeState extends State<ItemHome> {
  // Item Service
  ItemsService itemsService = ItemsService();
  ItemsBrandsService itemsBrandsService = ItemsBrandsService();
  ItemsGroupService itemsGroupService = ItemsGroupService();
  StoreLocationService storeLocationService = StoreLocationService();
  final TextEditingController _searchController = TextEditingController();

  // Fetched Ledger List
  List<Item> fectedItems = [];
  List<Item> fectedItems2 = [];
  ValueNotifier<String?> selectedId = ValueNotifier<String?>(null);
  final ValueNotifier<int> currentIndexNotifier = ValueNotifier<int>(0);

  List<ItemsBrand> fectedItemBrands = [];
  List<ItemsGroup> fectedItemGroups = [];
  List<StoreLocation> fectedStoreLocations = [];

  // Scaffold Global Key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKeyM = GlobalKey<ScaffoldState>();

  // ScrollControllers
  late ScrollController _horizontalController1;
  late ScrollController _horizontalController2;
  late LinkedScrollControllerGroup _horizontalControllersGroup;

  int currentPage = 1;
  int totalPages = 1;
  int limit = 50;
  Timer? _debounce;
  FocusNode _focusNode = FocusNode();

  // Variable
  bool isLoading = false;
  bool isLoadingItems = false;
  ScrollController _scrollController = ScrollController();

  void goToPage(int page) {
    if (page != currentPage) {
      fetchItemsWithPagination(page);
      setState(() {
        currentPage = page;
      });
    }
  }

  Future<void> fetchItemsWithPagination(int page) async {
    if (isLoadingItems || page > totalPages)
      return; // Prevent duplicate fetches and exceeding total pages

    setState(() {
      isLoadingItems = true;
    });

    try {
      final List<Item> newItems =
          await itemsService.fetchItemsWithPagination(page, limit: 25);
      setState(() {
        if (newItems.isNotEmpty) {
          fectedItems.addAll(newItems); // Append new items to existing list
          currentPage = page; // Update current page
        }
        isLoadingItems = false;
      });
    } catch (error) {
      print('Failed to fetch items: $error');
      setState(() {
        isLoadingItems = false;
      });
    }
  }

  Future<void> fetchInitialItems() async {
    try {
      final List<Item> initialItems =
          await itemsService.fetchItemsWithPagination(1, limit: 1500);
      setState(() {
        fectedItems = initialItems;
        fectedItems2 = initialItems;

        if (fectedItems.isNotEmpty) {
          selectedId.value = fectedItems[0].id;
        }
        totalPages = itemsService.totalPages; // Ensure this is set correctly
        currentPage = 1; // Initialize currentPage
      });
    } catch (error) {
      print('Failed to fetch items: $error');
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Trigger fetch only if not already loading and more pages are available
      if (!isLoadingItems && currentPage < totalPages) {
        fetchItemsWithPagination(currentPage + 1);
      }
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      searchItem(query);
    });
  }

  void searchItem(String query) {
    if (query.isNotEmpty) {
      List<Item> filteredList = fectedItems2.where((item) {
        return item.itemName.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        fectedItems = filteredList;
      });
    } else {
      setState(() {
        fectedItems = fectedItems2;
      });
    }
  }

  Future<void> fetchItemGroups() async {
    try {
      final List<ItemsGroup> itemGroups =
          await itemsGroupService.fetchItemGroups();
      setState(() {
        fectedItemGroups = itemGroups;
      });
    } catch (error) {
      print('Failed to fetch item groups: $error');
    }
  }

  String getItemGroup(String ledgerGroup) {
    for (var company in fectedItemGroups) {
      if (company.id == ledgerGroup) {
        return company.name.toString();
      }
    }
    return '';
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  void _initializeData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await Future.wait([
        fetchInitialItems(),
        fetchItemGroups(),
      ]);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Exit"),
          content: const Text("Do you want to exit?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        const DBHomePage(), // Replace with your dashboard screen widget
                  ),
                );
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToEditScreen(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NIMyDesktopBodyE(
          id: id,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    currentIndexNotifier.value = 1;

    _initializeData();
    _scrollController.addListener(_scrollListener);
    _horizontalControllersGroup = LinkedScrollControllerGroup();
    _horizontalController1 = _horizontalControllersGroup.addAndGet();
    _horizontalController2 = _horizontalControllersGroup.addAndGet();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          return _buildMobileWidget();
        } else if (constraints.maxWidth >= 600 && constraints.maxWidth < 1200) {
          return _buildTabletWidget();
        } else {
          return _buildDesktopWidget();
        }
      },
    );
  }

  Widget _buildMobileWidget() {
    int totalItems = fectedItems.length;

    final textAlignments = [
      TextAlign.center,
      TextAlign.left,
      TextAlign.left,
      TextAlign.left,
      TextAlign.center,
      TextAlign.center,
      TextAlign.center,
      TextAlign.center,
    ];

    final widths = [
      0.1,
      0.5,
      0.3,
      0.3,
      0.3,
      0.3,
      0.3,
      0.3,
    ];

    final List<Map<String, dynamic>> menuItems = [
      {'text': 'New', 'icon': Icons.add},
      {'text': 'Edit', 'icon': Icons.edit_outlined},
      {'text': 'Delete', 'icon': Icons.delete_outline},
      {'text': 'Export Excel', 'icon': Icons.file_download_outlined},
      {'text': 'Bulk Upload', 'icon': Icons.cloud_upload_outlined},
      {'text': 'Op. Bal', 'icon': Icons.account_balance_outlined},
      {'text': 'MultiEdit', 'icon': Icons.edit_attributes_outlined},
      {'text': 'Filters', 'icon': Icons.filter_list_outlined},
      {'text': 'Copy Items', 'icon': Icons.content_copy_outlined},
      {'text': 'Image Gallery', 'icon': Icons.image_outlined},
      {'text': 'Duplicate Items', 'icon': Icons.copy_outlined},
      {'text': 'Non/Used', 'icon': Icons.not_interested_outlined},
    ];

    return Scaffold(
      key: _scaffoldKeyM,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35.0),
        child: AppBar(
          title: const Text(
            'ITEM MASTER',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const DBMyDesktopBody(),
                ),
              );
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                _scaffoldKeyM.currentState!.openDrawer();
              },
              icon: const Icon(
                Icons.menu,
              ),
            )
          ],
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF0000FF),
          centerTitle: true,
        ),
      ),
      drawer: Drawer(
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
                  onTap: () {
                    // Handle the tap event
                    print('Tapped on ${item['text']}');
                  },
                ),
              );
            }),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 850,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      isLoading
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: 820,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              height: 820,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Text(
                                            "Search",
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF6C0082),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.64,
                                            child: Container(
                                              color: Colors.black,
                                              height: 35,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextField(
                                                  controller: _searchController,
                                                  onChanged: _onSearchChanged,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    height: 0.8,
                                                  ),
                                                  // cursorHeight: 15,
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.0), // Adjust the border radius as needed
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        controller: _horizontalController1,
                                        child: Row(
                                          children: [
                                            _buildHeaderCell2(
                                                'Sr', 2, TextAlign.center, 0.1),
                                            _buildHeaderCell2('Item Name', 6,
                                                TextAlign.left, 0.5),
                                            _buildHeaderCell2('Code No', 4,
                                                TextAlign.left, 0.3),
                                            _buildHeaderCell2('Group', 3,
                                                TextAlign.left, 0.3),
                                            _buildHeaderCell2('Retail', 3,
                                                TextAlign.center, 0.3),
                                            _buildHeaderCell2('MRP', 3,
                                                TextAlign.center, 0.3),
                                            _buildHeaderCell2('Cl.Stk', 3,
                                                TextAlign.center, 0.3),
                                            _buildHeaderCell2('Status', 2,
                                                TextAlign.center, 0.3),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      controller: _scrollController,
                                      itemCount: fectedItems.length,
                                      itemBuilder: (context, i) {
                                        final item = fectedItems[i];
                                        final cellData = [
                                          (i + 1).toString(),
                                          item.itemName.toString(),
                                          item.codeNo.toString(),
                                          getItemGroup(item.itemGroup),
                                          item.retail.toStringAsFixed(2),
                                          item.mrp.toStringAsFixed(2),
                                          item.maximumStock.toString(),
                                          item.status.toString(),
                                        ];

                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedId.value = item.id;
                                            });

                                            currentIndexNotifier.value =
                                                i + 1; // Update currentIndex
                                          },
                                          onDoubleTap: () {
                                            _navigateToEditScreen(item.id);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: selectedId.value == item.id
                                                  ? const Color(0xFF4169E1)
                                                  : null,
                                              border: Border.all(),
                                            ),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: List.generate(
                                                    cellData.length, (j) {
                                                  return Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            widths[j],
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      cellData[j],
                                                      textAlign:
                                                          textAlignments[j],
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color:
                                                            selectedId.value ==
                                                                    item.id
                                                                ? Colors.yellow
                                                                : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  ValueListenableBuilder<int>(
                                    valueListenable: currentIndexNotifier,
                                    builder: (context, index, child) {
                                      return Text(
                                        'Row No: $index of $totalItems (Total: $totalItems)',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF1A138F),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletWidget() {
    int totalItems = fectedItems.length;

    final textAlignments = [
      TextAlign.center,
      TextAlign.left,
      TextAlign.left,
      TextAlign.left,
      TextAlign.center,
      TextAlign.center,
      TextAlign.center,
      TextAlign.center,
    ];

    final List<Map<String, dynamic>> menuItems = [
      {'text': 'New', 'icon': Icons.add},
      {'text': 'Edit', 'icon': Icons.edit_outlined},
      {'text': 'Delete', 'icon': Icons.delete_outline},
      {'text': 'Export Excel', 'icon': Icons.file_download_outlined},
      {'text': 'Bulk Upload', 'icon': Icons.cloud_upload_outlined},
      {'text': 'Op. Bal', 'icon': Icons.account_balance_outlined},
      {'text': 'MultiEdit', 'icon': Icons.edit_attributes_outlined},
      {'text': 'Filters', 'icon': Icons.filter_list_outlined},
      {'text': 'Copy Items', 'icon': Icons.content_copy_outlined},
      {'text': 'Image Gallery', 'icon': Icons.image_outlined},
      {'text': 'Duplicate Items', 'icon': Icons.copy_outlined},
      {'text': 'Non/Used', 'icon': Icons.not_interested_outlined},
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35.0),
        child: AppBar(
          title: const Text(
            'ITEM MASTER Tablet',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const DBMyDesktopBody(),
                ),
              );
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              icon: const Icon(
                Icons.menu,
              ),
            )
          ],
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF0000FF),
          centerTitle: true,
        ),
      ),
      drawer: Drawer(
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
                    onTap: () {
                      // Handle the tap event
                      print('Tapped on ${item['text']}');
                    },
                  ),
                );
              }),
            ],
          )),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 850,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      isLoading
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: 820,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              height: 820,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          child: Text(
                                            "Search",
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF6C0082),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.64,
                                            child: Container(
                                              color: Colors.black,
                                              height: 35,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextField(
                                                  controller: _searchController,
                                                  onChanged: _onSearchChanged,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    height: 0.8,
                                                  ),
                                                  // cursorHeight: 15,
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.0), // Adjust the border radius as needed
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Row(
                                      children: [
                                        _buildHeaderCell(
                                            'Sr', 1, TextAlign.center),
                                        _buildHeaderCell(
                                            'Item Name', 4, TextAlign.left),
                                        _buildHeaderCell(
                                            'Code No', 3, TextAlign.left),
                                        _buildHeaderCell(
                                            'Group', 2, TextAlign.left),
                                        _buildHeaderCell(
                                            'Retail', 2, TextAlign.center),
                                        _buildHeaderCell(
                                            'MRP', 2, TextAlign.center),
                                        _buildHeaderCell(
                                            'Cl.Stk', 2, TextAlign.center),
                                        _buildHeaderCell(
                                            'Status', 1, TextAlign.center),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      controller: _scrollController,
                                      itemCount: fectedItems.length,
                                      itemBuilder: (context, i) {
                                        final item = fectedItems[i];
                                        final cellData = [
                                          (i + 1).toString(),
                                          item.itemName.toString(),
                                          item.codeNo.toString(),
                                          getItemGroup(item.itemGroup),
                                          item.retail.toStringAsFixed(2),
                                          item.mrp.toStringAsFixed(2),
                                          item.maximumStock.toString(),
                                          item.status.toString(),
                                        ];

                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedId.value = item.id;
                                            });

                                            currentIndexNotifier.value =
                                                i + 1; // Update currentIndex
                                          },
                                          onDoubleTap: () {
                                            _navigateToEditScreen(item.id);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: selectedId.value == item.id
                                                  ? const Color(0xFF4169E1)
                                                  : null,
                                              border: Border.all(),
                                            ),
                                            child: Row(
                                              children: List.generate(
                                                  cellData.length, (j) {
                                                return Expanded(
                                                  flex: [
                                                    1,
                                                    4,
                                                    3,
                                                    2,
                                                    2,
                                                    2,
                                                    2,
                                                    1
                                                  ][j], // Adjust flex as needed
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      cellData[j],
                                                      textAlign:
                                                          textAlignments[j],
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color:
                                                            selectedId.value ==
                                                                    item.id
                                                                ? Colors.yellow
                                                                : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  ValueListenableBuilder<int>(
                                    valueListenable: currentIndexNotifier,
                                    builder: (context, index, child) {
                                      return Text(
                                        'Row No: $index of $totalItems (Total: $totalItems)',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF1A138F),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopWidget() {
    int totalItems = fectedItems.length;

    final textAlignments = [
      TextAlign.center,
      TextAlign.left,
      TextAlign.left,
      TextAlign.left,
      TextAlign.center,
      TextAlign.center,
      TextAlign.center,
      TextAlign.center,
    ];

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          _showExitConfirmationDialog();
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(35.0),
          child: AppBar(
            title: Text(
              'ITEM MASTER',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const DBMyDesktopBody(),
                  ),
                );
              },
            ),
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF0000FF),
            centerTitle: true,
          ),
        ),
        body: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 890,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          isLoading
                              ? Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  height: 820,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  height: 820,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              child: Text(
                                                "Search",
                                                style: GoogleFonts.poppins(
                                                  color:
                                                      const Color(0xFF6C0082),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.64,
                                                child: Container(
                                                  color: Colors.black,
                                                  height: 35,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextField(
                                                      controller:
                                                          _searchController,
                                                      onChanged:
                                                          _onSearchChanged,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        height: 0.8,
                                                      ),
                                                      // cursorHeight: 15,
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  0.0), // Adjust the border radius as needed
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      0.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                        ),
                                        child: Row(
                                          children: [
                                            _buildHeaderCell(
                                                'Sr', 1, TextAlign.center),
                                            _buildHeaderCell(
                                                'Item Name', 4, TextAlign.left),
                                            _buildHeaderCell(
                                                'Code No', 3, TextAlign.left),
                                            _buildHeaderCell(
                                                'Group', 2, TextAlign.left),
                                            _buildHeaderCell(
                                                'Retail', 2, TextAlign.center),
                                            _buildHeaderCell(
                                                'MRP', 2, TextAlign.center),
                                            _buildHeaderCell(
                                                'Cl.Stk', 2, TextAlign.center),
                                            _buildHeaderCell(
                                                'Status', 1, TextAlign.center),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          controller: _scrollController,
                                          itemCount: fectedItems.length,
                                          itemBuilder: (context, i) {
                                            final item = fectedItems[i];
                                            final cellData = [
                                              (i + 1).toString(),
                                              item.itemName.toString(),
                                              item.codeNo.toString(),
                                              getItemGroup(item.itemGroup),
                                              item.retail.toStringAsFixed(2),
                                              item.mrp.toStringAsFixed(2),
                                              item.maximumStock.toString(),
                                              item.status.toString(),
                                            ];

                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedId.value = item.id;
                                                });

                                                currentIndexNotifier.value = i +
                                                    1; // Update currentIndex
                                              },
                                              onDoubleTap: () {
                                                _navigateToEditScreen(item.id);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: selectedId.value ==
                                                          item.id
                                                      ? const Color(0xFF4169E1)
                                                      : null,
                                                  border: Border.all(),
                                                ),
                                                child: Row(
                                                  children: List.generate(
                                                      cellData.length, (j) {
                                                    return Expanded(
                                                      flex: [
                                                        1,
                                                        4,
                                                        3,
                                                        2,
                                                        2,
                                                        2,
                                                        2,
                                                        1
                                                      ][j],
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        decoration:
                                                            const BoxDecoration(
                                                          border: Border(
                                                            right: BorderSide(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          cellData[j],
                                                          textAlign:
                                                              textAlignments[j],
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: selectedId
                                                                        .value ==
                                                                    item.id
                                                                ? Colors.yellow
                                                                : Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      ValueListenableBuilder<int>(
                                        valueListenable: currentIndexNotifier,
                                        builder: (context, index, child) {
                                          return Text(
                                            'Row No: $index of $totalItems (Total: $totalItems)',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF1A138F),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                child: Shortcuts(
                  shortcuts: {
                    LogicalKeySet(LogicalKeyboardKey.f3):
                        const ActivateIntent(),
                    LogicalKeySet(LogicalKeyboardKey.f4):
                        const ActivateIntent(),
                  },
                  child: Focus(
                    autofocus: true,
                    onKey: (node, event) {
                      // ignore: deprecated_member_use
                      if (event is RawKeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.f2) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const NIMyDesktopBody(),
                          ),
                        );

                        return KeyEventResult.handled;
                      } else if (event is RawKeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.f4) {
                        _navigateToEditScreen(selectedId.value.toString());

                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.099,
                      child: Column(
                        children: [
                          CustomList(
                              Skey: "F2",
                              name: "New",
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const NIMyDesktopBody(),
                                  ),
                                );
                              }),
                          CustomList(
                            Skey: "F4",
                            name: "Edit",
                            onTap: () {
                              _navigateToEditScreen(
                                  selectedId.value.toString());
                            },
                          ),
                          CustomList(
                            Skey: "D",
                            name: "Delete",
                            onTap: () {
                              showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: const Text('Delete'),
                                    content: const Text(
                                        'Are you sure you want to delete this entry?'),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: const Text('Yes'),
                                        onPressed: () {
                                          itemsService
                                              .deleteItem(
                                                  selectedId.value!, context)
                                              .then(
                                                (value) => {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ItemHome(),
                                                    ),
                                                  )
                                                },
                                              );
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        child: const Text('No',
                                            style:
                                                TextStyle(color: Colors.red)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),

                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(
                          //     Skey: "X", name: "Export-Excel", onTap: () {}),
                          // CustomList(Skey: "B", name: "BulkUpt", onTap: () {}),
                          // CustomList(Skey: "O", name: "Op. Bal", onTap: () {}),
                          // CustomList(
                          //     Skey: "M", name: "MultiEdit", onTap: () {}),
                          // CustomList(Skey: "F", name: "Filters", onTap: () {}),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(Skey: "", name: "MinMax Up", onTap: () {}),
                          // CustomList(
                          //     Skey: "Y", name: "Copy Item", onTap: () {}),
                          // CustomList(
                          //     Skey: "G", name: "Img Gallery", onTap: () {}),
                          // CustomList(Skey: "", name: "Dup Items", onTap: () {}),
                          // CustomList(Skey: "", name: "Non/Used", onTap: () {}),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, int flex, TextAlign textAlign) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.black),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: const Color(0xFF6C0082),
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
        ),
      ),
    );
  }

  Widget _buildHeaderCell2(
      String text, int flex, TextAlign textAlign, double width) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * width,
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.black),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w800,
          fontSize: 16,
          color: const Color(0xFF6C0082),
        ),
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
      ),
    );
  }
}
