// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:billingsphere/data/models/brand/item_brand_model.dart';
import 'package:billingsphere/data/models/hsn/hsn_model.dart';
import 'package:billingsphere/data/models/item/item_model.dart';
import 'package:billingsphere/data/models/itemGroup/item_group_model.dart';
import 'package:billingsphere/data/models/measurementLimit/measurement_limit_model.dart';
import 'package:billingsphere/data/models/secondaryUnit/secondary_unit_model.dart';
import 'package:billingsphere/data/models/storeLocation/store_location_model.dart';
import 'package:billingsphere/data/models/taxCategory/tax_category_model.dart';
import 'package:billingsphere/data/repository/item_repository.dart';
import 'package:billingsphere/logic/cubits/itemBrand_cubit/itemBrand_state.dart';
import 'package:billingsphere/logic/cubits/itemGroup_cubit/itemGroup_cubit.dart';
import 'package:billingsphere/utils/controllers/items_text_controllers.dart';
import 'package:billingsphere/views/NI_widgets/NI_new_table.dart';
import 'package:billingsphere/views/NI_widgets/NI_singleTextField.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repository/barcode_repository.dart';
import '../../data/repository/item_brand_repository.dart';
import '../../data/repository/item_group_repository.dart';
import '../../logic/cubits/hsn_cubit/hsn_cubit.dart';
import '../../logic/cubits/hsn_cubit/hsn_state.dart';
import '../../logic/cubits/itemBrand_cubit/itemBrand_cubit.dart';
import '../../logic/cubits/itemGroup_cubit/itemGroup_state.dart';
import '../../logic/cubits/measurement_cubit/measurement_limit_cubit.dart';
import '../../logic/cubits/measurement_cubit/measurement_limit_state.dart';
import '../../logic/cubits/secondary_unit_cubit/secondary_unit_cubit.dart';
import '../../logic/cubits/secondary_unit_cubit/secondary_unit_state.dart';
import '../../logic/cubits/store_cubit/store_cubit.dart';
import '../../logic/cubits/store_cubit/store_state.dart';
import '../../logic/cubits/taxCategory_cubit/taxCategory_cubit.dart';
import '../../logic/cubits/taxCategory_cubit/taxCategory_state.dart';
import '../DB_homepage.dart';
import '../searchable_dropdown.dart';
import '../sumit_screen/hsn_code/hsn_code.dart';
import '../sumit_screen/measurement_unit/measurement_unit.dart';
import '../sumit_screen/secondary_unit/secondary_unit.dart';
import '../sumit_screen/store_location/store_location.dart';
import 'NI_table_row_edit.dart';

class NIMyDesktopBodyE extends StatefulWidget {
  const NIMyDesktopBodyE({super.key, required this.id});

  final String id;

  @override
  State<NIMyDesktopBodyE> createState() => _BasicDetailsState();
}

class _BasicDetailsState extends State<NIMyDesktopBodyE> {
  List<List<String>> tableData = [
    // Initial data for the table
    ["Header 1", "Header 2", "Header 3"],
    ["Data 1", "Data 2", "Data 3"],
  ];

  bool _isSaving = false;
  ItemsService items = ItemsService();
  List<Uint8List> _selectedImages = [];
  Item? _item;
  List<String>? companyCode;
  String selectedBarcode = '';
  final GlobalKey<ExpandableFabState> _key = GlobalKey<ExpandableFabState>();

  Future<List<String>?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('companies');
  }

  Future<void> setCompanyCode() async {
    List<String>? code = await getCompanyCode();
    setState(() {
      companyCode = code;
    });
  }

  void createItems() async {
    setState(() {
      _isSaving = true;
    });

    List<ImageData>? imageList;
    if (_selectedImages.isNotEmpty) {
      imageList = _selectedImages
          .map((image) => ImageData(
                data: image,
                contentType: 'image/jpeg',
                filename: 'filename.jpg',
              ))
          .toList();
    }
    // Validate and log _allValues before mapping
    print("Validating and Mapping _allValues to OpeningBalance:");

    List<OpeningBalance> openingBalanceList = [];
    for (var entry in _allValues) {
      try {
        final qtyStr = entry['qty'].toString();
        final rateStr = entry['rate'].toString();
        final unit = entry['unit'];
        final totalStr = entry['total'].toString();

        final qty = int.tryParse(qtyStr);
        final rate = double.tryParse(rateStr);
        final total = double.tryParse(totalStr);

        if (qty == null || rate == null || total == null || unit == null) {
          continue;
        }

        openingBalanceList.add(OpeningBalance(
          qty: qty,
          rate: rate,
          unit: unit,
          total: total,
        ));
      } catch (e) {
        print("Error processing entry: $entry, error: $e");
      }
    }
    double totalQty =
        openingBalanceList.fold(0.0, (sum, entry) => sum + (entry.qty ?? 0.0));
    double totalAmount = openingBalanceList.fold(
        0.0, (sum, entry) => sum + (entry.total ?? 0.0));

    double maximumStockValue =
        ((int.tryParse(controllers.maximumStockController.text) ?? 0) -
                fetchQty) +
            totalQty;
    controllers.maximumStockController.text = maximumStockValue.toString();
    items.updateItem(
      companyCode: companyCode!.first,
      id: widget.id,
      itemGroup: selectedItemId!,
      itemBrand: selectedItemId2!,
      itemName: controllers.itemNameController.text,
      printName: controllers.printNameController.text,
      codeNo: controllers.codeNoController.text,
      taxCategory: selectedTaxRateId!,
      hsnCode: selectedHSNCodeId!,
      storeLocation: selectedStoreLocationId!,
      measurementUnit: selectedMeasurementLimitId!,
      secondaryUnit: selectedSecondaryUnitId!,
      minimumStock:
          int.tryParse(controllers.minimumStockController.text.trim()) ?? 0,
      maximumStock:
          int.tryParse(controllers.maximumStockController.text.trim()) ?? 0,
      monthlySalesQty:
          int.tryParse(controllers.monthlySalesQtyController.text.trim()) ?? 0,
      dealer: double.parse(controllers.dealerController.text),
      subDealer: double.parse(controllers.subDealerController.text),
      retail: double.parse(controllers.retailController.text),
      mrp: double.parse(controllers.mrpController.text),
      openingStock: selectedStock,
      barcode: selectedBarcode,
      status: selectedStatus,
      context: context,
      date: controllers.dateController.text,
      price: double.parse(controllers.currentPriceController.text),
      images: imageList ?? [],
      openingBalance: openingBalanceList,
      openingBalanceAmt: totalAmount,
      openingBalanceQty: totalQty,
    );
    print(_allValues);
    controllers.itemNameController.clear();
    controllers.printNameController.clear();
    controllers.codeNoController.clear();
    controllers.minimumStockController.clear();
    controllers.maximumStockController.clear();
    controllers.monthlySalesQtyController.clear();
    controllers.dealerController.clear();
    controllers.subDealerController.clear();
    controllers.retailController.clear();
    controllers.mrpController.clear();
    controllers.openingStockController.clear();
    controllers.barcodeController.clear();
    controllers.dateController.clear();
    selectedItemId = fetchedItemGroups.first.id;
    selectedItemId2 = fetchedItemBrands.first.id;
    selectedTaxRateId = fetchedTaxCategories.first.id;
    selectedHSNCodeId = fetchedHSNCodes.first.id;
    selectedStoreLocationId = fetchedStores.first.id;
    selectedMeasurementLimitId = fetchedMLimits.first.id;
    selectedSecondaryUnitId = fetchedSUnit.first.id;
    imageList = [];
    _selectedImages = [];
    selectedStatus = 'Active';
    selectedStock = 'Yes';

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSaving = false;
    });
  }

  //  Dropdown Data
  List<ItemsGroup> fetchedItemGroups = [];
  List<ItemsBrand> fetchedItemBrands = [];
  List<TaxRate> fetchedTaxCategories = [];
  List<HSNCode> fetchedHSNCodes = [];
  List<StoreLocation> fetchedStores = [];
  List<MeasurementLimit> fetchedMLimits = [];
  List<SecondaryUnit> fetchedSUnit = [];
  List<String> status = ['Active', 'Inactive'];
  List<String> stock = ['Yes', 'No'];
  List<File> files = [];
  final List<Map<String, dynamic>> _allValues = [];
  final List<NItableEdit> _newWidget = [];

  // Variables
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isFetched = false;

  // Dropdown Values
  String? selectedItemId;
  String? selectedItemId2;
  String? selectedTaxRateId;
  String? selectedHSNCodeId;
  String? selectedStoreLocationId;
  String? selectedMeasurementLimitId;
  String? selectedSecondaryUnitId;
  String selectedStatus = 'Active';
  String selectedStock = 'Yes';
  int fetchQty = 0;
  // Controllers
  ItemsFormControllers controllers = ItemsFormControllers();
  BarcodeRepository barcodeRepository = BarcodeRepository();
  ItemsGroupService itemsGroup = ItemsGroupService();
  ItemsBrandsService itemsBrand = ItemsBrandsService();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    _allDataInit();
    super.initState();
  }

  Future<void> fetchBarcodeData(String id) async {
    final barcode = await barcodeRepository.fetchBarcodeById(id);
    setState(() {
      controllers.barcodeController.text = barcode!.barcode;
    });
  }

  void _allDataInit() {
    _fetchData();
    setCompanyCode();
    _fetchSingleItem();
  }

  Future<void> _fetchSingleItem() async {
    print(widget.id);
    try {
      final item = await items.getSingleItem(widget.id);

      setState(() {
        _item = item;

        DateTime dateTime = DateTime.parse(_item!.date);

        String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

        selectedItemId = _item!.itemGroup;
        selectedItemId2 = _item!.itemBrand;
        selectedTaxRateId = _item!.taxCategory;
        selectedHSNCodeId = _item!.hsnCode;
        selectedStoreLocationId = _item!.storeLocation;
        selectedMeasurementLimitId = _item!.measurementUnit;
        selectedSecondaryUnitId = _item!.secondaryUnit;

        controllers.codeNoController.text = _item!.codeNo;
        controllers.itemNameController.text = _item!.itemName;
        controllers.dateController.text = formattedDate;
        controllers.dealerController.text = _item!.dealer.toString();
        controllers.maximumStockController.text =
            _item!.maximumStock.toString();
        controllers.minimumStockController.text =
            _item!.minimumStock.toString();
        controllers.currentPriceController.text =
            _item!.price!.toStringAsFixed(2).toString();
        controllers.mrpController.text =
            _item!.mrp.toStringAsFixed(2).toString();
        controllers.printNameController.text = _item!.printName.toString();
        controllers.retailController.text =
            _item!.retail.toStringAsFixed(2).toString();
        selectedBarcode = _item!.barcode;
        controllers.subDealerController.text =
            _item!.subDealer.toStringAsFixed(2).toString();
        controllers.monthlySalesQtyController.text =
            _item!.monthlySalesQty.toString();
        selectedStock = _item!.openingStock;
        selectedStatus = _item!.status;
        _selectedImages = _item!.images!.map((e) => e.data).toList();

        // Add the existing entries to the _allValues list
        for (final entry in item!.openingBalance) {
          final entryId = UniqueKey().toString();
          _allValues.add({
            'uniqueKey': entryId,
            'qty': entry.qty,
            'rate': entry.rate,
            'unit': entry.unit,
            'total': entry.total,
          });

          // Set the controller
          final qtyController =
              TextEditingController(text: entry.qty.toString());
          final rateController =
              TextEditingController(text: entry.rate.toString());
          final unitController = TextEditingController(text: entry.unit);
          final totalController =
              TextEditingController(text: entry.total.toString());
          fetchQty += int.parse(qtyController.text);

          _newWidget.add(NItableEdit(
            key: ValueKey(entryId),
            oPBalanceQtyI: qtyController,
            oPBalanceUnitI: unitController,
            oPBalanceRatetI: rateController,
            oPBalanceTotaltI: totalController,
            entryId: entryId,
            serialNo: _newWidget.length + 1,
            onSaveValues: saveValues,
          ));
        }
      });

      print("Printing all values");
      print(_allValues);
      print(fetchQty);

      await fetchBarcodeData(_item!.barcode.toString());
    } catch (error) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Failed to fetch item: $error'),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    }
  }

  void saveValues(Map<String, dynamic> values) {
    final String uniqueKey = values['uniqueKey'];

    // Check if an entry with the same uniqueKey exists
    final existingEntryIndex =
        _allValues.indexWhere((entry) => entry['uniqueKey'] == uniqueKey);

    setState(() {
      if (existingEntryIndex != -1) {
        _allValues.removeAt(existingEntryIndex);
      }

      // Add the latest values
      _allValues.add(values);
    });
  }

  // Method to fetch data from Cubits
  void _fetchData() async {
    await Future.wait([
      BlocProvider.of<ItemBrandCubit>(context).getItemBrand(),
      BlocProvider.of<ItemGroupCubit>(context).getItemGroups(),
      BlocProvider.of<TaxCategoryCubit>(context).getTaxCategory(),
      BlocProvider.of<HSNCodeCubit>(context).getHSNCodes(),
      BlocProvider.of<CubitStore>(context).getStores(),
      BlocProvider.of<MeasurementLimitCubit>(context).getLimit(),
      BlocProvider.of<SecondaryUnitCubit>(context).getLimit(),
    ]);
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Exit"),
          content: const Text("Do you want to exit without saving?"),
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

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.1;
    double buttonHeight = MediaQuery.of(context).size.height * 0.03;
    double screenWidth = MediaQuery.of(context).size.width;

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          _showExitConfirmationDialog();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text('EDIT Item', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          foregroundColor: Colors.white,
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<ItemBrandCubit, CubitItemBrandStates>(
              listener: (context, state) {
                if (state is CubitItemBrandLoaded) {
                  setState(() {
                    fetchedItemBrands = state.itemBrands;
                  });
                } else if (state is CubitItemBrandError) {
                  print(state.error);
                }
              },
            ),
            BlocListener<ItemGroupCubit, CubitItemGroupStates>(
              listener: (context, state) {
                if (state is CubitItemGroupLoaded) {
                  setState(() {
                    fetchedItemGroups = state.itemGroups;
                  });
                } else if (state is CubitItemGroupError) {
                  print(state.error);
                }
              },
            ),
            BlocListener<TaxCategoryCubit, CubitTaxCategoryStates>(
              listener: (context, state) {
                if (state is CubitTaxCategoryLoaded) {
                  setState(() {
                    fetchedTaxCategories = state.taxCategories;
                  });
                } else if (state is CubitTaxCategoryError) {
                  print(state.error);
                }
              },
            ),
            BlocListener<HSNCodeCubit, CubitHsnStates>(
              listener: (context, state) {
                if (state is CubitHsnLoaded) {
                  setState(() {
                    fetchedHSNCodes = state.hsns;
                  });
                } else if (state is CubitHsnError) {
                  print(state.error);
                }
              },
            ),
            BlocListener<CubitStore, CubitStoreStates>(
              listener: (context, state) {
                if (state is CubicStoreLoaded) {
                  setState(() {
                    fetchedStores = state.stores;
                  });
                } else if (state is CubitStoreError) {
                  print(state.error);
                }
              },
            ),
            BlocListener<MeasurementLimitCubit, CubitMeasurementLimitStates>(
              listener: (context, state) {
                if (state is CubitMeasurementLimitLoaded) {
                  setState(() {
                    fetchedMLimits = state.measurementLimits;
                  });
                } else if (state is CubitMeasurementLimitError) {
                  print(state.error);
                }
              },
            ),
            BlocListener<SecondaryUnitCubit, CubitSecondaryUnitStates>(
              listener: (context, state) {
                if (state is CubitSecondaryUnitLoaded) {
                  setState(() {
                    fetchedSUnit = state.secondaryUnits;
                  });
                } else if (state is CubitSecondaryUnitError) {
                  print(state.error);
                }
              },
            ),
          ],
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                isFetched == true
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .6,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .44,
                                        decoration: const BoxDecoration(
                                            border: Border(
                                          top: BorderSide(
                                              width: 1, color: Colors.black),
                                          left: BorderSide(
                                            width: 1,
                                            color: Colors.black,
                                          ),
                                        )),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .04,
                                                  width: screenWidth < 900
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .14
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.1,
                                                  color: const Color.fromARGB(
                                                      255, 14, 63, 147),
                                                  child: Text(
                                                    ' BASIC DETAILS',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            screenWidth < 1030
                                                                ? 11.0
                                                                : 14.0),
                                                  )),
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const Expanded(
                                                      flex: 3,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(4.0),
                                                        child: Text(
                                                            'Item Group',
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        14,
                                                                        63,
                                                                        147))),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 9,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              .055,
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .black, // Choose the border color you prefer
                                                                width:
                                                                    1.0, // Adjust the border width
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0), // Adjust the border radius
                                                            ),
                                                            child:
                                                                SearchableDropDown(
                                                              controller:
                                                                  controllers
                                                                      .itemGroupController,
                                                              searchController:
                                                                  controllers
                                                                      .itemGroupController,
                                                              value:
                                                                  selectedItemId,
                                                              onChanged: (String?
                                                                  newValue) {
                                                                setState(() {
                                                                  selectedItemId =
                                                                      newValue;
                                                                });
                                                              },
                                                              items: fetchedItemGroups
                                                                  .map((ItemsGroup
                                                                      itemGroup) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value:
                                                                      itemGroup
                                                                          .id,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            8.0,
                                                                        vertical:
                                                                            8.0),
                                                                    child: Text(
                                                                        itemGroup
                                                                            .name),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                              searchMatchFn: (item,
                                                                  searchValue) {
                                                                final itemGroup =
                                                                    fetchedItemGroups
                                                                        .firstWhere((e) =>
                                                                            e.id ==
                                                                            item.value)
                                                                        .name;
                                                                return itemGroup
                                                                    .toLowerCase()
                                                                    .contains(
                                                                        searchValue
                                                                            .toLowerCase());
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          const Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                'Item Brand',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          14,
                                                                          63,
                                                                          147),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .055,
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .black, // Choose the border color you prefer
                                                                      width:
                                                                          1.0, // Adjust the border width
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            0), // Adjust the border radius
                                                                  ),
                                                                  child:
                                                                      SearchableDropDown(
                                                                    controller:
                                                                        controllers
                                                                            .itemBrandController,
                                                                    searchController:
                                                                        controllers
                                                                            .itemBrandController,
                                                                    value:
                                                                        selectedItemId2,
                                                                    onChanged:
                                                                        (String?
                                                                            newValue) {
                                                                      setState(
                                                                          () {
                                                                        selectedItemId2 =
                                                                            newValue;
                                                                      });
                                                                    },
                                                                    items: fetchedItemBrands.map(
                                                                        (ItemsBrand
                                                                            itemBrand) {
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value: itemBrand
                                                                            .id,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 2.0,
                                                                              vertical: 0.0),
                                                                          child:
                                                                              Text(itemBrand.name),
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                    searchMatchFn:
                                                                        (item,
                                                                            searchValue) {
                                                                      final itemBrand = fetchedItemBrands
                                                                          .firstWhere((e) =>
                                                                              e.id ==
                                                                              item.value)
                                                                          .name;
                                                                      return itemBrand
                                                                          .toLowerCase()
                                                                          .contains(
                                                                              searchValue.toLowerCase());
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          const Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                'Code No',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          14,
                                                                          63,
                                                                          147),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .055,
                                                                child:
                                                                    TextFormField(
                                                                  enabled:
                                                                      false,
                                                                  controller:
                                                                      controllers
                                                                          .codeNoController,
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  cursorHeight:
                                                                      21,
                                                                  textAlignVertical:
                                                                      TextAlignVertical
                                                                          .top,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0),
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Colors
                                                                            .black,
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
                                                  ],
                                                ),
                                                NISingleTextField(
                                                  labelText: 'Item Name',
                                                  flex1: 3,
                                                  flex2: 9,
                                                  controller: controllers
                                                      .itemNameController,
                                                ),
                                                NISingleTextField(
                                                  labelText: 'Print Name',
                                                  flex1: 3,
                                                  flex2: 9,
                                                  controller: controllers
                                                      .printNameController,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          const Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                'Tax Category',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          14,
                                                                          63,
                                                                          147),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .055,
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .black, // Choose the border color you prefer
                                                                      width:
                                                                          1.0, // Adjust the border width
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            0), // Adjust the border radius
                                                                  ),
                                                                  child:
                                                                      DropdownButtonHideUnderline(
                                                                    child: DropdownButton<
                                                                        String>(
                                                                      value:
                                                                          selectedTaxRateId,
                                                                      underline:
                                                                          Container(),
                                                                      onChanged:
                                                                          (String?
                                                                              newValue) {
                                                                        setState(
                                                                            () {
                                                                          selectedTaxRateId =
                                                                              newValue;
                                                                        });
                                                                      },
                                                                      items: fetchedTaxCategories.map(
                                                                          (TaxRate
                                                                              taxRate) {
                                                                        return DropdownMenuItem<
                                                                            String>(
                                                                          value:
                                                                              taxRate.id,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                                                            child:
                                                                                Text('${taxRate.rate}%'),
                                                                          ),
                                                                        );
                                                                      }).toList(),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          const Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                'HSN Code',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          14,
                                                                          63,
                                                                          147),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .055,
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .black, // Choose the border color you prefer
                                                                      width:
                                                                          1.0, // Adjust the border width
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            0), // Adjust the border radius
                                                                  ),
                                                                  child:
                                                                      SearchableDropDown(
                                                                    controller:
                                                                        controllers
                                                                            .itemHsnController,
                                                                    searchController:
                                                                        controllers
                                                                            .itemHsnController,
                                                                    value:
                                                                        selectedHSNCodeId,
                                                                    onChanged:
                                                                        (String?
                                                                            newValue) {
                                                                      setState(
                                                                          () {
                                                                        selectedHSNCodeId =
                                                                            newValue;
                                                                      });
                                                                    },
                                                                    items: fetchedHSNCodes.map(
                                                                        (HSNCode
                                                                            hsnCode) {
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value: hsnCode
                                                                            .id,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text(
                                                                                '${hsnCode.description}(${hsnCode.hsn})',
                                                                                style: const TextStyle(
                                                                                  fontSize: 16,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                ),
                                                                                maxLines: 2,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                    searchMatchFn:
                                                                        (item,
                                                                            searchValue) {
                                                                      final itemHsn = fetchedHSNCodes
                                                                          .firstWhere((e) =>
                                                                              e.id ==
                                                                              item.value)
                                                                          .description;
                                                                      return itemHsn
                                                                          .toLowerCase()
                                                                          .contains(
                                                                              searchValue.toLowerCase());
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .6,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .44,
                                        decoration: const BoxDecoration(
                                            border: Border(
                                          left: BorderSide(color: Colors.black),
                                          bottom:
                                              BorderSide(color: Colors.black),
                                        )),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const DottedLine(
                                              direction: Axis.horizontal,
                                              lineLength: double.infinity,
                                              lineThickness: 1.0,
                                              dashLength: 4.0,
                                              dashColor: Colors.black,
                                              dashRadius: 0.0,
                                              dashGapLength: 4.0,
                                              dashGapColor: Colors.transparent,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4, top: 4),
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .04,
                                                width: screenWidth < 900
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        .14
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.1,
                                                color: const Color.fromARGB(
                                                    255, 14, 63, 147),
                                                child: Text(
                                                  ' STOCK OPTIONS',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          screenWidth < 1030
                                                              ? 11.0
                                                              : 14.0),
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          const Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                  'Store Location',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          14,
                                                                          63,
                                                                          147))),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .055,
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .black, // Choose the border color you prefer
                                                                      width:
                                                                          1.0, // Adjust the border width
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            0), // Adjust the border radius
                                                                  ),
                                                                  child:
                                                                      DropdownButtonHideUnderline(
                                                                    child: DropdownButton<
                                                                        String>(
                                                                      value:
                                                                          selectedStoreLocationId,
                                                                      underline:
                                                                          Container(),
                                                                      onChanged:
                                                                          (String?
                                                                              newValue) {
                                                                        setState(
                                                                            () {
                                                                          selectedStoreLocationId =
                                                                              newValue;
                                                                        });
                                                                      },
                                                                      items: fetchedStores.map(
                                                                          (StoreLocation
                                                                              storeLocation) {
                                                                        return DropdownMenuItem<
                                                                            String>(
                                                                          value:
                                                                              storeLocation.id,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Text(storeLocation.location),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      }).toList(),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          const Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                'Barcode Sr',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          14,
                                                                          63,
                                                                          147),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .1,
                                                                child:
                                                                    TextFormField(
                                                                  enabled:
                                                                      false,
                                                                  controller:
                                                                      controllers
                                                                          .barcodeController,
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  cursorHeight:
                                                                      21,
                                                                  textAlignVertical:
                                                                      TextAlignVertical
                                                                          .top,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0),
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Colors
                                                                            .black,
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
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          const Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                'Measurement Unit',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          14,
                                                                          63,
                                                                          147),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .055,
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .black, // Choose the border color you prefer
                                                                      width:
                                                                          1.0, // Adjust the border width
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            0), // Adjust the border radius
                                                                  ),
                                                                  child:
                                                                      DropdownButtonHideUnderline(
                                                                    child: DropdownButton<
                                                                        String>(
                                                                      value:
                                                                          selectedMeasurementLimitId,
                                                                      underline:
                                                                          Container(),
                                                                      onChanged:
                                                                          (String?
                                                                              newValue) {
                                                                        setState(
                                                                            () {
                                                                          selectedMeasurementLimitId =
                                                                              newValue;
                                                                        });
                                                                      },
                                                                      items: fetchedMLimits.map(
                                                                          (MeasurementLimit
                                                                              measurementLimit) {
                                                                        return DropdownMenuItem<
                                                                            String>(
                                                                          value:
                                                                              measurementLimit.id,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Text(measurementLimit.measurement),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      }).toList(),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          const Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                'Secondary Unit',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          14,
                                                                          63,
                                                                          147),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .055,
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .black, // Choose the border color you prefer
                                                                      width:
                                                                          1.0, // Adjust the border width
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            0), // Adjust the border radius
                                                                  ),
                                                                  child:
                                                                      DropdownButtonHideUnderline(
                                                                    child: DropdownButton<
                                                                        String>(
                                                                      value:
                                                                          selectedSecondaryUnitId,
                                                                      underline:
                                                                          Container(),
                                                                      onChanged:
                                                                          (String?
                                                                              newValue) {
                                                                        setState(
                                                                            () {
                                                                          selectedSecondaryUnitId =
                                                                              newValue;
                                                                        });
                                                                      },
                                                                      items: fetchedSUnit.map(
                                                                          (SecondaryUnit
                                                                              secondaryUnit) {
                                                                        return DropdownMenuItem<
                                                                            String>(
                                                                          value:
                                                                              secondaryUnit.id,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Text(secondaryUnit.secondaryUnit),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      }).toList(),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          const Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                  'Minimum Stock',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          14,
                                                                          63,
                                                                          147))),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .055,
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      controllers
                                                                          .minimumStockController,
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  cursorHeight:
                                                                      21,
                                                                  textAlignVertical:
                                                                      TextAlignVertical
                                                                          .top,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0),
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Colors
                                                                            .black,
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
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          const Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                'Maximum Stock',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          14,
                                                                          63,
                                                                          147),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .055,
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      controllers
                                                                          .maximumStockController,
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  cursorHeight:
                                                                      21,
                                                                  textAlignVertical:
                                                                      TextAlignVertical
                                                                          .top,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0),
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Colors
                                                                            .black,
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
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          const Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                  'Monthly Sale Qty',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          14,
                                                                          63,
                                                                          147))),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 6,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .055,
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      controllers
                                                                          .monthlySalesQtyController,
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  cursorHeight:
                                                                      21,
                                                                  textAlignVertical:
                                                                      TextAlignVertical
                                                                          .top,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0),
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Colors
                                                                            .black,
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
                                                    Expanded(
                                                      child: Visibility(
                                                        visible: false,
                                                        child: Row(
                                                          children: [
                                                            const Expanded(
                                                              flex: 6,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            4.0),
                                                                child: Text(
                                                                  'Maximum Stock',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            14,
                                                                            63,
                                                                            147),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 6,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        4.0),
                                                                child: SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      .055,
                                                                  child:
                                                                      TextFormField(
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    cursorHeight:
                                                                        21,
                                                                    textAlignVertical:
                                                                        TextAlignVertical
                                                                            .top,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(0),
                                                                        borderSide:
                                                                            const BorderSide(
                                                                          color:
                                                                              Colors.black,
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
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .6,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .44,
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    color: Colors.black),
                                                right: BorderSide(
                                                    color: Colors.black),
                                                left: BorderSide(
                                                    color: Colors.black))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4),
                                              child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .04,
                                                  width: screenWidth < 900
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .14
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.1,
                                                  color: const Color.fromARGB(
                                                      255, 14, 63, 147),
                                                  child: Text(
                                                    ' PRICE DETAILS',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            screenWidth < 1030
                                                                ? 11.0
                                                                : 14.0),
                                                  )),
                                            ),
                                            // NIEditableTable()
                                            NInewTable(
                                              dealerController:
                                                  controllers.dealerController,
                                              subDealerController: controllers
                                                  .subDealerController,
                                              retailController:
                                                  controllers.retailController,
                                              mrpController:
                                                  controllers.mrpController,
                                              dateController:
                                                  controllers.dateController,
                                              currentPriceController:
                                                  controllers
                                                      .currentPriceController,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .6,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .44,
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                right: BorderSide(
                                                  color: Colors.black,
                                                ),
                                                bottom: BorderSide(
                                                    color: Colors.black),
                                                left: BorderSide(
                                                    color: Colors.black))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const DottedLine(
                                              direction: Axis.horizontal,
                                              lineLength: double.infinity,
                                              lineThickness: 1.0,
                                              dashLength: 4.0,
                                              dashColor: Colors.black,
                                              dashRadius: 0.0,
                                              dashGapLength: 4.0,
                                              dashGapColor: Colors.transparent,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4, top: 4),
                                              child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .04,
                                                  width: screenWidth < 900
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .14
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.1,
                                                  color: const Color.fromARGB(
                                                      255, 14, 63, 147),
                                                  child: Text(
                                                    ' ITEM IMAGES',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            screenWidth < 1030
                                                                ? 11.0
                                                                : 14.0),
                                                  )),
                                            ),
                                            Column(children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                      'Update Image ? :',
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Color.fromARGB(
                                                              255,
                                                              14,
                                                              63,
                                                              147)),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .01,
                                                    ),
                                                    SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .13,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .055,
                                                        child: const TextField(
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          cursorHeight: 21,
                                                          textAlignVertical:
                                                              TextAlignVertical
                                                                  .top,
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .01,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black)),
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.29,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.22,
                                                      child: _selectedImages
                                                              .isEmpty
                                                          ? const Center(
                                                              child: Text(
                                                                  'No Image Selected'))
                                                          : Image.memory(
                                                              _selectedImages[
                                                                  0]),
                                                    ),
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1.0),
                                                          child: ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              FilePickerResult?
                                                                  result =
                                                                  await FilePicker
                                                                      .platform
                                                                      .pickFiles(
                                                                type: FileType
                                                                    .custom,
                                                                allowedExtensions: [
                                                                  'jpg',
                                                                  'jpeg',
                                                                  'png',
                                                                  'gif'
                                                                ],
                                                              );

                                                              if (result !=
                                                                  null) {
                                                                // setState(() {
                                                                //   _filePickerResult =
                                                                //       result;
                                                                // });
                                                                List<Uint8List>
                                                                    fileBytesList =
                                                                    [];

                                                                for (PlatformFile file
                                                                    in result
                                                                        .files) {
                                                                  Uint8List
                                                                      fileBytes =
                                                                      file.bytes!;
                                                                  fileBytesList.add(
                                                                      fileBytes);
                                                                }

                                                                setState(() {
                                                                  _selectedImages
                                                                      .addAll(
                                                                          fileBytesList);
                                                                });

                                                                // print(_selectedImages);
                                                              } else {
                                                                // User canceled the picker
                                                                print(
                                                                    'File picking canceled by the user.');
                                                              }
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              foregroundColor:
                                                                  Colors.black,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              fixedSize: Size(
                                                                  buttonWidth,
                                                                  buttonHeight),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0),
                                                              ),
                                                              side:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            child: Text(
                                                              'Add',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      screenWidth <
                                                                              1030
                                                                          ? 11.0
                                                                          : 13.0),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1.0),
                                                          child: ElevatedButton(
                                                            onPressed: () {},
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              foregroundColor:
                                                                  Colors.black,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              fixedSize: Size(
                                                                  buttonWidth,
                                                                  buttonHeight),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0),
                                                              ),
                                                              side:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            child: Center(
                                                                child: Text(
                                                              'Delete',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      screenWidth <
                                                                              1030
                                                                          ? 11.0
                                                                          : 13.0),
                                                            )),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1.0),
                                                          child: ElevatedButton(
                                                            onPressed: () {},
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              foregroundColor:
                                                                  Colors.black,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              fixedSize: Size(
                                                                  buttonWidth,
                                                                  buttonHeight),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0),
                                                              ),
                                                              side:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            child: Text(
                                                              'Next',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      screenWidth <
                                                                              1030
                                                                          ? 11.0
                                                                          : 13.0),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1.0),
                                                          child: ElevatedButton(
                                                            onPressed: () {},
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              foregroundColor:
                                                                  Colors.black,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              fixedSize: Size(
                                                                  buttonWidth,
                                                                  buttonHeight),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0),
                                                              ),
                                                              side:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            child: Text(
                                                              'Previous',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      screenWidth <
                                                                              1030
                                                                          ? 11.0
                                                                          : 13.0),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1.0),
                                                          child: ElevatedButton(
                                                            onPressed: () {},
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              foregroundColor:
                                                                  Colors.black,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              fixedSize: Size(
                                                                  buttonWidth,
                                                                  buttonHeight),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0),
                                                              ),
                                                              side:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            child: Text(
                                                              'Zoom',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      screenWidth <
                                                                              1030
                                                                          ? 11.0
                                                                          : 13.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ]),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height * .1,
                                width: MediaQuery.of(context).size.width * .88,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                          color: Colors.black,
                                        ),
                                        bottom: BorderSide(
                                          color: Colors.black,
                                        ),
                                        left: BorderSide(color: Colors.black))),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Opening Stock (F7) :',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 14, 63, 147)),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .01,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .13,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .055,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors
                                                  .black, // Choose the border color you prefer
                                              width:
                                                  1.0, // Adjust the border width
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                0), // Adjust the border radius
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: selectedStock,
                                              underline: Container(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedStock = newValue!;
                                                });
                                              },
                                              items: stock.map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(value),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .03,
                                      ),
                                      const Text(
                                        'Is Active :',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 14, 63, 147)),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .01,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .13,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .055,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors
                                                  .black, // Choose the border color you prefer
                                              width:
                                                  1.0, // Adjust the border width
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                0), // Adjust the border radius
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: selectedStatus,
                                              underline: Container(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedStatus = newValue!;
                                                });
                                              },
                                              items: status.map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(value),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .01,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    fixedSize: Size(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .1,
                                                        25),
                                                    shape:
                                                        const BeveledRectangleBorder(
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: .3)),
                                                    backgroundColor:
                                                        Colors.yellow.shade100),
                                                onPressed: () {
                                                  if (selectedStock == 'Yes') {
                                                    showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return StatefulBuilder(
                                                          builder: (context,
                                                              setState) {
                                                            return AlertDialog(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              content: SizedBox(
                                                                height: 500,
                                                                width: 1000,
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          1000,
                                                                      height:
                                                                          50,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                              color: Colors.blue[600]),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            const SizedBox(),
                                                                            const Spacer(),
                                                                            const Text(
                                                                              'Opening Stock Entry',
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                            const Spacer(),
                                                                            IconButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              icon: const Icon(
                                                                                Icons.close_outlined,
                                                                                color: Colors.white,
                                                                                // size: 36.0,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            2),
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .topCenter,
                                                                      width:
                                                                          990,
                                                                      height:
                                                                          350,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border:
                                                                            Border.all(),
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Container(
                                                                                height: 30,
                                                                                width: 70,
                                                                                decoration: const BoxDecoration(border: Border(bottom: BorderSide(), top: BorderSide(), left: BorderSide())),
                                                                                child: const Padding(
                                                                                  padding: EdgeInsets.all(2.0),
                                                                                  child: Text(
                                                                                    'Sr',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: 30,
                                                                                width: 250,
                                                                                decoration: const BoxDecoration(border: Border(bottom: BorderSide(), top: BorderSide(), left: BorderSide())),
                                                                                child: const Padding(
                                                                                  padding: EdgeInsets.all(2.0),
                                                                                  child: Text(
                                                                                    'Qty',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: 30,
                                                                                width: 130,
                                                                                decoration: const BoxDecoration(border: Border(bottom: BorderSide(), top: BorderSide(), left: BorderSide())),
                                                                                child: const Padding(
                                                                                  padding: EdgeInsets.all(2.0),
                                                                                  child: Text(
                                                                                    'Unit',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: 30,
                                                                                width: 250,
                                                                                decoration: const BoxDecoration(border: Border(bottom: BorderSide(), top: BorderSide(), left: BorderSide())),
                                                                                child: const Padding(
                                                                                  padding: EdgeInsets.all(2.0),
                                                                                  child: Text(
                                                                                    'Rate',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: 30,
                                                                                width: 250,
                                                                                decoration: BoxDecoration(border: Border.all()),
                                                                                child: const Padding(
                                                                                  padding: EdgeInsets.all(2.0),
                                                                                  child: Text(
                                                                                    'Total',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 30,
                                                                                width: 30,
                                                                                child: IconButton(
                                                                                  onPressed: () {
                                                                                    final entryId = UniqueKey().toString();
                                                                                    setState(() {
                                                                                      _newWidget.add(
                                                                                        NItableEdit(
                                                                                          key: ValueKey(entryId),
                                                                                          serialNo: _newWidget.length + 1,
                                                                                          oPBalanceQtyI: TextEditingController(),
                                                                                          oPBalanceUnitI: TextEditingController(),
                                                                                          oPBalanceRatetI: TextEditingController(),
                                                                                          oPBalanceTotaltI: TextEditingController(),
                                                                                          onSaveValues: saveValues,
                                                                                          entryId: entryId,
                                                                                        ),
                                                                                      );
                                                                                    });
                                                                                  },
                                                                                  icon: const Icon(
                                                                                    Icons.add,
                                                                                    color: Colors.black,
                                                                                    size: 30.0,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Column(
                                                                            children:
                                                                                _newWidget,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            2),
                                                                    Container(
                                                                      width:
                                                                          990,
                                                                      height:
                                                                          50,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border:
                                                                            Border.all(),
                                                                      ),
                                                                      child:
                                                                          const Row(
                                                                        children: [
                                                                          // SizedBox(
                                                                          //   width: 200,
                                                                          //   child: Text(
                                                                          //     '$totalQty',
                                                                          //     style: TextStyle(color: Color.fromARGB(255, 4, 26, 228), fontSize: 14, fontWeight: FontWeight.bold),
                                                                          //     textAlign: TextAlign.end,
                                                                          //   ),
                                                                          // ),
                                                                          // SizedBox(
                                                                          //   width: 620,
                                                                          //   child: Text(
                                                                          //     '$totalAmount',
                                                                          //     style: TextStyle(color: Color.fromARGB(255, 4, 26, 228), fontSize: 14, fontWeight: FontWeight.bold),
                                                                          //     textAlign: TextAlign.end,
                                                                          //   ),
                                                                          // ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            5),
                                                                    Row(
                                                                      children: [
                                                                        const SizedBox(),
                                                                        const Spacer(),
                                                                        ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                              fixedSize: Size(MediaQuery.of(context).size.width * .1, 25),
                                                                              shape: const BeveledRectangleBorder(side: BorderSide(color: Colors.black, width: .3)),
                                                                              backgroundColor: Colors.yellow.shade100),
                                                                          onPressed:
                                                                              createItems,
                                                                          child:
                                                                              const Text(
                                                                            'Save',
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 12),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                10),
                                                                        ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                              fixedSize: Size(MediaQuery.of(context).size.width * .1, 25),
                                                                              shape: const BeveledRectangleBorder(side: BorderSide(color: Colors.black, width: .3)),
                                                                              backgroundColor: Colors.yellow.shade100),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            'Cancel',
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 12),
                                                                          ),
                                                                        ),
                                                                        const Spacer(),
                                                                        const SizedBox(),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    createItems();
                                                  }
                                                },
                                                child: const Text(
                                                  'Save [F4]',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .002,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  fixedSize: Size(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .1,
                                                      25),
                                                  shape:
                                                      const BeveledRectangleBorder(
                                                          side: BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width: .3)),
                                                  backgroundColor:
                                                      Colors.yellow.shade100),
                                              onPressed: () {},
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          key: _key,
          type: ExpandableFabType.side,
          overlayStyle: ExpandableFabOverlayStyle(
            color: Colors.black.withOpacity(0.5),
          ),
          // distance: 100,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const Responsive_measurementunit(),
                      ),
                    );
                  },
                  child: const Icon(Icons.balance_outlined),
                ),
                const SizedBox(height: 8),
                Text(
                  'Stock Unit',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const Responsive_NewHSNCommodity(),
                      ),
                    );
                  },
                  child: const Icon(Icons.code),
                ),
                const SizedBox(height: 8),
                Text(
                  'HSN',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    final TextEditingController catNameController =
                        TextEditingController();
                    final TextEditingController catBrandController =
                        TextEditingController();
                    final TextEditingController catDescController =
                        TextEditingController();
                    List<Uint8List> selectedImage = [];
                    Alert(
                        context: context,
                        title: "ADD BRAND",
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: catBrandController,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.category),
                                    labelText: 'Brand Name',
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          },
                        ),
                        buttons: [
                          DialogButton(
                            color: Colors.yellow.shade100,
                            onPressed: () {
                              itemsBrand.createItemBrand(
                                name: catBrandController.text,
                              );

                              _fetchData();

                              Navigator.pop(context);
                            },
                            child: Text(
                              "CREATE",
                              style: GoogleFonts.poppins(
                                  color: Colors.black, fontSize: 20),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DialogButton(
                            color: Colors.yellow.shade100,
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "CANCEL",
                              style: GoogleFonts.poppins(
                                  color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ]).show();
                  },
                  child: const Icon(Icons.branding_watermark),
                ),
                const SizedBox(height: 8),
                Text(
                  'Brand',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    final TextEditingController catNameController =
                        TextEditingController();
                    final TextEditingController catDescController =
                        TextEditingController();
                    List<Uint8List> selectedImage = [];
                    Alert(
                        context: context,
                        title: "ADD ITEM GROUP",
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                              children: <Widget>[
                                TextField(
                                  controller: catNameController,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.category),
                                    labelText: 'Category Name',
                                  ),
                                ),
                                TextField(
                                  controller: catDescController,
                                  obscureText: false,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.description),
                                    labelText: 'Category Description',
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      decoration: BoxDecoration(
                                        color: Colors.white10,
                                        border: Border.all(
                                            color: Colors.black, width: 2),
                                      ),
                                      child: selectedImage.isEmpty
                                          ? const Center(
                                              child: Text(
                                                'No Image Selected',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          : Image.memory(selectedImage[0]),
                                    ),
                                    Positioned(
                                      top: 150,
                                      right: -10,
                                      left: 0,
                                      child: GestureDetector(
                                        onTap: () async {
                                          FilePickerResult? result =
                                              await FilePicker.platform
                                                  .pickFiles(
                                            type: FileType.custom,
                                            allowedExtensions: [
                                              'jpg',
                                              'jpeg',
                                              'png',
                                              'gif'
                                            ],
                                          );

                                          if (result != null) {
                                            List<Uint8List> fileBytesList = [];

                                            for (PlatformFile file
                                                in result.files) {
                                              Uint8List fileBytes = file.bytes!;
                                              fileBytesList.add(fileBytes);
                                            }

                                            setState(() {
                                              selectedImage
                                                  .addAll(fileBytesList);
                                            });

                                            // print(_selectedImages);
                                          } else {
                                            // User canceled the picker
                                            print(
                                                'File picking canceled by the user.');
                                          }
                                        },
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: SizedBox(
                                            height: 50,
                                            child: CircleAvatar(
                                              radius: 50,
                                              backgroundColor:
                                                  Colors.yellow.shade100,
                                              child: const Icon(Icons.upload),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        buttons: [
                          DialogButton(
                            color: Colors.yellow.shade100,
                            onPressed: () {
                              itemsGroup.createItemsGroup(
                                name: catNameController.text,
                                desc: catDescController.text,
                                images: selectedImage == []
                                    ? []
                                    : selectedImage
                                        .map((image) => ImageData(
                                              data: image,
                                              contentType: 'image/jpeg',
                                              filename: 'filename.jpg',
                                            ))
                                        .toList(),
                              );

                              _fetchData();

                              Navigator.pop(context);
                            },
                            child: Text(
                              "CREATE",
                              style: GoogleFonts.poppins(
                                  color: Colors.black, fontSize: 20),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DialogButton(
                            color: Colors.yellow.shade100,
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "CANCEL",
                              style: GoogleFonts.poppins(
                                  color: Colors.black, fontSize: 20),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ]).show();
                  },
                  child: const Icon(Icons.category),
                ),
                const SizedBox(height: 8),
                Text(
                  'Item Group',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
