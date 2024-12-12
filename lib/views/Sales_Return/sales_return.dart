import 'dart:async';
import 'dart:math';

import 'package:billingsphere/data/models/salesEntries/sales_entrires_model.dart';
import 'package:billingsphere/data/models/salesReturn/sales_return_model.dart';
import 'package:billingsphere/data/repository/purchase_return_repository.dart';
import 'package:billingsphere/data/repository/sales_enteries_repository.dart';
// import 'package:billingsphere/data/repository/sales_enteries_repository.dart';
import 'package:billingsphere/data/repository/sales_return_repository.dart';
import 'package:billingsphere/utils/constant.dart';
import 'package:billingsphere/views/PURCHASE_RETURN/widget/purchase_return_textfield.dart';
import 'package:billingsphere/views/RV_responsive/receipt_billwise.dart';
import 'package:billingsphere/views/Sales_Return/sales_return_List.dart';
import 'package:billingsphere/views/Sales_Return/widget/salesEntry_table_widget.dart';

import 'package:billingsphere/views/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/item/item_model.dart';
import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/measurementLimit/measurement_limit_model.dart';
import '../../data/models/purchase/purchase_model.dart';
import '../../data/models/taxCategory/tax_category_model.dart';
import '../../data/repository/item_repository.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/measurement_limit_repository.dart';
import '../../data/repository/purchase_repository.dart';
import '../../data/repository/tax_category_repository.dart';
import '../../utils/controllers/purchase_text_controller.dart';
import '../../utils/controllers/sundry_controller.dart';
import '../LG_responsive/LG_desktop_body.dart';
import '../PE_widgets/PE_text_fields.dart';
import '../PE_widgets/PE_text_fields_no.dart';
import '../PE_widgets/purchase_table_mobile_2.dart';
import '../PEresponsive/PE_desktop_body.dart';
import '../SE_common/SE_top_text.dart';
import '../SE_responsive/SE_desktop_body.dart';
import '../SE_variables/SE_variables.dart';
import '../SE_widgets/sundry_row.dart';
import '../sumit_screen/voucher _entry.dart/voucher_list_widget.dart';
import 'widget/sales_return_textfield.dart';

class SalesReturnPage extends StatefulWidget {
  const SalesReturnPage({super.key});

  @override
  State<SalesReturnPage> createState() => _SalesReturnPageState();
}

class _SalesReturnPageState extends State<SalesReturnPage> {
  DateTime? _selectedDate;
  DateTime? _pickedDateData;
  List<String> status = ['Cash', 'Debit'];
  String selectedStatus = 'Debit';
  String? selectedState = 'Gujarat';
  List<SalesReturnTable> _newWidget = [];
  final List<PEntriesM> _newWidget2 = [];
  final List<SundryRow> _newSundry = [];
  final List<Map<String, dynamic>> _allValues = [];
  final List<Map<String, dynamic>> _allValuesBillwise = [];
  List<Billwise> billwise = [];
  final List<Map<String, dynamic>> _allValuesSundry = [];
  List<SalesReturn> fetchedSalesReturn = [];
  SalesEntry? selectedPurchase;
  List<Entry> selectedEntries = [];
  late Timer _timer;

  bool isLoading = false;
  bool isGettingDetails = false;

  // Focus
  // FocusNode noFocusNode = FocusNode();
  // FocusNode dateFocusNode1 = FocusNode();
  // FocusNode typeFocus = FocusNode();
  // FocusNode partyFocus = FocusNode();
  // FocusNode placeFocus = FocusNode();
  // FocusNode billFocus = FocusNode();
  // FocusNode remarksFocus = FocusNode();
  // FocusNode dateFocusNode2 = FocusNode();

  // SUMMATION VALUES
  double Ttotal = 0.00;
  double Tqty = 0.00;
  double Tamount = 0.00;
  double Tdisc = 0.00;
  double Tsgst = 0.00;
  double Tcgst = 0.00;
  double Tigst = 0.00;
  double TnetAmount = 0.00;
  double Tdiscount = 0.00;
  double ledgerAmount = 0;
  double TfinalAmt = 0.00;
  double TRoundOff = 0.00; // New variable to store the round-off amount
  late TextEditingController roundOffController;
  late FocusNode roundOffFocusNode;
  bool isManualRoundOffChange = false;
  final _formKey = GlobalKey<FormState>();

  List<String>? companyCode;

  //fetch ledger
  List<Ledger> suggestionItems5 = [];
  List<Item> itemsList = [];
  List<TaxRate> taxLists = [];
  List<MeasurementLimit> measurement = [];
  String? selectedLedgerName;
  LedgerService ledgerService = LedgerService();
  ItemsService itemsService = ItemsService();
  SalesReturnService salesReturnService = SalesReturnService();
  PurchaseServices purchaseServices = PurchaseServices();
  PurchaseReturnService purchaseReturnService = PurchaseReturnService();
  SalesEntryService salesEntryService = SalesEntryService();
  MeasurementLimitService measurementService = MeasurementLimitService();
  TaxRateService taxRateService = TaxRateService();

  // Controllers
  PurchaseFormController purchaseController = PurchaseFormController();
  SundryFormController sundryFormController = SundryFormController();

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

  String? purchaseLength;
  int _currentSundrySerialNumber = 1;

  String registrationTypeDated = '';

  Future<void> setEntriesTables() async {
    for (int i = 0; i < 5; i++) {
      final entryId = UniqueKey().toString();
      setState(() {
        _newWidget.add(
          SalesReturnTable(
            key: ValueKey(entryId),
            entryId: entryId,
            serialNumber: i + 1,
            itemNameControllerP: purchaseController.itemNameController,
            qtyControllerP: purchaseController.qtyController,
            rateControllerP: purchaseController.rateController,
            unitControllerP: purchaseController.unitController,
            amountControllerP: purchaseController.amountController,
            taxControllerP: purchaseController.taxController,
            sgstControllerP: purchaseController.sgstController,
            cgstControllerP: purchaseController.cgstController,
            igstControllerP: purchaseController.igstController,
            netAmountControllerP: purchaseController.netAmountController,
            discountControllerP: purchaseController.discountController,
            sellingPriceControllerP: purchaseController.sellingPriceController,
            onSaveValues: saveValues,
            onDelete: (String entryId) {
              setState(
                () {
                  _newWidget
                      .removeWhere((widget) => widget.key == ValueKey(entryId));
                  Map<String, dynamic>? entryToRemove;
                  for (final entry in _allValues) {
                    if (entry['uniqueKey'] == entryId) {
                      entryToRemove = entry;
                      break;
                    }
                  }
                  if (entryToRemove != null) {
                    _allValues.remove(entryToRemove);
                  }
                  // calculateTotal();
                },
              );
            },
            item: itemsList,
            measurementLimit: measurement,
            taxCategory: taxLists,
          ),
        );

        _newWidget2.add(
          PEntriesM(
            key: ValueKey(entryId),
            entryId: entryId,
            serialNumber: i + 1,
            itemNameControllerP: purchaseController.itemNameController,
            qtyControllerP: purchaseController.qtyController,
            rateControllerP: purchaseController.rateController,
            unitControllerP: purchaseController.unitController,
            amountControllerP: purchaseController.amountController,
            taxControllerP: purchaseController.taxController,
            sgstControllerP: purchaseController.sgstController,
            cgstControllerP: purchaseController.cgstController,
            igstControllerP: purchaseController.igstController,
            netAmountControllerP: purchaseController.netAmountController,
            discountControllerP: purchaseController.discountController,
            sellingPriceControllerP: purchaseController.sellingPriceController,
            onSaveValues: saveValues,
            onDelete: (String entryId) {
              setState(
                () {
                  _newWidget
                      .removeWhere((widget) => widget.key == ValueKey(entryId));
                  Map<String, dynamic>? entryToRemove;
                  for (final entry in _allValues) {
                    if (entry['uniqueKey'] == entryId) {
                      entryToRemove = entry;
                      break;
                    }
                  }
                  if (entryToRemove != null) {
                    _allValues.remove(entryToRemove);
                  }
                  // calculateTotal();
                },
              );
            },
            item: itemsList,
            measurementLimit: measurement,
            taxCategory: taxLists,
          ),
        );
      });
    }

    for (int i = 0; i < 4; i++) {
      final entryId = UniqueKey().toString();

      setState(() {
        _newSundry.add(
          SundryRow(
            key: ValueKey(entryId),
            serialNumber: i + 1,
            sundryControllerP: sundryFormController.sundryController,
            sundryControllerQ: sundryFormController.amountController,
            onSaveValues: (p0) {},
            onDelete: (String entryId) {
              setState(
                () {
                  _newSundry
                      .removeWhere((widget) => widget.key == ValueKey(entryId));
                  Map<String, dynamic>? entryToRemove;
                  for (final entry in _allValuesSundry) {
                    if (entry['uniqueKey'] == entryId) {
                      entryToRemove = entry;
                      break;
                    }
                  }
                  if (entryToRemove != null) {
                    _allValuesSundry.remove(entryToRemove);
                  }
                  // calculateSundry();
                },
              );
            },
            entryId: entryId,
          ),
        );
      });
    }
  }

  void initializeData() async {
    await Future.wait([
      setCompanyCode(),
      fetchSalesReturnEntries(),
      fetchLedgers2(),
      fetchItems(),
      fetchAndSetTaxRates(),
      fetchMeasurementLimit(),
    ]);
    generateBillNumber();
    purchaseController.typeController.text = selectedStatus;
    purchaseController.date2Controller.text = formatter.format(DateTime.now());
    purchaseController.dateController.text = formatter.format(DateTime.now());

    await setEntriesTables();
  }

  @override
  initState() {
    initializeData();
    super.initState();
    roundOffController = TextEditingController();
    roundOffFocusNode = FocusNode();
    roundOffController.text = TRoundOff.toStringAsFixed(2);
    roundOffFocusNode.addListener(() {
      if (roundOffFocusNode.hasFocus) {
        isManualRoundOffChange = true;
      }
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: mobileView(),
      desktopBody: deskTopView(),
    );
  }

  Widget deskTopView() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SalesAppBar(
              title: 'Sales Return Entry',
              color: const Color(0xFFBDB76B),
              width1: 0.18,
              width2: 0.82,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    purchaseTopText(
                                      width: MediaQuery.of(context).size.width *
                                          0.06,
                                      text: 'No',
                                    ),
                                    PETextFieldsNo(
                                      // onEditingComplete: () {
                                      //   FocusScope.of(context)
                                      //       .requestFocus(dateFocusNode1);

                                      //   setState(() {});
                                      // },
                                      // focusNode: noFocusNode,
                                      onSaved: (newValue) {
                                        purchaseController.noController.text =
                                            newValue!;
                                      },
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      height: 40,
                                      controller:
                                          purchaseController.noController,
                                    ),
                                    purchaseTopText(
                                      width: MediaQuery.of(context).size.width *
                                          0.06,
                                      text: 'Date',
                                    ),
                                    Flexible(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.075,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, bottom: 14.0),
                                          child: TextFormField(
                                            // focusNode: dateFocusNode1,
                                            // onEditingComplete: () {
                                            //   FocusScope.of(context)
                                            //       .requestFocus(
                                            //           typeFocus);

                                            //   setState(() {});
                                            // },
                                            controller: purchaseController
                                                .dateController,
                                            onSaved: (newValue) {
                                              purchaseController.dateController
                                                  .text = newValue!;
                                            },
                                            decoration: InputDecoration(
                                              hintText: _selectedDate == null
                                                  ? '12/12/2023'
                                                  : formatter
                                                      .format(_selectedDate!),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 1, bottom: 8),
                                              border: InputBorder.none,
                                            ),
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.035,
                                      child: IconButton(
                                          onPressed: _presentDatePICKER,
                                          icon:
                                              const Icon(Icons.calendar_month)),
                                    ),
                                    const SizedBox(width: 40),
                                    purchaseTopText(
                                      width: MediaQuery.of(context).size.width *
                                          0.06,
                                      text: 'Type',
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        color: Colors.white,
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      height: 40,
                                      padding: const EdgeInsets.all(2.0),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownMenu<String>(
                                          // focusNode: typeFocus,

                                          requestFocusOnTap: true,

                                          initialSelection: status.firstWhere(
                                            (element) =>
                                                element == selectedStatus,
                                          ),
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
                                            activeIndicatorBorder:
                                                const BorderSide(
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
                                            // FocusScope.of(context)
                                            //     .requestFocus(partyFocus);
                                            setState(() {
                                              selectedStatus = value!;
                                              purchaseController.typeController
                                                  .text = selectedStatus;
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      // color: typeFocus.hasFocus
                                                      //     ? Colors.white
                                                      //     : Colors.black,
                                                      color: Colors.black,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    purchaseTopText(
                                      width: MediaQuery.of(context).size.width *
                                          0.06,
                                      text: 'Party',
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        color: Colors.white,
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.265,
                                      height: 40,
                                      padding: const EdgeInsets.all(2.0),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownMenu<Ledger>(
                                          controller: purchaseController
                                              .partyController,
                                          // focusNode: partyFocus,
                                          requestFocusOnTap: true,
                                          initialSelection:
                                              suggestionItems5.isNotEmpty
                                                  ? suggestionItems5.first
                                                  : null,
                                          enableSearch: true,
                                          trailingIcon: const SizedBox.shrink(),
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
                                                    horizontal: 8, vertical: 8),
                                            isDense: true,
                                            activeIndicatorBorder: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          expandedInsets: EdgeInsets.zero,
                                          onSelected: (Ledger? value) {
                                            // FocusScope.of(context)
                                            //     .requestFocus(placeFocus);
                                            setState(() {
                                              if (selectedLedgerName != null) {
                                                selectedLedgerName = value!.id;
                                                purchaseController
                                                    .ledgerController
                                                    .text = selectedLedgerName!;
                                                purchaseController
                                                    .partyController
                                                    .text = value.name;
                                                final selectedLedger =
                                                    suggestionItems5.firstWhere(
                                                        (element) =>
                                                            element.id ==
                                                            selectedLedgerName);

                                                ledgerAmount =
                                                    selectedLedger.debitBalance;
                                              }
                                            });
                                          },
                                          dropdownMenuEntries: suggestionItems5
                                              .map<DropdownMenuEntry<Ledger>>(
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
                                                    fontWeight: FontWeight.bold,
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.041),
                                    purchaseTopText(
                                      width: MediaQuery.of(context).size.width *
                                          0.06,
                                      text: 'Place',
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        color: Colors.white,
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      height: 40,
                                      padding: const EdgeInsets.all(2.0),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownMenu<String>(
                                          // focusNode: placeFocus,

                                          requestFocusOnTap: true,

                                          initialSelection:
                                              indianStates.firstWhere(
                                            (element) =>
                                                element == selectedState,
                                          ),
                                          enableSearch: true,
                                          // enableFilter: true,
                                          // leadingIcon: const SizedBox.shrink(),
                                          menuHeight: 300,

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
                                            // FocusScope.of(context)
                                            //     .requestFocus(billFocus);
                                            setState(() {
                                              selectedState = value;
                                              purchaseController.placeController
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    purchaseTopText(
                                      width: MediaQuery.of(context).size.width *
                                          0.06,
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
                                        purchaseController.billNumberController
                                            .text = newValue!;
                                      },
                                      controller: purchaseController
                                          .billNumberController,
                                      width: MediaQuery.of(context).size.width *
                                          0.265,
                                      height: 40,
                                      readOnly: false,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.041,
                                    ),
                                    purchaseTopText(
                                      width: MediaQuery.of(context).size.width *
                                          0.06,
                                      text: 'Date',
                                    ),
                                    Flexible(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                            // focusNode: dateFocusNode2,
                                            // onEditingComplete: () {
                                            //   FocusScope.of(context)
                                            //       .requestFocus(
                                            //           remarksFocus);
                                            //   setState(() {});
                                            // },
                                            onSaved: (newValue) {
                                              purchaseController.date2Controller
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
                                              hintText: _pickedDateData == null
                                                  ? '12/12/2023'
                                                  : formatter
                                                      .format(_pickedDateData!),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.03,
                                      child: IconButton(
                                          onPressed: _showDataPICKER,
                                          icon:
                                              const Icon(Icons.calendar_month)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 150,
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showReturnInfoDialog();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        const Color(0xFFFFFACD),
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
                                        'Return Info',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showGetItemDialog();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        const Color(0xFFFFFACD),
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
                                        'Get Items',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),

                          //table header
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Row(
                              children: [
                                TableHeaderText(
                                  text: 'Sr',
                                  width:
                                      MediaQuery.of(context).size.width * 0.023,
                                ),
                                TableHeaderText(
                                  text: '   Item Name',
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                ),
                                TableHeaderText(
                                  text: 'Qty',
                                  width:
                                      MediaQuery.of(context).size.width * 0.061,
                                ),
                                TableHeaderText(
                                  text: 'Unit',
                                  width:
                                      MediaQuery.of(context).size.width * 0.061,
                                ),
                                TableHeaderText(
                                  text: 'Rate',
                                  width:
                                      MediaQuery.of(context).size.width * 0.061,
                                ),
                                TableHeaderText(
                                  text: 'Amount',
                                  width:
                                      MediaQuery.of(context).size.width * 0.061,
                                ),
                                TableHeaderText(
                                  text: 'Disc',
                                  width:
                                      MediaQuery.of(context).size.width * 0.061,
                                ),
                                TableHeaderText(
                                  text: 'Tax%',
                                  width:
                                      MediaQuery.of(context).size.width * 0.061,
                                ),
                                TableHeaderText(
                                  text: 'SGST',
                                  width:
                                      MediaQuery.of(context).size.width * 0.061,
                                ),
                                TableHeaderText(
                                  text: 'CGST',
                                  width:
                                      MediaQuery.of(context).size.width * 0.061,
                                ),
                                TableHeaderText(
                                  text: 'IGST',
                                  width:
                                      MediaQuery.of(context).size.width * 0.061,
                                ),
                                TableHeaderText(
                                  text: 'Net Amt.',
                                  width:
                                      MediaQuery.of(context).size.width * 0.055,
                                ),
                                TableHeaderText(
                                  text: 'Selling Amt.',
                                  width:
                                      MediaQuery.of(context).size.width * 0.055,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),

                          isLoading
                              ? const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 7.0),
                                  child: TableExample(rows: 7, cols: 13))
                              :
                              //table body
                              Column(
                                  children: [
                                    SizedBox(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.023,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(),
                                          top: BorderSide(),
                                          left: BorderSide())),
                                  child: const Text(
                                    '',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.061,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.061,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(),
                                          top: BorderSide(),
                                          left: BorderSide())),
                                  child: const Text(
                                    '',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.061,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(),
                                          top: BorderSide(),
                                          left: BorderSide())),
                                  child: const Text(
                                    '',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.061,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.061,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.061,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(),
                                          top: BorderSide(),
                                          left: BorderSide())),
                                  child: const Text(
                                    '',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.061,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.061,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.061,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.055,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.055,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(),
                                          top: BorderSide(),
                                          left: BorderSide(
                                              color: Colors.transparent),
                                          right: BorderSide())),
                                  child: const Text(
                                    '',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        purchaseTopText(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.06,
                                          text: 'Remarks',
                                        ),
                                        PETextFields(
                                          // focusNode:
                                          //     remarksFocus,
                                          // onEditingComplete:
                                          //     () {
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
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
                                            padding: const EdgeInsets.all(2.0),
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
                                                        style:
                                                            GoogleFonts.poppins(
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
                                          MediaQuery.of(context).size.width * 0,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          openDialog1(
                                            context,
                                            selectedLedgerName!,
                                            purchaseController
                                                .partyController.text,
                                            TfinalAmt,
                                            createSalesReturn,
                                          );
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            const Color(0xFFFFFACD),
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
                                          MediaQuery.of(context).size.width * 0,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            const Color(0xFFFFFACD),
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
                                          MediaQuery.of(context).size.width * 0,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Clear All
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            const Color(0xFFFFFACD),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.20),
                              // Round off area...
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
                                                    color: Colors.transparent),
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.transparent),
                                              ),
                                            ),
                                            controller: roundOffController,
                                            focusNode: roundOffFocusNode,
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
                                                TRoundOff = newRoundOff;
                                                TfinalAmt =
                                                    TnetAmount + TRoundOff;
                                                isManualRoundOffChange = true;
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
                                            TfinalAmt.toStringAsFixed(2),
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
                  // Container(
                  //   width: MediaQuery.of(context).size.width * 0.1,
                  // ),

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
                                builder: (context) => const ListOfSalesReturn(),
                                // builder: (context) => const PEMasterBody(),
                              ),
                            );
                          },
                        ),
                        CustomList(
                          Skey: "F4",
                          name: "Create New",
                          onTap: () {
                            final entryId = UniqueKey().toString();
                            setState(() {
                              _newWidget.add(
                                SalesReturnTable(
                                  key: ValueKey(entryId),
                                  serialNumber: _newWidget.length + 1,
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
                                  sellingPriceControllerP:
                                      purchaseController.sellingPriceController,
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
                                        // calculateTotal();
                                      },
                                    );
                                  },
                                  entryId: entryId,
                                  item: itemsList,
                                  measurementLimit: measurement,
                                  taxCategory: taxLists,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget mobileView() {
    Screen s = Screen(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45.0),
        child: AppBar(
          title: Text(
            'Sales Return Entry',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
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
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF8FBC8B),
          centerTitle: true,
        ),
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
                    onTap: () {
                      switch (item['text']) {
                        case 'List':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ListOfSalesReturn(),
                            ),
                          );
                          break;
                        case 'Create New':
                          {
                            final entryId = UniqueKey().toString();
                            setState(() {
                              _newWidget.add(
                                SalesReturnTable(
                                  key: ValueKey(entryId),
                                  serialNumber: _newWidget.length + 1,
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
                                  sellingPriceControllerP:
                                      purchaseController.sellingPriceController,
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
                                        // calculateTotal();
                                      },
                                    );
                                  },
                                  entryId: entryId,
                                  item: itemsList,
                                  taxCategory: [],
                                  measurementLimit: [],
                                ),
                              );
                            });
                          }
                          break;
                        case 'Create Ledger':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LGMyDesktopBody(),
                            ),
                          );
                          break;
                        // Add cases for other menu items here
                        default:
                          print('Tapped on ${item['text']}');
                          break;
                      }
                    },
                  ),
                );
              }),
            ],
          )),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    purchaseTopText(
                      width: 60,
                      text: 'No',
                    ),
                    PETextFieldsNo(
                      onSaved: (newValue) {
                        purchaseController.noController.text = newValue!;
                      },
                      width: s.width,
                      height: 40,
                      controller: purchaseController.noController,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    purchaseTopText(
                      width: 60,
                      text: 'Date',
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.075,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(0),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8.0, bottom: 14.0),
                          child: TextFormField(
                            // focusNode: dateFocusNode1,
                            // onEditingComplete: () {
                            //   FocusScope.of(context)
                            //       .requestFocus(
                            //           typeFocus);

                            //   setState(() {});
                            // },
                            controller: purchaseController.dateController,
                            onSaved: (newValue) {
                              purchaseController.dateController.text =
                                  newValue!;
                            },
                            decoration: InputDecoration(
                              hintText: _selectedDate == null
                                  ? '12/12/2023'
                                  : formatter.format(_selectedDate!),
                              contentPadding:
                                  const EdgeInsets.only(left: 1, bottom: 8),
                              border: InputBorder.none,
                            ),
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: IconButton(
                          onPressed: _presentDatePICKER,
                          icon: const Icon(Icons.calendar_month)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    purchaseTopText(
                      width: 60,
                      text: 'Type',
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          color: Colors.white,
                        ),
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: 40,
                        padding: const EdgeInsets.all(2.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownMenu<String>(
                            // focusNode: typeFocus,

                            requestFocusOnTap: true,

                            initialSelection: status.firstWhere(
                              (element) => element == selectedStatus,
                            ),
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
                            selectedTrailingIcon: const SizedBox.shrink(),

                            inputDecorationTheme: InputDecorationTheme(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
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
                              // FocusScope.of(context)
                              //     .requestFocus(partyFocus);
                              setState(() {
                                selectedStatus = value!;
                                purchaseController.typeController.text =
                                    selectedStatus;
                                // Set Type
                              });
                            },
                            dropdownMenuEntries: status
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                  value: value,
                                  label: value,
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                      GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        // color: typeFocus.hasFocus
                                        //     ? Colors.white
                                        //     : Colors.black,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ));
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    purchaseTopText(
                      width: 60,
                      text: 'Party',
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          color: Colors.white,
                        ),
                        // width: s.width,
                        height: 40,
                        padding: const EdgeInsets.all(2.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownMenu<Ledger>(
                            // focusNode: partyFocus,
                            requestFocusOnTap: true,
                            initialSelection: selectedLedgerName == null ||
                                    suggestionItems5.isEmpty
                                ? null
                                : suggestionItems5.firstWhere((element) =>
                                    element.id == selectedLedgerName),
                            enableSearch: true,
                            trailingIcon: const SizedBox.shrink(),
                            textStyle: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                            menuHeight: 300,
                            enableFilter: true,
                            filterCallback:
                                (List<DropdownMenuEntry<Ledger>> entries,
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
                            selectedTrailingIcon: const SizedBox.shrink(),
                            inputDecorationTheme: const InputDecorationTheme(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              isDense: true,
                              activeIndicatorBorder: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            expandedInsets: EdgeInsets.zero,
                            onSelected: (Ledger? value) {
                              // FocusScope.of(context)
                              //     .requestFocus(placeFocus);
                              setState(() {
                                if (selectedLedgerName != null) {
                                  selectedLedgerName = value!.id;
                                  purchaseController.ledgerController.text =
                                      selectedLedgerName!;

                                  final selectedLedger =
                                      suggestionItems5.firstWhere((element) =>
                                          element.id == selectedLedgerName);

                                  ledgerAmount = selectedLedger.debitBalance;
                                }
                              });
                            },
                            dropdownMenuEntries: suggestionItems5
                                .map<DropdownMenuEntry<Ledger>>((Ledger value) {
                              return DropdownMenuEntry<Ledger>(
                                value: value,
                                label: value.name,
                                trailingIcon: Text(
                                  value.debitBalance.toStringAsFixed(2),
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                style: ButtonStyle(
                                  textStyle: WidgetStateProperty.all(
                                    GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    purchaseTopText(
                      width: 60,
                      text: 'Place',
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          color: Colors.white,
                        ),
                        // width: s.width,
                        height: 40,
                        padding: const EdgeInsets.all(2.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownMenu<String>(
                            // focusNode: placeFocus,

                            requestFocusOnTap: true,

                            initialSelection: indianStates.firstWhere(
                              (element) => element == selectedState,
                            ),
                            enableSearch: true,
                            // enableFilter: true,
                            // leadingIcon: const SizedBox.shrink(),
                            menuHeight: 300,

                            trailingIcon: const SizedBox.shrink(),
                            textStyle: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                            selectedTrailingIcon: const SizedBox.shrink(),

                            inputDecorationTheme: InputDecorationTheme(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              isDense: true,
                              activeIndicatorBorder: const BorderSide(
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
                              // FocusScope.of(context)
                              //     .requestFocus(billFocus);
                              setState(() {
                                selectedState = value;
                                purchaseController.placeController.text =
                                    selectedState!;
                              });
                            },
                            dropdownMenuEntries: indianStates
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                  value: value,
                                  label: value,
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                      GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
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
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    purchaseTopText(
                      width: 60,
                      text: 'Bill No',
                    ),
                    PETextFields(
                      onSaved: (newValue) {
                        purchaseController.billNumberController.text =
                            newValue!;
                      },
                      controller: purchaseController.billNumberController,
                      width: s.width,
                      height: 40,
                      readOnly: false,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    purchaseTopText(
                      width: 60,
                      text: 'Date',
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.13,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8.0, bottom: 14.0),
                          child: TextFormField(
                            // focusNode: dateFocusNode2,
                            // onEditingComplete: () {
                            //   FocusScope.of(context)
                            //       .requestFocus(
                            //           remarksFocus);
                            //   setState(() {});
                            // },
                            onSaved: (newValue) {
                              purchaseController.date2Controller.text =
                                  newValue!;
                            },
                            controller: purchaseController.date2Controller,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: _pickedDateData == null
                                  ? '12/12/2023'
                                  : formatter.format(_pickedDateData!),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.only(left: 1, bottom: 8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: IconButton(
                          onPressed: _showDataPICKER,
                          icon: const Icon(Icons.calendar_month)),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 30,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0,
                        child: ElevatedButton(
                          onPressed: () {
                            showReturnInfoDialog();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFFFFFACD),
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1.0),
                                side: const BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Return Info',
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
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 150,
                      height: 30,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0,
                        child: ElevatedButton(
                          onPressed: () {
                            showGetItemDialog();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFFFFFACD),
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1.0),
                                side: const BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Get Items',
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                //table header
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          TableHeaderText(
                            text: 'Sr',
                            width: 50,
                          ),
                          TableHeaderText(
                            text: 'Item Name',
                            width: 200,
                          ),
                          TableHeaderText(
                            text: 'Qty',
                            width: 70,
                          ),
                          TableHeaderText(
                            text: 'Unit',
                            width: 70,
                          ),
                          TableHeaderText(
                            text: 'Rate',
                            width: 100,
                          ),
                          TableHeaderText(
                            text: 'Amount',
                            width: 180,
                          ),
                          TableHeaderText(
                            text: 'Disc',
                            width: 70,
                          ),
                          TableHeaderText(
                            text: 'Tax%',
                            width: 70,
                          ),
                          TableHeaderText(
                            text: 'SGST',
                            width: 70,
                          ),
                          TableHeaderText(
                            text: 'CGST',
                            width: 70,
                          ),
                          TableHeaderText(
                            text: 'IGST',
                            width: 70,
                          ),
                          TableHeaderText(
                            text: 'Net Amt.',
                            width: 160,
                          ),
                          TableHeaderText(
                            text: 'Selling Amt.',
                            width: 160,
                            color: Colors.black,
                          ),
                        ],
                      ),

                      isLoading
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7.0),
                              child: TableExample(rows: 7, cols: 13))
                          :
                          //table body
                          SingleChildScrollView(
                              child: Column(
                                children: _newWidget,
                              ),
                            ),
                      // Table footer
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 50,
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
                            width: 200,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(),
                                    top: BorderSide(),
                                    left: BorderSide())),
                            child: const Text(
                              '',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 70,
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
                            width: 70,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(),
                                    top: BorderSide(),
                                    left: BorderSide())),
                            child: const Text(
                              '',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 100,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(),
                                    top: BorderSide(),
                                    left: BorderSide())),
                            child: const Text(
                              '',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 180,
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
                            width: 70,
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
                            width: 70,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(),
                                    top: BorderSide(),
                                    left: BorderSide())),
                            child: const Text(
                              '',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 70,
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
                            width: 70,
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
                            width: 70,
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
                            width: 160,
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
                            width: 160,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(),
                                    top: BorderSide(),
                                    left: BorderSide(color: Colors.transparent),
                                    right: BorderSide())),
                            child: const Text(
                              '',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                Row(
                  children: [
                    purchaseTopText(
                      width: 80,
                      text: 'Remarks',
                    ),
                    PETextFields(
                      onSaved: (newValue) {
                        purchaseController.remarksController!.text = newValue!;
                      },
                      controller: purchaseController.remarksController,
                      width: s.width,
                      height: 40,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Container(
                  width: s.width,
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
                        padding: const EdgeInsets.all(2.0),
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
                                    overflow: TextOverflow.ellipsis,
                                    header2Titles[index],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF4B0082),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 180,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          child: Column(
                            children: _newSundry,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 100,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Round-Off: ',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4B0082),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        // width: ,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 12.0, bottom: 6),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                          controller: roundOffController,
                          focusNode: roundOffFocusNode,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          // textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4B0082),
                          ),
                          onChanged: (value) {
                            double newRoundOff = double.tryParse(value) ?? 0.00;
                            setState(() {
                              TRoundOff = newRoundOff;
                              TfinalAmt = TnetAmount + TRoundOff;
                              isManualRoundOffChange = true;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 100,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Amount: ',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4B0082),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          TfinalAmt.toStringAsFixed(2),
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

                const SizedBox(height: 10),

                //Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 105,
                      child: ElevatedButton(
                        onPressed: () {
                          // Create Purchase
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFFFFACD),
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Save',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 105,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFFFFACD),
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              side: const BorderSide(color: Colors.black),
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
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 105,
                      child: ElevatedButton(
                        onPressed: () {
                          // Clear All
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFFFFACD),
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              side: const BorderSide(color: Colors.black),
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> menuItems = [
    {'text': 'List', 'icon': Icons.list},
    {'text': 'Create New', 'icon': Icons.note_add_rounded},
    {'text': 'Create Ledger', 'icon': Icons.receipt},
  ];

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

  void _startTimer() {
    const Duration duration = Duration(seconds: 2);
    _timer = Timer.periodic(duration, (Timer timer) {
      calculateTotal();
      calculateSundry();
    });
  }

  Future<void> createSalesReturn() async {
    if (selectedLedgerName == null || selectedLedgerName!.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Error!',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            content: Text('Please select a ledger!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      return;
    } else if (_allValues.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Error!',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            content: Text('Please add an item!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      return;
    }

    for (var valueBillwise in _allValuesBillwise) {
      double amount = double.tryParse(valueBillwise['amount']) ?? 0.0;

      billwise.add(
        Billwise(
          date: valueBillwise['date'],
          sales: valueBillwise['selectedSales'],
          amount: amount,
          billNo: valueBillwise['billno'],
        ),
      );
    }

    final purchaseReturn = SalesReturn(
      companyCode: companyCode!.first,
      id: 'id',
      no: purchaseController.noController.text,
      date: purchaseController.dateController.text,
      date2: purchaseController.date2Controller.text,
      type: purchaseController.typeController.text,
      ledger: selectedLedgerName!,
      place: selectedState!,
      billNumber: purchaseController.billNumberController.text,
      remarks:
          purchaseController.remarksController?.text ?? 'No remark available',
      totalAmount: TfinalAmt.toStringAsFixed(2),
      entries: _allValues.map((entry) {
        return SalesEntries(
          itemName: entry['itemName'] ?? '',
          qty: int.tryParse(entry['qty']) ?? 0,
          rate: double.tryParse(entry['rate']) ?? 0,
          unit: entry['unit'] ?? '',
          amount: double.tryParse(entry['amount']) ?? 0,
          tax: entry['tax'] ?? '',
          sgst: double.tryParse(entry['sgst']) ?? 0,
          cgst: double.tryParse(entry['cgst']) ?? 0,
          igst: double.tryParse(entry['igst']) ?? 0,
          netAmount: double.tryParse(entry['netAmount']) ?? 0,
          sellingPrice: double.tryParse(entry['sellingPrice']) ?? 0,
          discount: double.tryParse(entry['discount']) ?? 0,
        );
      }).toList(),
      sundry: _allValuesSundry.map((sundry) {
        print('Sundry: $sundry');
        return Sundry(
          sundryName: sundry['sndryName'] ?? 'No name',
          amount: double.tryParse(sundry['sundryAmount']) ?? 0,
        );
      }).toList(),
      billwise: billwise,
      cashAmount: purchaseController.cashAmountController.text.isEmpty
          ? '0'
          : purchaseController.cashAmountController.text,
    );

    await salesReturnService
        .createSalesReturn(purchaseReturn)
        .then((value) async {
      fetchSalesReturnEntries().then((_) {
        clearAll();
        final newSalesReturnEntry = fetchedSalesReturn.firstWhere(
          (element) => element.no == purchaseReturn.no,
          orElse: () => SalesReturn(
            id: '',
            companyCode: '',
            totalAmount: '',
            no: '',
            date: '',
            date2: '',
            cashAmount: '',
            type: '',
            ledger: '',
            place: '',
            billNumber: '',
            remarks: '',
            entries: [],
            sundry: [],
            billwise: [],
          ),
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'PRINT RECEIPT',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              content: Text(
                'Do you want to print the receipt?',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'YES',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) {
                        return const ListOfSalesReturn();
                      },
                    ));
                  },
                  child: const Text(
                    'NO',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      });
    }).catchError((error) {
      Navigator.of(context).pop();
      print('Failed to create sales return: $error');
    });
  }

  void saveValues(Map<String, dynamic> values) {
    final String uniqueKey = values['uniqueKey'];

    final existingEntryIndex =
        _allValues.indexWhere((entry) => entry['uniqueKey'] == uniqueKey);

    setState(() {
      if (existingEntryIndex != -1) {
        _allValues.removeAt(existingEntryIndex);
      }
      _allValues.add(values);
    });
  }

  void calculateTotal() {
    double qty = 0.00;
    double amount = 0.00;
    double sgst = 0.00;
    double cgst = 0.00;
    double igst = 0.00;
    double netAmount = 0.00;
    double discount = 0.00;

    for (var values in _allValues) {
      qty += double.tryParse(values['qty']) ?? 0;
      amount += double.tryParse(values['amount']) ?? 0;
      sgst += double.tryParse(values['sgst']) ?? 0;
      cgst += double.tryParse(values['cgst']) ?? 0;
      igst += double.tryParse(values['igst']) ?? 0;
      netAmount += double.tryParse(values['netAmount']) ?? 0;
      discount += double.tryParse(values['discount']) ?? 0;
    }
    double originalTotalAmount = netAmount + Ttotal;
    double roundedTotalAmount =
        (originalTotalAmount - originalTotalAmount.floor()) >= 0.50
            ? originalTotalAmount.ceil().toDouble()
            : originalTotalAmount.floor().toDouble();
    double roundOffAmount = roundedTotalAmount - originalTotalAmount;

    setState(() {
      Tqty = qty;
      Tamount = amount;
      Tsgst = sgst;
      Tcgst = cgst;
      Tigst = igst;
      TnetAmount = netAmount;
      Tdiscount = discount;
      if (!isManualRoundOffChange) {
        TRoundOff = roundOffAmount;
        TfinalAmt = TnetAmount + TRoundOff;
        roundOffController.text = TRoundOff.toStringAsFixed(2);
      } else {
        TfinalAmt =
            TnetAmount + (double.tryParse(roundOffController.text) ?? 0.00);
      }
    });
  }

  void calculateSundry() {
    double total = 0.00;
    for (var values in _allValuesSundry) {
      total += double.tryParse(values['sundryAmount']) ?? 0;
    }

    setState(() {
      Ttotal = total;
    });
  }

  Future<void> fetchItems() async {
    try {
      final List<Item> items = await itemsService.fetchItems();

      itemsList = items;
    } catch (error) {
      // ignore: avoid_print
      print('Failed to fetch ledger name: $error');
    }
  }

  Future<void> fetchAndSetTaxRates() async {
    try {
      final List<TaxRate> taxRates = await taxRateService.fetchTaxRates();

      taxLists = taxRates;
    } catch (error) {
      print('Failed to fetch Tax Rates: $error');
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

  Future<void> fetchLedgers2() async {
    try {
      final List<Ledger> ledger = await ledgerService.fetchLedgers();
      // Add empty data on the 0 index

      suggestionItems5 = ledger
          .where((element) =>
              element.status == 'Yes' &&
              element.ledgerGroup != '662f97d2a07ec73369c237b0')
          .toList();

      if (suggestionItems5.isNotEmpty) {
        selectedLedgerName =
            suggestionItems5.isNotEmpty ? suggestionItems5.first.id : null;
        ledgerAmount = suggestionItems5.first.debitBalance;
      }
    } catch (error) {
      print('Failed to fetch ledger name: $error');
    }
  }

  Future<void> fetchSalesReturnEntries() async {
    try {
      final List<SalesReturn> purchaseReturn =
          await salesReturnService.fetchAllSalesReturns();
      setState(() {
        fetchedSalesReturn = purchaseReturn;
      });

      print('Fetched Purchase Return: $fetchedSalesReturn');
      setSalesReturnLength();
    } catch (error) {
      print('Failed to fetch purchase Return: $error');
      setSalesReturnLength();
    }
  }

  Future<List<String>?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('companies');
  }

  Future<void> setCompanyCode() async {
    List<String>? code = await getCompanyCode();
    companyCode = code;
  }

  Future<String?> getNumberOfSalesReturn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('salesReturnLength');
  }

  Future<void> setSalesReturnLength() async {
    String? length = await getNumberOfSalesReturn();
    setState(() {
      purchaseLength = length;
      purchaseController.noController.text =
          (int.parse(purchaseLength!) + 1).toString();
    });
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

  void saveSelectedPurchaseEntries(
      {required SalesEntry sales, required List<bool> checkboxStates}) {
    // Get the selected entries
    for (int i = 0; i < checkboxStates.length; i++) {
      if (checkboxStates[i]) {
        selectedEntries.add(sales.entries[i]);
      }
    }

    print('Selected Entries: $selectedEntries');
  }

  void getDetailsDialog({
    required TextEditingController noController,
    required SalesEntry sales,
  }) {
    List<TableRow> salesEntries = [];

    print('Sales Entries: ${sales.entries}');

    List<bool> checkboxStates =
        List.generate(sales.entries.length, (index) => true);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: Dialog(
            alignment: AlignmentDirectional.center,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: Container(
              constraints: BoxConstraints(
                // maxHeight: MediaQuery.of(context).size.height / 2,
                maxWidth: MediaQuery.of(context).size.width / 1.5,
              ),
              child: StatefulBuilder(
                builder: (context, setState) {
                  // Define methods to handle checkbox actions
                  // void selectAll() {
                  //   setState(() {
                  //     for (int i = 0; i < checkboxStates.length; i++) {
                  //       checkboxStates[i] = true;
                  //     }
                  //   });
                  // }

                  void deselectAll() {
                    setState(() {
                      for (int i = 0; i < checkboxStates.length; i++) {
                        checkboxStates[i] = false;
                      }
                    });
                  }

                  salesEntries = sales.entries.asMap().entries.map((entry) {
                    int index = entry.key;
                    var entryValue = entry.value;

                    return TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                sales.date,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF4B0082),
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                sales.no.toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF4B0082),
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                suggestionItems5.isNotEmpty
                                    ? suggestionItems5
                                        .firstWhere(
                                          (element) =>
                                              element.id == sales.party,
                                        )
                                        .name
                                    : '',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF4B0082),
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                itemsList
                                    .firstWhere(
                                      (element) =>
                                          element.id == entryValue.itemName,
                                    )
                                    .itemName,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF4B0082),
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                entryValue.qty.toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF4B0082),
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                entryValue.netAmount.toStringAsFixed(2),
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF4B0082),
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Checkbox(
                              value: checkboxStates[index],
                              onChanged: (value) {
                                setState(() {
                                  checkboxStates[index] = value ?? false;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList();

                  // Invoke the method to select all checkboxes
                  // selectAll();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        color: const Color(0xFF4169E1),
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                'Get Details',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 2,
                              child: SETopText(
                                text: 'Purchase No',
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 4,
                              child: SizedBox(
                                height: 40,
                                child: SalesReturnTextField(
                                  controller: noController,
                                  onSaved: (newValue) {},
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 16.0),
                                  hintText: '',
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFFACD),
                                    border: Border.all(
                                      color: const Color(0xFFFFFACD),
                                      width: 1,
                                    ),
                                  ),
                                  height: 40,
                                  padding: const EdgeInsets.all(2.0),
                                  child: Center(
                                    child: Text(
                                      'Search',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 2,
                              child: InkWell(
                                onTap: () {
                                  deselectAll();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFFACD),
                                    border: Border.all(
                                      color: const Color(0xFFFFFACD),
                                      width: 1,
                                    ),
                                  ),
                                  height: 40,
                                  padding: const EdgeInsets.all(2.0),
                                  child: Center(
                                    child: Text(
                                      'Deselect All',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5),
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height / 1.5,
                            maxWidth: MediaQuery.of(context).size.width / 1.5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Table(
                                  border: TableBorder.all(
                                      width: 1, color: Colors.black),
                                  columnWidths: const {
                                    0: FlexColumnWidth(3),
                                    1: FlexColumnWidth(2),
                                    2: FlexColumnWidth(5),
                                    3: FlexColumnWidth(4),
                                    4: FlexColumnWidth(3),
                                    5: FlexColumnWidth(3),
                                    6: FlexColumnWidth(2),
                                    7: FlexColumnWidth(2),
                                  },
                                  children: [
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: SizedBox(
                                            height: 40,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  "Date",
                                                  textAlign: TextAlign.end,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xff4B0082),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                            child: SizedBox(
                                          height: 40,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "No",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xff4B0082),
                                              ),
                                            ),
                                          ),
                                        )),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: SizedBox(
                                              height: 40,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Particulars",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xff4B0082),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: SizedBox(
                                              height: 40,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Items Name",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xff4B0082),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: SizedBox(
                                            height: 40,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  "Qty",
                                                  textAlign: TextAlign.end,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xff4B0082),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: SizedBox(
                                            height: 40,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  "Amount",
                                                  textAlign: TextAlign.end,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xff4B0082),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: SizedBox(
                                            height: 40,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  "Select",
                                                  textAlign: TextAlign.end,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xff4B0082),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    // Table Body with dummy details...
                                    ...salesEntries,
                                    // TableRow(children: [
                                    //   // Tablecells
                                    //   TableCell(
                                    //     child: SizedBox(
                                    //       height: 40,
                                    //       child: Align(
                                    //         alignment: Alignment.center,
                                    //         child: Padding(
                                    //           padding:
                                    //               const EdgeInsets.all(4.0),
                                    //           child: Text(
                                    //             '12/12/2021',
                                    //             textAlign: TextAlign.end,
                                    //             style: GoogleFonts.poppins(
                                    //               fontSize: 15,
                                    //               fontWeight: FontWeight.bold,
                                    //               color:
                                    //                   const Color(0xff4B0082),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    //   TableCell(
                                    //     child: SizedBox(
                                    //       height: 40,
                                    //       child: Align(
                                    //         alignment: Alignment.center,
                                    //         child: Text(
                                    //           '1',
                                    //           textAlign: TextAlign.center,
                                    //           style: GoogleFonts.poppins(
                                    //             fontSize: 15,
                                    //             fontWeight: FontWeight.bold,
                                    //             color: const Color(0xff4B0082),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    //   TableCell(
                                    //     child: SizedBox(
                                    //       height: 40,
                                    //       child: Align(
                                    //         alignment: Alignment.centerLeft,
                                    //         child: Text(
                                    //           'Purchase',
                                    //           textAlign: TextAlign.center,
                                    //           style: GoogleFonts.poppins(
                                    //             fontSize: 15,
                                    //             fontWeight: FontWeight.bold,
                                    //             color: const Color(0xff4B0082),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    //   TableCell(
                                    //     child: SizedBox(
                                    //       height: 40,
                                    //       child: Align(
                                    //         alignment: Alignment.centerLeft,
                                    //         child: Text(
                                    //           'LONG NOTES 400 PAGES WHITE PAPER',
                                    //           overflow: TextOverflow.ellipsis,
                                    //           textAlign: TextAlign.center,
                                    //           style: GoogleFonts.poppins(
                                    //             fontSize: 15,
                                    //             fontWeight: FontWeight.bold,
                                    //             color: const Color(0xff4B0082),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    //   TableCell(
                                    //     child: SizedBox(
                                    //       height: 40,
                                    //       child: Align(
                                    //         alignment: Alignment.center,
                                    //         child: Padding(
                                    //           padding:
                                    //               const EdgeInsets.all(4.0),
                                    //           child: Text(
                                    //             '10',
                                    //             textAlign: TextAlign.end,
                                    //             style: GoogleFonts.poppins(
                                    //               fontSize: 15,
                                    //               fontWeight: FontWeight.bold,
                                    //               color:
                                    //                   const Color(0xff4B0082),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    //   TableCell(
                                    //     child: SizedBox(
                                    //       height: 40,
                                    //       child: Align(
                                    //         alignment: Alignment.center,
                                    //         child: Padding(
                                    //           padding:
                                    //               const EdgeInsets.all(4.0),
                                    //           child: Text(
                                    //             '1000',
                                    //             textAlign: TextAlign.end,
                                    //             style: GoogleFonts.poppins(
                                    //               fontSize: 15,
                                    //               fontWeight: FontWeight.bold,
                                    //               color:
                                    //                   const Color(0xff4B0082),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    //   TableCell(
                                    //     child: SizedBox(
                                    //       height: 40,
                                    //       child: Align(
                                    //         alignment: Alignment.center,
                                    //         child: Padding(
                                    //           padding:
                                    //               const EdgeInsets.all(4.0),
                                    //           child: Checkbox(
                                    //             value: false,
                                    //             onChanged: (value) {
                                    //               setState(() {});
                                    //             },
                                    //             activeColor:
                                    //                 const Color(0xFFDAA520),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ])
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                // Create a Map of the selected entries
                                saveSelectedPurchaseEntries(
                                  sales: sales,
                                  checkboxStates: checkboxStates,
                                );

                                selectedPurchase = sales;

                                // Close the dialog
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFACD),
                                  border: Border.all(
                                    color: const Color(0xFFFFFACD),
                                    width: 1,
                                  ),
                                ),
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.1,
                                padding: const EdgeInsets.all(2.0),
                                child: Center(
                                  child: Text(
                                    'Save[F4]',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFACD),
                                  border: Border.all(
                                    color: const Color(0xFFFFFACD),
                                    width: 1,
                                  ),
                                ),
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.1,
                                padding: const EdgeInsets.all(2.0),
                                child: Center(
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void showReturnInfoDialog() async {
    List<SalesEntry>? purchase =
        await salesEntryService.fetchSalesEntriesByParty(selectedLedgerName!);
    TextEditingController originalInvoiceNoController = TextEditingController();
    TextEditingController originalInvoiceDateController =
        TextEditingController();

    List<String> reasons = [
      '01-Sales Return',
      '02-Post sales discount',
      '03-Deficiency In services',
      '04-Correction In invoice',
      '05-Change In POS',
      '06-Finilization Of Provisional Assessment',
    ];
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Dialog(
            alignment: AlignmentDirectional.center,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: Container(
              constraints: BoxConstraints(
                // maxHeight: MediaQuery.of(context).size.height / 2,
                maxWidth: MediaQuery.of(context).size.width / 2,
              ),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 50,
                        color: const Color(0xFF4169E1),
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                'Return Details',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 2,
                              child: SETopText(
                                text: 'Orig. Inv No',
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 4,
                              child: SizedBox(
                                height: 40,
                                child: SalesReturnTextField(
                                  controller: originalInvoiceNoController,
                                  onSaved: (newValue) {},
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 16.0),
                                  hintText: '',
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: InkWell(
                                onTap: () async {
                                  if (originalInvoiceNoController
                                      .text.isEmpty) {
                                    PanaraConfirmDialog.showAnimatedGrow(
                                      context,
                                      title: "BillingSphere",
                                      message:
                                          "Please enter the original invoice number",
                                      confirmButtonText: "Confirm",
                                      cancelButtonText: "Cancel",
                                      onTapCancel: () {
                                        Navigator.pop(context);
                                      },
                                      onTapConfirm: () {
                                        // pop screen
                                        Navigator.of(context).pop();
                                      },
                                      panaraDialogType:
                                          PanaraDialogType.warning,
                                    );
                                  } else {
                                    final SalesEntry? purchase =
                                        await salesEntryService
                                            .fetchSalesByBillNumber(
                                                originalInvoiceNoController
                                                    .text);
                                    if (purchase == null) {
                                      PanaraConfirmDialog.showAnimatedGrow(
                                        context,
                                        title: "BillingSphere",
                                        message:
                                            "No purchase found with the given invoice number",
                                        confirmButtonText: "Confirm",
                                        cancelButtonText: "Cancel",
                                        onTapCancel: () {
                                          Navigator.pop(context);
                                        },
                                        onTapConfirm: () {
                                          // pop screen
                                          Navigator.of(context).pop();
                                        },
                                        panaraDialogType:
                                            PanaraDialogType.error,
                                      );
                                    } else {
                                      print('Purchase: $purchase');
                                      // Set the date
                                      originalInvoiceDateController.text =
                                          purchase.date;
                                      getDetailsDialog(
                                        noController:
                                            originalInvoiceNoController,
                                        sales: purchase,
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFFACD),
                                    border: Border.all(
                                      color: const Color(0xFFFFFACD),
                                      width: 1,
                                    ),
                                  ),
                                  height: 40,
                                  padding: const EdgeInsets.all(2.0),
                                  child: Center(
                                    child: Text(
                                      'Get Details',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SETopText(
                              text: 'Orig. Inv Date',
                              padding: EdgeInsets.zero,
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.12,
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.12,
                              child: SalesReturnTextField(
                                controller: originalInvoiceDateController,
                                onSaved: (newValue) {},
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 16.0),
                                hintText: '',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SETopText(
                              text: 'Reason',
                              padding: EdgeInsets.zero,
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.12,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                height: 40,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownMenu<String>(
                                    requestFocusOnTap: true,
                                    initialSelection: null,
                                    enableSearch: true,
                                    trailingIcon: const SizedBox.shrink(),
                                    textStyle: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xff000000),
                                      decoration: TextDecoration.none,
                                    ),
                                    menuHeight: 300,
                                    enableFilter: true,
                                    // filterCallback:
                                    //     (List<DropdownMenuEntry<String>> entries,
                                    //         String filter) {
                                    //   final String trimmedFilter =
                                    //       filter.trim().toLowerCase();

                                    //   if (trimmedFilter.isEmpty) {
                                    //     return entries;
                                    //   }

                                    //   // Filter the entries based on the query
                                    //   return entries.where((entry) {
                                    //     return entry.value.itemName
                                    //         .toLowerCase()
                                    //         .contains(trimmedFilter);
                                    //   }).toList();
                                    // },
                                    width: MediaQuery.of(context).size.width *
                                        0.19,
                                    selectedTrailingIcon:
                                        const SizedBox.shrink(),
                                    inputDecorationTheme:
                                        const InputDecorationTheme(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 16),
                                      isDense: true,
                                      activeIndicatorBorder: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    expandedInsets: EdgeInsets.zero,
                                    onSelected: (String? value) {},
                                    dropdownMenuEntries: reasons
                                        .map<DropdownMenuEntry<String>>(
                                            (String value) {
                                      return DropdownMenuEntry<String>(
                                        value: value,
                                        label: value,
                                        style: ButtonStyle(
                                          textStyle: WidgetStateProperty.all(
                                            GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                _updateWidgetList(selectedEntries);
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFACD),
                                  border: Border.all(
                                    color: const Color(0xFFFFFACD),
                                    width: 1,
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: 40,
                                padding: const EdgeInsets.all(2.0),
                                child: Center(
                                  child: Text(
                                    'Save [F4]',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // const Spacer(),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFACD),
                                  border: Border.all(
                                    color: const Color(0xFFFFFACD),
                                    width: 1,
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: 40,
                                padding: const EdgeInsets.all(2.0),
                                child: Center(
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Recent Transactions [Press F12 for to Select Bill]',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4B0082),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5),
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height / 2.5,
                            maxWidth: MediaQuery.of(context).size.width / 2.5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Table(
                                  border: TableBorder.all(
                                      width: 1, color: Colors.black),
                                  columnWidths: const {
                                    0: FlexColumnWidth(3),
                                    1: FlexColumnWidth(3),
                                    2: FlexColumnWidth(3),
                                    3: FlexColumnWidth(3),
                                    4: FlexColumnWidth(3),
                                    5: FlexColumnWidth(3),
                                    6: FlexColumnWidth(3),
                                  },
                                  children: [
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: SizedBox(
                                            height: 40,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  "Voucher",
                                                  textAlign: TextAlign.end,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xff4B0082),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                            child: SizedBox(
                                          height: 40,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Date",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xff4B0082),
                                              ),
                                            ),
                                          ),
                                        )),
                                        TableCell(
                                          child: SizedBox(
                                            height: 40,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Time",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      const Color(0xff4B0082),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: SizedBox(
                                            height: 40,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "No",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      const Color(0xff4B0082),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: SizedBox(
                                            height: 40,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  "Amount",
                                                  textAlign: TextAlign.end,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xff4B0082),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    for (var entry in purchase)
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: SizedBox(
                                              height: 40,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Retail Purchase",
                                                  textAlign: TextAlign.end,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: SizedBox(
                                              height: 40,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  entry.date,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: SizedBox(
                                              height: 40,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  entry.date,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: SizedBox(
                                              height: 40,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  entry.dcNo,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: SizedBox(
                                              height: 40,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    entry.totalamount,
                                                    textAlign: TextAlign.end,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  ),
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
                          ),
                        ),
                      ),

                      // Add your content here
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void showGetItemDialog() async {
    TextEditingController originalInvoiceNoController = TextEditingController();
    TextEditingController vchController = TextEditingController();

    List<String> reasons = [
      'Bill OF SUPPLY',
      'Credit Note',
      'Debit Note',
      'Delivery Challan',
      'Inward Challan',
      'Production',
      'Proforma Invoice',
      'Purchase Enquiry',
      'Purchase Order',
      'Purchase Return',
      'Retail Purchase',
      'Sales Order',
      'Sales Quotation',
      'Sales Return',
      'Tax INVOICE',
      'Tax Purchase',
    ];

    List<dynamic>? purchase;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Dialog(
            alignment: AlignmentDirectional.center,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 2.5,
              ),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 50,
                        color: const Color(0xFF4169E1),
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                'Import Items From Voucher',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SETopText(
                              text: 'From Voucher',
                              padding: EdgeInsets.zero,
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.12,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                height: 40,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownMenu<String>(
                                    requestFocusOnTap: true,
                                    initialSelection: null,
                                    enableSearch: true,
                                    trailingIcon: const SizedBox.shrink(),
                                    textStyle: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xff000000),
                                      decoration: TextDecoration.none,
                                    ),
                                    menuHeight: 300,
                                    enableFilter: true,
                                    width: MediaQuery.of(context).size.width *
                                        0.19,
                                    selectedTrailingIcon:
                                        const SizedBox.shrink(),
                                    inputDecorationTheme:
                                        const InputDecorationTheme(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 16),
                                      isDense: true,
                                      activeIndicatorBorder: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    expandedInsets: EdgeInsets.zero,
                                    onSelected: (String? value) async {
                                      List<dynamic>? fetchedData;
                                      if (value == "Retail Purchase") {
                                        fetchedData = await purchaseServices
                                            .fetchPurchaseEntries();
                                      } else if (value == "Purchase Return") {
                                        fetchedData =
                                            await purchaseReturnService
                                                .fetchAllPurchaseReturns();
                                      } else if (value == "Bill OF SUPPLY") {
                                        fetchedData = await salesEntryService
                                            .fetchSalesEntriesByParty(
                                                selectedLedgerName!);
                                      } else if (value == "Sales Return") {
                                        fetchedData = await salesReturnService
                                            .fetchAllSalesReturns();
                                      }

                                      setState(() {
                                        purchase = fetchedData;
                                        print(purchase);
                                      });
                                    },
                                    dropdownMenuEntries: reasons
                                        .map<DropdownMenuEntry<String>>(
                                            (String value) {
                                      return DropdownMenuEntry<String>(
                                        value: value,
                                        label: value,
                                        style: ButtonStyle(
                                          textStyle: WidgetStateProperty.all(
                                            GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SETopText(
                              text: 'Vch No',
                              padding: EdgeInsets.zero,
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.12,
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.12,
                              child: PRTopTextfield(
                                controller: vchController,
                                onSaved: (newValue) {},
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 16.0),
                                hintText: '',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () async {
                                if (vchController.text.isEmpty) {
                                  PanaraConfirmDialog.showAnimatedGrow(
                                    context,
                                    title: "BillingSphere",
                                    message: "From Voucher is Empty",
                                    confirmButtonText: "Confirm",
                                    cancelButtonText: "Cancel",
                                    onTapCancel: () {
                                      Navigator.pop(context);
                                    },
                                    onTapConfirm: () {
                                      Navigator.of(context).pop();
                                    },
                                    panaraDialogType: PanaraDialogType.warning,
                                  );
                                } else {
                                  var matchingPurchase = purchase?.firstWhere(
                                    (entry) =>
                                        entry.billNumber == vchController.text,
                                  );

                                  if (matchingPurchase == null) {
                                    PanaraConfirmDialog.showAnimatedGrow(
                                      context,
                                      title: "BillingSphere",
                                      message:
                                          "No purchase found with the given invoice number",
                                      confirmButtonText: "Confirm",
                                      cancelButtonText: "Cancel",
                                      onTapCancel: () {
                                        Navigator.pop(context);
                                      },
                                      onTapConfirm: () {
                                        Navigator.of(context).pop();
                                      },
                                      panaraDialogType: PanaraDialogType.error,
                                    );
                                  } else {
                                    print(matchingPurchase.entries);
                                    List<Entry> entries = (matchingPurchase
                                            .entries as List<dynamic>)
                                        .map((entry) => Entry(
                                            itemName: entry.itemName,
                                            qty: entry.qty,
                                            rate: entry.rate,
                                            unit: entry.unit,
                                            amount: entry.amount,
                                            tax: entry.tax,
                                            sgst: entry.sgst,
                                            discount: entry.discount,
                                            cgst: entry.cgst,
                                            igst: entry.igst,
                                            netAmount: entry.netAmount,
                                            baseRate: 12,
                                            originaldiscount: 12,
                                            additionalInfo: ""))
                                        .toList();

                                    _updateWidgetList(entries);
                                  }
                                }
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFACD),
                                  border: Border.all(
                                    color: const Color(0xFFFFFACD),
                                    width: 1,
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: 40,
                                padding: const EdgeInsets.all(2.0),
                                child: Center(
                                  child: Text(
                                    'Import [F4]',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // const Spacer(),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFACD),
                                  border: Border.all(
                                    color: const Color(0xFFFFFACD),
                                    width: 1,
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: 40,
                                padding: const EdgeInsets.all(2.0),
                                child: Center(
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5),
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height / 2.5,
                            maxWidth: MediaQuery.of(context).size.width / 2.5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (purchase != null)
                                    Table(
                                      border: TableBorder.all(
                                          width: 1, color: Colors.black),
                                      columnWidths: const {
                                        0: FlexColumnWidth(3),
                                        1: FlexColumnWidth(3),
                                        2: FlexColumnWidth(3),
                                        3: FlexColumnWidth(3),
                                      },
                                      children: [
                                        TableRow(
                                          children: [
                                            buildTableCell(
                                              text: "Date",
                                              isHeader: true,
                                            ),
                                            buildTableCell(
                                              text: "No",
                                              isHeader: true,
                                            ),
                                            buildTableCell(
                                              text: "Particular",
                                              isHeader: true,
                                            ),
                                            buildTableCell(
                                              text: "Amount",
                                              isHeader: true,
                                            ),
                                          ],
                                        ),
                                        for (var entry in purchase!)
                                          TableRow(
                                            children: [
                                              buildTableCell(
                                                text: entry.date,
                                              ),
                                              buildTableCell(
                                                text: entry.billNumber,
                                              ),
                                              buildTableCell(
                                                  // text: suggestionItems5
                                                  //     .firstWhere(
                                                  //       (ledger) =>
                                                  //           ledger.id ==
                                                  //           entry.ledger,
                                                  //     )
                                                  //     .name,
                                                  text: entry.ledger),
                                              buildTableCell(
                                                text: entry.totalAmount,
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildTableCell({
    required String text,
    Alignment alignment = Alignment.center,
    TextAlign textAlign = TextAlign.center,
    bool isHeader = false,
    EdgeInsets padding = const EdgeInsets.all(4.0),
  }) {
    return TableCell(
      child: SizedBox(
        height: 40,
        child: Align(
          alignment: alignment,
          child: Padding(
            padding: padding,
            child: Text(
              text,
              textAlign: textAlign,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                color: isHeader ? const Color(0xff4B0082) : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void openDialog1(BuildContext context, String ledgerID, String ledgerName,
      double debitAmount, VoidCallback onSave) {
    showDialog(
      context: context,
      builder: (context) => ReceiptBillwise(
        ledgerID: ledgerID,
        ledgerName: ledgerName,
        debitAmount: debitAmount,
        allValuesCallback: (List<Map<String, dynamic>> newValues) {
          setState(() {
            // Merge newValues into _allValuesBillwise
            for (var newValue in newValues) {
              final existingIndex = _allValuesBillwise.indexWhere(
                (entry) => entry['uniqueKey'] == newValue['uniqueKey'],
              );
              if (existingIndex != -1) {
                _allValuesBillwise[existingIndex] = newValue;
              } else {
                _allValuesBillwise.add(newValue);
              }
            }
            print('Updated _allValuesBillwise: $_allValuesBillwise');
          });
        },
        onSave: onSave,
      ),
    );
  }

  void _updateWidgetList(List<Entry> selectedEntries) {
    setState(() {
      _newWidget.clear();
      _allValues.clear();
      print(".........1");
      for (var i = 0; i < selectedEntries.length; i++) {
        final entry = selectedEntries[i];
        _allValues.add({
          'uniqueKey': entry.itemName,
          'itemName': entry.itemName,
          'qty': entry.qty.toString(),
          'rate': entry.rate.toString(),
          'unit': entry.unit,
          'amount': entry.amount.toString(),
          'tax': entry.tax,
          'sgst': entry.sgst.toString(),
          'cgst': entry.cgst.toString(),
          'igst': entry.igst.toString(),
          'discount': entry.discount.toString(),
          'netAmount': entry.netAmount.toString(),
        });

        print(".........2");

        final itemNameController = TextEditingController(text: entry.itemName);
        final qtyController = TextEditingController(text: entry.qty.toString());
        final rateController =
            TextEditingController(text: entry.rate.toString());
        final unitController = TextEditingController(text: entry.unit);
        final amountController =
            TextEditingController(text: entry.amount.toString());
        final taxController = TextEditingController(text: entry.tax.toString());
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
        final sellingPriceController = TextEditingController(text: "0");
        print(".........3");
        _newWidget.add(
          SalesReturnTable(
            key: ValueKey(entry.itemName),
            entryId: entry.itemName,
            serialNumber: i + 1,
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
            discountControllerP: discountController,
            sellingPriceControllerP: sellingPriceController,
            onSaveValues: saveValues,
            onDelete: (p0) {},
            item: itemsList,
            measurementLimit: measurement,
            taxCategory: taxLists,
          ),
        );
      }

      print(".........4");

      while (_newWidget.length < 5) {
        print("enter");
        final entryId = ValueKey(_newWidget.length);
        _newWidget.add(
          SalesReturnTable(
            key: ValueKey(entryId),
            serialNumber: _newWidget.length + 1,
            itemNameControllerP: purchaseController.itemNameController,
            qtyControllerP: purchaseController.qtyController,
            rateControllerP: purchaseController.rateController,
            unitControllerP: purchaseController.unitController,
            amountControllerP: purchaseController.amountController,
            taxControllerP: purchaseController.taxController,
            discountControllerP: purchaseController.discountController,
            sgstControllerP: purchaseController.sgstController,
            cgstControllerP: purchaseController.cgstController,
            igstControllerP: purchaseController.igstController,
            netAmountControllerP: purchaseController.netAmountController,
            sellingPriceControllerP: purchaseController.sellingPriceController,
            onSaveValues: saveValues,
            onDelete: (String entryId) {
              setState(
                () {
                  _newWidget
                      .removeWhere((widget) => widget.key == ValueKey(entryId));
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
                  // calculateTotal();
                },
              );
            },
            entryId: entryId.toString(),
            item: itemsList,
            measurementLimit: measurement,
            taxCategory: taxLists,
          ),
        );
      }
    });
    print("done");
  }

  void clearAll() {
    setState(() {
      purchaseController.noController.clear();
      purchaseController.dateController.clear();
      purchaseController.date2Controller.clear();
      purchaseController.typeController.clear();
      purchaseController.ledgerController.clear();
      purchaseController.placeController.clear();
      purchaseController.billNumberController.clear();
      purchaseController.remarksController?.clear();
      purchaseController.cashAmountController.clear();
      purchaseController.dueAmountController.clear();
      _newWidget.clear();
      _allValues.clear();
      _allValuesSundry.clear();
      Ttotal = 0.00;
      Tqty = 0.00;
      Tamount = 0.00;
      Tdisc = 0.00;
      Tsgst = 0.00;
      Tcgst = 0.00;
      Tigst = 0.00;
      TnetAmount = 0.00;

      generateBillNumber();
      // setEntriesTables();
    });
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

class SalesAppBar extends StatelessWidget {
  final VoidCallback onPressed;
  final double width1;
  final double width2;
  final Color color;
  final String title;
  const SalesAppBar({
    super.key,
    required this.onPressed,
    required this.width1,
    required this.width2,
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * width1,
            height: 60,
            color: const Color(0xFFA0522D),
            child: Row(
              children: [
                const Spacer(),
                Text(
                  'Retail Sales',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              width: MediaQuery.of(context).size.width * width2,
              height: 60,
              color: color,
              child: Row(
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      onPressed: onPressed,
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
