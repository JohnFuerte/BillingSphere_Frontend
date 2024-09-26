import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/providers/onchange_item_provider.dart';
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
import '../PE_widgets/PE_app_bar.dart';
import '../PE_widgets/PE_text_fields.dart';
import '../PE_widgets/PE_text_fields_no.dart';
import '../PE_widgets/purchase_return_table.dart';
import '../PE_widgets/purchase_table.dart';
import '../PE_widgets/purchase_table_mobile_2.dart';
import '../PEresponsive/PE_desktop_body.dart';
import '../PEresponsive/PE_master.dart';
import '../SE_common/SE_top_text.dart';
import '../SE_responsive/SE_desktop_body.dart';
import '../SE_variables/SE_variables.dart';
import '../SE_widgets/sundry_row.dart';
import '../sumit_screen/voucher _entry.dart/voucher_list_widget.dart';
import 'widget/purchase_return_textfield.dart';

class PurchaseReturn extends StatefulWidget {
  const PurchaseReturn({super.key});

  @override
  State<PurchaseReturn> createState() => _PurchaseReturnState();
}

class _PurchaseReturnState extends State<PurchaseReturn> {
  DateTime? _selectedDate;
  DateTime? _pickedDateData;
  List<String> status = ['Cash', 'Debit'];
  String selectedStatus = 'Debit';
  String? selectedState = 'Gujarat';
  List<PEntriesT> _newWidget = [];
  final List<PEntriesM> _newWidget2 = [];
  final List<SundryRow> _newSundry = [];
  final List<Map<String, dynamic>> _allValues = [];
  final List<Map<String, dynamic>> _allValuesSundry = [];
  List<Purchase> fetchedPurchase = [];
  Purchase? selectedPurchase;
  List<PurchaseEntry> selectedEntries = [];

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
  // late Timer _timer;
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
  PurchaseServices purchaseServices = PurchaseServices();
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
          PEntriesT(
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
      // setPurchaseLength(),
      // fetchPurchaseEntries(),
      fetchLedgers2(),
      fetchItems(),
      fetchAndSetTaxRates(),
      fetchMeasurementLimit(),
    ]);

    await setEntriesTables();
  }

  @override
  initState() {
    initializeData();
    super.initState();
    roundOffController = TextEditingController();
    roundOffFocusNode = FocusNode();
    roundOffController.text = '0.00';
    roundOffFocusNode.addListener(() {
      if (roundOffFocusNode.hasFocus) {
        isManualRoundOffChange = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PECustomAppBar(
              title: 'Purchase Return Entry',
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
                                    const SizedBox(width: 50),
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
                                          // focusNode: partyFocus,
                                          requestFocusOnTap: true,
                                          initialSelection:
                                              selectedLedgerName == null ||
                                                      suggestionItems5.isEmpty
                                                  ? null
                                                  : suggestionItems5.firstWhere(
                                                      (element) =>
                                                          element.id ==
                                                          selectedLedgerName),
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
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 26.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.12,
                                  height: 30,
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0,
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
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.12,
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
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  purchaseTopText(
                                                    width:
                                                        MediaQuery.of(context)
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
                                                    controller:
                                                        purchaseController
                                                            .remarksController,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    height: 40,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.25,
                                                      height: 170,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: const Color
                                                              .fromARGB(
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
                                                            height: 30,
                                                            decoration:
                                                                const BoxDecoration(
                                                              border: Border(
                                                                bottom:
                                                                    BorderSide(
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
                                                                    border:
                                                                        Border(
                                                                      bottom:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      SizedBox(
                                                                    width: MediaQuery.of(context)
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
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: const Color(0xFF4B0082),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              2,
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
                                                                            color:
                                                                                const Color(0xFFA0522D),
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                (ledgerAmount + (TnetAmount + Ttotal)).toStringAsFixed(2),
                                                                                textAlign: TextAlign.center,
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
                                                                          width:
                                                                              2,
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
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: const Color(0xFF4B0082),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              2,
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
                                                                            color:
                                                                                const Color(0xFFA0522D),
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                '0.00 Dr',
                                                                                textAlign: TextAlign.center,
                                                                                style: GoogleFonts.poppins(
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
                                                    Consumer<
                                                            OnChangeItenProvider>(
                                                        builder: (context,
                                                            itemID, _) {
                                                      return Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.38,
                                                        height: 170,
                                                        decoration:
                                                            BoxDecoration(
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
                                                                  child:
                                                                      Container(
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
                                                                              BorderRadius.circular(0),
                                                                        ),
                                                                        backgroundColor:
                                                                            const Color(0xFFDAA520),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        'Statements',
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        softWrap:
                                                                            false,
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
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
                                                                Expanded(
                                                                  flex: 4,
                                                                  child:
                                                                      Container(
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
                                                                              BorderRadius.circular(0),
                                                                        ),
                                                                        backgroundColor:
                                                                            const Color(0xFFDAA520),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        'Purchase',
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.white,
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
                                                                right:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .transparent,
                                                                ),
                                                                bottom:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                left:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .transparent,
                                                                ),
                                                                top: BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              )),
                                                              child: Row(
                                                                children: List
                                                                    .generate(
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
                                                                            FontWeight.bold,
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
                                                                      width:
                                                                          1.0,
                                                                      color: Colors
                                                                          .black),
                                                                  children: [
                                                                    // Iterate over all purchases' entries
                                                                    for (int i =
                                                                            0;
                                                                        i <
                                                                            fetchedPurchase
                                                                                .length;
                                                                        i++)
                                                                      ...fetchedPurchase[
                                                                              i]
                                                                          .entries
                                                                          .where((entry) =>
                                                                              entry.itemName ==
                                                                              itemID.itemID)
                                                                          .map((entry) {
                                                                        // Find the corresponding ledger for the current entry
                                                                        String
                                                                            ledgerName =
                                                                            '';
                                                                        if (suggestionItems5
                                                                            .isNotEmpty) {
                                                                          final ledger =
                                                                              suggestionItems5.firstWhere(
                                                                            (ledger) =>
                                                                                ledger.id ==
                                                                                fetchedPurchase[i].ledger,
                                                                            orElse: () =>
                                                                                Ledger(
                                                                              id: '',
                                                                              name: '',
                                                                              printName: '',
                                                                              aliasName: '',
                                                                              ledgerGroup: '',
                                                                              date: '',
                                                                              bilwiseAccounting: '',
                                                                              creditDays: 0,
                                                                              openingBalance: 0,
                                                                              debitBalance: 0,
                                                                              ledgerType: '',
                                                                              priceListCategory: '',
                                                                              remarks: '',
                                                                              status: '',
                                                                              ledgerCode: 0,
                                                                              mailingName: '',
                                                                              address: '',
                                                                              city: '',
                                                                              region: '',
                                                                              state: '',
                                                                              pincode: 0,
                                                                              tel: 0,
                                                                              fax: 0,
                                                                              mobile: 0,
                                                                              sms: 0,
                                                                              email: '',
                                                                              contactPerson: '',
                                                                              bankName: '',
                                                                              branchName: '',
                                                                              ifsc: '',
                                                                              accName: '',
                                                                              accNo: '',
                                                                              panNo: '',
                                                                              gst: '',
                                                                              gstDated: '',
                                                                              cstNo: '',
                                                                              cstDated: '',
                                                                              lstNo: '',
                                                                              lstDated: '',
                                                                              serviceTaxNo: '',
                                                                              serviceTaxDated: '',
                                                                              registrationType: '',
                                                                              registrationTypeDated: '',
                                                                            ),
                                                                          );
                                                                          ledgerName =
                                                                              ledger.name;
                                                                        }

                                                                        return TableRow(
                                                                          children: [
                                                                            Text(
                                                                              fetchedPurchase[i].date.toString(),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                            Text(
                                                                              fetchedPurchase[i].billNumber.toString(),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                            Text(
                                                                              ledgerName, // Display the ledger name here
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                            Text(
                                                                              entry.qty.toString(),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                            Text(
                                                                              '${entry.rate}%', // Assuming this should be entry.rate, not entry.qty
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                            Text(
                                                                              entry.netAmount.toString(),
                                                                              textAlign: TextAlign.center,
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
                                          // Create Purchase
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
                                builder: (context) => const PEMasterBody(),
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
                                PEntriesT(
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
          ],
        ),
      ),
    );
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

  saveValues(Map<String, dynamic> p1) {}

  Future<void> fetchItems() async {
    try {
      final List<Item> items = await itemsService.fetchITEMS();

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
              element.ledgerGroup == '662f97d2a07ec73369c237b0')
          .toList();

      if (suggestionItems5.isNotEmpty) {
        ledgerAmount = suggestionItems5.first.debitBalance;
      }
    } catch (error) {
      print('Failed to fetch ledger name: $error');
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

  void saveSelectedPurchaseEntries(
      {required Purchase purchase, required List<bool> checkboxStates}) {
    // Get the selected entries
    for (int i = 0; i < checkboxStates.length; i++) {
      if (checkboxStates[i]) {
        selectedEntries.add(purchase.entries[i]);
      }
    }

    print('Selected Entries: $selectedEntries');
  }

  void getDetailsDialog({
    required TextEditingController noController,
    required Purchase purchase,
  }) {
    List<TableRow> purchaseEntries = [];

    print('Purchase Entries: ${purchase.entries}');

    List<bool> checkboxStates =
        List.generate(purchase.entries.length, (index) => true);

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

                  // Construct the table rows from purchase.entries
                  purchaseEntries =
                      purchase.entries.asMap().entries.map((entry) {
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
                                purchase.date,
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
                                purchase.no,
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
                                              element.id == purchase.ledger,
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
                                child: PRTopTextfield(
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
                                    ...purchaseEntries,
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
                                  purchase: purchase,
                                  checkboxStates: checkboxStates,
                                );

                                selectedPurchase = purchase;

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

  void showReturnInfoDialog() {
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
                                child: PRTopTextfield(
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
                                  // Call the API
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
                                    final Purchase? purchase =
                                        await purchaseServices
                                            .fetchPurchaseByBillNumber(
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
                                        purchase: purchase,
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
                              child: PRTopTextfield(
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
                                    // ...Ctables,
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

  void _updateWidgetList(List<PurchaseEntry> selectedEntries) {
    setState(() {
      _newWidget.clear();
      purchaseController.noController.text = selectedPurchase!.no;
      purchaseController.dateController.text = selectedPurchase!.date;
      purchaseController.ledgerController.text = suggestionItems5.isNotEmpty
          ? suggestionItems5
              .firstWhere((element) => element.id == selectedPurchase!.ledger)
              .name
          : '';
      purchaseController.billNumberController.text =
          selectedPurchase!.billNumber;
      purchaseController.date2Controller.text = selectedPurchase!.date2;
      purchaseController.remarksController!.text = selectedPurchase!.remarks;
      selectedLedgerName = selectedPurchase!.ledger;
      selectedState = selectedPurchase!.place;
      selectedStatus = selectedPurchase!.type;

      for (var i = 0; i < selectedEntries.length; i++) {
        final entry = selectedEntries[i];
        _newWidget.add(
          PEntriesT(
            key: ValueKey(entry.itemName), // or another unique key
            entryId: entry.itemName,
            serialNumber: i + 1,
            itemNameControllerP: TextEditingController(text: entry.itemName),
            qtyControllerP: TextEditingController(text: entry.qty.toString()),
            rateControllerP: TextEditingController(text: entry.rate.toString()),
            unitControllerP: TextEditingController(text: entry.unit),
            amountControllerP:
                TextEditingController(text: entry.amount.toString()),
            taxControllerP: TextEditingController(text: entry.tax.toString()),
            sgstControllerP: TextEditingController(text: entry.sgst.toString()),
            cgstControllerP: TextEditingController(text: entry.cgst.toString()),
            igstControllerP: TextEditingController(text: entry.igst.toString()),
            netAmountControllerP:
                TextEditingController(text: entry.netAmount.toString()),
            discountControllerP:
                TextEditingController(text: entry.discount.toString()),
            sellingPriceControllerP:
                TextEditingController(text: entry.sellingPrice.toString()),
            onSaveValues: (p0) {},
            onDelete: (p0) {},
            item: itemsList,
            measurementLimit: measurement,
            taxCategory: taxLists,
          ),
        );
      }

      while (_newWidget.length < 5) {
        final entryId = ValueKey(_newWidget.length);
        _newWidget.add(PEntriesT(
          unitControllerP: TextEditingController(),
          entryId: entryId.toString(),
          itemNameControllerP: TextEditingController(),
          qtyControllerP: TextEditingController(),
          rateControllerP: TextEditingController(),
          amountControllerP: TextEditingController(),
          taxControllerP: TextEditingController(),
          sgstControllerP: TextEditingController(),
          cgstControllerP: TextEditingController(),
          igstControllerP: TextEditingController(),
          netAmountControllerP: TextEditingController(),
          discountControllerP: TextEditingController(),
          sellingPriceControllerP: TextEditingController(),
          onSaveValues: (p0) {},
          onDelete: (p0) {},
          serialNumber: _newWidget.length + 1,
          item: itemsList,
          measurementLimit: measurement,
          taxCategory: taxLists,
        ));
      }
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
