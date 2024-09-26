import 'dart:async';
import 'dart:math';

import 'package:billingsphere/data/models/purchase/purchase_model.dart';
import 'package:billingsphere/data/repository/purchase_repository.dart';
import 'package:billingsphere/utils/controllers/purchase_text_controller.dart';
import 'package:billingsphere/utils/controllers/sundry_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/providers/onchange_item_provider.dart';
import '../../data/models/item/item_model.dart';
import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/measurementLimit/measurement_limit_model.dart';
import '../../data/models/taxCategory/tax_category_model.dart';
import '../../data/repository/item_repository.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/measurement_limit_repository.dart';
import '../../data/repository/tax_category_repository.dart';
import '../LG_responsive/LG_desktop_body.dart';
import '../PE_widgets/PE_app_bar.dart';
import '../PE_widgets/PE_text_fields.dart';
import '../PE_widgets/PE_text_fields_no.dart';
import '../PE_widgets/purchase_table_2.dart';
import '../SE_responsive/SE_desktop_body.dart';
import '../SE_variables/SE_variables.dart';
import '../SE_widgets/sundry_row.dart';
import '../searchable_dropdown.dart';
import '../sumit_screen/voucher _entry.dart/voucher_list_widget.dart';
import 'PE_master.dart';

class PurchaseEditD extends StatefulWidget {
  const PurchaseEditD({super.key, required this.data});

  final String data;

  @override
  State<PurchaseEditD> createState() => _PurchaseEditDState();
}

class _PurchaseEditDState extends State<PurchaseEditD> {
  bool isLoading = false;
  PurchaseFormController purchaseController = PurchaseFormController();
  DateTime? _selectedDate;
  DateTime? _pickedDateData;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final List<PEntries2> _newWidget = [];
  final List<SundryRow> _newSundry = [];
  final List<Map<String, dynamic>> _allValues = [];
  final List<Map<String, dynamic>> _allValuesSundry = [];
  List<String> status = ['Cash', 'Debit'];
  String? selectedStatus = 'Debit';
  String? selectedState;
  String? selectedLedgerName;

  int _currentSundrySerialNumber = 1;
  List<Ledger> suggestionItems5 = [];
  List<Purchase> fetchedPurchase = [];
  LedgerService ledgerService = LedgerService();
  ItemsService itemsService = ItemsService();
  PurchaseServices purchaseServices = PurchaseServices();
  SundryFormController sundryFormController = SundryFormController();
  TaxRateService taxRateService = TaxRateService();
  MeasurementLimitService measurementService = MeasurementLimitService();
  ItemsService itemService = ItemsService();
  List<String>? companyCode;

  // List of Data
  List<Item> itemsList = [];
  List<TaxRate> taxLists = [];
  List<MeasurementLimit> measurement = [];

  // Focus
  FocusNode noFocusNode = FocusNode();
  FocusNode dateFocusNode1 = FocusNode();
  FocusNode typeFocus = FocusNode();
  FocusNode partyFocus = FocusNode();
  FocusNode placeFocus = FocusNode();
  FocusNode billFocus = FocusNode();
  FocusNode remarksFocus = FocusNode();
  FocusNode dateFocusNode2 = FocusNode();

  List<String> indianStates = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal'
  ];

  List<String> header2Titles = ['Sr', 'Sundry Name', 'Amount'];

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

  Future<void> fetchItem() async {
    try {
      final List<Item> item = await itemService.fetchItems();

      itemsList = item;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> fetchAndSetTaxRates() async {
    try {
      final List<TaxRate> taxRates = await taxRateService.fetchTaxRates();

      taxLists = taxRates;
    } catch (error) {
      // print('Failed to fetch Tax Rates: $error');
    }
  }

  Future<void> fetchMeasurementLimit() async {
    try {
      final List<MeasurementLimit> measurements =
          await measurementService.fetchMeasurementLimits();

      measurement = measurements;
    } catch (error) {
      print('Failed to fetch Tax Rates: $error');
    }
  }

  Future<void> fetchSinglePurchase() async {
    final response = await purchaseServices.fetchPurchaseById(widget.data);

    setState(() {
      purchaseController.noController.text = response!.no;
      purchaseController.dateController.text = response.date;
      purchaseController.typeController.text = response.type;
      purchaseController.ledgerController.text = response.ledger;
      purchaseController.placeController.text = response.place;
      purchaseController.billNumberController.text = response.billNumber;
      purchaseController.date2Controller.text = response.date2;
      purchaseController.cashAmountController.text = response.cashAmount ?? '';
      purchaseController.remarksController!.text = response.remarks;

      selectedStatus = response.type;
      selectedState = response.place;
      selectedLedgerName = response.ledger;

      // Add the existing entries to the _allValues list
      for (final entry in response.entries) {
        final entryId = UniqueKey().toString();
        _allValues.add({
          'uniqueKey': entryId,
          'itemName': entry.itemName,
          'qty': entry.qty,
          'rate': entry.rate,
          'unit': entry.unit,
          'amount': entry.amount,
          'tax': entry.tax,
          'sgst': entry.sgst,
          'cgst': entry.cgst,
          'igst': entry.igst,
          'discount': entry.discount,
          'netAmount': entry.netAmount,
          'sellingPrice': entry.sellingPrice,
        });

        // Set the controller
        final itemNameController = TextEditingController(text: entry.itemName);
        final qtyController = TextEditingController(text: entry.qty.toString());
        final rateController =
            TextEditingController(text: entry.rate.toString());
        final unitController = TextEditingController(text: entry.unit);
        final amountController =
            TextEditingController(text: entry.amount.toString());
        final taxController = TextEditingController(text: entry.tax);
        final sgstController =
            TextEditingController(text: entry.sgst.toString());
        final cgstController =
            TextEditingController(text: entry.cgst.toString());
        final igstController =
            TextEditingController(text: entry.igst.toString());
        final netAmountController =
            TextEditingController(text: entry.netAmount.toString());
        final discountController =
            TextEditingController(text: entry.discount.toString());
        final sellingPriceController =
            TextEditingController(text: entry.sellingPrice.toString());

        // Add the existing entries to the _newWidget list
        _newWidget.add(
          PEntries2(
            key: ValueKey(entryId),
            serialNo: _newWidget.length + 1,
            itemNameControllerP: itemNameController,
            qtyControllerP: qtyController,
            rateControllerP: rateController,
            unitControllerP: unitController,
            amountControllerP: amountController,
            taxControllerP: taxController,
            sgstControllerP: sgstController,
            cgstControllerP: cgstController,
            igstControllerP: igstController,
            netAmountControllerP: netAmountController,
            sellingPriceControllerP: sellingPriceController,
            discountControllerP: discountController,
            onSaveValues: saveValues,
            itemsList: itemsList,
            measurement: measurement,
            taxLists: taxLists,
            onDelete: (String entryId) {
              setState(
                () {
                  _newWidget
                      .removeWhere((widget) => widget.key == ValueKey(entryId));

                  // Find the map in _allValues that contains the entry with the specified entryId
                  Map<String, dynamic>? entryToRemove;
                  for (final entry in _allValues) {
                    if (entry['uniqueKey'] == entryId) {
                      entryToRemove = entry;
                      break;
                    }
                  }

                  // Remove the map from _allValues if found
                  if (entryToRemove != null) {
                    _allValues.remove(entryToRemove);
                  }
                },
              );
            },
            entryId: entryId,
          ),
        );

        // Calculate total in full here
        // Tqty += double.parse(entry.qty.toString());
        // Tamount += double.parse(entry.amount.toString());
        // Tdisc += double.parse(entry.tax.toString());
        // Tsgst += double.parse(entry.sgst.toString());
        // Tcgst += double.parse(entry.cgst.toString());
        // Tigst += double.parse(entry.igst.toString());
        // TnetAmount += double.parse(entry.netAmount.toString());
        // Tdiscount += double.parse(entry.discount.toString());
      }

      while (_newWidget.length < 5) {
        final newEntryId = UniqueKey().toString();

        _newWidget.add(
          PEntries2(
            key: ValueKey(newEntryId),
            serialNo: _newWidget.length + 1,
            itemNameControllerP: TextEditingController(),
            qtyControllerP: TextEditingController(),
            rateControllerP: TextEditingController(),
            unitControllerP: TextEditingController(),
            amountControllerP: TextEditingController(),
            taxControllerP: TextEditingController(),
            sgstControllerP: TextEditingController(),
            cgstControllerP: TextEditingController(),
            igstControllerP: TextEditingController(),
            netAmountControllerP: TextEditingController(),
            sellingPriceControllerP: TextEditingController(),
            discountControllerP: TextEditingController(),
            onSaveValues: saveValues,
            itemsList: itemsList,
            measurement: measurement,
            taxLists: taxLists,
            onDelete: (String entryId) {
              setState(
                () {
                  _newWidget
                      .removeWhere((widget) => widget.key == ValueKey(entryId));

                  // Find the map in _allValues that contains the entry with the specified entryId
                  Map<String, dynamic>? entryToRemove;
                  for (final entry in _allValues) {
                    if (entry['uniqueKey'] == entryId) {
                      entryToRemove = entry;
                      break;
                    }
                  }

                  // Remove the map from _allValues if found
                  if (entryToRemove != null) {
                    _allValues.remove(entryToRemove);
                  }
                  calculateTotal();
                },
              );
            },
            entryId: newEntryId,
          ),
        );
      }

      // Add the existing sundry to the _allValuesSundry list
      for (final entry in response.sundry) {
        final entryId = UniqueKey().toString();
        _allValuesSundry.add({
          'uniqueKey': entryId,
          'sundryName': entry?.sundryName ?? '',
          'amount': entry?.amount ?? '',
        });

        // Add the existing sundry to the _newSundry list
        _newSundry.add(
          SundryRow(
            key: ValueKey(entryId),
            serialNumber: _currentSundrySerialNumber++,
            sundryControllerP: sundryFormController.sundryController,
            sundryControllerQ: sundryFormController.amountController,
            onSaveValues: (p0) {},
            onDelete: (String entryId) {
              setState(
                () {
                  _newSundry
                      .removeWhere((widget) => widget.key == ValueKey(entryId));

                  // Find the map in _allValuesSundry that contains the entry with the specified entryId
                  Map<String, dynamic>? entryToRemove;
                  for (final entry in _allValuesSundry) {
                    if (entry['uniqueKey'] == entryId) {
                      entryToRemove = entry;
                      break;
                    }
                  }

                  // Remove the map from _allValuesSundry if found
                  if (entryToRemove != null) {
                    _allValuesSundry.remove(entryToRemove);
                  }
                },
              );
            },
            entryId: entryId,
          ),
        );
      }
    });
  }

  Future<void> fetchLedgers2() async {
    try {
      final List<Ledger> ledger = await ledgerService.fetchLedgers();

      suggestionItems5 = ledger;
    } catch (error) {
      print('Failed to fetch ledger name: $error');
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

  double Ttotal = 0.00;
  double Tqty = 0;
  double Tamount = 0;
  double Tdisc = 0;
  double Tsgst = 0;
  double Tcgst = 0;
  double Tigst = 0;
  double TnetAmount = 0;
  double TsundryAmount = 0;
  double Tdiscount = 0.00;
  double ledgerAmount = 0;
  double roundedValue = 0.00;
  double roundOff = 0.00;
  late Timer _timer;

  void calculateTotal() {
    double qty = 0.00;
    double amount = 0.00;
    double sgst = 0.00;
    double cgst = 0.00;
    double igst = 0.00;
    double netAmount = 0.00;
    double discount = 0.00;

    for (var values in _allValues) {
      qty += double.tryParse(values['qty'].toString()) ?? 0;
      amount += double.tryParse(values['amount'].toString()) ?? 0;
      sgst += double.tryParse(values['sgst'].toString()) ?? 0;
      cgst += double.tryParse(values['cgst'].toString()) ?? 0;
      igst += double.tryParse(values['igst'].toString()) ?? 0;
      netAmount += double.tryParse(values['netAmount'].toString()) ?? 0;
      discount += double.tryParse(values['discount'].toString()) ?? 0;
    }
    double totalAmount = netAmount + Ttotal;
    int roundedValue2 = totalAmount.truncate();
    double roundOff2 = totalAmount - roundedValue2;

    setState(() {
      Tqty = qty;
      Tamount = amount;
      Tsgst = sgst;
      Tcgst = cgst;
      Tigst = igst;
      TnetAmount = netAmount;
      roundedValue = roundedValue2.toDouble();
      roundOff = roundOff2;
      Tdiscount = discount;
    });
  }

  void _startTimer() {
    const Duration duration = Duration(seconds: 2);
    _timer = Timer.periodic(duration, (Timer timer) {
      calculateTotal();
    });
  }

  Future<void> _initializeData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await Future.wait([
        fetchLedgers2(),
        fetchItem(),
        fetchAndSetTaxRates(),
        fetchMeasurementLimit(),
        setCompanyCode(),
      ]);

      await fetchSinglePurchase();
    } catch (e) {
      print("Error in fetching data: $e");
    } finally {}
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (mounted) {
      FocusScope.of(context).requestFocus(noFocusNode);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    purchaseController.dispose();
    _newSundry.clear();
    _allValues.clear();
    _allValuesSundry.clear();
    _timer.cancel();

    noFocusNode.dispose();
    dateFocusNode1.dispose();
    typeFocus.dispose();
    partyFocus.dispose();
    placeFocus.dispose();
    billFocus.dispose();
    remarksFocus.dispose();
    dateFocusNode2.dispose();
  }

  // Write code for update purchase
  Future<void> updatePurchase() async {
    print(_allValues);
    print(_allValuesSundry);
    Purchase purchaseData = Purchase(
        id: widget.data,
        companyCode: companyCode!.first,
        totalamount: (TnetAmount + Ttotal).toString(),
        no: purchaseController.noController.text,
        date: purchaseController.dateController.text,
        cashAmount: purchaseController.cashAmountController.text,
        dueAmount: purchaseController.dueAmountController.text,
        date2: purchaseController.date2Controller.text,
        type: selectedStatus!,
        ledger: selectedLedgerName!,
        place: selectedState!,
        billNumber: purchaseController.billNumberController.text,
        remarks: purchaseController.remarksController!.text,
        roundoffDiff: 0.00,
        entries: _allValues.map((entry) {
          return PurchaseEntry(
            itemName: entry['itemName'] ?? '',
            qty: int.tryParse(entry['qty'].toString()) ?? 0,
            rate: double.tryParse(entry['rate'].toString()) ?? 0,
            unit: entry['unit'] ?? '',
            amount: double.tryParse(entry['amount'].toString()) ?? 0,
            tax: entry['tax'] ?? '',
            sgst: double.tryParse(entry['sgst'].toString()) ?? 0,
            cgst: double.tryParse(entry['cgst'].toString()) ?? 0,
            igst: double.tryParse(entry['igst'].toString()) ?? 0,
            netAmount: double.tryParse(entry['netAmount'].toString()) ?? 0,
            sellingPrice:
                double.tryParse(entry['sellingPrice'].toString()) ?? 0,
            discount: double.tryParse(entry['sellingPrice'].toString()) ?? 0,
          );
        }).toList(),
        sundry: _allValuesSundry.map((sundry) {
          return SundryEntry(
            sundryName: sundry['sndryName'] ?? '',
            amount: double.tryParse(sundry['sundryAmount']) ?? 0,
          );
        }).toList());

    print(purchaseData);

    await purchaseServices.updatePurchase(purchaseData, context).then((value) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const PEMasterBody(),
        ),
      );
    }).catchError((error) {
      Navigator.of(context).pop();
      print('Failed to create purchase: $error');
    });
  }

  Widget purchaseTopText({required double width, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: width,
        height: 30,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: const Color(0xFF4B0082),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      descendantsAreFocusable: true,
      descendantsAreTraversable: true,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PECustomAppBar(
                title: 'Purchase Entry Edit',
                width1: 0.18,
                width2: 0.82,
                color: const Color(0xFFDAA520),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Form(
                        // key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                purchaseTopText(
                                  width:
                                      MediaQuery.of(context).size.width * 0.07,
                                  text: 'No',
                                ),
                                PETextFieldsNo(
                                  // onEditingComplete: () {
                                  //   FocusScope.of(context)
                                  //       .requestFocus(dateFocusNode1);
                                  // },
                                  // focusNode: noFocusNode,
                                  onSaved: (newValue) {
                                    purchaseController.noController.text =
                                        newValue!;
                                  },
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height: 40,
                                  controller: purchaseController.noController,
                                ),
                                purchaseTopText(
                                  width:
                                      MediaQuery.of(context).size.width * 0.06,
                                  text: 'Date',
                                ),
                                Flexible(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.075,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(0),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, bottom: 14.0),
                                      child: TextFormField(
                                        focusNode: dateFocusNode1,
                                        onEditingComplete: () {
                                          FocusScope.of(context)
                                              .requestFocus(typeFocus);

                                          setState(() {});
                                        },
                                        controller:
                                            purchaseController.dateController,
                                        onSaved: (newValue) {
                                          purchaseController
                                              .dateController.text = newValue!;
                                        },
                                        decoration: InputDecoration(
                                          hintText: _selectedDate == null
                                              ? '12/12/2023'
                                              : formatter
                                                  .format(_selectedDate!),
                                          contentPadding: const EdgeInsets.only(
                                              left: 1, bottom: 8),
                                          border: InputBorder.none,
                                        ),
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: dateFocusNode1.hasFocus
                                              ? Colors.white
                                              : Colors.black,
                                          // color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.035,
                                  child: IconButton(
                                      onPressed: _presentDatePICKER,
                                      icon: const Icon(Icons.calendar_month)),
                                ),
                                const SizedBox(width: 50),
                                purchaseTopText(
                                  width:
                                      MediaQuery.of(context).size.width * 0.06,
                                  text: 'Type',
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    color: Colors.white,
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  height: 40,
                                  padding: const EdgeInsets.all(2.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownMenu<String>(
                                      focusNode: typeFocus,

                                      requestFocusOnTap: true,

                                      initialSelection: selectedStatus!.isEmpty
                                          ? status.first
                                          : selectedStatus,
                                      enableSearch: true,
                                      // enableFilter: true,
                                      // leadingIcon: const SizedBox.shrink(),
                                      trailingIcon: const SizedBox.shrink(),
                                      textStyle: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        decoration: TextDecoration.none,
                                      ),
                                      selectedTrailingIcon:
                                          const SizedBox.shrink(),

                                      inputDecorationTheme:
                                          InputDecorationTheme(
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                        isDense: true,
                                        activeIndicatorBorder: const BorderSide(
                                          color: Colors.transparent,
                                        ),
                                        counterStyle: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      expandedInsets: EdgeInsets.zero,
                                      onSelected: (String? value) {
                                        FocusScope.of(context)
                                            .requestFocus(partyFocus);
                                        setState(() {
                                          selectedStatus = value!;
                                          purchaseController.typeController
                                              .text = selectedStatus!;
                                          // Set Type
                                        });
                                      },
                                      dropdownMenuEntries: status
                                          .map<DropdownMenuEntry<String>>(
                                              (String value) {
                                        return DropdownMenuEntry<String>(
                                            value: value,
                                            label: value,
                                            style: ButtonStyle(
                                              textStyle:
                                                  WidgetStateProperty.all(
                                                GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: typeFocus.hasFocus
                                                      ? Colors.white
                                                      : Colors.black,
                                                  // color: Colors.black,
                                                ),
                                              ),
                                            ));
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      purchaseTopText(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.07,
                                        text: 'Party',
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          color: Colors.white,
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.265,
                                        height: 40,
                                        padding: const EdgeInsets.all(2.0),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownMenu<Ledger>(
                                            focusNode: partyFocus,
                                            requestFocusOnTap: true,
                                            initialSelection: suggestionItems5
                                                        .isEmpty ||
                                                    selectedLedgerName == null
                                                ? null
                                                : suggestionItems5.firstWhere(
                                                    (element) =>
                                                        element.id ==
                                                        selectedLedgerName),
                                            enableSearch: true,
                                            trailingIcon:
                                                const SizedBox.shrink(),
                                            textStyle: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              decoration: TextDecoration.none,
                                            ),
                                            menuHeight: 300,
                                            enableFilter: true,
                                            filterCallback:
                                                (List<DropdownMenuEntry<Ledger>>
                                                        entries,
                                                    String filter) {
                                              final String trimmedFilter =
                                                  filter.trim().toLowerCase();

                                              if (trimmedFilter.isEmpty) {
                                                return entries;
                                              }

                                              // Filter the entries based on the query
                                              return entries.where((entry) {
                                                return entry.value.name
                                                    .toLowerCase()
                                                    .contains(trimmedFilter);
                                              }).toList();
                                            },
                                            selectedTrailingIcon:
                                                const SizedBox.shrink(),
                                            inputDecorationTheme:
                                                const InputDecorationTheme(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 16),
                                              isDense: true,
                                              activeIndicatorBorder: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            expandedInsets: EdgeInsets.zero,
                                            onSelected: (Ledger? value) {
                                              FocusScope.of(context)
                                                  .requestFocus(placeFocus);
                                              setState(() {
                                                if (selectedLedgerName !=
                                                    null) {
                                                  selectedLedgerName =
                                                      value!.id;
                                                  purchaseController
                                                          .ledgerController
                                                          .text =
                                                      selectedLedgerName!;

                                                  final selectedLedger =
                                                      suggestionItems5.firstWhere(
                                                          (element) =>
                                                              element.id ==
                                                              selectedLedgerName);

                                                  ledgerAmount = selectedLedger
                                                      .debitBalance;
                                                }
                                              });
                                            },
                                            dropdownMenuEntries:
                                                suggestionItems5.map<
                                                        DropdownMenuEntry<
                                                            Ledger>>(
                                                    (Ledger value) {
                                              return DropdownMenuEntry<Ledger>(
                                                value: value,
                                                label: value.name,
                                                trailingIcon: Text(
                                                  value.debitBalance
                                                      .toStringAsFixed(2),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                style: ButtonStyle(
                                                  textStyle:
                                                      WidgetStateProperty.all(
                                                    GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.041),
                                      purchaseTopText(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        text: 'Place',
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          color: Colors.white,
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        height: 40,
                                        padding: const EdgeInsets.all(2.0),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownMenu<String>(
                                            focusNode: placeFocus,

                                            requestFocusOnTap: true,

                                            initialSelection:
                                                selectedState == null
                                                    ? indianStates.first
                                                    : null,
                                            enableSearch: true,
                                            // enableFilter: true,
                                            // leadingIcon: const SizedBox.shrink(),
                                            menuHeight: 300,

                                            trailingIcon:
                                                const SizedBox.shrink(),
                                            textStyle: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              decoration: TextDecoration.none,
                                            ),
                                            selectedTrailingIcon:
                                                const SizedBox.shrink(),

                                            inputDecorationTheme:
                                                InputDecorationTheme(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 8),
                                              isDense: true,
                                              activeIndicatorBorder:
                                                  const BorderSide(
                                                color: Colors.transparent,
                                              ),
                                              counterStyle: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                // color: Colors.black,
                                              ),
                                            ),
                                            expandedInsets: EdgeInsets.zero,
                                            onSelected: (String? value) {
                                              FocusScope.of(context)
                                                  .requestFocus(billFocus);
                                              setState(() {
                                                selectedState = value;
                                                purchaseController
                                                    .placeController
                                                    .text = selectedState!;
                                              });
                                            },
                                            dropdownMenuEntries: indianStates
                                                .map<DropdownMenuEntry<String>>(
                                                    (String value) {
                                              return DropdownMenuEntry<String>(
                                                  value: value,
                                                  label: value,
                                                  style: ButtonStyle(
                                                    textStyle:
                                                        WidgetStateProperty.all(
                                                      GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        // color:
                                                        //     Colors.black,
                                                      ),
                                                    ),
                                                  ));
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      purchaseTopText(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.07,
                                        text: 'Bill No',
                                      ),
                                      PETextFields(
                                        // onEditingComplete: () {
                                        //   FocusScope.of(context)
                                        //       .requestFocus(dateFocusNode2);

                                        //   setState(() {});
                                        // },
                                        // focusNode: billFocus,
                                        onSaved: (newValue) {
                                          purchaseController
                                              .billNumberController
                                              .text = newValue!;
                                        },
                                        controller: purchaseController
                                            .billNumberController,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.265,
                                        height: 40,
                                        readOnly: false,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.041,
                                      ),
                                      purchaseTopText(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        text: 'Date',
                                      ),
                                      Flexible(
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.13,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, bottom: 14.0),
                                            child: TextFormField(
                                              focusNode: dateFocusNode2,
                                              onEditingComplete: () {
                                                FocusScope.of(context)
                                                    .requestFocus(remarksFocus);
                                                setState(() {});
                                              },
                                              onSaved: (newValue) {
                                                purchaseController
                                                    .date2Controller
                                                    .text = newValue!;
                                              },
                                              controller: purchaseController
                                                  .date2Controller,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              decoration: InputDecoration(
                                                hintText:
                                                    _pickedDateData == null
                                                        ? '12/12/2023'
                                                        : formatter.format(
                                                            _pickedDateData!),
                                                border: InputBorder.none,
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 1, bottom: 8),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        child: IconButton(
                                            onPressed: _showDataPICKER,
                                            icon: const Icon(
                                                Icons.calendar_month)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.only(right: 18.0, bottom: 8.0),
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.end,
                            //     mainAxisAlignment: MainAxisAlignment.end,
                            //     children: [
                            //       Container(
                            //         width: 100,
                            //         height: 25,
                            //         decoration: BoxDecoration(
                            //             border: Border.all(color: Colors.black)),
                            //         child: InkWell(
                            //           onTap: () {
                            //             final entryId = UniqueKey().toString();
                            //             setState(() {
                            //               _newWidget.add(
                            //                 PEntries2(
                            //                   key: ValueKey(entryId),
                            //                   serialNo: _newWidget.length + 1,
                            //                   itemNameControllerP:
                            //                       TextEditingController(),
                            //                   qtyControllerP:
                            //                       TextEditingController(),
                            //                   rateControllerP:
                            //                       TextEditingController(),
                            //                   unitControllerP:
                            //                       TextEditingController(),
                            //                   amountControllerP:
                            //                       TextEditingController(),
                            //                   taxControllerP:
                            //                       TextEditingController(),
                            //                   sgstControllerP:
                            //                       TextEditingController(),
                            //                   cgstControllerP:
                            //                       TextEditingController(),
                            //                   igstControllerP:
                            //                       TextEditingController(
                            //                           text: '0'),
                            //                   netAmountControllerP:
                            //                       TextEditingController(),
                            //                   discountControllerP:
                            //                       TextEditingController(),
                            //                   sellingPriceControllerP:
                            //                       TextEditingController(),
                            //                   onSaveValues: saveValues,
                            //                   onDelete: (String entryId) {
                            //                     setState(
                            //                       () {
                            //                         _newWidget.removeWhere(
                            //                             (widget) =>
                            //                                 widget.key ==
                            //                                 ValueKey(entryId));

                            //                         // Find the map in _allValues that contains the entry with the specified entryId
                            //                         Map<String, dynamic>?
                            //                             entryToRemove;
                            //                         for (final entry
                            //                             in _allValues) {
                            //                           if (entry['uniqueKey'] ==
                            //                               entryId) {
                            //                             entryToRemove = entry;
                            //                             break;
                            //                           }
                            //                         }

                            //                         // Remove the map from _allValues if found
                            //                         if (entryToRemove != null) {
                            //                           _allValues
                            //                               .remove(entryToRemove);
                            //                         }
                            //                         calculateTotal();
                            //                       },
                            //                     );
                            //                   },
                            //                   entryId: entryId,
                            //                 ),
                            //               );
                            //             });
                            //           },
                            //           child: const Text(
                            //             'Add',
                            //             style: TextStyle(
                            //               color: Colors.black,
                            //               fontWeight: FontWeight.w900,
                            //               fontSize: 15,
                            //             ),
                            //             softWrap: false,
                            //             maxLines: 1,
                            //             overflow: TextOverflow.ellipsis,
                            //             textAlign: TextAlign.center,
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),

                            // Padding(
                            //   padding:
                            //       const EdgeInsets.only(right: 18.0, bottom: 8.0),
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.end,
                            //     mainAxisAlignment: MainAxisAlignment.end,
                            //     children: [
                            //       Container(
                            //         width: 100,
                            //         height: 25,
                            //         decoration: BoxDecoration(
                            //             border: Border.all(color: Colors.black)),
                            //         child: InkWell(
                            //           // onTap: calculateTotal,
                            //           onTap: calculateTotal,
                            //           child: const Text(
                            //             'Save all',
                            //             style: TextStyle(
                            //               color: Colors.black,
                            //               fontWeight: FontWeight.w900,
                            //               fontSize: 15,
                            //             ),
                            //             softWrap: false,
                            //             maxLines: 1,
                            //             overflow: TextOverflow.ellipsis,
                            //             textAlign: TextAlign.center,
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),

                            //table header
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Row(
                                children: [
                                  TableHeaderText(
                                    text: 'Sr',
                                    width: MediaQuery.of(context).size.width *
                                        0.023,
                                  ),
                                  TableHeaderText(
                                    text: '   Item Name',
                                    width: MediaQuery.of(context).size.width *
                                        0.19,
                                  ),
                                  TableHeaderText(
                                    text: 'Qty',
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                  ),
                                  TableHeaderText(
                                    text: 'Unit',
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                  ),
                                  TableHeaderText(
                                    text: 'Rate',
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                  ),
                                  TableHeaderText(
                                    text: 'Amount',
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                  ),
                                  TableHeaderText(
                                    text: 'Disc',
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                  ),
                                  TableHeaderText(
                                    text: 'Tax%',
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                  ),
                                  TableHeaderText(
                                    text: 'SGST',
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                  ),
                                  TableHeaderText(
                                    text: 'CGST',
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                  ),
                                  TableHeaderText(
                                    text: 'IGST',
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                  ),
                                  TableHeaderText(
                                    text: 'Net Amt.',
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                  ),
                                  TableHeaderText(
                                    text: 'Selling Amt.',
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),

                            //table body
                            isLoading
                                ? const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: TableExample(rows: 7, cols: 13),
                                  )
                                : Column(
                                    children: [
                                      SizedBox(
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: _newWidget,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            // Table footer
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.023,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(),
                                            top: BorderSide(),
                                            left: BorderSide())),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Total',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF4B0082),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.19,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(),
                                            top: BorderSide(),
                                            left: BorderSide())),
                                    child: const Text(
                                      '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(),
                                            top: BorderSide(),
                                            left: BorderSide())),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '$Tqty',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF4B0082),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(),
                                            top: BorderSide(),
                                            left: BorderSide())),
                                    child: const Text(
                                      '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(),
                                            top: BorderSide(),
                                            left: BorderSide())),
                                    child: const Text(
                                      '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(),
                                            top: BorderSide(),
                                            left: BorderSide())),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        Tamount.toStringAsFixed(2),
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF4B0082),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(),
                                            top: BorderSide(),
                                            left: BorderSide())),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        Tdiscount.toStringAsFixed(2),
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF4B0082),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(),
                                            top: BorderSide(),
                                            left: BorderSide())),
                                    child: const Text(
                                      '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(),
                                            top: BorderSide(),
                                            left: BorderSide())),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        Tsgst.toStringAsFixed(2),
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF4B0082),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(),
                                            top: BorderSide(),
                                            left: BorderSide())),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        Tcgst.toStringAsFixed(2),
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF4B0082),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(),
                                            top: BorderSide(),
                                            left: BorderSide())),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        Tigst.toStringAsFixed(2),
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF4B0082),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(),
                                            top: BorderSide(),
                                            left: BorderSide(),
                                            right: BorderSide())),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        TnetAmount.toStringAsFixed(2),
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF4B0082),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.061,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(),
                                            top: BorderSide(),
                                            left: BorderSide(
                                                color: Colors.transparent),
                                            right: BorderSide())),
                                    child: const Text(
                                      '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              purchaseTopText(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.06,
                                                text: 'Remarks',
                                              ),
                                              PETextFields(
                                                // focusNode: FocusNode(),
                                                // onEditingComplete: () {
                                                //   // FocusScope.of(
                                                //   //         context)
                                                //   //     .requestFocus(
                                                //   //         typeFocus);

                                                //   setState(() {});
                                                // },
                                                onSaved: (newValue) {
                                                  purchaseController
                                                      .remarksController!
                                                      .text = newValue!;
                                                },
                                                controller: purchaseController
                                                    .remarksController,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                height: 40,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  height: 170,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 44, 43, 43),
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                        height: 40,
                                                        decoration:
                                                            const BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      44,
                                                                      43,
                                                                      43),
                                                              width: 2,
                                                            ),
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'Ledger Information',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: const Color(
                                                                  0xFF4B0082),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.3,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                border: Border(
                                                                  bottom:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 1,
                                                                  ),
                                                                ),
                                                              ),
                                                              child: SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.5,
                                                                height: 30,
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        'Limit',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              const Color(0xFF4B0082),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: 2,
                                                                      height:
                                                                          30,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          44,
                                                                          43,
                                                                          43),
                                                                    ),
                                                                    // Change Ledger Amount
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        color: const Color(
                                                                            0xFFA0522D),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            (ledgerAmount + (TnetAmount + Ttotal)).toStringAsFixed(2),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                // ignore: prefer_const_constructors
                                                                                GoogleFonts.poppins(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: 2,
                                                                      height:
                                                                          30,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          44,
                                                                          43,
                                                                          43),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        'Bal',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              const Color(0xFF4B0082),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: 2,
                                                                      height:
                                                                          30,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          44,
                                                                          43,
                                                                          43),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        color: const Color(
                                                                            0xFFA0522D),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            '0.00 Dr',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.white,
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
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Consumer<OnChangeItenProvider>(
                                                    builder:
                                                        (context, itemID, _) {
                                                  return Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.38,
                                                    height: 170,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.black,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 4,
                                                              child: Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                        border:
                                                                            Border(
                                                                  right:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                )),
                                                                height: 30,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0),
                                                                    ),
                                                                    backgroundColor:
                                                                        const Color(
                                                                            0xFFDAA520),
                                                                  ),
                                                                  child: Text(
                                                                    'Statements',
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    softWrap:
                                                                        false,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 6,
                                                              child: Text(
                                                                'Recent Transaction for the item',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: const Color(
                                                                      0xFF4B0082),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 4,
                                                              child: Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                        border:
                                                                            Border(
                                                                  left:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                )),
                                                                height: 30,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0),
                                                                    ),
                                                                    backgroundColor:
                                                                        const Color(
                                                                            0xFFDAA520),
                                                                  ),
                                                                  child: Text(
                                                                    'Purchase',
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                        // Table Starts Here
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          decoration:
                                                              const BoxDecoration(
                                                                  border:
                                                                      Border(
                                                            right: BorderSide(
                                                              color: Colors
                                                                  .transparent,
                                                            ),
                                                            bottom: BorderSide(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            left: BorderSide(
                                                              color: Colors
                                                                  .transparent,
                                                            ),
                                                            top: BorderSide(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          )),
                                                          child: Row(
                                                            children:
                                                                List.generate(
                                                              headerTitles
                                                                  .length,
                                                              (index) =>
                                                                  Expanded(
                                                                child: Text(
                                                                  headerTitles[
                                                                      index],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: const Color(
                                                                        0xFF4B0082),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        // Table Body

                                                        Expanded(
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            child: Table(
                                                              border: TableBorder.all(
                                                                  width: 1.0,
                                                                  color: Colors
                                                                      .black),
                                                              children: [
                                                                // Iterate over all purchases' entries
                                                                for (int i = 0;
                                                                    i <
                                                                        fetchedPurchase
                                                                            .length;
                                                                    i++)
                                                                  ...fetchedPurchase[
                                                                          i]
                                                                      .entries
                                                                      .where((entry) =>
                                                                          entry
                                                                              .itemName ==
                                                                          itemID
                                                                              .itemID)
                                                                      .map(
                                                                          (entry) {
                                                                    // Find the corresponding ledger for the current entry
                                                                    String
                                                                        ledgerName =
                                                                        '';
                                                                    if (suggestionItems5
                                                                        .isNotEmpty) {
                                                                      final ledger =
                                                                          suggestionItems5
                                                                              .firstWhere(
                                                                        (ledger) =>
                                                                            ledger.id ==
                                                                            fetchedPurchase[i].ledger,
                                                                        orElse: () =>
                                                                            Ledger(
                                                                          id: '',
                                                                          name:
                                                                              '',
                                                                          printName:
                                                                              '',
                                                                          aliasName:
                                                                              '',
                                                                          ledgerGroup:
                                                                              '',
                                                                          date:
                                                                              '',
                                                                          bilwiseAccounting:
                                                                              '',
                                                                          creditDays:
                                                                              0,
                                                                          openingBalance:
                                                                              0,
                                                                          debitBalance:
                                                                              0,
                                                                          ledgerType:
                                                                              '',
                                                                          priceListCategory:
                                                                              '',
                                                                          remarks:
                                                                              '',
                                                                          status:
                                                                              '',
                                                                          ledgerCode:
                                                                              0,
                                                                          mailingName:
                                                                              '',
                                                                          address:
                                                                              '',
                                                                          city:
                                                                              '',
                                                                          region:
                                                                              '',
                                                                          state:
                                                                              '',
                                                                          pincode:
                                                                              0,
                                                                          tel:
                                                                              0,
                                                                          fax:
                                                                              0,
                                                                          mobile:
                                                                              0,
                                                                          sms:
                                                                              0,
                                                                          email:
                                                                              '',
                                                                          contactPerson:
                                                                              '',
                                                                          bankName:
                                                                              '',
                                                                          branchName:
                                                                              '',
                                                                          ifsc:
                                                                              '',
                                                                          accName:
                                                                              '',
                                                                          accNo:
                                                                              '',
                                                                          panNo:
                                                                              '',
                                                                          gst:
                                                                              '',
                                                                          gstDated:
                                                                              '',
                                                                          cstNo:
                                                                              '',
                                                                          cstDated:
                                                                              '',
                                                                          lstNo:
                                                                              '',
                                                                          lstDated:
                                                                              '',
                                                                          serviceTaxNo:
                                                                              '',
                                                                          serviceTaxDated:
                                                                              '',
                                                                          registrationType:
                                                                              '',
                                                                          registrationTypeDated:
                                                                              '',
                                                                        ),
                                                                      );
                                                                      ledgerName =
                                                                          ledger
                                                                              .name;
                                                                    }

                                                                    return TableRow(
                                                                      children: [
                                                                        Text(
                                                                          fetchedPurchase[i]
                                                                              .date
                                                                              .toString(),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                        Text(
                                                                          fetchedPurchase[i]
                                                                              .billNumber
                                                                              .toString(),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                        Text(
                                                                          ledgerName, // Display the ledger name here
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                        Text(
                                                                          entry
                                                                              .qty
                                                                              .toString(),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                        Text(
                                                                          '${entry.rate}%', // Assuming this should be entry.rate, not entry.qty
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                        Text(
                                                                          entry
                                                                              .netAmount
                                                                              .toString(),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                      ],
                                                                    );
                                                                  }),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.22,
                                        height: 225,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            // Header

                                            Container(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                right: BorderSide(
                                                  color: Colors.transparent,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.black,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.transparent,
                                                ),
                                                top: BorderSide(
                                                  color: Colors.transparent,
                                                ),
                                              )),
                                              child: SizedBox(
                                                child: Row(
                                                  children: List.generate(
                                                    header2Titles.length,
                                                    (index) => Expanded(
                                                      child: SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          header2Titles[index],
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: const Color(
                                                                0xFF4B0082),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Table Body
                                            //Sundry
                                            // Padding(
                                            //   padding:
                                            //       const EdgeInsets.all(8.0),
                                            //   child: Row(
                                            //     crossAxisAlignment:
                                            //         CrossAxisAlignment.end,
                                            //     mainAxisAlignment:
                                            //         MainAxisAlignment.end,
                                            //     children: [
                                            //       Container(
                                            //         width: 100,
                                            //         height: 25,
                                            //         decoration:
                                            //             BoxDecoration(
                                            //           border: Border.all(
                                            //               color:
                                            //                   Colors.black),
                                            //         ),
                                            //         child: InkWell(
                                            //           onTap:
                                            //               calculateSundry,
                                            //           child: Text(
                                            //             'Save All',
                                            //             style: GoogleFonts
                                            //                 .poppins(
                                            //               fontSize: 15,
                                            //               fontWeight:
                                            //                   FontWeight
                                            //                       .bold,
                                            //               color:
                                            //                   Colors.black,
                                            //             ),
                                            //             softWrap: false,
                                            //             maxLines: 1,
                                            //             overflow:
                                            //                 TextOverflow
                                            //                     .ellipsis,
                                            //             textAlign: TextAlign
                                            //                 .center,
                                            //           ),
                                            //         ),
                                            //       ),
                                            //       // Container(
                                            //       //   width: 100,
                                            //       //   height: 25,
                                            //       //   decoration:
                                            //       //       BoxDecoration(
                                            //       //     border: Border.all(
                                            //       //         color:
                                            //       //             Colors.black),
                                            //       //   ),
                                            //       //   child: InkWell(
                                            //       //     onTap: () {
                                            //       //       final entryId =
                                            //       //           UniqueKey()
                                            //       //               .toString();

                                            //       //       setState(() {
                                            //       //         _newSundry.add(
                                            //       //           SundryRow(
                                            //       //               key: ValueKey(
                                            //       //                   entryId),
                                            //       //               serialNumber:
                                            //       //                   _currentSundrySerialNumber,
                                            //       //               sundryControllerP:
                                            //       //                   sundryFormController
                                            //       //                       .sundryController,
                                            //       //               sundryControllerQ:
                                            //       //                   sundryFormController
                                            //       //                       .amountController,
                                            //       //               onSaveValues:
                                            //       //                   saveSundry,
                                            //       //               entryId:
                                            //       //                   entryId,
                                            //       //               onDelete:
                                            //       //                   (String
                                            //       //                       entryId) {
                                            //       //                 setState(
                                            //       //                     () {
                                            //       //                   _newSundry.removeWhere((widget) =>
                                            //       //                       widget.key ==
                                            //       //                       ValueKey(entryId));

                                            //       //                   Map<String,
                                            //       //                           dynamic>?
                                            //       //                       entryToRemove;
                                            //       //                   for (final entry
                                            //       //                       in _allValuesSundry) {
                                            //       //                     if (entry['uniqueKey'] ==
                                            //       //                         entryId) {
                                            //       //                       entryToRemove =
                                            //       //                           entry;
                                            //       //                       break;
                                            //       //                     }
                                            //       //                   }

                                            //       //                   // Remove the map from _allValues if found
                                            //       //                   if (entryToRemove !=
                                            //       //                       null) {
                                            //       //                     _allValuesSundry
                                            //       //                         .remove(entryToRemove);
                                            //       //                   }
                                            //       //                   calculateSundry();
                                            //       //                 });
                                            //       //               }),
                                            //       //         );
                                            //       //         _currentSundrySerialNumber++;
                                            //       //       });
                                            //       //     },
                                            //       //     child: Text(
                                            //       //       'Add',
                                            //       //       style: GoogleFonts
                                            //       //           .poppins(
                                            //       //         fontSize: 15,
                                            //       //         fontWeight:
                                            //       //             FontWeight
                                            //       //                 .bold,
                                            //       //         color:
                                            //       //             Colors.black,
                                            //       //       ),
                                            //       //       softWrap: false,
                                            //       //       maxLines: 1,
                                            //       //       overflow:
                                            //       //           TextOverflow
                                            //       //               .ellipsis,
                                            //       //       textAlign: TextAlign
                                            //       //           .center,
                                            //       //     ),
                                            //       //   ),
                                            //       // ),
                                            //     ],
                                            //   ),
                                            // ),

                                            SizedBox(
                                              height: 180,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: _newSundry,
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

                            //Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.14,
                                      height: 30,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0,
                                        child: ElevatedButton(
                                          onPressed: updatePurchase,
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                              const Color.fromARGB(
                                                  255, 255, 243, 132),
                                            ),
                                            shape: MaterialStateProperty.all<
                                                OutlinedBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(1.0),
                                                side: const BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Save [F4]',
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.002,
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.14,
                                      height: 30,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                              const Color.fromARGB(
                                                  255, 255, 243, 132),
                                            ),
                                            shape: MaterialStateProperty.all<
                                                OutlinedBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(1.0),
                                                side: const BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Cancel',
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.002,
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.14,
                                      height: 30,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                              const Color.fromARGB(
                                                  255, 255, 243, 132),
                                            ),
                                            shape: MaterialStateProperty.all<
                                                OutlinedBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(1.0),
                                                side: const BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Delete',
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.3),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            height: 20,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            child: Text(
                                              'Round-Off: ',
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF4B0082),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 20,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                            decoration: const BoxDecoration(
                                                // border: Border(
                                                //     bottom:
                                                //         BorderSide(width: 1)),
                                                ),
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(12.0),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                ),
                                              ),
                                              controller: TextEditingController(
                                                  text: '0.00'),
                                              focusNode: FocusNode(),
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                  signed: true, decimal: true),
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF4B0082),
                                              ),
                                              onChanged: (value) {
                                                double newRoundOff =
                                                    double.tryParse(value) ??
                                                        0.00;
                                                setState(() {
                                                  // TRoundOff = newRoundOff;
                                                  // TfinalAmt =
                                                  //     TnetAmount + TRoundOff;
                                                  // isManualRoundOffChange = true;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            height: 20,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            child: Text(
                                              'Amount: ',
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF4B0082),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 20,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                            decoration: const BoxDecoration(
                                                // border: Border(
                                                //     bottom:
                                                //         BorderSide(width: 1)),
                                                ),
                                            child: Text(
                                              TnetAmount.toStringAsFixed(2),
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF4B0082),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.099,
                      child: Column(
                        children: [
                          CustomList(
                            Skey: "F2",
                            name: "List",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PEMasterBody(),
                                ),
                              );
                            },
                          ),
                          CustomList(
                            Skey: "F4",
                            name: "Add Line",
                            onTap: () {
                              final entryId = UniqueKey().toString();
                              setState(() {
                                _newWidget.add(
                                  PEntries2(
                                    key: ValueKey(entryId),
                                    serialNo: _newWidget.length + 1,
                                    itemNameControllerP:
                                        purchaseController.itemNameController,
                                    qtyControllerP:
                                        purchaseController.qtyController,
                                    rateControllerP:
                                        purchaseController.rateController,
                                    unitControllerP:
                                        purchaseController.unitController,
                                    amountControllerP:
                                        purchaseController.amountController,
                                    taxControllerP:
                                        purchaseController.taxController,
                                    discountControllerP:
                                        purchaseController.discountController,
                                    sgstControllerP:
                                        purchaseController.sgstController,
                                    cgstControllerP:
                                        purchaseController.cgstController,
                                    igstControllerP:
                                        purchaseController.igstController,
                                    netAmountControllerP:
                                        purchaseController.netAmountController,
                                    sellingPriceControllerP: purchaseController
                                        .sellingPriceController,
                                    onSaveValues: saveValues,
                                    onDelete: (String entryId) {
                                      setState(
                                        () {
                                          _newWidget.removeWhere((widget) =>
                                              widget.key == ValueKey(entryId));

                                          // Find the map in _allValues that contains the entry with the specified entryId
                                          Map<String, dynamic>? entryToRemove;
                                          for (final entry in _allValues) {
                                            if (entry['uniqueKey'] == entryId) {
                                              entryToRemove = entry;
                                              break;
                                            }
                                          }

                                          // Remove the map from _allValues if found
                                          if (entryToRemove != null) {
                                            _allValues.remove(entryToRemove);
                                          }
                                          calculateTotal();
                                        },
                                      );
                                    },
                                    entryId: entryId,
                                    itemsList: itemsList,
                                    measurement: measurement,
                                    taxLists: taxLists,
                                  ),
                                );
                              });
                            },
                          ),
                          CustomList(
                            Skey: "CTRL + L",
                            name: "Create Ledger",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LGMyDesktopBody(),
                                ),
                              );
                            },
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

                          // CustomList(
                          //     Skey: "F5", name: "Payment", onTap: () {}),
                          // CustomList(
                          //     Skey: "F6", name: "Receipt", onTap: () {}),
                          // CustomList(
                          //     Skey: "F7", name: "Journal", onTap: () {}),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(
                          //     Skey: "F8", name: "Contra", onTap: () {}),

                          // CustomList(
                          //     Skey: "CTRL + N",
                          //     name: "Search No",
                          //     onTap: () {}),
                          // CustomList(
                          //   Skey: "CTRL + M",
                          //   name: "Create Item",
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) =>
                          //             const NIMyDesktopBody(),
                          //       ),
                          //     );
                          //   },
                          // ),
                          // CustomList(
                          //   Skey: "",
                          //   name: "",
                          //   onTap: () {},
                          // ),
                          // CustomList(
                          //     Skey: "F12", name: "Discount", onTap: () {}),
                          // CustomList(
                          //     Skey: "F12", name: "Audit Trail", onTap: () {}),
                          // CustomList(
                          //     Skey: "PgUp", name: "Previous", onTap: () {}),
                          // CustomList(
                          //     Skey: "PgDn", name: "Next", onTap: () {}),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(
                          //     Skey: "CTRL + G",
                          //     name: "Attach. Img",
                          //     onTap: () {}),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(
                          //     Skey: "CTRL + G",
                          //     name: "Vch Setup",
                          //     onTap: () {}),
                          // CustomList(
                          //     Skey: "CTRL + T",
                          //     name: "Print Setup",
                          //     onTap: () {}),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _presentDatePICKER() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        purchaseController.dateController.text = formatter.format(pickedDate);
      });
    }
  }

  void _showDataPICKER() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );
    if (pickedDate != null) {
      setState(() {
        _pickedDateData = pickedDate;
        purchaseController.date2Controller.text = formatter.format(pickedDate);
      });
    }
  }

  void generateBillNumber() {
    // Generate a random number between 100 and 999
    Random random = Random();
    int randomNumber = random.nextInt(9000) + 1000;

    // Get the current month abbreviation
    String monthAbbreviation = _getMonthAbbreviation(DateTime.now().month);

    // Construct the bill number
    String billNumber = 'BIL$randomNumber$monthAbbreviation';

    setState(() {
      purchaseController.billNumberController.text = billNumber;
    });
  }

  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1:
        return 'JAN';
      case 2:
        return 'FEB';
      case 3:
        return 'MAR';
      case 4:
        return 'APR';
      case 5:
        return 'MAY';
      case 6:
        return 'JUN';
      case 7:
        return 'JUL';
      case 8:
        return 'AUG';
      case 9:
        return 'SEP';
      case 10:
        return 'OCT';
      case 11:
        return 'NOV';
      case 12:
        return 'DEC';
      default:
        return '';
    }
  }
}

class TableHeaderText extends StatelessWidget {
  const TableHeaderText({
    super.key,
    required this.text,
    required this.width,
    this.color,
  });

  final String text;
  final double width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: width,
      decoration: BoxDecoration(
        border: Border(
          bottom: const BorderSide(),
          top: const BorderSide(),
          left: const BorderSide(),
          right: BorderSide(
            color: color ?? Colors.transparent,
          ),
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: const Color(0xFF4B0082),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
