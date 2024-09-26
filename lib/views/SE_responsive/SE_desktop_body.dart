// ignore: file_names
// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:billingsphere/data/models/item/item_model.dart';
import 'package:billingsphere/data/models/ledger/ledger_model.dart';
import 'package:billingsphere/data/models/salesEntries/sales_entrires_model.dart';
import 'package:billingsphere/data/repository/ledger_repository.dart';
import 'package:billingsphere/data/repository/sales_enteries_repository.dart';
import 'package:billingsphere/utils/controllers/sales_text_controllers.dart';
import 'package:billingsphere/views/CUSTOMERS/new_customer_desktop.dart';
import 'package:billingsphere/views/LG_responsive/LG_desktop_body.dart';
import 'package:billingsphere/views/SE_common/SE_form_buttons.dart';
import 'package:billingsphere/views/SE_common/SE_top_text.dart';
import 'package:billingsphere/views/SE_common/SE_top_textfield.dart';
import 'package:billingsphere/views/SE_responsive/SE_desktop_body_POS.dart';
import 'package:billingsphere/views/SE_variables/SE_variables.dart';
import 'package:billingsphere/views/SE_widgets/sundry_row.dart';
import 'package:billingsphere/views/SE_widgets/table_row.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:high_q_paginated_drop_down/high_q_paginated_drop_down.dart';
import 'package:horizontal_data_table/scroll/linked_scroll_controller/linked_scroll_controller.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../auth/providers/onchange_item_provider.dart';
import '../../auth/providers/onchange_ledger_provider.dart';
import '../../data/models/measurementLimit/measurement_limit_model.dart';
import '../../data/models/price/price_category.dart';
import '../../data/models/taxCategory/tax_category_model.dart';
import '../../data/repository/item_repository.dart';
import '../../data/repository/measurement_limit_repository.dart';
import '../../data/repository/price_category_repository.dart';
import '../../data/repository/tax_category_repository.dart';
import '../../utils/controllers/sundry_controller.dart';
import '../Barcode_responsive/barcode_print_desktop_body.dart';
import '../DB_responsive/DB_desktop_body.dart';
import '../NI_responsive.dart/NI_desktopBody.dart';
import '../SE_widgets/dispatch.dart';
import '../SE_widgets/dispatch_responsive.dart';
import '../SE_widgets/table_footer.dart';
import '../SE_widgets/table_header.dart';
import '../sumit_screen/voucher _entry.dart/voucher_list_widget.dart';
import 'SE_master.dart';
import 'SE_multimode.dart';
import 'SE_receipt_2.dart';

import 'package:billingsphere/views/SE_widgets/table_row_mobile.dart'
    as mobileBody;

class SEMyDesktopBody extends StatefulWidget {
  const SEMyDesktopBody({super.key});

  @override
  State<SEMyDesktopBody> createState() => _SEMyDesktopBodyState();
}

class _SEMyDesktopBodyState extends State<SEMyDesktopBody> {
  DateTime? _selectedDate;
  DateTime? _pickedDateData;
  List<String> status = ['CASH', 'DEBIT', 'MULTI MODE'];
  String selectedStatus = 'CASH';
  String selectedsundry = 'Cash Discount';
  String selectedPlaceState = 'Gujarat';
  bool isLoading = false;
  final bool _isSaving = false;
  final formatter = DateFormat('dd/MM/yyyy');
  int _generatedNumber = 0;
  double ledgerAmount = 0;
  double itemRate = 0.0;
  String? selectedPriceTypeId;
  //fetch ledger
  List<Ledger> suggestionItems5 = [];
  String? selectedLedgerName;
  Ledger? _selectedLedger;
  LedgerService ledgerService = LedgerService();
  Ledger? _ledgers;
  late ScrollController _horizontalController1;
  late ScrollController _horizontalController2;
  late ScrollController _horizontalController3;
  late LinkedScrollControllerGroup _horizontalControllersGroup;

  bool isMoreDetailsOpen = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // late FocusNode noFocus;
  // late FocusNode dcNoFocus;
  // late FocusNode dateFocus;
  // late FocusNode typeFocus;
  // late FocusNode partyFocus;
  // late FocusNode placeFocus;
  // late FocusNode dcNoFocus2;
  // late FocusNode dateFocus2;
  // late FocusNode totalAmountFocus;
  // late FocusNode cashAmountFocus;
  // late FocusNode dueAmountFocus;
  // late FocusNode roundOffFocus;
  // late FocusNode remarkFocus;
  // late FocusNode itemNameFocus;
  // late FocusNode qtyFocus;
  // late FocusNode rateFocus;
  // late FocusNode unitFocus;
  // late FocusNode amountFocus;
  // late FocusNode discountFocus;
  // late FocusNode taxFocus;
  // late FocusNode sgstFocus;
  // late FocusNode cgstFocus;
  // late FocusNode igstFocus;
  // late FocusNode netAmountFocus;
  // late FocusNode sundryFocus;
  // late FocusNode sundryAmountFocus;
  // late FocusNode dispatchFocus;
  // late FocusNode transAgencyFocus;
  // late FocusNode docketNoFocus;
  // late FocusNode vehicleNoFocus;
  // late FocusNode fromStationFocus;
  // late FocusNode fromDistrictFocus;
  // late FocusNode transModeFocus;
  // late FocusNode parcelFocus;
  // late FocusNode freightFocus;
  // late FocusNode kmsFocus;
  // late FocusNode toStateFocus;
  // late FocusNode ewayBillFocus;
  // late FocusNode billingAddressFocus;
  // late FocusNode shippedToFocus;
  // late FocusNode shippingAddressFocus;
  // late FocusNode phoneNoFocus;
  // late FocusNode gstNoFocus;
  // late FocusNode remarksFocus;
  // late FocusNode licenceNoFocus;
  // late FocusNode issueStateFocus;
  // late FocusNode nameFocus;
  // late FocusNode addressFocus;
  // late FocusNode cashFocus;
  // late FocusNode debitFocus;
  // late FocusNode adjustedAmountFocus;
  // late FocusNode pendingAmountFocus;
  // late FocusNode finalAmountFocus;
  // late FocusNode advPaymentFocus;
  // late FocusNode advPaymentDateFocus;
  // late FocusNode installmentFocus;
  // late FocusNode totalDebitAmountFocus;
  // late FocusNode dateFocusNode1;
  // late FocusNode dateFocusNode2;

  // void _handleDate1FocusChange() {
  //   if (dateFocusNode1.hasFocus) {
  //     dateFocusNode1.unfocus();
  //     _presentDatePICKER();
  //   }
  // }

  // void _handleDate2FocusChange() {
  //   if (dateFocusNode2.hasFocus) {
  //     dateFocusNode2.unfocus();
  //     _showDataPICKER();
  //   }
  // }

  //fetch sales
  List<SalesEntry> suggestionItems6 = [];
  String? selectedSales;
  SalesEntryService salesService = SalesEntryService();
  SalesEntryFormController salesEntryFormController =
      SalesEntryFormController();

  //fetch item
  List<Item> itemsList = [];

  ItemsService itemsService = ItemsService();

  SundryFormController sundryFormController = SundryFormController();

  List<String> ledgerNames = [];

  List<String> placestate = [
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

  List<String>? companyCode;
  Future<List<String>?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('companies');
  }

  Future<void> setCompanyCode() async {
    List<String>? code = await getCompanyCode();
    setState(() {
      companyCode = code;
      print(companyCode);
    });
  }

  final List<SEntries> _newWidget = [];
  final List<mobileBody.SEntries> _newWidgetMobile = [];
  final List<SundryRow> _newSundry = [];

  int _currentSerialNumber = 1;
  int _currentSerialNumberSundry = 1;

  final List<Map<String, dynamic>> _allValues = [];
  final List<Map<String, dynamic>> _allValuesSundry = [];

  late Timer _timer;

  bool isLedgerSelected = false;

  PriceCategoryRepository pricetypeService = PriceCategoryRepository();
  TaxRateService taxRateService = TaxRateService();
  MeasurementLimitService measurementService = MeasurementLimitService();

  List<PriceCategory> pricecategory = [];
  List<TaxRate> taxLists = [];
  List<MeasurementLimit> measurement = [];

  void _startTimer() {
    const Duration duration = Duration(seconds: 2);
    _timer = Timer.periodic(duration, (Timer timer) {
      calculateTotal();
      calculateSundry();
    });
  }

  // Dispatch Values
  final Map<String, dynamic> dispacthDetails = {};
  final Map<String, dynamic> moreDetails = {};
  final Map<String, dynamic> multimodeDetails = {};
  final TextEditingController _advpaymentController = TextEditingController();
  final TextEditingController _advpaymentdateController =
      TextEditingController();
  final TextEditingController _installmentController = TextEditingController();
  final TextEditingController _toteldebitamountController =
      TextEditingController();

  void saveMoreDetailsValues() {
    moreDetails['advpayment'] = _advpaymentController.text;
    moreDetails['advpaymentdate'] = _advpaymentdateController.text;
    moreDetails['installment'] = _installmentController.text;
    moreDetails['toteldebitamount'] = _toteldebitamountController.text;

    Navigator.of(context).pop();
  }

  void _generateRandomNumber() {
    setState(() {
      if (suggestionItems6.isEmpty) {
        _generatedNumber = 1;
      } else {
        // Find the maximum no value in suggestionItems6
        int maxNo = suggestionItems6
            .map((e) => e.no)
            .reduce((value, element) => value > element ? value : element);
        _generatedNumber = maxNo + 1;
      }
      salesEntryFormController.noController.text = _generatedNumber.toString();
      salesEntryFormController.dcNoController.text =
          'HN00${_generatedNumber.toString()}';
    });
  }

  Future<void> fetchSales() async {
    try {
      final List<SalesEntry> sales = await salesService.fetchSalesEntries();
      final filteredSalesEntry = sales
          .where((salesentry) => salesentry.companyCode == companyCode!.first)
          .toList();

      setState(() {
        suggestionItems6 = filteredSalesEntry;
        _generateRandomNumber();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> fetchSingleLedger(String id) async {
    try {
      final ledger = await ledgerService.fetchLedgerById(id);

      // FocusScope.of(context).requestFocus(placeFocus);

      setState(() {
        _ledgers = ledger;
      });
      // String variable = '';
      // for (PriceCategory price in pricecategory) {
      //   if (price.id == _ledgers!.priceListCategory) {
      //     variable = price.priceCategoryType;

      //     if (variable == 'SUB DEALER') {
      //       itemRate = itemsList.first.dealer;
      //       salesEntryFormController.rateController.text = itemRate.toString();
      //     } else if (variable == 'DEALER') {
      //       itemRate = itemsList.first.subDealer;
      //       salesEntryFormController.rateController.text = itemRate.toString();
      //     } else if (variable == 'Retailer') {
      //       itemRate = itemsList.first.retail;
      //       salesEntryFormController.rateController.text = itemRate.toString();
      //     } else {
      //       itemRate = itemsList.first.mrp;
      //       salesEntryFormController.rateController.text = itemRate.toString();
      //     }
      //   }
      // }
    } catch (ex) {
      print(ex);
    }
  }

  void _generateBillNumber() {
    // Generate a random number between 100 and 999
    Random random = Random();
    int randomNumber = random.nextInt(9000) + 1000;

    // Get the current month abbreviation
    String monthAbbreviation = _getMonthAbbreviation(DateTime.now().month);

    // Construct the bill number
    String billNumber =
        'HN000000000000000000000000000${salesEntryFormController.noController.text}';

    setState(() {
      // salesEntryFormController.dcNoController.text = billNumber;
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

  Future<void> createSalesEntry() async {
    if (selectedLedgerName!.isEmpty) {
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
    updateDueAmountController();

    final salesEntry = SalesEntry(
      id: '',
      companyCode: companyCode!.first,
      no: int.parse(salesEntryFormController.noController.text),
      date: salesEntryFormController.dateController1.text,
      type: salesEntryFormController.typeController.text,
      party: selectedLedgerName!,
      place: selectedPlaceState,
      dcNo: salesEntryFormController.dcNoController.text,
      date2: salesEntryFormController.dateController2.text,
      totalamount: TfinalAmt.toStringAsFixed(2),
      cashAmount: salesEntryFormController.cashAmountController.text == ''
          ? '0'
          : salesEntryFormController.cashAmountController.text,
      dueAmount: salesEntryFormController.dueAmountController.text == ''
          ? '0'
          : salesEntryFormController.dueAmountController.text,
      roundoffDiff: double.parse(roundOffController.text),
      entries: _allValues.map((entry) {
        return Entry(
          itemName: entry['itemName'],
          additionalInfo: entry['additionalInfo'],
          qty: int.tryParse(entry['qty']) ?? 0,
          rate: double.tryParse(entry['rate']) ?? 0,
          baseRate: double.tryParse(entry['baseRate']) ?? 0,
          unit: entry['unit'],
          amount: double.tryParse(entry['amount']) ?? 0,
          tax: entry['tax'] ?? 0,
          discount: double.tryParse(entry['discount']) ?? 0,
          originaldiscount: double.tryParse(entry['originaldiscount']) ?? 0,
          sgst: double.tryParse(entry['sgst']) ?? 0,
          cgst: double.tryParse(entry['cgst']) ?? 0,
          igst: double.tryParse(entry['igst']) ?? 0,
          netAmount: double.tryParse(entry['netAmount']) ?? 0,
        );
      }).toList(),
      sundry: _allValuesSundry.map((sundry) {
        return Sundry2(
          sundryName: sundry['sndryName'],
          amount: double.tryParse(sundry['sundryAmount']) ?? 0,
        );
      }).toList(),
      remark: salesEntryFormController.remarkController?.text ?? '',
      dispatch: dispacthDetails.isNotEmpty
          ? [
              Dispatch(
                transAgency: dispacthDetails['transAgency'] ?? '',
                docketNo: dispacthDetails['docketNo'] ?? '',
                vehicleNo: dispacthDetails['vehicleNo'] ?? '',
                fromStation: dispacthDetails['fromStation'] ?? '',
                fromDistrict: dispacthDetails['fromDistrict'] ?? '',
                transMode: dispacthDetails['transMode'] ?? '',
                parcel: dispacthDetails['parcel'] ?? '',
                freight: dispacthDetails['freight'] ?? '',
                kms: dispacthDetails['kms'] ?? '',
                toState: dispacthDetails['toState'] ?? '',
                ewayBill: dispacthDetails['ewayBill'] ?? '',
                billingAddress: dispacthDetails['billingAddress'] ?? '',
                shippedTo: dispacthDetails['shippedTo'] ?? 'shippedTo',
                shippingAddress:
                    dispacthDetails['shippingAddress'] ?? 'shippingAddress',
                phoneNo: dispacthDetails['phoneNo'] ?? 'phoneNo',
                gstNo: dispacthDetails['gstNo'] ?? 'gstNo',
                remarks: dispacthDetails['remarks'] ?? 'remarks',
                licenceNo: dispacthDetails['licenceNo'] ?? 'lincenseNo',
                issueState: dispacthDetails['issueState'] ?? 'issueState',
                name: dispacthDetails['name'] ?? 'name ',
                address: dispacthDetails['address'] ?? 'Address',
              )
            ]
          : [],
      multimode: multimodeDetails.isNotEmpty
          ? [
              Multimode(
                cash: multimodeDetails['cash'] ?? '',
                debit: multimodeDetails['debit'] ?? '',
                adjustedamount: multimodeDetails['adjustedamount'] ?? '',
                pending: multimodeDetails['pendingAmount'] ?? '',
                finalamount: multimodeDetails['finalAmount'] ?? '',
              ),
            ]
          : [],
      moredetails: moreDetails.isNotEmpty
          ? [
              MoreDetails(
                advpayment: moreDetails['advpayment'] ?? '',
                advpaymentdate: moreDetails['advpaymentdate'] ?? '',
                installment: moreDetails['installment'] ?? '',
                toteldebitamount: moreDetails['toteldebitamount'] ?? '',
              )
            ]
          : [],
    );

    clearAll();

    bool success = await salesService.addSalesEntry(salesEntry, context);
    // Get the id of the newly added sales entry
    if (success) {
      fetchSales().then((_) {
        final newSalesEntry = suggestionItems6.firstWhere(
            (element) => element.no == salesEntry.no,
            orElse: () => SalesEntry(
                  id: '',
                  companyCode: '',
                  no: 0,
                  date: '',
                  type: '',
                  party: '',
                  place: '',
                  dcNo: '',
                  date2: '',
                  totalamount: '',
                  cashAmount: '',
                  dueAmount: '',
                  roundoffDiff: 0.00,
                  entries: [],
                  sundry: [],
                  remark: '',
                  dispatch: [],
                  multimode: [],
                  moredetails: [],
                ));

        // Navigate to the sales entry details page
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Print Receipt'),
              content: const Text('Do you want to print receipt?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => PrintBigReceipt(
                          sales: newSalesEntry,
                          ledger: _ledgers!,
                          'Print Sales Receipt',
                        ),
                      ),
                    );
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const DBMyDesktopBody()),
                    );
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        );
      });
    }
  }

  // Functions
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

  void saveSundry(Map<String, dynamic> values) {
    final String uniqueKey = values['uniqueKey'];

    // Check if an entry with the same uniqueKey exists
    final existingEntryIndex =
        _allValuesSundry.indexWhere((entry) => entry['uniqueKey'] == uniqueKey);

    setState(() {
      if (existingEntryIndex != -1) {
        _allValuesSundry.removeAt(existingEntryIndex);
      }

      // Add the latest values
      _allValuesSundry.add(values);
    });
  }

  // Total Values
  double Ttotal = 0.00;
  double Tqty = 0.00;
  double Tamount = 0.00;
  double Tsgst = 0.00;
  double Tcgst = 0.00;
  double Tigst = 0.00;
  double TnetAmount = 0.00;
  double Tdiscount = 0.00;
  double TfinalAmt = 0.00;
  double TRoundOff = 0.00; // New variable to store the round-off amount
  late TextEditingController roundOffController;
  late FocusNode roundOffFocusNode;
  bool isManualRoundOffChange = false;

  // Calculate total debit and credit
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
      TnetAmount = originalTotalAmount;
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

  void updateDueAmountController() {
    // Ensure TnetAmount and Ttotal are not null and are of type double
    if (TnetAmount == null || Ttotal == null) {
      print("Error: TnetAmount or Ttotal is null");
      salesEntryFormController.dueAmountController.text = '0';
    } else {
      if (selectedStatus == 'DEBIT') {
        salesEntryFormController.dueAmountController.text =
            TfinalAmt.toStringAsFixed(2);
      } else if (selectedStatus == 'MULTI MODE') {
        // Convert debit to a string
        String? debit = multimodeDetails['debit']?.toString();
        // Check if debit is a valid string
        if (debit == null || debit.isEmpty) {
          print("Error: Debit is null or empty");
          salesEntryFormController.dueAmountController.text = '0';
        } else {
          salesEntryFormController.dueAmountController.text = debit;
        }
      } else {
        salesEntryFormController.dueAmountController.text = '0';
      }
    }
  }

  void calculateSundry() {
    double total = 0.00;
    for (var values in _allValuesSundry) {
      total += double.tryParse(values['sundryAmount']) ?? 0;
      // ledgerAmount -= (TnetAmount + total);
    }

    setState(() {
      Ttotal = total;
    });
  }

  Future<void> fetchItems() async {
    try {
      final List<Item> items = await itemsService.fetchITEMS();

      setState(() {
        itemsList = items;
      });

      // print("Rate Controller ${widget.rateControllerP.text}");
    } catch (error) {
      // print('Failed to fetch item name: $error');
    }
  }

  Future<void> fetchLedgers2() async {
    try {
      final List<Ledger> ledger = await ledgerService.fetchLedgers();

      setState(() {
        suggestionItems5 = ledger
            .where((element) =>
                element.status == 'Yes' &&
                element.ledgerGroup != '662f97d2a07ec73369c237b0')
            .toList();
        _selectedLedger = suggestionItems5.first;
        ledgerNames = suggestionItems5.map((ledger) => ledger.name).toList();

        selectedLedgerName =
            suggestionItems5.isNotEmpty ? suggestionItems5.first.id : null;
        ledgerAmount = suggestionItems5.first.debitBalance;
      });
    } catch (error) {}
  }

  List<SEntries> computePEntriesData(Null _) {
    List<SEntries> newWidgets = [];
    for (int i = 0; i < 5; i++) {
      final entryId = UniqueKey().toString();

      newWidgets.add(SEntries(
        key: ValueKey(entryId),
        serialNumber: _currentSerialNumber++,
        itemNameControllerP: salesEntryFormController.itemNameController,
        qtyControllerP: salesEntryFormController.qtyController,
        rateControllerP: salesEntryFormController.rateController,
        unitControllerP: salesEntryFormController.unitController,
        amountControllerP: salesEntryFormController.amountController,
        discountControllerP: salesEntryFormController.discountController,
        taxControllerP: salesEntryFormController.taxController,
        sgstControllerP: salesEntryFormController.sgstController,
        cgstControllerP: salesEntryFormController.cgstController,
        igstControllerP: salesEntryFormController.igstController,
        netAmountControllerP: salesEntryFormController.netAmountController,
        selectedLegerId: selectedLedgerName!,
        onSaveValues: saveValues,
        itemsList: itemsList,
        measurement: measurement,
        taxLists: taxLists,
        onDelete: (String entryId) {
          setState(() {
            _newWidget.removeWhere((widget) => widget.key == ValueKey(entryId));

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

            // Calculate total
            calculateTotal();
          });
        },
        entryId: entryId,
      ));
    }

    print("New Widgets: $newWidgets");
    return newWidgets;
  }

  List<mobileBody.SEntries> computeSEntriesDataM(Null _) {
    List<mobileBody.SEntries> newWidgets = [];
    for (int i = 0; i < 10; i++) {
      final entryId = UniqueKey().toString();

      newWidgets.add(mobileBody.SEntries(
        key: ValueKey(entryId),
        serialNumber: i + 1,
        itemNameControllerP: salesEntryFormController.itemNameController,
        qtyControllerP: salesEntryFormController.qtyController,
        rateControllerP: salesEntryFormController.rateController,
        unitControllerP: salesEntryFormController.unitController,
        amountControllerP: salesEntryFormController.amountController,
        discountControllerP: salesEntryFormController.discountController,
        taxControllerP: salesEntryFormController.taxController,
        sgstControllerP: salesEntryFormController.sgstController,
        cgstControllerP: salesEntryFormController.cgstController,
        igstControllerP: salesEntryFormController.igstController,
        netAmountControllerP: salesEntryFormController.netAmountController,
        selectedLegerId: selectedLedgerName!,
        onSaveValues: saveValues,
        scrollController: _horizontalController2,
        onDelete: (String entryId) {
          setState(() {
            _newWidget.removeWhere((widget) => widget.key == ValueKey(entryId));

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

            // Calculate total
            calculateTotal();
          });
        },
        entryId: entryId,
      ));
    }

    print("New Widgets: $newWidgets");
    return newWidgets;
  }

  List<SundryRow> computeSundryEntriesData(Null _) {
    List<SundryRow> sundryWidget = [];
    for (int i = 0; i < 4; i++) {
      final entryId = UniqueKey().toString();
      sundryWidget.add(
        SundryRow(
          key: ValueKey(entryId),
          serialNumber: _currentSerialNumberSundry++,
          sundryControllerP: sundryFormController.sundryController,
          sundryControllerQ: sundryFormController.amountController,
          onSaveValues: saveSundry,
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
                calculateSundry();
              },
            );
          },
          entryId: entryId,
        ),
      );
    }
    return sundryWidget;
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

  Future<void> fetchPriceCategoryType() async {
    try {
      final List<PriceCategory> priceType =
          await pricetypeService.fetchPriceCategories();

      pricecategory = priceType;
      selectedPriceTypeId =
          pricecategory.isNotEmpty ? pricecategory.first.id : null;
    } catch (error) {
      print('Failed to fetch Price Type: $error');
    }
  }

  Future<void> _initliazeData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await Future.wait([
        fetchItems(),
        setCompanyCode(),
        fetchSales(),
        fetchLedgers2(),
        fetchAndSetTaxRates(),
        fetchMeasurementLimit(),
        fetchPriceCategoryType(),
      ]);

      final results = await Future.wait([
        compute(computePEntriesData, null),
        compute(computeSEntriesDataM, null),
        compute(computeSundryEntriesData, null),
      ]);

      setState(() {
        _newWidget.addAll(results[0] as List<SEntries>);
        _newWidgetMobile.addAll(results[1] as List<mobileBody.SEntries>);
        _newSundry.addAll(results[2] as List<SundryRow>);
      });

      // compute(computePEntriesData, null).then((List<SEntries> computedData) {
      //   setState(() {
      //     _newWidget.addAll(computedData);
      //   });
      // });

      // compute(computeSEntriesDataM, null)
      //     .then((List<mobileBody.SEntries> computedData) {
      //   setState(() {
      //     _newWidgetMobile.addAll(computedData);
      //   });
      // });

      // compute(computeSundryEntriesData, null)
      //     .then((List<SundryRow> computedData) {
      //   setState(() {
      //     _newSundry.addAll(computedData);
      //   });
      // });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });

      print("NO OF ITEMS ${itemsList.length}");
    }
  }

  void clearAll() {
    setState(() {
      _newWidget.clear();
      _newSundry.clear();
      _allValues.clear();
      _allValuesSundry.clear();
      dispacthDetails.clear();
      Ttotal = 0.00;
      Tqty = 0.00;
      Tamount = 0.00;
      Tsgst = 0.00;
      Tcgst = 0.00;
      Tigst = 0.00;
      TnetAmount = 0.00;
      // Set serialNumber to 1
      _currentSerialNumber = 1;
      _currentSerialNumberSundry = 1;
      // roundOffController.dispose();

      salesEntryFormController.noController.clear();
      // salesEntryFormController.dateController1.clear();
      selectedLedgerName = suggestionItems5.first.id;
      salesEntryFormController.dcNoController.clear();
      // salesEntryFormController.dateController2.clear();
      salesEntryFormController.remarkController?.clear();
      _generateBillNumber();
      _generateRandomNumber();
    });

    compute(computePEntriesData, null).then((List<SEntries> computedData) {
      setState(() {
        _newWidget.addAll(computedData);
      });
    });

    // Compute Sundry Entries
    compute(computeSundryEntriesData, null)
        .then((List<SundryRow> computedData) {
      setState(() {
        _newSundry.addAll(computedData);
      });
    });

    print("All values cleared");
  }

  void _initializaControllers() {
    salesEntryFormController.noController.text = _generatedNumber.toString();
    salesEntryFormController.typeController.text = selectedStatus;
    salesEntryFormController.dateController1.text =
        formatter.format(DateTime.now());
    salesEntryFormController.dateController2.text =
        formatter.format(DateTime.now());
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   if (mounted) {
  //     FocusScope.of(context).requestFocus(noFocus);
  //   }
  // }

  @override
  void dispose() {
    print("Disposing");
    // noFocus.dispose();
    // dcNoFocus.dispose();
    // dateFocus.dispose();
    // typeFocus.dispose();
    // partyFocus.dispose();
    // placeFocus.dispose();
    // dcNoFocus2.dispose();
    // dateFocus2.dispose();
    // totalAmountFocus.dispose();
    // cashAmountFocus.dispose();
    // dueAmountFocus.dispose();
    // roundOffFocus.dispose();
    // remarkFocus.dispose();
    // itemNameFocus.dispose();
    // qtyFocus.dispose();
    // rateFocus.dispose();
    // unitFocus.dispose();
    // amountFocus.dispose();
    // discountFocus.dispose();
    // taxFocus.dispose();
    // sgstFocus.dispose();
    // cgstFocus.dispose();
    // igstFocus.dispose();
    // netAmountFocus.dispose();
    // sundryFocus.dispose();
    // sundryAmountFocus.dispose();
    // dispatchFocus.dispose();
    // transAgencyFocus.dispose();
    // docketNoFocus.dispose();
    // vehicleNoFocus.dispose();
    // fromStationFocus.dispose();
    // fromDistrictFocus.dispose();
    // transModeFocus.dispose();
    // parcelFocus.dispose();
    // freightFocus.dispose();
    // kmsFocus.dispose();
    // toStateFocus.dispose();
    // ewayBillFocus.dispose();
    // billingAddressFocus.dispose();
    // shippedToFocus.dispose();
    // shippingAddressFocus.dispose();
    // phoneNoFocus.dispose();
    // gstNoFocus.dispose();
    // remarksFocus.dispose();
    // licenceNoFocus.dispose();
    // issueStateFocus.dispose();
    // nameFocus.dispose();
    // addressFocus.dispose();
    // cashFocus.dispose();
    // debitFocus.dispose();
    // adjustedAmountFocus.dispose();
    // pendingAmountFocus.dispose();
    // finalAmountFocus.dispose();
    // advPaymentFocus.dispose();
    // advPaymentDateFocus.dispose();
    // installmentFocus.dispose();
    // totalDebitAmountFocus.dispose();
    dispacthDetails.clear();
    moreDetails.clear();
    multimodeDetails.clear();
    _advpaymentController.dispose();
    _advpaymentdateController.dispose();
    _installmentController.dispose();
    _toteldebitamountController.dispose();
    salesEntryFormController.dispose();
    sundryFormController.dispose();
    _horizontalController1.dispose();
    _horizontalController2.dispose();
    _horizontalController3.dispose();
    // dateFocusNode1.removeListener(_handleDate1FocusChange);
    // dateFocusNode2.removeListener(_handleDate2FocusChange);

    _timer.cancel();

    super.dispose();
  }

  void clearFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // void initializeAllFocusNode() {
  //   // Initialize all FocusNodes
  //   dateFocusNode1 = FocusNode();
  //   dateFocusNode2 = FocusNode();

  //   noFocus = FocusNode();
  //   dcNoFocus = FocusNode();
  //   dateFocus = FocusNode();
  //   typeFocus = FocusNode();
  //   partyFocus = FocusNode();
  //   placeFocus = FocusNode();
  //   dcNoFocus2 = FocusNode();
  //   dateFocus2 = FocusNode();
  //   totalAmountFocus = FocusNode();
  //   cashAmountFocus = FocusNode();
  //   dueAmountFocus = FocusNode();
  //   roundOffFocus = FocusNode();
  //   remarkFocus = FocusNode();
  //   itemNameFocus = FocusNode();
  //   qtyFocus = FocusNode();
  //   rateFocus = FocusNode();
  //   unitFocus = FocusNode();
  //   amountFocus = FocusNode();
  //   discountFocus = FocusNode();
  //   taxFocus = FocusNode();
  //   sgstFocus = FocusNode();
  //   cgstFocus = FocusNode();
  //   igstFocus = FocusNode();
  //   netAmountFocus = FocusNode();
  //   sundryFocus = FocusNode();
  //   sundryAmountFocus = FocusNode();
  //   dispatchFocus = FocusNode();
  //   transAgencyFocus = FocusNode();
  //   docketNoFocus = FocusNode();
  //   vehicleNoFocus = FocusNode();
  //   fromStationFocus = FocusNode();
  //   fromDistrictFocus = FocusNode();
  //   transModeFocus = FocusNode();
  //   parcelFocus = FocusNode();
  //   freightFocus = FocusNode();
  //   kmsFocus = FocusNode();
  //   toStateFocus = FocusNode();
  //   ewayBillFocus = FocusNode();
  //   billingAddressFocus = FocusNode();
  //   shippedToFocus = FocusNode();
  //   shippingAddressFocus = FocusNode();
  //   phoneNoFocus = FocusNode();
  //   gstNoFocus = FocusNode();
  //   remarksFocus = FocusNode();
  //   licenceNoFocus = FocusNode();
  //   issueStateFocus = FocusNode();
  //   nameFocus = FocusNode();
  //   addressFocus = FocusNode();
  //   cashFocus = FocusNode();
  //   debitFocus = FocusNode();
  //   adjustedAmountFocus = FocusNode();
  //   pendingAmountFocus = FocusNode();
  //   finalAmountFocus = FocusNode();
  //   advPaymentFocus = FocusNode();
  //   advPaymentDateFocus = FocusNode();
  //   installmentFocus = FocusNode();
  //   totalDebitAmountFocus = FocusNode();
  // }

  @override
  void initState() {
    super.initState();
    _initliazeData();
    // initializeAllFocusNode();
    _generateRandomNumber();
    _horizontalControllersGroup = LinkedScrollControllerGroup();
    _horizontalController1 = _horizontalControllersGroup.addAndGet();
    _horizontalController2 = _horizontalControllersGroup.addAndGet();
    _horizontalController3 = _horizontalControllersGroup.addAndGet();
    _initializaControllers();
    roundOffController = TextEditingController();
    roundOffFocusNode = FocusNode();
    roundOffController.text =
        TRoundOff.toStringAsFixed(2); // Initial value from TRoundOff
    roundOffController.addListener(() {
      if (roundOffFocusNode.hasFocus) {
        isManualRoundOffChange = true;
      }
    });
    // dateFocusNode1.addListener(_handleDate1FocusChange);
    // dateFocusNode2.addListener(_handleDate2FocusChange);
    _startTimer();
  }

  void addANewLine() {
    final entryId = UniqueKey().toString();
    setState(() {
      _newWidget.add(SEntries(
        key: ValueKey(entryId),
        serialNumber: _currentSerialNumber++,
        itemNameControllerP: salesEntryFormController.itemNameController,
        qtyControllerP: salesEntryFormController.qtyController,
        rateControllerP: salesEntryFormController.rateController,
        unitControllerP: salesEntryFormController.unitController,
        amountControllerP: salesEntryFormController.amountController,
        discountControllerP: salesEntryFormController.discountController,
        taxControllerP: salesEntryFormController.taxController,
        sgstControllerP: salesEntryFormController.sgstController,
        cgstControllerP: salesEntryFormController.cgstController,
        igstControllerP: salesEntryFormController.igstController,
        netAmountControllerP: salesEntryFormController.netAmountController,
        selectedLegerId: selectedLedgerName!,
        onSaveValues: saveValues,
        itemsList: itemsList,
        measurement: measurement,
        taxLists: taxLists,
        onDelete: (String entryId) {
          setState(() {
            _newWidget.removeWhere((widget) => widget.key == ValueKey(entryId));

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

            // Calculate total
            calculateTotal();
          });
        },
        entryId: entryId,
      ));
    });
  }

  final _formKey = GlobalKey<FormState>();

  // Navigate from sales to ledger and return result
  void navigateToLedger() async {
    final lp = Provider.of<OnChangeLedgerProvider>(context, listen: false);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LGMyDesktopBody(),
      ),
    );

    print("Result: $result");

    if (result != null) {
      setState(() {
        suggestionItems5.add(result);
        selectedLedgerName = result.id;
        _selectedLedger = result;
        lp.setLedger(result.priceListCategory);
      });

      fetchSingleLedger(selectedLedgerName!);

      print("Selected Ledger: $_selectedLedger");
    }
  }

  Widget _buildDesktopScreen() {
    final lp = Provider.of<OnChangeLedgerProvider>(context);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: FocusScope(
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.escape): const ActivateIntent(),
            LogicalKeySet(LogicalKeyboardKey.f2): const NavigateToListIntent(),
            LogicalKeySet(LogicalKeyboardKey.f4): const SaveIntent(),
            LogicalKeySet(LogicalKeyboardKey.f5): const ChangeTypeIntent(),
            LogicalKeySet(
                    LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyE):
                const CreateNewEntryIntent(),
            LogicalKeySet(
                    LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyP):
                const PrintIntent(),
            LogicalKeySet(
                    LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyA):
                const AddNewLineIntent(),
            LogicalKeySet(
                    LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyB):
                const PrintBarcodeIntent(),
            LogicalKeySet(
                    LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyM):
                const CreateNewItemIntent(),
            LogicalKeySet(
                    LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyL):
                const CreateNewLedgerIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (ActivateIntent intent) {
                  Navigator.of(context).pop();
                  return KeyEventResult.handled;
                },
              ),
              SaveIntent: CallbackAction<SaveIntent>(
                onInvoke: (SaveIntent intent) {
                  createSalesEntry();
                  return KeyEventResult.handled;
                },
              ),
              NavigateToListIntent: CallbackAction<NavigateToListIntent>(
                onInvoke: (NavigateToListIntent intent) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SalesHome(
                        item: itemsList,
                      ),
                    ),
                  );
                  return KeyEventResult.handled;
                },
              ),
              CreateNewEntryIntent: CallbackAction<CreateNewEntryIntent>(
                onInvoke: (CreateNewEntryIntent intent) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const SEMyDesktopBody(),
                    ),
                  );
                  return KeyEventResult.handled;
                },
              ),
              PrintIntent: CallbackAction<PrintIntent>(
                onInvoke: (PrintIntent intent) {
                  return KeyEventResult.handled;
                },
              ),
              AddNewLineIntent: CallbackAction<AddNewLineIntent>(
                onInvoke: (AddNewLineIntent intent) {
                  addANewLine();
                  return KeyEventResult.handled;
                },
              ),
              PrintBarcodeIntent: CallbackAction<PrintBarcodeIntent>(
                onInvoke: (PrintBarcodeIntent intent) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BarcodePrintD(),
                    ),
                  );
                  return KeyEventResult.handled;
                },
              ),
              CreateNewItemIntent: CallbackAction<CreateNewItemIntent>(
                onInvoke: (CreateNewItemIntent intent) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NIMyDesktopBody(),
                    ),
                  );
                  return KeyEventResult.handled;
                },
              ),
              CreateNewLedgerIntent: CallbackAction<CreateNewLedgerIntent>(
                onInvoke: (CreateNewLedgerIntent intent) {
                  navigateToLedger();
                  return KeyEventResult.handled;
                },
              ),
              ChangeTypeIntent: CallbackAction<ChangeTypeIntent>(
                onInvoke: (ChangeTypeIntent intent) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SalesReturn(),
                    ),
                  );
                  return KeyEventResult.handled;
                },
              ),
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.901,
                      child: Opacity(
                        opacity: _isSaving ? 0.5 : 1,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // First Row...
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  children: [
                                    SETopText(
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                      height: 30,
                                      text: 'No',
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.00),
                                    ),
                                    SETopTextfield(
                                      // focusNode: noFocus,
                                      // onEditingComplete: () {
                                      //   FocusScope.of(context)
                                      //       .requestFocus(dateFocusNode1);
                                      //   setState(() {});
                                      // },
                                      controller:
                                          salesEntryFormController.noController,
                                      onSaved: (newValue) {
                                        salesEntryFormController
                                            .noController.text = newValue!;
                                      },
                                      width: MediaQuery.of(context).size.width *
                                          0.07,
                                      height: 40,
                                      padding: const EdgeInsets.only(
                                          left: 8.0, bottom: 16.0),
                                      hintText: '',
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: SETopText(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                        height: 40,
                                        text: 'Date',
                                        padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.00,
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0005),
                                      ),
                                    ),
                                    SETopTextfield(
                                      // focusNode: dateFocusNode1,
                                      // onEditingComplete: () {
                                      //   FocusScope.of(context)
                                      //       .requestFocus(typeFocus);
                                      //   setState(() {});
                                      // },
                                      controller: salesEntryFormController
                                          .dateController1,
                                      onSaved: (newValue) {
                                        salesEntryFormController
                                            .dateController1.text = newValue!;
                                      },
                                      width: MediaQuery.of(context).size.width *
                                          0.09,
                                      height: 40,
                                      padding: const EdgeInsets.only(
                                          left: 8.0, bottom: 16.0),
                                      hintText: _selectedDate == null
                                          ? '12/12/2023'
                                          : formatter.format(_selectedDate!),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.03,
                                      child: IconButton(
                                          onPressed: _presentDatePICKER,
                                          icon:
                                              const Icon(Icons.calendar_month)),
                                    ),
                                    SETopText(
                                      width: MediaQuery.of(context).size.width *
                                          0.04,
                                      height: 30,
                                      text: 'Type',
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.0005,
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.00),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        color: Colors.white,
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      height: 40,
                                      padding: const EdgeInsets.all(2.0),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownMenu<String>(
                                          // focusNode: typeFocus,

                                          requestFocusOnTap: true,

                                          initialSelection: status.first,
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
                                              salesEntryFormController
                                                  .typeController
                                                  .text = selectedStatus;
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

                              const SizedBox(height: 5),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 2.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SETopText(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            height: 30,
                                            text: 'Party',
                                            padding: EdgeInsets.only(
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.00,
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.00),
                                          ),

                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                              color: Colors.white,
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.377,
                                            height: 40,
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownMenu<Ledger>(
                                                // focusNode: partyFocus,
                                                requestFocusOnTap: true,
                                                initialSelection: null,
                                                enableSearch: true,
                                                trailingIcon:
                                                    const SizedBox.shrink(),
                                                textStyle: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                                menuHeight: 300,
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
                                                  activeIndicatorBorder:
                                                      BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                                expandedInsets: EdgeInsets.zero,
                                                enableFilter: true,
                                                filterCallback: (List<
                                                            DropdownMenuEntry<
                                                                Ledger>>
                                                        entries,
                                                    String filter) {
                                                  final String trimmedFilter =
                                                      filter
                                                          .trim()
                                                          .toLowerCase();

                                                  if (trimmedFilter.isEmpty) {
                                                    return entries;
                                                  }

                                                  // Filter the entries based on the query
                                                  return entries.where((entry) {
                                                    return entry.value.name
                                                        .toLowerCase()
                                                        .contains(
                                                            trimmedFilter);
                                                  }).toList();
                                                },
                                                onSelected: (Ledger? value) {
                                                  if (value != null) {
                                                    setState(() {
                                                      _selectedLedger = value;
                                                      selectedLedgerName =
                                                          value.id;
                                                      isLedgerSelected = true;

                                                      final selectedLedger =
                                                          suggestionItems5
                                                              .firstWhere(
                                                        (element) =>
                                                            element.id ==
                                                            selectedLedgerName,
                                                        orElse: () =>
                                                            value, // Fallback to selected value if not found
                                                      );
                                                      ledgerAmount =
                                                          selectedLedger
                                                              .debitBalance;
                                                      lp.setLedger(selectedLedger
                                                          .priceListCategory);
                                                    });

                                                    fetchSingleLedger(
                                                        selectedLedgerName!);
                                                  }
                                                },
                                                dropdownMenuEntries:
                                                    suggestionItems5.map<
                                                            DropdownMenuEntry<
                                                                Ledger>>(
                                                        (Ledger value) {
                                                  return DropdownMenuEntry<
                                                      Ledger>(
                                                    value: value,
                                                    label: value.name,
                                                    trailingIcon: Text(
                                                      value.debitBalance
                                                          .toStringAsFixed(2),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    style: ButtonStyle(
                                                      textStyle:
                                                          WidgetStateProperty
                                                              .all(
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

                                          SETopText(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            height: 30,
                                            text: 'Place',
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01,
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.00,
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.00),
                                          ),
                                          // Custom Textfield

                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                              color: Colors.white,
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            height: 40,
                                            padding: const EdgeInsets.all(2.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownMenu<String>(
                                                // focusNode: placeFocus,
                                                requestFocusOnTap: true,
                                                initialSelection: 'Gujarat',
                                                enableSearch: true,
                                                // enableFilter: true,
                                                // leadingIcon: const SizedBox.shrink(),
                                                trailingIcon:
                                                    const SizedBox.shrink(),
                                                textStyle: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                                menuHeight: 300,
                                                selectedTrailingIcon:
                                                    const SizedBox.shrink(),

                                                inputDecorationTheme:
                                                    InputDecorationTheme(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 8),
                                                  isDense: true,
                                                  activeIndicatorBorder:
                                                      const BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                  counterStyle:
                                                      GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                expandedInsets: EdgeInsets.zero,
                                                onSelected: (String? value) {
                                                  setState(() {
                                                    selectedPlaceState = value!;
                                                    salesEntryFormController
                                                            .placeController
                                                            .text =
                                                        selectedPlaceState;
                                                  });
                                                },
                                                dropdownMenuEntries: placestate
                                                    .map<
                                                            DropdownMenuEntry<
                                                                String>>(
                                                        (String value) {
                                                  return DropdownMenuEntry<
                                                          String>(
                                                      value: value,
                                                      label: value,
                                                      style: ButtonStyle(
                                                        textStyle:
                                                            WidgetStateProperty
                                                                .all(
                                                          GoogleFonts.poppins(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                              ),

                              const SizedBox(height: 5),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 2.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SETopText(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            height: 30,
                                            text: 'Bill No',
                                            padding: EdgeInsets.only(
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.00,
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.00),
                                          ),

                                          SETopTextfield(
                                            // focusNode: dcNoFocus,
                                            // onEditingComplete: () {
                                            //   FocusScope.of(context)
                                            //       .requestFocus(dateFocusNode2);
                                            //   setState(() {});
                                            // },
                                            controller: salesEntryFormController
                                                .dcNoController,
                                            onSaved: (newValue) {
                                              salesEntryFormController
                                                  .dcNoController
                                                  .text = newValue!;
                                            },
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.248,
                                            height: 40,
                                            padding: const EdgeInsets.only(
                                                left: 8.0, bottom: 16.0),
                                            hintText: '',
                                          ),
                                          const SizedBox(width: 20),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: SETopText(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              height: 30,
                                              text: 'Date',
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.0005,
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.00),
                                            ),
                                          ),
                                          SETopTextfield(
                                            // focusNode: dateFocusNode2,
                                            // onEditingComplete: () {
                                            //   FocusScope.of(context)
                                            //       .requestFocus(remarkFocus);
                                            //   setState(() {});
                                            // },
                                            controller: salesEntryFormController
                                                .dateController2,
                                            onSaved: (newValue) {
                                              salesEntryFormController
                                                  .dateController2
                                                  .text = newValue!;

                                              print(salesEntryFormController
                                                  .dateController2.text);
                                            },
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.09,
                                            height: 40,
                                            padding: const EdgeInsets.only(
                                                left: 8.0, bottom: 16.0),
                                            hintText: _pickedDateData == null
                                                ? '12/12/2023'
                                                : formatter
                                                    .format(_pickedDateData!),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                            child: IconButton(
                                                onPressed: _showDataPICKER,
                                                icon: const Icon(
                                                    Icons.calendar_month)),
                                          ),

                                          // Visibility(
                                          //   visible:
                                          //       selectedStatus == 'CASH',
                                          //   child: Padding(
                                          //     padding: EdgeInsets.only(
                                          //         left: MediaQuery.of(
                                          //                     context)
                                          //                 .size
                                          //                 .width *
                                          //             0.01,
                                          //         top: MediaQuery.of(
                                          //                     context)
                                          //                 .size
                                          //                 .width *
                                          //             0.003),
                                          //     child: SizedBox(
                                          //       width:
                                          //           MediaQuery.of(context)
                                          //                   .size
                                          //                   .width *
                                          //               0.05,
                                          //       child: const Text(
                                          //         'Cash',
                                          //         style: TextStyle(
                                          //             color: Colors.black,
                                          //             fontWeight:
                                          //                 FontWeight
                                          //                     .bold),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          // Visibility(
                                          //   visible:
                                          //       selectedStatus == 'Cash',
                                          //   child: Flexible(
                                          //     child: Container(
                                          //       width:
                                          //           MediaQuery.of(context)
                                          //                   .size
                                          //                   .width *
                                          //               0.07,
                                          //       height: 30,
                                          //       decoration: BoxDecoration(
                                          //         border: Border.all(
                                          //             color:
                                          //                 Colors.black),
                                          //         borderRadius:
                                          //             BorderRadius
                                          //                 .circular(0),
                                          //       ),
                                          //       child: Padding(
                                          //         padding:
                                          //             const EdgeInsets
                                          //                 .all(0.0),
                                          //         child: TextFormField(
                                          //           controller:
                                          //               salesEntryFormController
                                          //                   .cashAmountController,
                                          //           onSaved: (newValue) {
                                          //             salesEntryFormController
                                          //                 .cashAmountController
                                          //                 .text = newValue!;
                                          //           },
                                          //           decoration:
                                          //               const InputDecoration(
                                          //             border: InputBorder
                                          //                 .none,
                                          //           ),
                                          //           textAlign:
                                          //               TextAlign.start,
                                          //           style:
                                          //               const TextStyle(
                                          //                   fontWeight:
                                          //                       FontWeight
                                          //                           .bold,
                                          //                   color: Colors
                                          //                       .black),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),

                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                maxWidth: 200,
                                                maxHeight: 30,
                                              ),
                                              child: SEFormButton(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.18,
                                                height: 40,
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        // FocusScope.of(context)
                                                        //     .requestFocus(
                                                        //         advPaymentFocus);
                                                      });

                                                      return AlertDialog(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        content: SizedBox(
                                                          width: 700,
                                                          height: 400,
                                                          child: Scaffold(
                                                            appBar: AppBar(
                                                              backgroundColor:
                                                                  const Color(
                                                                      0xFF4169E1),
                                                              automaticallyImplyLeading:
                                                                  false,
                                                              centerTitle: true,
                                                              title: Text(
                                                                'More Details',
                                                                style: GoogleFonts.poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                            body:
                                                                StatefulBuilder(
                                                              builder: (context,
                                                                  setState) {
                                                                return Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                200,
                                                                            child:
                                                                                Text(
                                                                              '1. ADVANCE PAYMENT',
                                                                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 109, 17, 189)),
                                                                            ),
                                                                          ),
                                                                          Flexible(
                                                                            child:
                                                                                Container(
                                                                              width: 400,
                                                                              height: 40,
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(color: Colors.black),
                                                                                borderRadius: BorderRadius.circular(0),
                                                                                color: Colors.white,
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                                                                                child: TextFormField(
                                                                                  // focusNode: advPaymentFocus,
                                                                                  // onEditingComplete: () {
                                                                                  //   FocusScope.of(context).requestFocus(advPaymentDateFocus);
                                                                                  //   setState(() {});
                                                                                  // },
                                                                                  controller: _advpaymentController,
                                                                                  onSaved: (newValue) {
                                                                                    _advpaymentController.text = newValue!;
                                                                                  },
                                                                                  style: GoogleFonts.poppins(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 17,
                                                                                    height: 1,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                  decoration: const InputDecoration(
                                                                                    border: InputBorder.none,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                200,
                                                                            child:
                                                                                Text(
                                                                              '2. ADVANCE PAYMENT DATE',
                                                                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 109, 17, 189)),
                                                                            ),
                                                                          ),
                                                                          Flexible(
                                                                            child:
                                                                                Container(
                                                                              width: 400,
                                                                              height: 40,
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(color: Colors.black),
                                                                                borderRadius: BorderRadius.circular(0),
                                                                                color: Colors.white,
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                                                                                child: TextFormField(
                                                                                  // focusNode: advPaymentDateFocus,
                                                                                  // onEditingComplete: () {
                                                                                  //   FocusScope.of(context).requestFocus(installmentFocus);
                                                                                  //   setState(() {});
                                                                                  // },
                                                                                  controller: _advpaymentdateController,
                                                                                  onSaved: (newValue) {
                                                                                    _advpaymentdateController.text = newValue!;
                                                                                  },
                                                                                  style: GoogleFonts.poppins(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 17,
                                                                                    height: 1,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                  decoration: const InputDecoration(
                                                                                    border: InputBorder.none,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                200,
                                                                            child:
                                                                                Text(
                                                                              '3. INSTALLMENT',
                                                                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 109, 17, 189)),
                                                                            ),
                                                                          ),
                                                                          Flexible(
                                                                            child:
                                                                                Container(
                                                                              width: 400,
                                                                              height: 40,
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(color: Colors.black),
                                                                                borderRadius: BorderRadius.circular(0),
                                                                                color: Colors.white,
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                                                                                child: TextFormField(
                                                                                  // focusNode: installmentFocus,
                                                                                  // onEditingComplete: () {
                                                                                  //   FocusScope.of(context).requestFocus(debitFocus);
                                                                                  //   setState(() {});
                                                                                  // },
                                                                                  controller: _installmentController,
                                                                                  onSaved: (newValue) {
                                                                                    _installmentController.text = newValue!;
                                                                                  },
                                                                                  style: GoogleFonts.poppins(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 17,
                                                                                    height: 1,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                  decoration: const InputDecoration(
                                                                                    border: InputBorder.none,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                200,
                                                                            child:
                                                                                Text(
                                                                              '4. TOTAL DEBIT AMOUNT',
                                                                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 109, 17, 189)),
                                                                            ),
                                                                          ),
                                                                          Flexible(
                                                                            child:
                                                                                Container(
                                                                              width: 400,
                                                                              height: 40,
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(color: Colors.black),
                                                                                borderRadius: BorderRadius.circular(0),
                                                                                color: Colors.white,
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                                                                                child: TextFormField(
                                                                                  // focusNode: debitFocus,
                                                                                  controller: _toteldebitamountController,
                                                                                  onSaved: (newValue) {
                                                                                    _toteldebitamountController.text = newValue!;
                                                                                  },
                                                                                  style: GoogleFonts.poppins(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 17,
                                                                                    height: 1,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                  decoration: const InputDecoration(
                                                                                    border: InputBorder.none,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            50),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        SEFormButton(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.1,
                                                                          height:
                                                                              30,
                                                                          onPressed:
                                                                              saveMoreDetailsValues,
                                                                          buttonText:
                                                                              'Save',
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                10),
                                                                        SEFormButton(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.1,
                                                                          height:
                                                                              30,
                                                                          onPressed:
                                                                              () {
                                                                            moreDetails.clear();
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          buttonText:
                                                                              'Cancel',
                                                                        )
                                                                      ],
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
                                                },
                                                buttonText: 'More Details',
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //  Make Table Shimmer Here...
                              isLoading
                                  ? const TableExample(rows: 7, cols: 13)
                                  : Column(
                                      children: [
                                        const NotaTable(),
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
                                        Column(
                                          children: [
                                            NotaTableFooter(
                                              qty: Tqty,
                                              amount: Tamount,
                                              sgst: Tsgst,
                                              cgst: Tcgst,
                                              igst: Tigst,
                                              netAmount: TnetAmount,
                                              discount: Tdiscount,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                              // Column(
                              //   children: [
                              //     const NotaTable(),
                              //     isLoading
                              //         ? SizedBox(
                              //             height: 200,
                              //             width: MediaQuery.of(context).size.width,
                              //             child: const Center(
                              //               child: CircularProgressIndicator(),
                              //             ),
                              //           )
                              //         : SizedBox(
                              //             height: 200,
                              //             width: MediaQuery.of(context).size.width,
                              //             child: SingleChildScrollView(
                              //               child: Column(
                              //                 children: _newWidget,
                              //               ),
                              //             ),
                              //           ),
                              //     Column(
                              //       children: [
                              //         NotaTableFooter(
                              //           qty: Tqty,
                              //           amount: Tamount,
                              //           sgst: Tsgst,
                              //           cgst: Tcgst,
                              //           igst: Tigst,
                              //           netAmount: TnetAmount,
                              //           discount: Tdiscount,
                              //         ),
                              //       ],
                              //     )
                              //   ],
                              // ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.06,
                                                          child: Text(
                                                            'Remarks',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: const Color(
                                                                  0xFF4B0082),
                                                            ),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.67,
                                                            height: 40,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black),
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 8.0,
                                                                      bottom:
                                                                          16.0),
                                                              child:
                                                                  TextFormField(
                                                                // focusNode:
                                                                //     remarkFocus,
                                                                canRequestFocus:
                                                                    true,
                                                                onEditingComplete:
                                                                    () {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .requestFocus(
                                                                          roundOffFocusNode);
                                                                  setState(
                                                                      () {});
                                                                },
                                                                controller:
                                                                    salesEntryFormController
                                                                        .remarkController,
                                                                onSaved:
                                                                    (newValue) {
                                                                  salesEntryFormController
                                                                          .remarkController!
                                                                          .text =
                                                                      newValue!;
                                                                },
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                decoration:
                                                                    const InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets.only(
                                                                          left:
                                                                              1,
                                                                          bottom:
                                                                              8),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Visibility(
                                                          visible:
                                                              isLedgerSelected,
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.25,
                                                            height: 170,
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    44,
                                                                    43,
                                                                    43),
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
                                                                    border:
                                                                        Border(
                                                                      bottom:
                                                                          BorderSide(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            44,
                                                                            43,
                                                                            43),
                                                                        width:
                                                                            2,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Ledger Information',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.bold,
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
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.3,
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          border:
                                                                              Border(
                                                                            bottom:
                                                                                BorderSide(
                                                                              color: Color.fromARGB(255, 44, 43, 43),
                                                                              width: 2,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.5,
                                                                          height:
                                                                              30,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Text(
                                                                                  'Limit',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: GoogleFonts.poppins(
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: const Color(0xFF4B0082),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                width: 2,
                                                                                height: 30,
                                                                                color: const Color.fromARGB(255, 44, 43, 43),
                                                                              ),
                                                                              // Change Ledger Amount
                                                                              Expanded(
                                                                                child: Container(
                                                                                  color: const Color(0xff70402a),
                                                                                  child: Center(
                                                                                    child: selectedStatus == 'CASH'
                                                                                        ? Text(
                                                                                            ledgerAmount.toStringAsFixed(2),
                                                                                            textAlign: TextAlign.center,
                                                                                            style: GoogleFonts.poppins(
                                                                                              fontSize: 16,
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: const Color(0xFFFFFFFF),
                                                                                            ),
                                                                                          )
                                                                                        : Text(
                                                                                            '${(ledgerAmount + (TnetAmount + Ttotal)).toStringAsFixed(2)} Dr',
                                                                                            textAlign: TextAlign.center,
                                                                                            style: GoogleFonts.poppins(
                                                                                              fontSize: 16,
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: const Color(0xFFffffff),
                                                                                            ),
                                                                                          ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                width: 2,
                                                                                height: 30,
                                                                                color: const Color.fromARGB(255, 44, 43, 43),
                                                                              ),
                                                                              Expanded(
                                                                                child: Text(
                                                                                  'Bal',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: GoogleFonts.poppins(
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: const Color(0xFF4B0082),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                width: 2,
                                                                                height: 30,
                                                                                color: const Color.fromARGB(255, 44, 43, 43),
                                                                              ),
                                                                              Expanded(
                                                                                child: Container(
                                                                                  color: const Color(0xff70402a),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      '0.00 Dr',
                                                                                      textAlign: TextAlign.center,
                                                                                      style: GoogleFonts.poppins(
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: const Color(0xFFFFFFFF),
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
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Visibility(
                                                          visible:
                                                              _allValues.isEmpty
                                                                  ? false
                                                                  : true,
                                                          child: SizedBox(
                                                            child: Consumer<
                                                                    OnChangeItenProvider>(
                                                                builder:
                                                                    (context,
                                                                        itemID,
                                                                        _) {
                                                              return Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.4,
                                                                height: 170,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        44,
                                                                        43,
                                                                        43),
                                                                    width: 2,
                                                                  ),
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          flex:
                                                                              4,
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              border: Border.all(
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                            height:
                                                                                30,
                                                                            child:
                                                                                ElevatedButton(
                                                                              onPressed: () {},
                                                                              style: ElevatedButton.styleFrom(
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(0),
                                                                                ),
                                                                                backgroundColor: const Color.fromARGB(
                                                                                  255,
                                                                                  255,
                                                                                  243,
                                                                                  132,
                                                                                ),
                                                                              ),
                                                                              child: Text(
                                                                                'Statements',
                                                                                style: GoogleFonts.poppins(
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: const Color(0xFF000000),
                                                                                ),
                                                                                softWrap: false,
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              6,
                                                                          child:
                                                                              Text(
                                                                            'Recent Transaction for the item',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: const Color(0xFF4B0082),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              4,
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              border: Border.all(
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                            height:
                                                                                30,
                                                                            child:
                                                                                ElevatedButton(
                                                                              onPressed: () {},
                                                                              style: ElevatedButton.styleFrom(
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(0),
                                                                                ),
                                                                                backgroundColor: const Color.fromARGB(255, 255, 243, 132),
                                                                              ),
                                                                              child: Text(
                                                                                'Purchase',
                                                                                style: GoogleFonts.poppins(
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: const Color(0xFF000000),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),

                                                                    // Table Starts Here
                                                                    Container(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          4.0),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border.all(
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        children:
                                                                            List.generate(
                                                                          headerTitles
                                                                              .length,
                                                                          (index) =>
                                                                              Expanded(
                                                                            child:
                                                                                Text(
                                                                              headerTitles[index],
                                                                              textAlign: TextAlign.center,
                                                                              style: GoogleFonts.poppins(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: const Color(0xFF4B0082),
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
                                                                        child:
                                                                            Table(
                                                                          border: TableBorder.all(
                                                                              width: 1.0,
                                                                              color: Colors.black),
                                                                          children: [
                                                                            // Iterate over all purchases' entries
                                                                            for (int i = 0;
                                                                                i < suggestionItems6.length;
                                                                                i++)
                                                                              ...suggestionItems6[i].entries.where((entry) => entry.itemName == itemID.itemID).map((entry) {
                                                                                // Find the corresponding ledger for the current entry
                                                                                String ledgerName = '';
                                                                                if (suggestionItems5.isNotEmpty) {
                                                                                  final ledger = suggestionItems5.firstWhere(
                                                                                    (ledger) => ledger.id == suggestionItems6[i].party,
                                                                                    orElse: () => Ledger(
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
                                                                                  ledgerName = ledger.name;
                                                                                }

                                                                                return TableRow(
                                                                                  children: [
                                                                                    Text(
                                                                                      suggestionItems6[i].date.toString(),
                                                                                      textAlign: TextAlign.center,
                                                                                      style: GoogleFonts.poppins(
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: const Color(0xFF000000),
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      suggestionItems6[i].dcNo.toString(),
                                                                                      textAlign: TextAlign.center,
                                                                                      style: GoogleFonts.poppins(
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: const Color(0xFF000000),
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      ledgerName, // Display the ledger name here
                                                                                      textAlign: TextAlign.center,
                                                                                      style: GoogleFonts.poppins(
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: const Color(0xFF000000),
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      entry.qty.toString(),
                                                                                      textAlign: TextAlign.center,
                                                                                      style: GoogleFonts.poppins(
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: const Color(0xFF000000),
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      entry.rate.toStringAsFixed(2),
                                                                                      textAlign: TextAlign.center,
                                                                                      style: GoogleFonts.poppins(
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: const Color(0xFF000000),
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      entry.netAmount.toStringAsFixed(2),
                                                                                      textAlign: TextAlign.center,
                                                                                      style: GoogleFonts.poppins(
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: const Color(0xFF000000),
                                                                                      ),
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
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.01,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.22,
                                          height: 230,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 44, 43, 43),
                                              width: 1,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              // Header
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black),
                                                ),
                                                child: Row(
                                                  children: List.generate(
                                                    header2Titles.length,
                                                    (index) => Expanded(
                                                      child: Text(
                                                        header2Titles[index],
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 16,
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
                                              SizedBox(
                                                height: 120,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: _newSundry,
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(height: 10),

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 18.0, bottom: 8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      width: 100,
                                                      height: 25,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      child: InkWell(
                                                        onTap: calculateSundry,
                                                        child: Text(
                                                          'Save All',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: const Color(
                                                                0xFF000000),
                                                          ),
                                                          softWrap: false,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 100,
                                                      height: 25,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {
                                                          final entryId =
                                                              UniqueKey()
                                                                  .toString();

                                                          setState(() {
                                                            _newSundry.add(
                                                              SundryRow(
                                                                  key: ValueKey(
                                                                      entryId),
                                                                  serialNumber:
                                                                      _currentSerialNumberSundry,
                                                                  sundryControllerP:
                                                                      sundryFormController
                                                                          .sundryController,
                                                                  sundryControllerQ:
                                                                      sundryFormController
                                                                          .amountController,
                                                                  onSaveValues:
                                                                      saveSundry,
                                                                  entryId:
                                                                      entryId,
                                                                  onDelete: (String
                                                                      entryId) {
                                                                    setState(
                                                                        () {
                                                                      _newSundry.removeWhere((widget) =>
                                                                          widget
                                                                              .key ==
                                                                          ValueKey(
                                                                              entryId));

                                                                      Map<String,
                                                                              dynamic>?
                                                                          entryToRemove;
                                                                      for (final entry
                                                                          in _allValuesSundry) {
                                                                        if (entry['uniqueKey'] ==
                                                                            entryId) {
                                                                          entryToRemove =
                                                                              entry;
                                                                          break;
                                                                        }
                                                                      }

                                                                      // Remove the map from _allValues if found
                                                                      if (entryToRemove !=
                                                                          null) {
                                                                        _allValuesSundry
                                                                            .remove(entryToRemove);
                                                                      }
                                                                      calculateSundry();
                                                                    });
                                                                  }),
                                                            );
                                                            _currentSerialNumberSundry++;
                                                          });
                                                        },
                                                        child: Text(
                                                          'Add',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: const Color(
                                                                0xFF000000),
                                                          ),
                                                          softWrap: false,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    children: [
                                      SEFormButton(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        height: 30,
                                        onPressed: () {
                                          if (selectedLedgerName!.isEmpty) {
                                            // Show dialog for selecting ledger
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Error!',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  content: Text(
                                                    'Please select a ledger!',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else if (_allValues.isEmpty) {
                                            // Show dialog for adding an item
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Error!',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  content: Text(
                                                    'Please add an item!',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else if (selectedStatus ==
                                              'MULTI MODE') {
                                            // Show the multi-mode details dialog
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  content: SizedBox(
                                                    width: 700,
                                                    height: 700,
                                                    child: PoPUP(
                                                      multimodeDetails:
                                                          multimodeDetails,
                                                      onSaveData:
                                                          createSalesEntry,
                                                      totalAmount: TfinalAmt,
                                                      listWidget: Expanded(
                                                        child: ListView.builder(
                                                          itemCount:
                                                              _allValues.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            Map<String, dynamic>
                                                                e = _allValues[
                                                                    index];
                                                            return Row(
                                                              children: [
                                                                Container(
                                                                  width: 145,
                                                                  height: 30,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            2.0),
                                                                    child: Text(
                                                                      itemsList
                                                                          .firstWhere((item) =>
                                                                              item.id ==
                                                                              e['itemName'])
                                                                          .itemName,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 145,
                                                                  height: 30,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            2.0),
                                                                    child: Text(
                                                                      '${e['netAmount']}',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .end,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          } else {
                                            // Proceed with creating sales entry
                                            createSalesEntry();
                                          }
                                        },
                                        buttonText: 'Save [F4]',
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.002),
                                  Column(
                                    children: [
                                      SEFormButton(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        height: 30,
                                        onPressed: () {
                                          openDialog(context);
                                        },
                                        buttonText: 'Dispatch',
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.002),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.002,
                                  ),
                                  Column(
                                    children: [
                                      SEFormButton(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        height: 30,
                                        onPressed: clearAll,
                                        buttonText: 'Delete',
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.15),
                                  Column(
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
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      const Color(0xFF4B0082),
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
                                              decoration: BoxDecoration(
                                                color:
                                                    roundOffFocusNode.hasFocus
                                                        ? Colors.black
                                                        : Colors.white,
                                                border: const Border(
                                                  bottom: BorderSide(
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                              child: TextFormField(
                                                // onEditingComplete: () {
                                                //   FocusScope.of(context)
                                                //       .requestFocus(
                                                //           netAmountFocus);

                                                //   setState(() {});
                                                // },
                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(12.0),
                                                ),
                                                controller: roundOffController,
                                                focusNode: roundOffFocusNode,
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                        signed: true,
                                                        decimal: true),
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      roundOffFocusNode.hasFocus
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                                onChanged: (value) {
                                                  double newRoundOff =
                                                      double.tryParse(value) ??
                                                          0.00;
                                                  setState(() {
                                                    TRoundOff = newRoundOff;
                                                    TfinalAmt =
                                                        TnetAmount + TRoundOff;
                                                    isManualRoundOffChange =
                                                        true;
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
                                                'Net Amount: ',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      const Color(0xFF4B0082),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Focus(
                                              canRequestFocus: true,
                                              // focusNode: netAmountFocus,
                                              child: Container(
                                                height: 20,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      width: 2,
                                                    ),
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                child: Text(
                                                  TfinalAmt.toStringAsFixed(2),
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 16,
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
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // My Desktop Body Shortcuts Starts Here...
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
                                  builder: (context) => SalesHome(
                                    item: itemsList,
                                  ),
                                ),
                              );
                            },
                          ),
                          CustomList(
                            Skey: "F5",
                            name: "Change Type",
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SalesReturn(),
                                ),
                              );
                            },
                          ),
                          CustomList(
                            Skey: "CTRL + E",
                            name: "New",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SEMyDesktopBody(),
                                ),
                              );
                            },
                          ),
                          CustomList(
                              Skey: "CTRL + P", name: "Print", onTap: () {}),
                          CustomList(
                            Skey: "CTRL + A",
                            name: "Add",
                            onTap: () {
                              addANewLine();
                            },
                          ),
                          CustomList(
                              Skey: "CTRL + B",
                              name: "Prn Barcode",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BarcodePrintD(),
                                  ),
                                );
                              }),
                          CustomList(
                              Skey: "CTRL + N",
                              name: "Search No",
                              onTap: () {}),
                          CustomList(
                              Skey: "CTRL + M",
                              name: "Create Item",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const NIMyDesktopBody(),
                                  ),
                                );
                              }),
                          CustomList(
                            Skey: "CTRL + L",
                            name: "Create Ledger",
                            onTap: navigateToLedger,
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
                          // CustomList(
                          //     Skey: "F12", name: "Discount", onTap: () {}),
                          // CustomList(
                          //     Skey: "F12", name: "Audit Trail", onTap: () {}),
                          // CustomList(
                          //     Skey: "PgUp", name: "Previous", onTap: () {}),
                          // CustomList(Skey: "PgDn", name: "Next", onTap: () {}),
                          // CustomList(Skey: "", name: "", onTap: () {}),
                          // CustomList(
                          //     Skey: "G", name: "Attach. Img", onTap: () {}),
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
                    if (_isSaving)
                      Center(
                        child: Lottie.asset('lottie/loading.json'),
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

  Widget _buildTabletScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              SETopText(
                width: MediaQuery.of(context).size.width * 0.1,
                height: 30,
                text: 'No',
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.00),
              ),
              SETopTextfield(
                // focusNode: noFocus,
                controller: salesEntryFormController.noController,
                onSaved: (newValue) {
                  salesEntryFormController.noController.text = newValue!;
                },
                width: MediaQuery.of(context).size.width * 0.35,
                height: 40,
                padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                hintText: '',
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SETopText(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: 40,
                  text: 'Date',
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.00,
                      left: MediaQuery.of(context).size.width * 0.0005),
                ),
              ),
              SETopTextfield(
                controller: salesEntryFormController.dateController1,
                onSaved: (newValue) {
                  salesEntryFormController.dateController1.text = newValue!;
                },
                width: MediaQuery.of(context).size.width * 0.35,
                height: 40,
                // focusNode: dateFocusNode1,
                padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                hintText: _selectedDate == null
                    ? '12/12/2023'
                    : formatter.format(_selectedDate!),
              ),

              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.03,
              //   child: IconButton(
              //       onPressed: _presentDatePICKER,
              //       icon: const Icon(Icons.calendar_month)),
              // ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SETopText(
                width: MediaQuery.of(context).size.width * 0.1,
                height: 40,
                text: 'Type',
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.0005,
                    top: MediaQuery.of(context).size.width * 0.00),
              ),
              Container(
                decoration: BoxDecoration(border: Border.all()),
                width: MediaQuery.of(context).size.width * 0.35,
                height: 40,
                padding: const EdgeInsets.all(2.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    // focusNode: typeFocus,
                    icon: const SizedBox.shrink(),
                    value: selectedStatus,
                    underline: Container(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatus = newValue!;
                        salesEntryFormController.typeController.text =
                            selectedStatus;
                        // Set Type
                      });
                    },
                    items: status.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            value,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              SETopText(
                width: MediaQuery.of(context).size.width * 0.1,
                height: 40,
                text: 'Place',
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.01,
                    right: MediaQuery.of(context).size.width * 0.00,
                    top: MediaQuery.of(context).size.width * 0.00),
              ),
              // Custom Textfield

              Container(
                decoration: BoxDecoration(border: Border.all()),
                width: MediaQuery.of(context).size.width * 0.35,
                height: 40,
                padding: const EdgeInsets.all(2.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    // focusNode: placeFocus,
                    icon: const SizedBox.shrink(),
                    menuMaxHeight: 300,
                    isExpanded: true,
                    value: selectedPlaceState,
                    underline: Container(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPlaceState = newValue!;
                        salesEntryFormController.placeController.text =
                            selectedPlaceState;
                      });
                    },
                    items: placestate.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            value,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SETopText(
                width: MediaQuery.of(context).size.width * 0.1,
                height: 40,
                text: 'Bill No',
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.00,
                    top: MediaQuery.of(context).size.width * 0.00),
              ),
              SETopTextfield(
                // focusNode: dcNoFocus,
                controller: salesEntryFormController.dcNoController,
                onSaved: (newValue) {
                  salesEntryFormController.dcNoController.text = newValue!;
                },
                width: MediaQuery.of(context).size.width * 0.35,
                height: 40,
                padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                hintText: '',
              ),
              SETopText(
                width: MediaQuery.of(context).size.width * 0.1,
                height: 40,
                text: 'Date',
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.00,
                    left: MediaQuery.of(context).size.width * 0.01),
              ),

              // Edit Date Textfield
              SETopTextfield(
                controller: salesEntryFormController.dateController2,
                // focusNode: dateFocusNode2,
                onSaved: (newValue) {
                  salesEntryFormController.dateController2.text = newValue!;
                },
                width: MediaQuery.of(context).size.width * 0.35,
                height: 40,
                padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                hintText: _pickedDateData == null
                    ? '12/12/2023'
                    : formatter.format(_pickedDateData!),
              ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.03,
              //   child: IconButton(
              //       onPressed: _showDataPICKER,
              //       icon: const Icon(Icons.calendar_month)),
              // ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SETopText(
                width: MediaQuery.of(context).size.width * 0.1,
                height: 40,
                text: 'Party',
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.00,
                    top: MediaQuery.of(context).size.width * 0.00),
              ),
              Container(
                decoration: BoxDecoration(border: Border.all()),
                width: MediaQuery.of(context).size.width * 0.81,
                height: 40,
                padding: const EdgeInsets.all(2.0),
                child: HighQPaginatedDropdown<Ledger>.paginated(
                  isDialogExpanded: false,
                  spaceBetweenDropDownAndItemsDialog: 5,
                  trailingIcon: const SizedBox.shrink(),
                  hasTrailingClearIcon: false,
                  // controller: controller,
                  onChanged: (value) {
                    setState(() {
                      selectedLedgerName = value!.id;
                      fetchSingleLedger(selectedLedgerName!);
                      if (selectedLedgerName != null) {
                        final selectedLedger = suggestionItems5.firstWhere(
                            (element) => element.id == selectedLedgerName);
                        ledgerAmount = selectedLedger.debitBalance;
                        // lp.setLedger(selectedLedger.priceListCategory);
                      }
                    });
                  },
                  paginatedRequest: (
                    int page,
                    String? searchText,
                  ) async {
                    List<Ledger> fetchedLedgers =
                        await ledgerService.fetchLedgers(
                      queryParameters: {
                        'page': page,
                        "q": searchText,
                      },
                    );
                    suggestionItems5 = fetchedLedgers
                        .where((element) =>
                            element.status == 'Yes' &&
                            element.ledgerGroup == '662f97d2a07ec73369c237b0')
                        .toList();

                    if (searchText != null && searchText.isNotEmpty) {
                      fetchedLedgers = fetchedLedgers
                          .where((element) => element.name
                              .toLowerCase()
                              .contains(searchText.toLowerCase()))
                          .toList();
                    }

                    List<MenuItemModel<Ledger>>? menuItemModels =
                        fetchedLedgers.map((ledger) {
                      return MenuItemModel<Ledger>(
                        value: ledger,
                        label: ledger.name,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ledger.name,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              ledger.debitBalance.toStringAsFixed(2),
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList();

                    return menuItemModels;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Table Starts Here
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 64.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 1200,
                    ),
                    child: SEFormButton(
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: 30,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              content: SizedBox(
                                width: 700,
                                height: 350,
                                child: Scaffold(
                                  appBar: AppBar(
                                    backgroundColor: const Color(0xFF4169E1),
                                    automaticallyImplyLeading: false,
                                    centerTitle: true,
                                    title: Text(
                                      'More Details',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  body: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              child: Text(
                                                '1. ADVANCE PAYMENT',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color.fromARGB(
                                                        255, 109, 17, 189)),
                                              ),
                                            ),
                                            Flexible(
                                              child: Container(
                                                width: 400,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          bottom: 16.0),
                                                  child: TextFormField(
                                                    controller:
                                                        _advpaymentController,
                                                    onSaved: (newValue) {
                                                      _advpaymentController
                                                          .text = newValue!;
                                                    },
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17,
                                                      height: 1,
                                                    ),
                                                    decoration:
                                                        const InputDecoration(
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              child: Text(
                                                '2. ADVANCE PAYMENT DATE',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color.fromARGB(
                                                        255, 109, 17, 189)),
                                              ),
                                            ),
                                            Flexible(
                                              child: Container(
                                                width: 400,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          bottom: 16.0),
                                                  child: TextFormField(
                                                    controller:
                                                        _advpaymentdateController,
                                                    onSaved: (newValue) {
                                                      _advpaymentdateController
                                                          .text = newValue!;
                                                    },
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17,
                                                      height: 1,
                                                    ),
                                                    decoration:
                                                        const InputDecoration(
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              child: Text(
                                                '3. INSTALLMENT',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color.fromARGB(
                                                        255, 109, 17, 189)),
                                              ),
                                            ),
                                            Flexible(
                                              child: Container(
                                                width: 400,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          bottom: 16.0),
                                                  child: TextFormField(
                                                    controller:
                                                        _installmentController,
                                                    onSaved: (newValue) {
                                                      _installmentController
                                                          .text = newValue!;
                                                    },
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17,
                                                      height: 1,
                                                    ),
                                                    decoration:
                                                        const InputDecoration(
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              child: Text(
                                                '4. TOTAL DEBIT AMOUNT',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color.fromARGB(
                                                        255, 109, 17, 189)),
                                              ),
                                            ),
                                            Flexible(
                                              child: Container(
                                                width: 400,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          bottom: 16.0),
                                                  child: TextFormField(
                                                    controller:
                                                        _toteldebitamountController,
                                                    onSaved: (newValue) {
                                                      _toteldebitamountController
                                                          .text = newValue!;
                                                    },
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17,
                                                      height: 1,
                                                    ),
                                                    decoration:
                                                        const InputDecoration(
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 50),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SEFormButton(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                            height: 30,
                                            onPressed: saveMoreDetailsValues,
                                            buttonText: 'Save',
                                          ),
                                          const SizedBox(width: 10),
                                          SEFormButton(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                            height: 30,
                                            onPressed: () {
                                              moreDetails.clear();
                                              Navigator.of(context).pop();
                                            },
                                            buttonText: 'Cancel',
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      buttonText: 'More Details',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              // Table Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.96,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _horizontalController1,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.40,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide())),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Item Name',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: const Color(0xFF4B0082),
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide())),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Qty',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: const Color(0xFF4B0082),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide())),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Unit',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: const Color(0xFF4B0082),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide())),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Rate',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: const Color(0xFF4B0082),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide())),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Amount',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: const Color(0xFF4B0082),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide())),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Disc.',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: const Color(0xFF4B0082),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide(),
                                              right: BorderSide())),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'D1%',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: const Color(0xFF4B0082),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide())),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Tax%',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: const Color(0xFF4B0082),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide())),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'SGST',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: const Color(0xFF4B0082),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide())),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'CGST',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: const Color(0xFF4B0082),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide())),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'IGST',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: const Color(0xFF4B0082),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.30,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide(),
                                              right: BorderSide())),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Net Amt.',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: const Color(0xFF4B0082),
                                          ),
                                          textAlign: TextAlign.center,
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

              // Table Today
              isLoading
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Container(
                        height: 400,
                        width: MediaQuery.of(context).size.width * 0.96,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.zero,
                          // border: Border.fromBorderSide(
                          //   BorderSide(
                          //     color: Colors.black,
                          //   ),
                          // ),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.96,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.zero,
                          border: Border.fromBorderSide(
                            BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        child: SingleChildScrollView(
                          controller: _horizontalController2,
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: _newWidgetMobile,
                          ),
                        ),
                      ),
                    ),

              // Table Footer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.96,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _horizontalController3,
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.40,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(),
                                  right: BorderSide(),
                                  top: BorderSide(),
                                  left: BorderSide())),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Total',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4B0082),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.20,
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
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4B0082),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.20,
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
                          width: MediaQuery.of(context).size.width * 0.20,
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
                          width: MediaQuery.of(context).size.width * 0.20,
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
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4B0082),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.20,
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
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4B0082),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.20,
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
                          width: MediaQuery.of(context).size.width * 0.20,
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
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4B0082),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.20,
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
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4B0082),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.20,
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
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4B0082),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.20,
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
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4B0082),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.30,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(),
                                  top: BorderSide(),
                                  left: BorderSide(),
                                  right: BorderSide())),
                          child: const Text(
                            '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          // Remarks
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Text(
                  'Remarks',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4B0082),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.96,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    cursorHeight: 18,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 1, bottom: 8),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          // Ledger Information
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.96,
              height: 170,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 44, 43, 43),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.96,
                    height: 30,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromARGB(255, 44, 43, 43),
                          width: 2,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Ledger Information',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4B0082),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.96,
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.96,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color.fromARGB(255, 44, 43, 43),
                                width: 2,
                              ),
                            ),
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 30,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Limit',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF4B0082),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 2,
                                  height: 30,
                                  color: const Color.fromARGB(255, 44, 43, 43),
                                ),
                                // Change Ledger Amount
                                Expanded(
                                  child: Container(
                                    color: const Color(0xFFA0522D),
                                    child: Center(
                                      child: Text(
                                        (ledgerAmount + (TnetAmount + Ttotal))
                                            .toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 2,
                                  height: 30,
                                  color: const Color.fromARGB(255, 44, 43, 43),
                                ),
                                Expanded(
                                  child: Text(
                                    'Bal',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF4B0082),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 2,
                                  height: 30,
                                  color: const Color.fromARGB(255, 44, 43, 43),
                                ),
                                Expanded(
                                  child: Container(
                                    color: const Color(0xFFA0522D),
                                    child: Center(
                                      child: Text(
                                        '0.00 Dr',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
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
          ),

          const SizedBox(height: 10),
          // Statement
          Consumer<OnChangeItenProvider>(builder: (context, itemID, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.96,
                height: 170,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 44, 43, 43),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  255,
                                  243,
                                  132,
                                ),
                              ),
                              child: Text(
                                'Statements',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF4B0082),
                                ),
                                softWrap: false,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Text(
                            'Recent Transaction for the item',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF4B0082),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 243, 132),
                              ),
                              child: Text(
                                'Purchase',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF4B0082),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Table Starts Here
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        children: List.generate(
                          headerTitles.length,
                          (index) => Expanded(
                            child: Text(
                              headerTitles[index],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4B0082),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Table Body

                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Table(
                          border:
                              TableBorder.all(width: 1.0, color: Colors.black),
                          children: [
                            // Iterate over all purchases' entries
                            // Iterate over all purchases' entries
                            for (int i = 0; i < suggestionItems6.length; i++)
                              ...suggestionItems6[i]
                                  .entries
                                  .where((entry) =>
                                      entry.itemName == itemID.itemID)
                                  .map((entry) {
                                // Find the corresponding ledger for the current entry
                                String ledgerName = '';
                                if (suggestionItems5.isNotEmpty) {
                                  final ledger = suggestionItems5.firstWhere(
                                    (ledger) =>
                                        ledger.id == suggestionItems6[i].party,
                                    orElse: () => Ledger(
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
                                  ledgerName = ledger.name;
                                }

                                return TableRow(
                                  children: [
                                    Text(
                                      suggestionItems6[i].date.toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      suggestionItems6[i].dcNo.toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      ledgerName, // Display the ledger name here
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      entry.qty.toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      entry.rate.toStringAsFixed(2),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      entry.netAmount.toStringAsFixed(2),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
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
              ),
            );
          }),

          const SizedBox(height: 10),
          // Round Off
          Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 20,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Text(
                        'Round-Off: ',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4B0082),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(width: 2))),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                        ),
                        controller: roundOffController,
                        focusNode: roundOffFocusNode,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 20,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Text(
                        'Amount: ',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4B0082),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(width: 2))),
                      child: Text(
                        TfinalAmt.toStringAsFixed(2),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          //Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.96,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30,
                    height: 30,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0,
                      child: ElevatedButton(
                        onPressed: createSalesEntry,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            const Color.fromARGB(255, 255, 243, 132),
                          ),
                          shape: WidgetStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Save [F4]',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30,
                    height: 30,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return FullScreenDialog(
                                dispacthDetails: dispacthDetails,
                              );
                            },
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            const Color.fromARGB(255, 255, 243, 132),
                          ),
                          shape: WidgetStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Dispatch ',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30,
                    height: 30,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0,
                      child: ElevatedButton(
                        onPressed: clearAll,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            const Color.fromARGB(255, 255, 243, 132),
                          ),
                          shape: WidgetStateProperty.all<OutlinedBorder>(
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
                              fontSize: 16,
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
          ),
          // SafehEIGHT
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMobileScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                SETopText(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: 30,
                  text: 'No',
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.00),
                ),
                SETopTextfield(
                  // focusNode: noFocus,
                  // onEditingComplete: () {
                  //   FocusScope.of(context).requestFocus(dateFocusNode1);
                  //   setState(() {});
                  // },
                  controller: salesEntryFormController.noController,
                  onSaved: (newValue) {
                    salesEntryFormController.noController.text = newValue!;
                  },
                  width: MediaQuery.of(context).size.width * 0.33,
                  height: 40,
                  padding: const EdgeInsets.only(left: 8.0, bottom: 0.0),
                  hintText: '',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SETopText(
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: 30,
                    text: 'Date',
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.00,
                        left: MediaQuery.of(context).size.width * 0.0005),
                  ),
                ),
                SETopTextfield(
                  // focusNode: dateFocusNode1,
                  // onEditingComplete: () {
                  //   FocusScope.of(context).requestFocus(typeFocus);
                  //   setState(() {});
                  // },
                  controller: salesEntryFormController.dateController1,
                  onSaved: (newValue) {
                    salesEntryFormController.dateController1.text = newValue!;
                  },
                  width: MediaQuery.of(context).size.width * 0.33,
                  height: 40,
                  padding: const EdgeInsets.only(left: 8.0, bottom: 0.0),
                  hintText: _selectedDate == null
                      ? '12/12/2023'
                      : formatter.format(_selectedDate!),
                ),
                IconButton(
                  onPressed: _presentDatePICKER,
                  icon: const Icon(
                    Icons.calendar_month,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                SETopText(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: 30,
                  text: 'Type',
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.0005,
                      top: MediaQuery.of(context).size.width * 0.00),
                ),
                Container(
                  decoration: BoxDecoration(border: Border.all()),
                  width: MediaQuery.of(context).size.width * 0.33,
                  height: 40,
                  padding: const EdgeInsets.all(2.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      // focusNode: typeFocus,
                      icon: const SizedBox.shrink(),
                      value: selectedStatus,
                      underline: Container(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedStatus = newValue!;
                          salesEntryFormController.typeController.text =
                              selectedStatus;
                          // Set Type
                        });
                      },
                      items: status.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                SETopText(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: 30,
                  text: 'Place',
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.01,
                      right: MediaQuery.of(context).size.width * 0.00,
                      top: MediaQuery.of(context).size.width * 0.00),
                ),
                // Custom Textfield

                Container(
                  decoration: BoxDecoration(border: Border.all()),
                  width: MediaQuery.of(context).size.width * 0.33,
                  height: 40,
                  padding: const EdgeInsets.all(2.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      // focusNode: placeFocus,
                      icon: const SizedBox.shrink(),
                      menuMaxHeight: 300,
                      isExpanded: true,
                      value: selectedPlaceState,
                      underline: Container(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPlaceState = newValue!;
                          salesEntryFormController.placeController.text =
                              selectedPlaceState;
                        });
                      },
                      items: placestate.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                SETopText(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: 30,
                  text: 'Bill No',
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.00,
                      top: MediaQuery.of(context).size.width * 0.00),
                ),
                SETopTextfield(
                  // focusNode: dcNoFocus,
                  controller: salesEntryFormController.dcNoController,
                  onSaved: (newValue) {
                    salesEntryFormController.dcNoController.text = newValue!;
                  },
                  width: MediaQuery.of(context).size.width * 0.33,
                  height: 40,
                  padding: const EdgeInsets.only(left: 8.0, bottom: 0.0),
                  hintText: '',
                ),
                SETopText(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: 30,
                  text: 'Date',
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.00,
                      left: MediaQuery.of(context).size.width * 0.01),
                ),
                SETopTextfield(
                  // focusNode: dateFocusNode2,
                  controller: salesEntryFormController.dateController2,
                  onSaved: (newValue) {
                    salesEntryFormController.dateController2.text = newValue!;
                  },
                  width: MediaQuery.of(context).size.width * 0.33,
                  height: 40,
                  padding: const EdgeInsets.only(left: 8.0, bottom: 0.0),
                  hintText: _pickedDateData == null
                      ? '12/12/2023'
                      : formatter.format(_pickedDateData!),
                ),
                IconButton(
                  onPressed: _showDataPICKER,
                  icon: const Icon(
                    Icons.calendar_month,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                SETopText(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: 30,
                  text: 'Party',
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.00,
                      top: MediaQuery.of(context).size.width * 0.00),
                ),
                Container(
                  decoration: BoxDecoration(border: Border.all()),
                  width: MediaQuery.of(context).size.width * 0.77,
                  height: 40,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      // focusNode: partyFocus,
                      underline: Container(),
                      isExpanded: true,
                      hint: Text(
                        'Select Item',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: suggestionItems5.map((Ledger ledger) {
                        return DropdownMenuItem<String>(
                          value: ledger.id,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(ledger.name),
                              Text(ledger.debitBalance.toStringAsFixed(2)),
                            ],
                          ),
                        );
                      }).toList(),
                      value: selectedLedgerName,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedLedgerName = newValue;
                          fetchSingleLedger(selectedLedgerName!);
                          if (selectedLedgerName != null) {
                            final selectedLedger = suggestionItems5.firstWhere(
                                (element) => element.id == selectedLedgerName);
                            ledgerAmount = selectedLedger.debitBalance;
                            // lp.setLedger(selectedLedger.priceListCategory);
                          }
                        });
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        height: 40,
                        width: 200,
                      ),
                      dropdownStyleData: const DropdownStyleData(
                        maxHeight: 200,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                      ),
                      dropdownSearchData: DropdownSearchData(
                        searchController:
                            salesEntryFormController.partyController,
                        searchInnerWidgetHeight: 50,
                        searchInnerWidget: Container(
                          height: 50,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 4,
                            right: 8,
                            left: 8,
                          ),
                          child: TextFormField(
                            onChanged: (value) {},
                            expands: true,
                            maxLines: null,
                            controller:
                                salesEntryFormController.partyController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText: 'Search for an item...',
                              hintStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  8,
                                ),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          final ledgerName = suggestionItems5
                              .firstWhere((e) => e.id == item.value)
                              .name;

                          return ledgerName
                              .toLowerCase()
                              .contains(searchValue.toLowerCase());
                        },
                      ),
                      // //This to clear the search value when you close the menu
                      // onMenuStateChange: (isOpen) {
                      //   if (!isOpen) {
                      //     textEditingController.clear();
                      //   }
                      // },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Table Starts Here
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: SEFormButton(
                  width: MediaQuery.of(context).size.width * 0.96,
                  height: 30,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          content: SizedBox(
                            width: 700,
                            height: 350,
                            child: Scaffold(
                              appBar: AppBar(
                                backgroundColor: const Color(0xFF4169E1),
                                automaticallyImplyLeading: false,
                                centerTitle: true,
                                title: Text(
                                  'More Details',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              body: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            '1. ADVANCE PAYMENT',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(
                                                    255, 109, 17, 189)),
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            width: 400,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, bottom: 16.0),
                                              child: TextFormField(
                                                controller:
                                                    _advpaymentController,
                                                onSaved: (newValue) {
                                                  _advpaymentController.text =
                                                      newValue!;
                                                },
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                  height: 1,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            '2. ADVANCE PAYMENT DATE',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(
                                                    255, 109, 17, 189)),
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            width: 400,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, bottom: 16.0),
                                              child: TextFormField(
                                                controller:
                                                    _advpaymentdateController,
                                                onSaved: (newValue) {
                                                  _advpaymentdateController
                                                      .text = newValue!;
                                                },
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                  height: 1,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            '3. INSTALLMENT',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(
                                                    255, 109, 17, 189)),
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            width: 400,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, bottom: 16.0),
                                              child: TextFormField(
                                                controller:
                                                    _installmentController,
                                                onSaved: (newValue) {
                                                  _installmentController.text =
                                                      newValue!;
                                                },
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                  height: 1,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            '4. TOTAL DEBIT AMOUNT',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(
                                                    255, 109, 17, 189)),
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            width: 400,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, bottom: 16.0),
                                              child: TextFormField(
                                                controller:
                                                    _toteldebitamountController,
                                                onSaved: (newValue) {
                                                  _toteldebitamountController
                                                      .text = newValue!;
                                                },
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                  height: 1,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 50),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SEFormButton(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        height: 30,
                                        onPressed: saveMoreDetailsValues,
                                        buttonText: 'Save',
                                      ),
                                      const SizedBox(width: 10),
                                      SEFormButton(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        height: 30,
                                        onPressed: () {
                                          moreDetails.clear();
                                          Navigator.of(context).pop();
                                        },
                                        buttonText: 'Cancel',
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  buttonText: 'More Details',
                ),
              ),

              const SizedBox(height: 10),
              // Table Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.96,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _horizontalController1,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 20,
                                      width: MediaQuery.of(context).size.width *
                                          0.40,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide())),
                                      child: const Text(
                                        '   Item Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide())),
                                      child: const Text(
                                        'Qty',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide())),
                                      child: const Text(
                                        'Unit',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide())),
                                      child: const Text(
                                        'Rate',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide())),
                                      child: const Text(
                                        'Amount',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide())),
                                      child: const Text(
                                        'Disc.',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide(),
                                              right: BorderSide())),
                                      child: const Text(
                                        'D1%',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide())),
                                      child: const Text(
                                        'Tax%',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide())),
                                      child: const Text(
                                        'SGST',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide())),
                                      child: const Text(
                                        'CGST',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide())),
                                      child: const Text(
                                        'IGST',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      width: MediaQuery.of(context).size.width *
                                          0.30,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(),
                                              left: BorderSide(),
                                              right: BorderSide())),
                                      child: const Text(
                                        'Net Amt.',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
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

              // Table Today
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.96,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.zero,
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: _horizontalController2,
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: _newWidgetMobile,
                    ),
                  ),
                ),
              ),

              // Table Footer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.96,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _horizontalController3,
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.40,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(),
                                  right: BorderSide(),
                                  top: BorderSide(),
                                  left: BorderSide())),
                          child: const Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.20,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(),
                                  top: BorderSide(),
                                  left: BorderSide())),
                          child: Text(
                            '$Tqty',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.20,
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
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.20,
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
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.20,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(),
                                  top: BorderSide(),
                                  left: BorderSide())),
                          child: Text(
                            Tamount.toStringAsFixed(2),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.20,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(),
                                  top: BorderSide(),
                                  left: BorderSide())),
                          child: Text(
                            Tdiscount.toStringAsFixed(2),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.20,
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
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.20,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(),
                                  top: BorderSide(),
                                  left: BorderSide())),
                          child: Text(
                            Tsgst.toStringAsFixed(2),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.20,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(),
                                  top: BorderSide(),
                                  left: BorderSide())),
                          child: Text(
                            Tcgst.toStringAsFixed(2),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.20,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(),
                                  top: BorderSide(),
                                  left: BorderSide())),
                          child: Text(
                            Tigst.toStringAsFixed(2),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.20,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(),
                                  top: BorderSide(),
                                  left: BorderSide(),
                                  right: BorderSide())),
                          child: Text(
                            TnetAmount.toStringAsFixed(2),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.30,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(),
                                  top: BorderSide(),
                                  left: BorderSide(),
                                  right: BorderSide())),
                          child: const Text(
                            '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          // Remarks
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Text(
                    'Remarks',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.96,
                  height: 35,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      cursorHeight: 18,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          // Ledger Information
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.96,
              height: 170,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 44, 43, 43),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.96,
                    height: 30,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromARGB(255, 44, 43, 43),
                          width: 2,
                        ),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Ledger Information',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 14, 63, 138),
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.96,
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.96,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color.fromARGB(255, 44, 43, 43),
                                width: 2,
                              ),
                            ),
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 30,
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Limit',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 20, 88, 181),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 2,
                                  height: 30,
                                  color: const Color.fromARGB(255, 44, 43, 43),
                                ),
                                // Change Ledger Amount
                                Expanded(
                                  child: Container(
                                    color: const Color(0xff70402a),
                                    child: Center(
                                      child: Text(
                                        (ledgerAmount + (TnetAmount + Ttotal))
                                            .toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                        style:
                                            // ignore: prefer_const_constructors
                                            TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 2,
                                  height: 30,
                                  color: const Color.fromARGB(255, 44, 43, 43),
                                ),
                                const Expanded(
                                  child: Text('Bal',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 20, 88, 181),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      )),
                                ),
                                Container(
                                  width: 2,
                                  height: 30,
                                  color: const Color.fromARGB(255, 44, 43, 43),
                                ),
                                Expanded(
                                  child: Container(
                                    color: const Color(0xff70402a),
                                    child: const Center(
                                      child: Text(
                                        '0.00 Dr',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
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
          ),

          const SizedBox(height: 10),
          // Statement
          Consumer<OnChangeItenProvider>(builder: (context, itemID, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.96,
                height: 170,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 44, 43, 43),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  255,
                                  243,
                                  132,
                                ),
                              ),
                              child: const Text(
                                'Statements',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                                softWrap: false,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 6,
                          child: Text(
                            'Recent Transaction for the item',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 20, 88, 181),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 243, 132),
                              ),
                              child: const Text(
                                'Purchase',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Table Starts Here
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        children: List.generate(
                          headerTitles.length,
                          (index) => Expanded(
                            child: Text(
                              headerTitles[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color.fromARGB(255, 14, 63, 138),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Table Body

                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Table(
                          border:
                              TableBorder.all(width: 1.0, color: Colors.black),
                          children: [
                            // Iterate over all purchases' entries
                            // Iterate over all purchases' entries
                            for (int i = 0; i < suggestionItems6.length; i++)
                              ...suggestionItems6[i]
                                  .entries
                                  .where((entry) =>
                                      entry.itemName == itemID.itemID)
                                  .map((entry) {
                                // Find the corresponding ledger for the current entry
                                String ledgerName = '';
                                if (suggestionItems5.isNotEmpty) {
                                  final ledger = suggestionItems5.firstWhere(
                                    (ledger) =>
                                        ledger.id == suggestionItems6[i].party,
                                    orElse: () => Ledger(
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
                                  ledgerName = ledger.name;
                                }

                                return TableRow(
                                  children: [
                                    Text(
                                      suggestionItems6[i].date.toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      suggestionItems6[i].dcNo.toString(),
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
                                      entry.rate.toStringAsFixed(2),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      entry.netAmount.toStringAsFixed(2),
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
              ),
            );
          }),

          const SizedBox(height: 10),
          // Round Off
          Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 20,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: const Text(
                        'Round-Off: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(width: 2))),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                        ),
                        controller: roundOffController,
                        focusNode: roundOffFocusNode,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 20,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: const Text(
                        'Amount: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(width: 2))),
                      child: Text(
                        TfinalAmt.toStringAsFixed(2),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          //Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.96,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30,
                    height: 30,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0,
                      child: ElevatedButton(
                        onPressed: createSalesEntry,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            const Color.fromARGB(255, 255, 243, 132),
                          ),
                          shape: WidgetStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Save [F4]',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30,
                    height: 30,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return FullScreenDialog(
                                dispacthDetails: dispacthDetails,
                              );
                            },
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            const Color.fromARGB(255, 255, 243, 132),
                          ),
                          shape: WidgetStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Dispatch ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30,
                    height: 30,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0,
                      child: ElevatedButton(
                        onPressed: clearAll,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            const Color.fromARGB(255, 255, 243, 132),
                          ),
                          shape: WidgetStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Delete',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // SafehEIGHT
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
      backgroundColor: Colors.white,
      drawer: Drawer(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Beautiful Drawer Header
              DrawerHeader(
                duration: const Duration(seconds: 1),
                child: Center(
                  child: Text(
                    'QUICK ACCESS',
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // Drawer Items

              CustomList(
                Skey: "F2",
                name: "List",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SalesHome(
                        item: itemsList,
                      ),
                    ),
                  );
                },
              ),
              CustomList(
                Skey: "F2",
                name: "New",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SEMyDesktopBody(),
                    ),
                  );
                },
              ),
              CustomList(Skey: "P", name: "Print", onTap: () {}),
              CustomList(
                Skey: "A",
                name: "Add",
                onTap: () {
                  addANewLine();
                },
              ),
              CustomList(Skey: "F5", name: "Change Type", onTap: () {}),
              CustomList(Skey: "", name: "", onTap: () {}),
              CustomList(
                  Skey: "B",
                  name: "Prn Barcode",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BarcodePrintD(),
                      ),
                    );
                  }),
              CustomList(
                Skey: "",
                name: "",
                onTap: () {},
              ),
              CustomList(Skey: "N", name: "Search No", onTap: () {}),
              CustomList(
                  Skey: "M",
                  name: "Create Item",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NIMyDesktopBody(),
                      ),
                    );
                  }),
              CustomList(
                Skey: "L",
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
              CustomList(Skey: "F12", name: "Discount", onTap: () {}),
              CustomList(Skey: "F12", name: "Audit Trail", onTap: () {}),
              CustomList(Skey: "PgUp", name: "Previous", onTap: () {}),
              CustomList(Skey: "PgDn", name: "Next", onTap: () {}),
              CustomList(Skey: "", name: "", onTap: () {}),
              CustomList(Skey: "G", name: "Attach. Img", onTap: () {}),
              CustomList(Skey: "", name: "", onTap: () {}),
              CustomList(Skey: "G", name: "Vch Setup", onTap: () {}),
              CustomList(Skey: "T", name: "Print Setup", onTap: () {}),
              CustomList(Skey: "", name: "", onTap: () {}),
            ],
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // For mobile layout
            return _buildMobileScreen();
          } else if (constraints.maxWidth < 1200) {
            // For tablet layout
            return _buildTabletScreen();
          } else {
            // For desktop layout
            return _buildDesktopScreen();
          }
        },
      ),
    );
  }

  void openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DispatchDetailsDialog(
        dispacthDetails: dispacthDetails,
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
        salesEntryFormController.dateController1.text =
            formatter.format(pickedDate);
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
        salesEntryFormController.dateController2.text =
            formatter.format(pickedDate);
      });
    }
  }
}

class ChangeTypeIntent extends Intent {
  const ChangeTypeIntent();
}

class CreateNewLedgerIntent extends Intent {
  const CreateNewLedgerIntent();
}

class CreateNewItemIntent extends Intent {
  const CreateNewItemIntent();
}

class PrintBarcodeIntent extends Intent {
  const PrintBarcodeIntent();
}

class AddNewLineIntent extends Intent {
  const AddNewLineIntent();
}

class PrintIntent extends Intent {
  const PrintIntent();
}

class CreateNewEntryIntent extends Intent {
  const CreateNewEntryIntent();
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 1200;
        return AppBar(
          toolbarHeight: 50.0, // Adjust the height as needed
          backgroundColor: Colors
              .transparent, // Make the background transparent for layering
          elevation: 0.0, // Remove the elevation to prevent shadow
          scrolledUnderElevation: 0.0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: isDesktop
              ? []
              : [
                  IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                ],
          flexibleSpace: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width /
                    2, // Half the width of the screen
                color: const Color(0xffA0522D),
                child: Center(
                  child: Text(
                    'Tax Invoice',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width /
                      2, // Half the width of the screen
                  decoration: const BoxDecoration(
                    color: Color(0xff008000),
                    // gradient: LinearGradient(
                    //   begin: Alignment.centerLeft,
                    //   end: Alignment.centerRight,
                    //   colors: [
                    //     Color.fromARGB(255, 13, 23, 33),
                    //     Color.fromARGB(255, 37, 65, 101),
                    //   ],
                    // ),
                  ),
                  child: Center(
                    child: Text(
                      'Sales Entry',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}

class TableExample extends StatelessWidget {
  const TableExample(
      {super.key, required this.rows, required this.cols, this.width});

  final int rows;
  final int cols;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Table(
        border: TableBorder.all(
          color: Colors.grey[300]!,
        ),
        columnWidths: {
          0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.023),
          1: FixedColumnWidth(
              width ?? MediaQuery.of(context).size.width * 0.19),
          2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.061),
          3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.061),
          4: FixedColumnWidth(MediaQuery.of(context).size.width * 0.061),
          5: FixedColumnWidth(MediaQuery.of(context).size.width * 0.061),
          6: FixedColumnWidth(MediaQuery.of(context).size.width * 0.061),
          7: FixedColumnWidth(MediaQuery.of(context).size.width * 0.061),
          8: FixedColumnWidth(MediaQuery.of(context).size.width * 0.061),
          9: FixedColumnWidth(MediaQuery.of(context).size.width * 0.061),
          10: FixedColumnWidth(MediaQuery.of(context).size.width * 0.061),
          11: FixedColumnWidth(MediaQuery.of(context).size.width * 0.061),
          12: FixedColumnWidth(MediaQuery.of(context).size.width * 0.061),
        },
        children: List.generate(rows, (rowIndex) {
          return TableRow(
            children: List.generate(cols, (columnIndex) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 0.0),
                child: Center(
                  child: Text(''),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
