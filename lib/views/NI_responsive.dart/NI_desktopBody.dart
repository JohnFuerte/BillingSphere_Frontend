// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:billingsphere/data/models/brand/item_brand_model.dart';
import 'package:billingsphere/data/models/hsn/hsn_model.dart';
import 'package:billingsphere/data/models/item/item_model.dart';
import 'package:billingsphere/data/models/itemGroup/item_group_model.dart';
import 'package:billingsphere/data/models/measurementLimit/measurement_limit_model.dart';
import 'package:billingsphere/data/models/secondaryUnit/secondary_unit_model.dart';
import 'package:billingsphere/data/models/storeLocation/store_location_model.dart';
import 'package:billingsphere/data/models/taxCategory/tax_category_model.dart';
import 'package:billingsphere/data/repository/item_brand_repository.dart';
import 'package:billingsphere/data/repository/item_repository.dart';
import 'package:billingsphere/logic/cubits/itemBrand_cubit/itemBrand_state.dart';
import 'package:billingsphere/logic/cubits/itemGroup_cubit/itemGroup_cubit.dart';
import 'package:billingsphere/utils/controllers/items_text_controllers.dart';
import 'package:billingsphere/views/NI_widgets/NI_new_table.dart';
import 'package:billingsphere/views/NI_widgets/NI_singleTextField.dart';
import 'package:billingsphere/views/searchable_dropdown.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import '../sumit_screen/hsn_code/hsn_code.dart';
import '../sumit_screen/measurement_unit/measurement_unit.dart';
import 'NI_home.dart';

class NIMyDesktopBody extends StatefulWidget {
  const NIMyDesktopBody({super.key});

  @override
  State<NIMyDesktopBody> createState() => _BasicDetailsState();
}

class _BasicDetailsState extends State<NIMyDesktopBody> {
  List<List<String>> tableData = [
    // Initial data for the table
    ["Header 1", "Header 2", "Header 3"],
    ["Data 1", "Data 2", "Data 3"],
  ];
  ItemsGroupService itemsGroup = ItemsGroupService();
  ItemsBrandsService itemsBrand = ItemsBrandsService();
  ItemsFormControllers controllers = ItemsFormControllers();
  bool _isSaving = false;
  ItemsService items = ItemsService();
  List<Uint8List> _selectedImages = [];
  final List<Widget> openingBalance = [];
  Map<String, dynamic> saveOpeningbalance = {};
  final List<Map<String, dynamic>> storesData = [];
  double totalQty = 0;
  double totalAmount = 0;

  List<String>? companyCode;
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

    items.createItem(
      itemGroup: selectedItemId!,
      companyCode: companyCode!.first,
      itemBrand: selectedItemId2!,
      itemName: controllers.itemNameController.text,
      printName: controllers.printNameController.text,
      codeNo: controllers.codeNoController.text,
      taxCategory: selectedTaxRateId!,
      hsnCode: selectedHSNCodeId!,
      barcode: controllers.barcodeController.text,
      storeLocation: selectedStoreLocationId!,
      measurementUnit: selectedMeasurementLimitId!,
      secondaryUnit: selectedSecondaryUnitId!,
      minimumStock:
          int.tryParse(controllers.minimumStockController.text.trim()) ?? 0,
      maximumStock:
          ((int.tryParse(controllers.minimumStockController.text.trim()) ?? 0) +
                  totalQty)
              .toInt(),
      monthlySalesQty:
          int.tryParse(controllers.monthlySalesQtyController.text.trim()) ?? 0,
      dealer: double.parse(controllers.dealerController.text),
      subDealer: double.parse(controllers.subDealerController.text),
      retail: double.parse(controllers.retailController.text),
      mrp: double.parse(controllers.mrpController.text),
      openingStock: selectedStock,
      status: selectedStatus,
      context: context,
      date: controllers.dateController.text,
      images: imageList ?? [],
      openingBalance: storesData.map((e) {
        return OpeningBalance(
          qty: e['qty'],
          unit: e['unit'],
          rate: e['rate'],
          total: e['total'],
        );
      }).toList(),
      openingBalanceQty: totalQty,
      openingBalanceAmt: totalAmount,
    );

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
    selectedUnitId = fetchedMLimits.first.id;
    selectedSecondaryUnitId = fetchedSUnit.first.id;
    imageList = [];
    _selectedImages = [];
    selectedStatus = 'Active';
    selectedStock = 'Yes';
    _generateRandomNumber();

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

  // Variables
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ExpandableFabState> _key = GlobalKey<ExpandableFabState>();

  int _generatedNumber = 0;
  Random random = Random();
  bool isFetched = false;
  FocusNode _focusNode = FocusNode();

  // Dropdown Values
  String? selectedItemId;
  String? selectedItemId2;
  String? selectedTaxRateId;
  String? selectedHSNCodeId;
  String? selectedStoreLocationId;
  String? selectedMeasurementLimitId;
  String? selectedUnitId;
  String? selectedSecondaryUnitId;
  String selectedStatus = 'Active';
  String selectedStock = 'No';

  void _generateRandomNumber() {
    setState(() {
      int seed = DateTime.now().millisecondsSinceEpoch;
      Random random = Random(seed);
      _generatedNumber = random.nextInt(900) + 100;
      controllers.codeNoController.text = _generatedNumber.toString();
    });
  }

  void _generateBarcode() {
    setState(() {
      int firstPart = Random().nextInt(1000000000);
      int secondPart = Random().nextInt(1000);
      _generatedNumber = int.parse('$firstPart$secondPart');
      controllers.barcodeController.text = _generatedNumber.toString();
    });
  }

  Future<void> _initializeData() async {
    await Future.wait([
      _fetchData(),
      setCompanyCode(),
    ]);
  }

  void _initControllers() {
    String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    controllers.dateController.text = formattedDate;
    controllers.maximumStockController.text = '0';
    controllers.minimumStockController.text = '0';
    controllers.monthlySalesQtyController.text = '0';
    controllers.dealerController.text = '0';
    controllers.subDealerController.text = '0';
    controllers.retailController.text = '0';
    controllers.mrpController.text = '0';
    controllers.currentPriceController.text = '0.0';
  }

  void _allDataInit() {
    _initializeData();
    _generateRandomNumber();
    _generateBarcode();
    _initControllers();
  }

  @override
  void initState() {
    _allDataInit();
    super.initState();
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Method to fetch data from Cubits
  Future<void> _fetchData() async {
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

  void initializeControllers() {
    controllers.oPBQtyController = TextEditingController();
    controllers.oPBUnitController = TextEditingController();
    controllers.oPBRateController = TextEditingController();
    controllers.oPBTotalController = TextEditingController();
  }

  void calculateTotals() {
    totalQty = storesData.fold(0, (sum, item) => sum + (item['qty'] ?? 0));
    totalAmount =
        storesData.fold(0.0, (sum, item) => sum + (item['total'] ?? 0.0));

    print('Total Qty: $totalQty');
    print('Total Amount: $totalAmount');
    print('Stores Data: $storesData');
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

  Widget buildStoresDetails({required Function() updateTotals}) {
    initializeControllers();
    final key = Random().nextInt(1000).toString();
    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          children: [
            Container(
              height: 50,
              width: 70,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(),
                      top: BorderSide(),
                      left: BorderSide())),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${openingBalance.length}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              // height: 30,
              width: 250,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(),
                  top: BorderSide(),
                  left: BorderSide(),
                ),
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(12.0),
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                cursorHeight: 20,
                controller: controllers.oPBQtyController,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 50,
              width: 130,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(),
                      top: BorderSide(),
                      left: BorderSide())),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: SearchableDropDown(
                  controller: controllers.oPBUnitController,
                  searchController: controllers.oPBUnitController,
                  value: selectedUnitId,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedUnitId = newValue;
                    });
                  },
                  items:
                      fetchedMLimits.map((MeasurementLimit measurementLimit) {
                    return DropdownMenuItem<String>(
                      value: measurementLimit.id,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text(measurementLimit.measurement),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  searchMatchFn: (item, searchValue) {
                    final itemMLimit = fetchedMLimits
                        .firstWhere((e) => e.id == item.value)
                        .measurement;
                    return itemMLimit
                        .toLowerCase()
                        .contains(searchValue.toLowerCase());
                  },
                ),
              ),
            ),
            Container(
              // height: 30,
              width: 250,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(),
                      top: BorderSide(),
                      left: BorderSide())),
              child: TextFormField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(12.0),
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                ],
                cursorHeight: 20,
                controller: controllers.oPBRateController,
                onChanged: (value) {
                  int qty =
                      int.tryParse(controllers.oPBQtyController.text) ?? 0;
                  double rate = double.tryParse(value) ?? 0;
                  double amount = qty * rate;
                  setState(() {
                    controllers.oPBTotalController.text =
                        amount.toStringAsFixed(2);
                  });

                  saveOpeningbalance = {
                    'key': key,
                    'qty': int.tryParse(controllers.oPBQtyController.text),
                    'unit': selectedUnitId,
                    'rate': double.tryParse(controllers.oPBRateController.text),
                    'total':
                        double.tryParse(controllers.oPBTotalController.text),
                  };
                  if (storesData
                      .where((element) =>
                          element['key'] == saveOpeningbalance['key'])
                      .isNotEmpty) {
                    storesData[storesData.indexWhere((element) =>
                            element['key'] == saveOpeningbalance['key'])] =
                        saveOpeningbalance;

                    // showToast('Opening Balance updated successfully');
                  } else {
                    storesData.add(saveOpeningbalance);
                    // showToast('Opening Balance added successfully');
                  }
                  updateTotals();
                },
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              // height: 30,
              width: 250,
              decoration: BoxDecoration(border: Border.all()),
              child: TextFormField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(12.0),
                ),
                cursorHeight: 20,
                controller: controllers.oPBTotalController,
                textAlign: TextAlign.center,
                readOnly: true,
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
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
    double buttonWidth = MediaQuery.of(context).size.width * 0.4;
    double buttonHeight = MediaQuery.of(context).size.height * 0.03;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35.0),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const ItemHome(),
                ),
              );
            },
          ),
          backgroundColor: const Color(0xFF8A2BE2),
          title: Text('NEW Item MOBILE',
              style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                _fetchData();
              },
              icon: const Icon(
                Icons.refresh,
              ),
            ),
          ],
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ItemBrandCubit, CubitItemBrandStates>(
            listener: (context, state) {
              if (state is CubitItemBrandLoaded) {
                setState(() {
                  fetchedItemBrands = state.itemBrands;
                  selectedItemId2 = fetchedItemBrands.first.id;
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
                  selectedItemId = fetchedItemGroups.first.id;
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
                  selectedTaxRateId = fetchedTaxCategories.first.id;
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
                  selectedHSNCodeId = fetchedHSNCodes.first.id;
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
                  selectedStoreLocationId = fetchedStores.first.id;
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
                  selectedMeasurementLimitId = fetchedMLimits.first.id;
                  selectedUnitId = fetchedMLimits.first.id;
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
                  selectedSecondaryUnitId = fetchedSUnit.first.id;
                });
              } else if (state is CubitSecondaryUnitError) {
                print(state.error);
              }
            },
          ),
        ],
        child: Column(
          children: [
            Expanded(
              child: isFetched == true
                  ? const Center(child: CircularProgressIndicator())
                  : Stack(
                      children: [
                        Opacity(
                          opacity: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const Row(
                                      children: [
                                        // Give me 5 buttons in a row
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          height: 560,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              8.0,
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0, top: 8.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.35,
                                                  color:
                                                      const Color(0xFF0000CD),
                                                  child: Text(
                                                    ' BASIC DETAILS',
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Item Group : ',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: const Color(
                                                          0xFF510986,
                                                        ),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                      height: 40,
                                                      width: screenWidth,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(),
                                                        ),
                                                        child:
                                                            SearchableDropDown(
                                                          controller: controllers
                                                              .itemGroupController,
                                                          searchController:
                                                              controllers
                                                                  .itemGroupController,
                                                          value: selectedItemId,
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
                                                                  itemGroup.id,
                                                              child: Text(
                                                                itemGroup.name,
                                                                style: GoogleFonts.poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
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
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      'Brand',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: const Color(
                                                            0xFF510986),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                      height: 40,
                                                      width: screenWidth,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(),
                                                        ),
                                                        child:
                                                            SearchableDropDown(
                                                          controller: controllers
                                                              .itemBrandController,
                                                          searchController:
                                                              controllers
                                                                  .itemBrandController,
                                                          value:
                                                              selectedItemId2,
                                                          onChanged: (String?
                                                              newValue) {
                                                            setState(() {
                                                              selectedItemId2 =
                                                                  newValue;
                                                            });
                                                          },
                                                          items: fetchedItemBrands
                                                              .map((ItemsBrand
                                                                  itemBrand) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value:
                                                                  itemBrand.id,
                                                              child: Text(
                                                                itemBrand.name,
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            );
                                                          }).toList(),
                                                          searchMatchFn: (item,
                                                              searchValue) {
                                                            final itemBrands =
                                                                fetchedItemBrands
                                                                    .firstWhere((e) =>
                                                                        e.id ==
                                                                        item.value)
                                                                    .name;
                                                            return itemBrands
                                                                .toLowerCase()
                                                                .contains(
                                                                    searchValue
                                                                        .toLowerCase());
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      'Code No',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: const Color(
                                                            0xFF510986),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    SizedBox(
                                                      height: 40,
                                                      width: screenWidth,
                                                      child: TextFormField(
                                                        enabled: false,
                                                        controller: controllers
                                                            .codeNoController,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                        cursorHeight: 21,
                                                        textAlignVertical:
                                                            TextAlignVertical
                                                                .top,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5.0,
                                                                  bottom: 8.0),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        0),
                                                            borderSide:
                                                                const BorderSide(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      'Item Name',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: const Color(
                                                            0xFF510986),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Container(
                                                      constraints:
                                                          const BoxConstraints(
                                                        maxHeight: 40,
                                                      ),
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                      ),
                                                      child: TextFormField(
                                                        controller: controllers
                                                            .itemNameController,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                        cursorHeight: 20,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: 5.0,
                                                                  bottom: 8.0),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      'Print Name',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: const Color(
                                                            0xFF510986),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Container(
                                                      constraints:
                                                          const BoxConstraints(
                                                        maxHeight: 40,
                                                      ),
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                      ),
                                                      child: TextFormField(
                                                        controller: controllers
                                                            .printNameController,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                        cursorHeight: 20,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: 5.0,
                                                                  bottom: 8.0),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      'HSN Code',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: const Color(
                                                            0xFF510986),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                      height: 40,
                                                      width: screenWidth,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(),
                                                        ),
                                                        child:
                                                            SearchableDropDown(
                                                          controller: controllers
                                                              .itemHsnController,
                                                          searchController:
                                                              controllers
                                                                  .itemHsnController,
                                                          value:
                                                              selectedHSNCodeId,
                                                          onChanged: (String?
                                                              newValue) {
                                                            setState(() {
                                                              selectedHSNCodeId =
                                                                  newValue;
                                                            });
                                                          },
                                                          items: fetchedHSNCodes
                                                              .map((HSNCode
                                                                  hsnCode) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: hsnCode.id,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      '${hsnCode.description}(${hsnCode.hsn})',
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          2,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }).toList(),
                                                          searchMatchFn: (item,
                                                              searchValue) {
                                                            final itemHsn =
                                                                fetchedHSNCodes
                                                                    .firstWhere((e) =>
                                                                        e.id ==
                                                                        item.value)
                                                                    .description;
                                                            return itemHsn
                                                                .toLowerCase()
                                                                .contains(
                                                                    searchValue
                                                                        .toLowerCase());
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      'Tax Category',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: const Color(
                                                            0xFF510986),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                      height: 40,
                                                      width: screenWidth,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(),
                                                        ),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: DropdownButton<
                                                              String>(
                                                            value:
                                                                selectedTaxRateId,
                                                            underline:
                                                                Container(),
                                                            isExpanded: true,
                                                            onChanged: (String?
                                                                newValue) {
                                                              setState(() {
                                                                selectedTaxRateId =
                                                                    newValue;
                                                              });
                                                            },
                                                            items: fetchedTaxCategories
                                                                .map((TaxRate
                                                                    taxRate) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value:
                                                                    taxRate.id,
                                                                child: Text(
                                                                  '  ${taxRate.rate}%',
                                                                  style: GoogleFonts.poppins(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 710,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              8.0,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              left: BorderSide(),
                                              right: BorderSide(),
                                              bottom: BorderSide(),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0, top: 8.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.35,
                                                  color:
                                                      const Color(0xFF0000CD),
                                                  child: Text(
                                                    ' STOCK OPTIONS',
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Store Location',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: const Color(
                                                            0xFF510986),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                      height: 40,
                                                      width: screenWidth,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(),
                                                        ),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: DropdownButton<
                                                              String>(
                                                            value:
                                                                selectedStoreLocationId,
                                                            underline:
                                                                Container(),
                                                            isExpanded: true,
                                                            onChanged: (String?
                                                                newValue) {
                                                              setState(() {
                                                                selectedStoreLocationId =
                                                                    newValue;
                                                              });
                                                            },
                                                            items: fetchedStores
                                                                .map((StoreLocation
                                                                    storeLocation) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value:
                                                                    storeLocation
                                                                        .id,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        '  ${storeLocation.location}',
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              15,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      'Barcode Sr',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: const Color(
                                                            0xFF510986),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Container(
                                                      constraints:
                                                          const BoxConstraints(
                                                        maxHeight: 40,
                                                      ),
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                      ),
                                                      child: TextFormField(
                                                        controller: controllers
                                                            .barcodeController,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                        cursorHeight: 20,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: 5.0,
                                                                  bottom: 8.0),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      'Stock Unit',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: const Color(
                                                            0xFF510986),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                      height: 40,
                                                      width: screenWidth,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(),
                                                        ),
                                                        child:
                                                            SearchableDropDown(
                                                          controller: controllers
                                                              .itemMeasureunitController,
                                                          searchController:
                                                              controllers
                                                                  .itemMeasureunitController,
                                                          value:
                                                              selectedMeasurementLimitId,
                                                          onChanged: (String?
                                                              newValue) {
                                                            setState(() {
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
                                                                  measurementLimit
                                                                      .id,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    measurementLimit
                                                                        .measurement,
                                                                    style: GoogleFonts.poppins(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }).toList(),
                                                          searchMatchFn: (item,
                                                              searchValue) {
                                                            final itemMLimit =
                                                                fetchedMLimits
                                                                    .firstWhere((e) =>
                                                                        e.id ==
                                                                        item.value)
                                                                    .measurement;
                                                            return itemMLimit
                                                                .toLowerCase()
                                                                .contains(
                                                                    searchValue
                                                                        .toLowerCase());
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      'Secondary Unit',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: const Color(
                                                            0xFF510986),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                      height: 40,
                                                      width: screenWidth,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(),
                                                        ),
                                                        child:
                                                            SearchableDropDown(
                                                          controller: controllers
                                                              .itemMeasureunitController,
                                                          searchController:
                                                              controllers
                                                                  .itemMeasureunitController,
                                                          value:
                                                              selectedSecondaryUnitId,
                                                          onChanged: (String?
                                                              newValue) {
                                                            setState(() {
                                                              selectedSecondaryUnitId =
                                                                  newValue;
                                                            });
                                                          },
                                                          items: fetchedSUnit
                                                              .map((SecondaryUnit
                                                                  secondaryUnit) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value:
                                                                  secondaryUnit
                                                                      .id,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      secondaryUnit
                                                                          .secondaryUnit,
                                                                      style: GoogleFonts.poppins(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }).toList(),
                                                          searchMatchFn: (item,
                                                              searchValue) {
                                                            final itemSunit = fetchedSUnit
                                                                .firstWhere((e) =>
                                                                    e.id ==
                                                                    item.value)
                                                                .secondaryUnit;
                                                            return itemSunit
                                                                .toLowerCase()
                                                                .contains(
                                                                    searchValue
                                                                        .toLowerCase());
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      'Minimum Stock',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: const Color(
                                                            0xFF510986),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Container(
                                                      constraints:
                                                          const BoxConstraints(
                                                        maxHeight: 40,
                                                      ),
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                      ),
                                                      child: TextFormField(
                                                        controller: controllers
                                                            .minimumStockController,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                        cursorHeight: 20,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: 5.0,
                                                                  bottom: 8.0),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      'Maximum Stock',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: const Color(
                                                            0xFF510986),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Container(
                                                      constraints:
                                                          const BoxConstraints(
                                                        maxHeight: 40,
                                                      ),
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                      ),
                                                      child: TextFormField(
                                                        controller: controllers
                                                            .maximumStockController,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                        cursorHeight: 20,
                                                        textAlignVertical:
                                                            TextAlignVertical
                                                                .top,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: 5.0,
                                                                  bottom: 8.0),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      'Monthly Sale Qty',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: const Color(
                                                            0xFF510986),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Container(
                                                      constraints:
                                                          const BoxConstraints(
                                                        maxHeight: 40,
                                                      ),
                                                      width: screenWidth,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                      ),
                                                      child: TextFormField(
                                                        controller: controllers
                                                            .monthlySalesQtyController,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                        cursorHeight: 20,
                                                        textAlignVertical:
                                                            TextAlignVertical
                                                                .top,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: 5.0,
                                                                  bottom: 8.0),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      'Opening Stock :',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: const Color(
                                                            0xFF510986),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth,
                                                      height: 40,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(),
                                                        ),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: DropdownButton<
                                                              String>(
                                                            value:
                                                                selectedStock,
                                                            underline:
                                                                Container(),
                                                            isExpanded: true,
                                                            onChanged: (String?
                                                                newValue) {
                                                              setState(() {
                                                                selectedStock =
                                                                    newValue!;
                                                              });
                                                            },
                                                            items: stock.map(
                                                                (String value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child: Text(
                                                                  '  $value',
                                                                  style: GoogleFonts.poppins(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      'Is Active :',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: const Color(
                                                            0xFF510986),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth,
                                                      height: 40,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(),
                                                        ),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: DropdownButton<
                                                              String>(
                                                            value:
                                                                selectedStatus,
                                                            underline:
                                                                Container(),
                                                            isExpanded: true,
                                                            onChanged: (String?
                                                                newValue) {
                                                              setState(() {
                                                                selectedStatus =
                                                                    newValue!;
                                                              });
                                                            },
                                                            items: status.map(
                                                                (String value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child: Text(
                                                                  '  $value',
                                                                  style: GoogleFonts.poppins(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 150,
                                          width: screenWidth,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(),
                                              right: BorderSide(),
                                              left: BorderSide(),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0, top: 8.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.35,
                                                  color:
                                                      const Color(0xFF0000CD),
                                                  child: Text(
                                                    ' PRICE DETAILS',
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: SizedBox(
                                                  height: 103,
                                                  width:
                                                      800, // Adjust width as necessary

                                                  child: NInewTable(
                                                    dealerController:
                                                        controllers
                                                            .dealerController,
                                                    subDealerController:
                                                        controllers
                                                            .subDealerController,
                                                    retailController:
                                                        controllers
                                                            .retailController,
                                                    mrpController: controllers
                                                        .mrpController,
                                                    dateController: controllers
                                                        .dateController,
                                                    currentPriceController:
                                                        controllers
                                                            .currentPriceController,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 350,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              8.0,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              right: BorderSide(),
                                              bottom: BorderSide(),
                                              left: BorderSide(),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0, top: 8.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.35,
                                                  color:
                                                      const Color(0xFF0000CD),
                                                  child: Text(
                                                    ' ITEM IMAGES',
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Update Image?',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: const Color(
                                                            0xFF510986),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Container(
                                                      width: screenWidth,
                                                      constraints:
                                                          const BoxConstraints(
                                                        maxHeight: 40,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                      ),
                                                      child: TextFormField(
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                        cursorHeight: 20,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: 5.0,
                                                                  bottom: 8.0),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black)),
                                                          height: 200,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.446,
                                                          child: _selectedImages
                                                                  .isEmpty
                                                              ? Center(
                                                                  child: Text(
                                                                  'No Image Selected',
                                                                  style: GoogleFonts.poppins(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ))
                                                              : Image.memory(
                                                                  _selectedImages[
                                                                      0]),
                                                        ),
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child:
                                                                  ElevatedButton(
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
                                                                      fileBytesList
                                                                          .add(
                                                                              fileBytes);
                                                                    }

                                                                    setState(
                                                                        () {
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
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      Colors
                                                                          .black,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  fixedSize: Size(
                                                                      buttonWidth,
                                                                      buttonHeight),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(0),
                                                                  ),
                                                                  side:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                    'Add',
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            16),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () {},
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      Colors
                                                                          .black,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  fixedSize: Size(
                                                                      buttonWidth,
                                                                      buttonHeight),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(0),
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
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            16),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () {},
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      Colors
                                                                          .black,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  fixedSize: Size(
                                                                      buttonWidth,
                                                                      buttonHeight),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(0),
                                                                  ),
                                                                  side:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                    'Next',
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            16),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () {},
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      Colors
                                                                          .black,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  fixedSize: Size(
                                                                      buttonWidth,
                                                                      buttonHeight),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(0),
                                                                  ),
                                                                  side:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                    'Previous',
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            16),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () {},
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      Colors
                                                                          .black,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  fixedSize: Size(
                                                                      buttonWidth,
                                                                      buttonHeight),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(0),
                                                                  ),
                                                                  side:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                    'Zoom',
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            16),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width *
                                          8.0,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(
                                                color: Colors.black,
                                              ),
                                              bottom: BorderSide(
                                                color: Colors.black,
                                              ),
                                              left: BorderSide(
                                                  color: Colors.black))),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: SizedBox(
                                              width: 100,
                                              child: ElevatedButton(
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
                                                            void
                                                                updateTotals() {
                                                              setState(() {
                                                                calculateTotals();
                                                              });
                                                            }

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
                                                                            Text(
                                                                              'Opening Stock Entry',
                                                                              style: GoogleFonts.poppins(
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
                                                                                openingBalance.clear();
                                                                                totalQty = 0;
                                                                                totalAmount = 0;
                                                                                storesData.clear();
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
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(2.0),
                                                                                  child: Text(
                                                                                    'Sr',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: 30,
                                                                                width: 250,
                                                                                decoration: const BoxDecoration(border: Border(bottom: BorderSide(), top: BorderSide(), left: BorderSide())),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(2.0),
                                                                                  child: Text(
                                                                                    'Qty',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: 30,
                                                                                width: 130,
                                                                                decoration: const BoxDecoration(border: Border(bottom: BorderSide(), top: BorderSide(), left: BorderSide())),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(2.0),
                                                                                  child: Text(
                                                                                    'Unit',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: 30,
                                                                                width: 250,
                                                                                decoration: const BoxDecoration(border: Border(bottom: BorderSide(), top: BorderSide(), left: BorderSide())),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(2.0),
                                                                                  child: Text(
                                                                                    'Rate',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: 30,
                                                                                width: 250,
                                                                                decoration: BoxDecoration(border: Border.all()),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(2.0),
                                                                                  child: Text(
                                                                                    'Total',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 30,
                                                                                width: 30,
                                                                                child: IconButton(
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      openingBalance.add(buildStoresDetails(updateTotals: updateTotals));
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
                                                                                openingBalance,
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
                                                                          Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                200,
                                                                            child:
                                                                                Text(
                                                                              '$totalQty',
                                                                              style: GoogleFonts.poppins(color: const Color.fromARGB(255, 4, 26, 228), fontSize: 14, fontWeight: FontWeight.bold),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textAlign: TextAlign.end,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                620,
                                                                            child:
                                                                                Text(
                                                                              '$totalAmount',
                                                                              style: GoogleFonts.poppins(color: const Color.fromARGB(255, 4, 26, 228), fontSize: 14, fontWeight: FontWeight.bold),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textAlign: TextAlign.end,
                                                                            ),
                                                                          ),
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
                                                                              Text(
                                                                            'Save',
                                                                            style:
                                                                                GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
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
                                                                            openingBalance.clear();
                                                                            totalQty =
                                                                                0;
                                                                            totalAmount =
                                                                                0;
                                                                            storesData.clear();
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'Cancel',
                                                                            style:
                                                                                GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
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
                                                child: Text(
                                                  'Save',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: SizedBox(
                                              width: 100,
                                              child: ElevatedButton(
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
                                                onPressed: () {},
                                                child: Text(
                                                  'Cancel',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _key,
        type: ExpandableFabType.up,
        overlayStyle: ExpandableFabOverlayStyle(
          color: Colors.black.withOpacity(0.5),
        ),
        // distance: 100,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FloatingActionButton.small(
                heroTag: null,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Responsive_measurementunit(),
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
              FloatingActionButton.small(
                heroTag: null,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Responsive_NewHSNCommodity(),
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
              FloatingActionButton.small(
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
                        builder: (BuildContext context, StateSetter setState) {
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
              FloatingActionButton.small(
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
                        builder: (BuildContext context, StateSetter setState) {
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
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
                                            await FilePicker.platform.pickFiles(
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
                                            selectedImage.addAll(fileBytesList);
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
    );
  }

  Widget _buildTabletWidget() {
    double buttonWidth = MediaQuery.of(context).size.width * 0.15;
    double buttonHeight = MediaQuery.of(context).size.height * 0.03;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35.0),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const ItemHome(),
                ),
              );
            },
          ),
          backgroundColor: const Color(0xFF8A2BE2),
          title: Text('NEW Item Tablet',
              style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                _fetchData();
              },
              icon: const Icon(
                Icons.refresh,
              ),
            ),
          ],
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ItemBrandCubit, CubitItemBrandStates>(
            listener: (context, state) {
              if (state is CubitItemBrandLoaded) {
                setState(() {
                  fetchedItemBrands = state.itemBrands;
                  selectedItemId2 = fetchedItemBrands.first.id;
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
                  selectedItemId = fetchedItemGroups.first.id;
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
                  selectedTaxRateId = fetchedTaxCategories.first.id;
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
                  selectedHSNCodeId = fetchedHSNCodes.first.id;
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
                  selectedStoreLocationId = fetchedStores.first.id;
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
                  selectedMeasurementLimitId = fetchedMLimits.first.id;
                  selectedUnitId = fetchedMLimits.first.id;
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
                  selectedSecondaryUnitId = fetchedSUnit.first.id;
                });
              } else if (state is CubitSecondaryUnitError) {
                print(state.error);
              }
            },
          ),
        ],
        child: Column(
          children: [
            Expanded(
              child: isFetched == true
                  ? const Center(child: CircularProgressIndicator())
                  : Stack(
                      children: [
                        Opacity(
                          opacity: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const Row(
                                      children: [
                                        // Give me 5 buttons in a row
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          height: 400,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              8.0,
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0, top: 8.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  color:
                                                      const Color(0xFF0000CD),
                                                  child: Text(
                                                    ' BASIC DETAILS',
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  //Item Group
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            'Item Group',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color:
                                                                  const Color(
                                                                0xFF510986,
                                                              ),
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 9,
                                                          child: SizedBox(
                                                            height: 40,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border
                                                                    .all(),
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
                                                                    child: Text(
                                                                      itemGroup
                                                                          .name,
                                                                      style: GoogleFonts.poppins(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                                searchMatchFn:
                                                                    (item,
                                                                        searchValue) {
                                                                  final itemGroup = fetchedItemGroups
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
                                                      ],
                                                    ),
                                                  ),
                                                  //Brands
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            'Brand',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color: const Color(
                                                                  0xFF510986),
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 4,
                                                          child: SizedBox(
                                                            height: 40,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border
                                                                    .all(),
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
                                                                onChanged: (String?
                                                                    newValue) {
                                                                  setState(() {
                                                                    selectedItemId2 =
                                                                        newValue;
                                                                  });
                                                                },
                                                                items: fetchedItemBrands
                                                                    .map((ItemsBrand
                                                                        itemBrand) {
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    value:
                                                                        itemBrand
                                                                            .id,
                                                                    child: Text(
                                                                      itemBrand
                                                                          .name,
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            15,
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                                searchMatchFn:
                                                                    (item,
                                                                        searchValue) {
                                                                  final itemBrands = fetchedItemBrands
                                                                      .firstWhere((e) =>
                                                                          e.id ==
                                                                          item.value)
                                                                      .name;
                                                                  return itemBrands
                                                                      .toLowerCase()
                                                                      .contains(
                                                                          searchValue
                                                                              .toLowerCase());
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            'Code No',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color: const Color(
                                                                  0xFF510986),
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: SizedBox(
                                                            height: 40,
                                                            child:
                                                                TextFormField(
                                                              enabled: false,
                                                              controller:
                                                                  controllers
                                                                      .codeNoController,
                                                              style: GoogleFonts.poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              cursorHeight: 21,
                                                              textAlignVertical:
                                                                  TextAlignVertical
                                                                      .top,
                                                              decoration:
                                                                  InputDecoration(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            5.0,
                                                                        bottom:
                                                                            8.0),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
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
                                                      ],
                                                    ),
                                                  ),
                                                  //Item Name
                                                  NISingleTextField(
                                                    labelText: 'Item Name',
                                                    flex1: 2,
                                                    flex2: 9,
                                                    controller: controllers
                                                        .itemNameController,
                                                  ),
                                                  //Print Name
                                                  NISingleTextField(
                                                    labelText: 'Print Name',
                                                    flex1: 2,
                                                    flex2: 9,
                                                    controller: controllers
                                                        .printNameController,
                                                  ),
                                                  //Hsn Code
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            'HSN Code',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color: const Color(
                                                                  0xFF510986),
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 9,
                                                          child: SizedBox(
                                                            height: 40,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border
                                                                    .all(),
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
                                                                onChanged: (String?
                                                                    newValue) {
                                                                  setState(() {
                                                                    selectedHSNCodeId =
                                                                        newValue;
                                                                  });
                                                                },
                                                                items: fetchedHSNCodes
                                                                    .map((HSNCode
                                                                        hsnCode) {
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    value:
                                                                        hsnCode
                                                                            .id,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            '${hsnCode.description}(${hsnCode.hsn})',
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16,
                                                                            ),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            maxLines:
                                                                                2,
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
                                                                          searchValue
                                                                              .toLowerCase());
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            'Tax Category',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color: const Color(
                                                                  0xFF510986),
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 9,
                                                          child: SizedBox(
                                                            height: 40,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border
                                                                    .all(),
                                                              ),
                                                              child:
                                                                  DropdownButtonHideUnderline(
                                                                child:
                                                                    DropdownButton<
                                                                        String>(
                                                                  value:
                                                                      selectedTaxRateId,
                                                                  underline:
                                                                      Container(),
                                                                  isExpanded:
                                                                      true,
                                                                  onChanged:
                                                                      (String?
                                                                          newValue) {
                                                                    setState(
                                                                        () {
                                                                      selectedTaxRateId =
                                                                          newValue;
                                                                    });
                                                                  },
                                                                  items: fetchedTaxCategories
                                                                      .map((TaxRate
                                                                          taxRate) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          taxRate
                                                                              .id,
                                                                      child:
                                                                          Text(
                                                                        '  ${taxRate.rate}%',
                                                                        style: GoogleFonts.poppins(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    );
                                                                  }).toList(),
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
                                        ),
                                        Container(
                                          height: 500,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              8.0,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              left: BorderSide(),
                                              right: BorderSide(),
                                              bottom: BorderSide(),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0, top: 8.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  color:
                                                      const Color(0xFF0000CD),
                                                  child: Text(
                                                    ' STOCK OPTIONS',
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            'Store Location',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color: const Color(
                                                                  0xFF510986),
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 9,
                                                          child: SizedBox(
                                                            height: 40,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border
                                                                    .all(),
                                                              ),
                                                              child:
                                                                  DropdownButtonHideUnderline(
                                                                child:
                                                                    DropdownButton<
                                                                        String>(
                                                                  value:
                                                                      selectedStoreLocationId,
                                                                  underline:
                                                                      Container(),
                                                                  isExpanded:
                                                                      true,
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
                                                                          storeLocation
                                                                              .id,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              '  ${storeLocation.location}',
                                                                              style: GoogleFonts.poppins(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 15,
                                                                              ),
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
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
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            'Barcode Sr',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color: const Color(
                                                                  0xFF510986),
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 9,
                                                          child: Container(
                                                            constraints:
                                                                const BoxConstraints(
                                                              maxHeight: 40,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0),
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  controllers
                                                                      .barcodeController,
                                                              style: GoogleFonts.poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              cursorHeight: 20,
                                                              decoration:
                                                                  const InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                contentPadding:
                                                                    EdgeInsets.only(
                                                                        left:
                                                                            5.0,
                                                                        bottom:
                                                                            8.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            'Stock Unit',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color: const Color(
                                                                  0xFF510986),
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 9,
                                                          child: SizedBox(
                                                            height: 40,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border
                                                                    .all(),
                                                              ),
                                                              child:
                                                                  SearchableDropDown(
                                                                controller:
                                                                    controllers
                                                                        .itemMeasureunitController,
                                                                searchController:
                                                                    controllers
                                                                        .itemMeasureunitController,
                                                                value:
                                                                    selectedMeasurementLimitId,
                                                                onChanged: (String?
                                                                    newValue) {
                                                                  setState(() {
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
                                                                        measurementLimit
                                                                            .id,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          measurementLimit
                                                                              .measurement,
                                                                          style:
                                                                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                                searchMatchFn:
                                                                    (item,
                                                                        searchValue) {
                                                                  final itemMLimit = fetchedMLimits
                                                                      .firstWhere((e) =>
                                                                          e.id ==
                                                                          item.value)
                                                                      .measurement;
                                                                  return itemMLimit
                                                                      .toLowerCase()
                                                                      .contains(
                                                                          searchValue
                                                                              .toLowerCase());
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            'Secondary Unit',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color: const Color(
                                                                  0xFF510986),
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 9,
                                                          child: SizedBox(
                                                            height: 40,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border
                                                                    .all(),
                                                              ),
                                                              child:
                                                                  SearchableDropDown(
                                                                controller:
                                                                    controllers
                                                                        .itemMeasureunitController,
                                                                searchController:
                                                                    controllers
                                                                        .itemMeasureunitController,
                                                                value:
                                                                    selectedSecondaryUnitId,
                                                                onChanged: (String?
                                                                    newValue) {
                                                                  setState(() {
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
                                                                        secondaryUnit
                                                                            .id,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            secondaryUnit.secondaryUnit,
                                                                            style:
                                                                                GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                                searchMatchFn:
                                                                    (item,
                                                                        searchValue) {
                                                                  final itemSunit = fetchedSUnit
                                                                      .firstWhere((e) =>
                                                                          e.id ==
                                                                          item.value)
                                                                      .secondaryUnit;
                                                                  return itemSunit
                                                                      .toLowerCase()
                                                                      .contains(
                                                                          searchValue
                                                                              .toLowerCase());
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            'Minimum Stock',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color: const Color(
                                                                  0xFF510986),
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 9,
                                                          child: Container(
                                                            constraints:
                                                                const BoxConstraints(
                                                              maxHeight: 40,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0),
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  controllers
                                                                      .minimumStockController,
                                                              style: GoogleFonts.poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              cursorHeight: 20,
                                                              decoration:
                                                                  const InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                contentPadding:
                                                                    EdgeInsets.only(
                                                                        left:
                                                                            5.0,
                                                                        bottom:
                                                                            8.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            'Maximum Stock',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color: const Color(
                                                                  0xFF510986),
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 9,
                                                          child: Container(
                                                            constraints:
                                                                const BoxConstraints(
                                                              maxHeight: 40,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0),
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  controllers
                                                                      .maximumStockController,
                                                              style: GoogleFonts.poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              cursorHeight: 20,
                                                              textAlignVertical:
                                                                  TextAlignVertical
                                                                      .top,
                                                              decoration:
                                                                  const InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                contentPadding:
                                                                    EdgeInsets.only(
                                                                        left:
                                                                            5.0,
                                                                        bottom:
                                                                            8.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            'Monthly Sale Qty',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color: const Color(
                                                                  0xFF510986),
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 9,
                                                          child: Container(
                                                            constraints:
                                                                const BoxConstraints(
                                                              maxHeight: 40,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0),
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  controllers
                                                                      .monthlySalesQtyController,
                                                              style: GoogleFonts.poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              cursorHeight: 20,
                                                              textAlignVertical:
                                                                  TextAlignVertical
                                                                      .top,
                                                              decoration:
                                                                  const InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                contentPadding:
                                                                    EdgeInsets.only(
                                                                        left:
                                                                            5.0,
                                                                        bottom:
                                                                            8.0),
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
                                        ),
                                        Container(
                                          height: 150,
                                          width: screenWidth,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(),
                                              right: BorderSide(),
                                              left: BorderSide(),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0, top: 8.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  color:
                                                      const Color(0xFF0000CD),
                                                  child: Text(
                                                    ' PRICE DETAILS',
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: SizedBox(
                                                  height: 103,
                                                  width: 800,
                                                  child: NInewTable(
                                                    dealerController:
                                                        controllers
                                                            .dealerController,
                                                    subDealerController:
                                                        controllers
                                                            .subDealerController,
                                                    retailController:
                                                        controllers
                                                            .retailController,
                                                    mrpController: controllers
                                                        .mrpController,
                                                    dateController: controllers
                                                        .dateController,
                                                    currentPriceController:
                                                        controllers
                                                            .currentPriceController,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 350,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              8.0,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              right: BorderSide(),
                                              bottom: BorderSide(),
                                              left: BorderSide(),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0, top: 8.0),
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  color:
                                                      const Color(0xFF0000CD),
                                                  child: Text(
                                                    ' ITEM IMAGES',
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 3,
                                                          child: SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.2,
                                                            child: Text(
                                                              'Update Image?',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: const Color(
                                                                    0xFF510986),
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 8,
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .25,
                                                            constraints:
                                                                const BoxConstraints(
                                                              maxHeight: 40,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0),
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              style: GoogleFonts.poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              cursorHeight: 20,
                                                              decoration:
                                                                  const InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                contentPadding:
                                                                    EdgeInsets.only(
                                                                        left:
                                                                            5.0,
                                                                        bottom:
                                                                            8.0),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black)),
                                                          height: 200,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.446,
                                                          child: _selectedImages
                                                                  .isEmpty
                                                              ? Center(
                                                                  child: Text(
                                                                  'No Image Selected',
                                                                  style: GoogleFonts.poppins(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ))
                                                              : Image.memory(
                                                                  _selectedImages[
                                                                      0]),
                                                        ),
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child:
                                                                  ElevatedButton(
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
                                                                      fileBytesList
                                                                          .add(
                                                                              fileBytes);
                                                                    }

                                                                    setState(
                                                                        () {
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
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      Colors
                                                                          .black,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  fixedSize: Size(
                                                                      buttonWidth,
                                                                      buttonHeight),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(0),
                                                                  ),
                                                                  side:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                    'Add',
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            16),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () {},
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      Colors
                                                                          .black,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  fixedSize: Size(
                                                                      buttonWidth,
                                                                      buttonHeight),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(0),
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
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            16),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () {},
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      Colors
                                                                          .black,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  fixedSize: Size(
                                                                      buttonWidth,
                                                                      buttonHeight),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(0),
                                                                  ),
                                                                  side:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                    'Next',
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            16),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () {},
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      Colors
                                                                          .black,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  fixedSize: Size(
                                                                      buttonWidth,
                                                                      buttonHeight),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(0),
                                                                  ),
                                                                  side:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                    'Previous',
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            16),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () {},
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      Colors
                                                                          .black,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  fixedSize: Size(
                                                                      buttonWidth,
                                                                      buttonHeight),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(0),
                                                                  ),
                                                                  side:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                    'Zoom',
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            16),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width *
                                          8.0,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(
                                                color: Colors.black,
                                              ),
                                              bottom: BorderSide(
                                                color: Colors.black,
                                              ),
                                              left: BorderSide(
                                                  color: Colors.black))),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.14,
                                              child: Text(
                                                'Opening Stock :',
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color:
                                                      const Color(0xFF510986),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                            height: 40,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(),
                                              ),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value: selectedStock,
                                                  underline: Container(),
                                                  isExpanded: true,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedStock = newValue!;
                                                    });
                                                  },
                                                  items:
                                                      stock.map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        '  $value',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: 100,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        fixedSize: Size(
                                                            MediaQuery.of(
                                                                        context)
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
                                                        backgroundColor: Colors
                                                            .yellow.shade100),
                                                    onPressed: () {
                                                      if (selectedStock ==
                                                          'Yes') {
                                                        showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return StatefulBuilder(
                                                              builder: (context,
                                                                  setState) {
                                                                void
                                                                    updateTotals() {
                                                                  setState(() {
                                                                    calculateTotals();
                                                                  });
                                                                }

                                                                return AlertDialog(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  content:
                                                                      SizedBox(
                                                                    height: 500,
                                                                    width: 1000,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              1000,
                                                                          height:
                                                                              50,
                                                                          decoration:
                                                                              BoxDecoration(color: Colors.blue[600]),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                const SizedBox(),
                                                                                const Spacer(),
                                                                                Text(
                                                                                  'Opening Stock Entry',
                                                                                  style: GoogleFonts.poppins(
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
                                                                                    openingBalance.clear();
                                                                                    totalQty = 0;
                                                                                    totalAmount = 0;
                                                                                    storesData.clear();
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
                                                                              Alignment.topCenter,
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
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(2.0),
                                                                                      child: Text(
                                                                                        'Sr',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    height: 30,
                                                                                    width: 250,
                                                                                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(), top: BorderSide(), left: BorderSide())),
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(2.0),
                                                                                      child: Text(
                                                                                        'Qty',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    height: 30,
                                                                                    width: 130,
                                                                                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(), top: BorderSide(), left: BorderSide())),
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(2.0),
                                                                                      child: Text(
                                                                                        'Unit',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    height: 30,
                                                                                    width: 250,
                                                                                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(), top: BorderSide(), left: BorderSide())),
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(2.0),
                                                                                      child: Text(
                                                                                        'Rate',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    height: 30,
                                                                                    width: 250,
                                                                                    decoration: BoxDecoration(border: Border.all()),
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(2.0),
                                                                                      child: Text(
                                                                                        'Total',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 30,
                                                                                    width: 30,
                                                                                    child: IconButton(
                                                                                      onPressed: () {
                                                                                        setState(() {
                                                                                          openingBalance.add(buildStoresDetails(updateTotals: updateTotals));
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
                                                                                children: openingBalance,
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
                                                                              Row(
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 200,
                                                                                child: Text(
                                                                                  '$totalQty',
                                                                                  style: GoogleFonts.poppins(color: const Color.fromARGB(255, 4, 26, 228), fontSize: 14, fontWeight: FontWeight.bold),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  textAlign: TextAlign.end,
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 620,
                                                                                child: Text(
                                                                                  '$totalAmount',
                                                                                  style: GoogleFonts.poppins(color: const Color.fromARGB(255, 4, 26, 228), fontSize: 14, fontWeight: FontWeight.bold),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  textAlign: TextAlign.end,
                                                                                ),
                                                                              ),
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
                                                                              style: ElevatedButton.styleFrom(fixedSize: Size(MediaQuery.of(context).size.width * .1, 25), shape: const BeveledRectangleBorder(side: BorderSide(color: Colors.black, width: .3)), backgroundColor: Colors.yellow.shade100),
                                                                              onPressed: createItems,
                                                                              child: Text(
                                                                                'Save',
                                                                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                overflow: TextOverflow.ellipsis,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(width: 10),
                                                                            ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(fixedSize: Size(MediaQuery.of(context).size.width * .1, 25), shape: const BeveledRectangleBorder(side: BorderSide(color: Colors.black, width: .3)), backgroundColor: Colors.yellow.shade100),
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                                openingBalance.clear();
                                                                                totalQty = 0;
                                                                                totalAmount = 0;
                                                                                storesData.clear();
                                                                              },
                                                                              child: Text(
                                                                                'Cancel',
                                                                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                overflow: TextOverflow.ellipsis,
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
                                                    child: Text(
                                                      'Save',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: 100,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        fixedSize: Size(
                                                            MediaQuery.of(
                                                                        context)
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
                                                        backgroundColor: Colors
                                                            .yellow.shade100),
                                                    onPressed: () {},
                                                    child: Text(
                                                      'Cancel',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .1,
                                            child: Text(
                                              'Is Active :',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: const Color(0xFF510986),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              height: 40,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(),
                                                ),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                    value: selectedStatus,
                                                    underline: Container(),
                                                    isExpanded: true,
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        selectedStatus =
                                                            newValue!;
                                                      });
                                                    },
                                                    items: status
                                                        .map((String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          '  $value',
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      );
                                                    }).toList(),
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
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
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
                      builder: (context) => const Responsive_measurementunit(),
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
                      builder: (context) => const Responsive_NewHSNCommodity(),
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
                        builder: (BuildContext context, StateSetter setState) {
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
                        builder: (BuildContext context, StateSetter setState) {
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
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
                                            await FilePicker.platform.pickFiles(
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
                                            selectedImage.addAll(fileBytesList);
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
    );
  }

  Widget _buildDesktopWidget() {
    double buttonWidth = MediaQuery.of(context).size.width * 0.1;
    double buttonHeight = MediaQuery.of(context).size.height * 0.03;
    double screenWidth = MediaQuery.of(context).size.width;

    return _isSaving
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : RawKeyboardListener(
            focusNode: _focusNode,
            onKey: (RawKeyEvent event) {
              if (event is RawKeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.escape) {
                _showExitConfirmationDialog();
              }
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(35.0),
                child: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const ItemHome(),
                        ),
                      );
                    },
                  ),
                  backgroundColor: const Color(0xFF8A2BE2),
                  title: Text('NEW Item',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  centerTitle: true,
                  foregroundColor: Colors.white,
                  actions: [
                    IconButton(
                      onPressed: () {
                        _fetchData();
                      },
                      icon: const Icon(
                        Icons.refresh,
                      ),
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MultiBlocListener(
                      listeners: [
                        BlocListener<ItemBrandCubit, CubitItemBrandStates>(
                          listener: (context, state) {
                            if (state is CubitItemBrandLoaded) {
                              setState(() {
                                fetchedItemBrands = state.itemBrands;
                                selectedItemId2 = fetchedItemBrands.first.id;
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
                                selectedItemId = fetchedItemGroups.first.id;
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
                                selectedTaxRateId = fetchedTaxCategories.first.id;
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
                                selectedHSNCodeId = fetchedHSNCodes.first.id;
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
                                selectedStoreLocationId = fetchedStores.first.id;
                              });
                            } else if (state is CubitStoreError) {
                              print(state.error);
                            }
                          },
                        ),
                        BlocListener<MeasurementLimitCubit,
                            CubitMeasurementLimitStates>(
                          listener: (context, state) {
                            if (state is CubitMeasurementLimitLoaded) {
                              setState(() {
                                fetchedMLimits = state.measurementLimits;
                                selectedMeasurementLimitId = fetchedMLimits.first.id;
                                selectedUnitId = fetchedMLimits.first.id;
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
                                selectedSecondaryUnitId = fetchedSUnit.first.id;
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
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      height: 425,
                                                      width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .44,
                                                      decoration: const BoxDecoration(
                                                          border: Border(
                                                        top: BorderSide(
                                                            width: 1,
                                                            color: Colors.black),
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
                                                            padding:
                                                                const EdgeInsets.only(
                                                                    bottom: 8.0,
                                                                    top: 8.0),
                                                            child: Container(
                                                              height: 30,
                                                              width: screenWidth < 900
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .14
                                                                  : MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.13,
                                                              color: const Color(
                                                                  0xFF0000CD),
                                                              child: Text(
                                                                ' BASIC DETAILS',
                                                                style:
                                                                    GoogleFonts.poppins(
                                                                  color: Colors.white,
                                                                  fontWeight:
                                                                      FontWeight.bold,
                                                                  fontSize:
                                                                      screenWidth < 1030
                                                                          ? 11.0
                                                                          : 14.0,
                                                                ),
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                          Column(
                                                            children: [
                                                              //Item Group
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8.0),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Text(
                                                                        'Item Group',
                                                                        style:
                                                                            GoogleFonts
                                                                                .poppins(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                          fontSize: 16,
                                                                          color:
                                                                              const Color(
                                                                            0xFF510986,
                                                                          ),
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 9,
                                                                      child: SizedBox(
                                                                        height: 40,
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border: Border
                                                                                .all(),
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
                                                                            onChanged:
                                                                                (String?
                                                                                    newValue) {
                                                                              setState(
                                                                                  () {
                                                                                selectedItemId =
                                                                                    newValue;
                                                                              });
                                                                            },
                                                                            items: fetchedItemGroups.map(
                                                                                (ItemsGroup
                                                                                    itemGroup) {
                                                                              return DropdownMenuItem<
                                                                                  String>(
                                                                                value: itemGroup
                                                                                    .id,
                                                                                child:
                                                                                    Text(
                                                                                  itemGroup
                                                                                      .name,
                                                                                  style:
                                                                                      GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                  overflow:
                                                                                      TextOverflow.ellipsis,
                                                                                ),
                                                                              );
                                                                            }).toList(),
                                                                            searchMatchFn:
                                                                                (item,
                                                                                    searchValue) {
                                                                              final itemGroup = fetchedItemGroups
                                                                                  .firstWhere((e) =>
                                                                                      e.id ==
                                                                                      item.value)
                                                                                  .name;
                                                                              return itemGroup
                                                                                  .toLowerCase()
                                                                                  .contains(
                                                                                      searchValue.toLowerCase());
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              //Brands
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8.0),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Text(
                                                                        'Brand',
                                                                        style:
                                                                            GoogleFonts
                                                                                .poppins(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                          fontSize: 16,
                                                                          color: const Color(
                                                                              0xFF510986),
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 4,
                                                                      child: SizedBox(
                                                                        height: 40,
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border: Border
                                                                                .all(),
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
                                                                                    Text(
                                                                                  itemBrand
                                                                                      .name,
                                                                                  style:
                                                                                      GoogleFonts.poppins(
                                                                                    fontWeight:
                                                                                        FontWeight.bold,
                                                                                    fontSize:
                                                                                        15,
                                                                                  ),
                                                                                  overflow:
                                                                                      TextOverflow.ellipsis,
                                                                                ),
                                                                              );
                                                                            }).toList(),
                                                                            searchMatchFn:
                                                                                (item,
                                                                                    searchValue) {
                                                                              final itemBrands = fetchedItemBrands
                                                                                  .firstWhere((e) =>
                                                                                      e.id ==
                                                                                      item.value)
                                                                                  .name;
                                                                              return itemBrands
                                                                                  .toLowerCase()
                                                                                  .contains(
                                                                                      searchValue.toLowerCase());
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Text(
                                                                        'Code No',
                                                                        style:
                                                                            GoogleFonts
                                                                                .poppins(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                          fontSize: 16,
                                                                          color: const Color(
                                                                              0xFF510986),
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 3,
                                                                      child: SizedBox(
                                                                        height: 40,
                                                                        child:
                                                                            TextFormField(
                                                                          enabled:
                                                                              false,
                                                                          controller:
                                                                              controllers
                                                                                  .codeNoController,
                                                                          style: GoogleFonts.poppins(
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
                                                                            contentPadding: const EdgeInsets
                                                                                .only(
                                                                                left:
                                                                                    5.0,
                                                                                bottom:
                                                                                    8.0),
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
                                                                  ],
                                                                ),
                                                              ),
                                                              //Item Name
                                                              NISingleTextField(
                                                                labelText: 'Item Name',
                                                                flex1: 2,
                                                                flex2: 9,
                                                                controller: controllers
                                                                    .itemNameController,
                                                              ),
                                                              //Print Name
                                                              NISingleTextField(
                                                                labelText: 'Print Name',
                                                                flex1: 2,
                                                                flex2: 9,
                                                                controller: controllers
                                                                    .printNameController,
                                                              ),
                                                              //Hsn Code
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8.0),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Text(
                                                                        'HSN Code',
                                                                        style:
                                                                            GoogleFonts
                                                                                .poppins(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                          fontSize: 16,
                                                                          color: const Color(
                                                                              0xFF510986),
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 4,
                                                                      child: SizedBox(
                                                                        height: 40,
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border: Border
                                                                                .all(),
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
                                                                                        style: GoogleFonts.poppins(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          fontSize: 16,
                                                                                        ),
                                                                                        overflow: TextOverflow.ellipsis,
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
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Text(
                                                                        'Tax Category',
                                                                        style:
                                                                            GoogleFonts
                                                                                .poppins(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                          fontSize: 16,
                                                                          color: const Color(
                                                                              0xFF510986),
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 3,
                                                                      child: SizedBox(
                                                                        height: 40,
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border: Border
                                                                                .all(),
                                                                          ),
                                                                          child:
                                                                              DropdownButtonHideUnderline(
                                                                            child: DropdownButton<
                                                                                String>(
                                                                              value:
                                                                                  selectedTaxRateId,
                                                                              underline:
                                                                                  Container(),
                                                                              isExpanded:
                                                                                  true,
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
                                                                                      Text(
                                                                                    '  ${taxRate.rate}%',
                                                                                    style:
                                                                                        GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                    overflow:
                                                                                        TextOverflow.ellipsis,
                                                                                  ),
                                                                                );
                                                                              }).toList(),
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
                                                    ),
                                                    Container(
                                                      height: 400,
                                                      width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .44,
                                                      decoration: const BoxDecoration(
                                                          border: Border(
                                                        left: BorderSide(
                                                            color: Colors.black),
                                                        bottom: BorderSide(
                                                            color: Colors.black),
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
                                                            dashGapColor:
                                                                Colors.transparent,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                    bottom: 8.0,
                                                                    top: 8.0),
                                                            child: Container(
                                                              height: 30,
                                                              width: screenWidth < 900
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .14
                                                                  : MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.13,
                                                              color: const Color(
                                                                  0xFF0000CD),
                                                              child: Text(
                                                                ' STOCK OPTIONS',
                                                                style:
                                                                    GoogleFonts.poppins(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            screenWidth <
                                                                                    1030
                                                                                ? 11.0
                                                                                : 14.0),
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                          Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8.0),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Text(
                                                                        'Store Location',
                                                                        style:
                                                                            GoogleFonts
                                                                                .poppins(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                          fontSize: 16,
                                                                          color: const Color(
                                                                              0xFF510986),
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 4,
                                                                      child: SizedBox(
                                                                        height: 40,
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border: Border
                                                                                .all(),
                                                                          ),
                                                                          child:
                                                                              DropdownButtonHideUnderline(
                                                                            child: DropdownButton<
                                                                                String>(
                                                                              value:
                                                                                  selectedStoreLocationId,
                                                                              underline:
                                                                                  Container(),
                                                                              isExpanded:
                                                                                  true,
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
                                                                                      Expanded(
                                                                                        child: Text(
                                                                                          '  ${storeLocation.location}',
                                                                                          style: GoogleFonts.poppins(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 15,
                                                                                          ),
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
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
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Text(
                                                                        'Barcode Sr',
                                                                        style:
                                                                            GoogleFonts
                                                                                .poppins(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                          fontSize: 16,
                                                                          color: const Color(
                                                                              0xFF510986),
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 3,
                                                                      child: Container(
                                                                        constraints:
                                                                            const BoxConstraints(
                                                                          maxHeight: 40,
                                                                        ),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border: Border.all(
                                                                              color: Colors
                                                                                  .black),
                                                                          borderRadius:
                                                                              BorderRadius
                                                                                  .circular(
                                                                                      0),
                                                                        ),
                                                                        child:
                                                                            TextFormField(
                                                                          controller:
                                                                              controllers
                                                                                  .barcodeController,
                                                                          style: GoogleFonts.poppins(
                                                                              fontWeight:
                                                                                  FontWeight
                                                                                      .bold),
                                                                          cursorHeight:
                                                                              20,
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            border:
                                                                                InputBorder
                                                                                    .none,
                                                                            contentPadding: EdgeInsets.only(
                                                                                left:
                                                                                    5.0,
                                                                                bottom:
                                                                                    8.0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8.0),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Text(
                                                                        'Stock Unit',
                                                                        style:
                                                                            GoogleFonts
                                                                                .poppins(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                          fontSize: 16,
                                                                          color: const Color(
                                                                              0xFF510986),
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 4,
                                                                      child: SizedBox(
                                                                        height: 40,
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border: Border
                                                                                .all(),
                                                                          ),
                                                                          child:
                                                                              SearchableDropDown(
                                                                            controller:
                                                                                controllers
                                                                                    .itemMeasureunitController,
                                                                            searchController:
                                                                                controllers
                                                                                    .itemMeasureunitController,
                                                                            value:
                                                                                selectedMeasurementLimitId,
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
                                                                                value: measurementLimit
                                                                                    .id,
                                                                                child:
                                                                                    Row(
                                                                                  mainAxisAlignment:
                                                                                      MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Text(
                                                                                      measurementLimit.measurement,
                                                                                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            }).toList(),
                                                                            searchMatchFn:
                                                                                (item,
                                                                                    searchValue) {
                                                                              final itemMLimit = fetchedMLimits
                                                                                  .firstWhere((e) =>
                                                                                      e.id ==
                                                                                      item.value)
                                                                                  .measurement;
                                                                              return itemMLimit
                                                                                  .toLowerCase()
                                                                                  .contains(
                                                                                      searchValue.toLowerCase());
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Text(
                                                                        'Secondary Unit',
                                                                        style:
                                                                            GoogleFonts
                                                                                .poppins(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                          fontSize: 16,
                                                                          color: const Color(
                                                                              0xFF510986),
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 3,
                                                                      child: SizedBox(
                                                                        height: 40,
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border: Border
                                                                                .all(),
                                                                          ),
                                                                          child:
                                                                              SearchableDropDown(
                                                                            controller:
                                                                                controllers
                                                                                    .itemMeasureunitController,
                                                                            searchController:
                                                                                controllers
                                                                                    .itemMeasureunitController,
                                                                            value:
                                                                                selectedSecondaryUnitId,
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
                                                                                value: secondaryUnit
                                                                                    .id,
                                                                                child:
                                                                                    Row(
                                                                                  mainAxisAlignment:
                                                                                      MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: Text(
                                                                                        secondaryUnit.secondaryUnit,
                                                                                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            }).toList(),
                                                                            searchMatchFn:
                                                                                (item,
                                                                                    searchValue) {
                                                                              final itemSunit = fetchedSUnit
                                                                                  .firstWhere((e) =>
                                                                                      e.id ==
                                                                                      item.value)
                                                                                  .secondaryUnit;
                                                                              return itemSunit
                                                                                  .toLowerCase()
                                                                                  .contains(
                                                                                      searchValue.toLowerCase());
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8.0),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Text(
                                                                        'Minimum Stock',
                                                                        style:
                                                                            GoogleFonts
                                                                                .poppins(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                          fontSize: 16,
                                                                          color: const Color(
                                                                              0xFF510986),
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 4,
                                                                      child: Container(
                                                                        constraints:
                                                                            const BoxConstraints(
                                                                          maxHeight: 40,
                                                                        ),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border: Border.all(
                                                                              color: Colors
                                                                                  .black),
                                                                          borderRadius:
                                                                              BorderRadius
                                                                                  .circular(
                                                                                      0),
                                                                        ),
                                                                        child:
                                                                            TextFormField(
                                                                          controller:
                                                                              controllers
                                                                                  .minimumStockController,
                                                                          style: GoogleFonts.poppins(
                                                                              fontWeight:
                                                                                  FontWeight
                                                                                      .bold),
                                                                          cursorHeight:
                                                                              20,
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            border:
                                                                                InputBorder
                                                                                    .none,
                                                                            contentPadding: EdgeInsets.only(
                                                                                left:
                                                                                    5.0,
                                                                                bottom:
                                                                                    8.0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Text(
                                                                        'Maximum Stock',
                                                                        style:
                                                                            GoogleFonts
                                                                                .poppins(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                          fontSize: 16,
                                                                          color: const Color(
                                                                              0xFF510986),
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 3,
                                                                      child: Container(
                                                                        constraints:
                                                                            const BoxConstraints(
                                                                          maxHeight: 40,
                                                                        ),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border: Border.all(
                                                                              color: Colors
                                                                                  .black),
                                                                          borderRadius:
                                                                              BorderRadius
                                                                                  .circular(
                                                                                      0),
                                                                        ),
                                                                        child:
                                                                            TextFormField(
                                                                          controller:
                                                                              controllers
                                                                                  .maximumStockController,
                                                                          style: GoogleFonts.poppins(
                                                                              fontWeight:
                                                                                  FontWeight
                                                                                      .bold),
                                                                          cursorHeight:
                                                                              20,
                                                                          textAlignVertical:
                                                                              TextAlignVertical
                                                                                  .top,
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            border:
                                                                                InputBorder
                                                                                    .none,
                                                                            contentPadding: EdgeInsets.only(
                                                                                left:
                                                                                    5.0,
                                                                                bottom:
                                                                                    8.0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8.0),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Text(
                                                                        'Monthly Sale Qty',
                                                                        style:
                                                                            GoogleFonts
                                                                                .poppins(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                          fontSize: 16,
                                                                          color: const Color(
                                                                              0xFF510986),
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 4,
                                                                      child: Container(
                                                                        constraints:
                                                                            const BoxConstraints(
                                                                          maxHeight: 40,
                                                                        ),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border: Border.all(
                                                                              color: Colors
                                                                                  .black),
                                                                          borderRadius:
                                                                              BorderRadius
                                                                                  .circular(
                                                                                      0),
                                                                        ),
                                                                        child:
                                                                            TextFormField(
                                                                          controller:
                                                                              controllers
                                                                                  .monthlySalesQtyController,
                                                                          style: GoogleFonts.poppins(
                                                                              fontWeight:
                                                                                  FontWeight
                                                                                      .bold),
                                                                          cursorHeight:
                                                                              20,
                                                                          textAlignVertical:
                                                                              TextAlignVertical
                                                                                  .top,
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            border:
                                                                                InputBorder
                                                                                    .none,
                                                                            contentPadding: EdgeInsets.only(
                                                                                left:
                                                                                    5.0,
                                                                                bottom:
                                                                                    8.0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const Expanded(
                                                                      flex: 5,
                                                                      child: SizedBox(),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: 425,
                                                      width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .44,
                                                      decoration: const BoxDecoration(
                                                          border: Border(
                                                              top: BorderSide(
                                                                  color: Colors.black),
                                                              right: BorderSide(
                                                                  color: Colors.black),
                                                              left: BorderSide(
                                                                  color:
                                                                      Colors.black))),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                    bottom: 8.0,
                                                                    top: 8.0),
                                                            child: Container(
                                                              height: 30,
                                                              width: screenWidth < 900
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .14
                                                                  : MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.13,
                                                              color: const Color(
                                                                  0xFF0000CD),
                                                              child: Text(
                                                                ' PRICE DETAILS',
                                                                style:
                                                                    GoogleFonts.poppins(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            screenWidth <
                                                                                    1030
                                                                                ? 11.0
                                                                                : 14.0),
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                          // NIEditableTable()
                                                          NInewTable(
                                                            dealerController:
                                                                controllers
                                                                    .dealerController,
                                                            subDealerController:
                                                                controllers
                                                                    .subDealerController,
                                                            retailController:
                                                                controllers
                                                                    .retailController,
                                                            mrpController: controllers
                                                                .mrpController,
                                                            dateController: controllers
                                                                .dateController,
                                                            currentPriceController:
                                                                controllers
                                                                    .currentPriceController,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 400,
                                                      width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .44,
                                                      decoration: const BoxDecoration(
                                                          border: Border(
                                                              right: BorderSide(
                                                                color: Colors.black,
                                                              ),
                                                              bottom: BorderSide(
                                                                  color: Colors.black),
                                                              left: BorderSide(
                                                                  color:
                                                                      Colors.black))),
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
                                                            dashGapColor:
                                                                Colors.transparent,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                    bottom: 8.0,
                                                                    top: 8.0),
                                                            child: Container(
                                                              height: 30,
                                                              width: screenWidth < 900
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .14
                                                                  : MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.13,
                                                              color: const Color(
                                                                  0xFF0000CD),
                                                              child: Text(
                                                                ' ITEM IMAGES',
                                                                style:
                                                                    GoogleFonts.poppins(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            screenWidth <
                                                                                    1030
                                                                                ? 11.0
                                                                                : 14.0),
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                          Column(children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets.all(
                                                                      4.0),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    'Update Image?',
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize: 16,
                                                                      color: const Color(
                                                                          0xFF510986),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .width *
                                                                        .01,
                                                                  ),
                                                                  Container(
                                                                    width: MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .width *
                                                                        .13,
                                                                    constraints:
                                                                        const BoxConstraints(
                                                                      maxHeight: 40,
                                                                    ),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          color: Colors
                                                                              .black),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                                  0),
                                                                    ),
                                                                    child:
                                                                        TextFormField(
                                                                      style: GoogleFonts.poppins(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                      cursorHeight: 20,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        border:
                                                                            InputBorder
                                                                                .none,
                                                                        contentPadding:
                                                                            EdgeInsets.only(
                                                                                left:
                                                                                    5.0,
                                                                                bottom:
                                                                                    8.0),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                      left: 8),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            color: Colors
                                                                                .black)),
                                                                    height: 200,
                                                                    width: MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .width *
                                                                        0.18,
                                                                    child: _selectedImages
                                                                            .isEmpty
                                                                        ? Center(
                                                                            child: Text(
                                                                            'No Image Selected',
                                                                            style: GoogleFonts.poppins(
                                                                                fontWeight:
                                                                                    FontWeight.bold),
                                                                            overflow:
                                                                                TextOverflow
                                                                                    .ellipsis,
                                                                          ))
                                                                        : Image.memory(
                                                                            _selectedImages[
                                                                                0]),
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets
                                                                                .only(
                                                                                left:
                                                                                    5.0,
                                                                                bottom:
                                                                                    1.0),
                                                                        child:
                                                                            ElevatedButton(
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
                                                                                fileBytesList
                                                                                    .add(fileBytes);
                                                                              }
                        
                                                                              setState(
                                                                                  () {
                                                                                _selectedImages
                                                                                    .addAll(fileBytesList);
                                                                              });
                        
                                                                              // print(_selectedImages);
                                                                            } else {
                                                                              // User canceled the picker
                                                                              print(
                                                                                  'File picking canceled by the user.');
                                                                            }
                                                                          },
                                                                          style: ElevatedButton
                                                                              .styleFrom(
                                                                            foregroundColor:
                                                                                Colors
                                                                                    .black,
                                                                            backgroundColor:
                                                                                Colors
                                                                                    .white,
                                                                            fixedSize: Size(
                                                                                buttonWidth,
                                                                                buttonHeight),
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
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
                                                                            style: GoogleFonts.poppins(
                                                                                fontSize: screenWidth <
                                                                                        1030
                                                                                    ? 11.0
                                                                                    : 13.0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets
                                                                                .only(
                                                                                left:
                                                                                    5.0,
                                                                                bottom:
                                                                                    1.0),
                                                                        child:
                                                                            ElevatedButton(
                                                                          onPressed:
                                                                              () {},
                                                                          style: ElevatedButton
                                                                              .styleFrom(
                                                                            foregroundColor:
                                                                                Colors
                                                                                    .black,
                                                                            backgroundColor:
                                                                                Colors
                                                                                    .white,
                                                                            fixedSize: Size(
                                                                                buttonWidth,
                                                                                buttonHeight),
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
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
                                                                              style: GoogleFonts.poppins(
                                                                                  fontSize: screenWidth < 1030
                                                                                      ? 11.0
                                                                                      : 13.0),
                                                                              overflow:
                                                                                  TextOverflow
                                                                                      .ellipsis,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets
                                                                                .only(
                                                                                left:
                                                                                    5.0,
                                                                                bottom:
                                                                                    1.0),
                                                                        child:
                                                                            ElevatedButton(
                                                                          onPressed:
                                                                              () {},
                                                                          style: ElevatedButton
                                                                              .styleFrom(
                                                                            foregroundColor:
                                                                                Colors
                                                                                    .black,
                                                                            backgroundColor:
                                                                                Colors
                                                                                    .white,
                                                                            fixedSize: Size(
                                                                                buttonWidth,
                                                                                buttonHeight),
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
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
                                                                            style: GoogleFonts.poppins(
                                                                                fontSize: screenWidth <
                                                                                        1030
                                                                                    ? 11.0
                                                                                    : 13.0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets
                                                                                .only(
                                                                                left:
                                                                                    5.0,
                                                                                bottom:
                                                                                    1.0),
                                                                        child:
                                                                            ElevatedButton(
                                                                          onPressed:
                                                                              () {},
                                                                          style: ElevatedButton
                                                                              .styleFrom(
                                                                            foregroundColor:
                                                                                Colors
                                                                                    .black,
                                                                            backgroundColor:
                                                                                Colors
                                                                                    .white,
                                                                            fixedSize: Size(
                                                                                buttonWidth,
                                                                                buttonHeight),
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
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
                                                                            style: GoogleFonts.poppins(
                                                                                fontSize: screenWidth <
                                                                                        1030
                                                                                    ? 11.0
                                                                                    : 13.0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets
                                                                                .only(
                                                                                left:
                                                                                    5.0,
                                                                                bottom:
                                                                                    1.0),
                                                                        child:
                                                                            ElevatedButton(
                                                                          onPressed:
                                                                              () {},
                                                                          style: ElevatedButton
                                                                              .styleFrom(
                                                                            foregroundColor:
                                                                                Colors
                                                                                    .black,
                                                                            backgroundColor:
                                                                                Colors
                                                                                    .white,
                                                                            fixedSize: Size(
                                                                                buttonWidth,
                                                                                buttonHeight),
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
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
                                                                            style: GoogleFonts.poppins(
                                                                                fontSize: screenWidth <
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
                                              height: 60,
                                              width: MediaQuery.of(context).size.width *
                                                  .88,
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      right: BorderSide(
                                                        color: Colors.black,
                                                      ),
                                                      bottom: BorderSide(
                                                        color: Colors.black,
                                                      ),
                                                      left: BorderSide(
                                                          color: Colors.black))),
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 4),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.1,
                                                      child: Text(
                                                        'Opening Stock (F7) :',
                                                        style: GoogleFonts.poppins(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                          color:
                                                              const Color(0xFF510986),
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.08,
                                                      height: 40,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          border: Border.all(),
                                                        ),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: DropdownButton<String>(
                                                            value: selectedStock,
                                                            underline: Container(),
                                                            isExpanded: true,
                                                            onChanged:
                                                                (String? newValue) {
                                                              setState(() {
                                                                selectedStock =
                                                                    newValue!;
                                                              });
                                                            },
                                                            items: stock
                                                                .map((String value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child: Text(
                                                                  '  $value',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .03,
                                                    ),
                                                    SizedBox(
                                                      width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .1,
                                                      child: Text(
                                                        'Is Active :',
                                                        style: GoogleFonts.poppins(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                          color:
                                                              const Color(0xFF510986),
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .08,
                                                      height: 40,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          border: Border.all(),
                                                        ),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: DropdownButton<String>(
                                                            value: selectedStatus,
                                                            underline: Container(),
                                                            isExpanded: true,
                                                            onChanged:
                                                                (String? newValue) {
                                                              setState(() {
                                                                selectedStatus =
                                                                    newValue!;
                                                              });
                                                            },
                                                            items: status
                                                                .map((String value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child: Text(
                                                                  '  $value',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .01,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(top: 8),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                        children: [
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                fixedSize: Size(
                                                                    MediaQuery.of(
                                                                                context)
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
                                                                backgroundColor: Colors
                                                                    .yellow.shade100),
                                                            onPressed: () {
                                                              if (selectedStock ==
                                                                  'Yes') {
                                                                showDialog(
                                                                  barrierDismissible:
                                                                      false,
                                                                  context: context,
                                                                  builder: (BuildContext
                                                                      context) {
                                                                    return StatefulBuilder(
                                                                      builder: (context,
                                                                          setState) {
                                                                        void
                                                                            updateTotals() {
                                                                          setState(() {
                                                                            calculateTotals();
                                                                          });
                                                                        }
                        
                                                                        return AlertDialog(
                                                                          contentPadding:
                                                                              EdgeInsets
                                                                                  .zero,
                                                                          content:
                                                                              SizedBox(
                                                                            height: 500,
                                                                            width: 1000,
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Container(
                                                                                  width:
                                                                                      1000,
                                                                                  height:
                                                                                      50,
                                                                                  decoration:
                                                                                      BoxDecoration(color: Colors.blue[600]),
                                                                                  child:
                                                                                      Padding(
                                                                                    padding:
                                                                                        const EdgeInsets.all(8.0),
                                                                                    child:
                                                                                        Row(
                                                                                      children: [
                                                                                        const SizedBox(),
                                                                                        const Spacer(),
                                                                                        Text(
                                                                                          'Opening Stock Entry',
                                                                                          style: GoogleFonts.poppins(
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
                                                                                            openingBalance.clear();
                                                                                            totalQty = 0;
                                                                                            totalAmount = 0;
                                                                                            storesData.clear();
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
                                                                                      Alignment.topCenter,
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
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(2.0),
                                                                                              child: Text(
                                                                                                'Sr',
                                                                                                textAlign: TextAlign.center,
                                                                                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            height: 30,
                                                                                            width: 250,
                                                                                            decoration: const BoxDecoration(border: Border(bottom: BorderSide(), top: BorderSide(), left: BorderSide())),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(2.0),
                                                                                              child: Text(
                                                                                                'Qty',
                                                                                                textAlign: TextAlign.center,
                                                                                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            height: 30,
                                                                                            width: 130,
                                                                                            decoration: const BoxDecoration(border: Border(bottom: BorderSide(), top: BorderSide(), left: BorderSide())),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(2.0),
                                                                                              child: Text(
                                                                                                'Unit',
                                                                                                textAlign: TextAlign.center,
                                                                                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            height: 30,
                                                                                            width: 250,
                                                                                            decoration: const BoxDecoration(border: Border(bottom: BorderSide(), top: BorderSide(), left: BorderSide())),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(2.0),
                                                                                              child: Text(
                                                                                                'Rate',
                                                                                                textAlign: TextAlign.center,
                                                                                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            height: 30,
                                                                                            width: 250,
                                                                                            decoration: BoxDecoration(border: Border.all()),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(2.0),
                                                                                              child: Text(
                                                                                                'Total',
                                                                                                textAlign: TextAlign.center,
                                                                                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 30,
                                                                                            width: 30,
                                                                                            child: IconButton(
                                                                                              onPressed: () {
                                                                                                setState(() {
                                                                                                  openingBalance.add(buildStoresDetails(updateTotals: updateTotals));
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
                                                                                        children: openingBalance,
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
                                                                                      Row(
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: 200,
                                                                                        child: Text(
                                                                                          '$totalQty',
                                                                                          style: GoogleFonts.poppins(color: const Color.fromARGB(255, 4, 26, 228), fontSize: 14, fontWeight: FontWeight.bold),
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          textAlign: TextAlign.end,
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 620,
                                                                                        child: Text(
                                                                                          '$totalAmount',
                                                                                          style: GoogleFonts.poppins(color: const Color.fromARGB(255, 4, 26, 228), fontSize: 14, fontWeight: FontWeight.bold),
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          textAlign: TextAlign.end,
                                                                                        ),
                                                                                      ),
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
                                                                                      style: ElevatedButton.styleFrom(fixedSize: Size(MediaQuery.of(context).size.width * .1, 25), shape: const BeveledRectangleBorder(side: BorderSide(color: Colors.black, width: .3)), backgroundColor: Colors.yellow.shade100),
                                                                                      onPressed: createItems,
                                                                                      child: Text(
                                                                                        'Save',
                                                                                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(width: 10),
                                                                                    ElevatedButton(
                                                                                      style: ElevatedButton.styleFrom(fixedSize: Size(MediaQuery.of(context).size.width * .1, 25), shape: const BeveledRectangleBorder(side: BorderSide(color: Colors.black, width: .3)), backgroundColor: Colors.yellow.shade100),
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                        openingBalance.clear();
                                                                                        totalQty = 0;
                                                                                        totalAmount = 0;
                                                                                        storesData.clear();
                                                                                      },
                                                                                      child: Text(
                                                                                        'Cancel',
                                                                                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                                        overflow: TextOverflow.ellipsis,
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
                                                            child: Text(
                                                              'Save [F4]',
                                                              style:
                                                                  GoogleFonts.poppins(
                                                                color: Colors.black,
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                              ),
                                                              overflow:
                                                                  TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                MediaQuery.of(context)
                                                                        .size
                                                                        .width *
                                                                    .002,
                                                          ),
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                fixedSize: Size(
                                                                    MediaQuery.of(
                                                                                context)
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
                                                                backgroundColor: Colors
                                                                    .yellow.shade100),
                                                            onPressed: () {
                                                              Navigator.of(context)
                                                                  .pushReplacement(
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      const ItemHome(),
                                                                ),
                                                              );
                                                            },
                                                            child: Text(
                                                              'Cancel',
                                                              style:
                                                                  GoogleFonts.poppins(
                                                                color: Colors.black,
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                              ),
                                                              overflow:
                                                                  TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                MediaQuery.of(context)
                                                                        .size
                                                                        .width *
                                                                    .002,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                MediaQuery.of(context)
                                                                        .size
                                                                        .width *
                                                                    .002,
                                                          ),
                                                        ],
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
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                                builder: (BuildContext context,
                                    StateSetter setState) {
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
                                builder: (BuildContext context,
                                    StateSetter setState) {
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            decoration: BoxDecoration(
                                              color: Colors.white10,
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 2),
                                            ),
                                            child: selectedImage.isEmpty
                                                ? const Center(
                                                    child: Text(
                                                      'No Image Selected',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                : Image.memory(
                                                    selectedImage[0]),
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
                                                  List<Uint8List>
                                                      fileBytesList = [];

                                                  for (PlatformFile file
                                                      in result.files) {
                                                    Uint8List fileBytes =
                                                        file.bytes!;
                                                    fileBytesList
                                                        .add(fileBytes);
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
                                                cursor:
                                                    SystemMouseCursors.click,
                                                child: SizedBox(
                                                  height: 50,
                                                  child: CircleAvatar(
                                                    radius: 50,
                                                    backgroundColor:
                                                        Colors.yellow.shade100,
                                                    child: const Icon(
                                                        Icons.upload),
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
