// ignore_for_file: use_build_context_synchronously, camel_case_types

import 'dart:async';
import 'dart:math';

import 'package:billingsphere/auth/providers/onchange_item_provider.dart';
import 'package:billingsphere/data/repository/purchase_repository.dart';
import 'package:billingsphere/utils/controllers/purchase_text_controller.dart';
import 'package:billingsphere/views/DC_responsive/DC_desktop_body.dart';
import 'package:billingsphere/views/PE_widgets/PE_app_bar.dart';
import 'package:billingsphere/views/PE_widgets/PE_text_fields.dart';
import 'package:billingsphere/views/PE_widgets/PE_text_fields_no.dart';
import 'package:billingsphere/views/PEresponsive/PE_receipt_print.dart';
import 'package:billingsphere/views/SE_responsive/SE_desktop_body_POS.dart';
import 'package:billingsphere/views/SE_widgets/sundry_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/item/item_model.dart';
import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/measurementLimit/measurement_limit_model.dart';
import '../../data/models/purchase/purchase_model.dart';
import '../../data/models/taxCategory/tax_category_model.dart';
import '../../data/repository/item_repository.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/measurement_limit_repository.dart';
import '../../data/repository/tax_category_repository.dart';
import '../../utils/controllers/sundry_controller.dart';
import '../LG_responsive/LG_desktop_body.dart';
import '../NI_responsive.dart/NI_desktopBody.dart';
import '../PE_widgets/purchase_table.dart';
import '../PE_widgets/purchase_table_mobile_2.dart';
import '../PM_responsive/payment_desktop.dart';
import '../RV_responsive/RV_desktopBody.dart';
import '../SE_responsive/SE_desktop_body.dart';
import '../SE_variables/SE_variables.dart';
import '../searchable_dropdown.dart';
import '../sumit_screen/voucher _entry.dart/voucher_list_widget.dart';
import 'PE_master.dart';

final formatter = DateFormat('dd/MM/yyyy');

class PEMyDesktopBody extends StatefulWidget {
  const PEMyDesktopBody({super.key});

  @override
  State<PEMyDesktopBody> createState() => _PEMyDesktopBodyState();
}

class _PEMyDesktopBodyState extends State<PEMyDesktopBody> {
  DateTime? _selectedDate;
  DateTime? _pickedDateData;
  List<String> status = ['Cash', 'Debit'];
  String selectedStatus = 'Debit';
  String? selectedState = 'Gujarat';
  final List<PEntries> _newWidget = [];
  final List<PEntriesM> _newWidget2 = [];
  final List<SundryRow> _newSundry = [];
  final List<Map<String, dynamic>> _allValues = [];
  final List<Map<String, dynamic>> _allValuesSundry = [];
  List<Purchase> fetchedPurchase = [];
  bool isLoading = false;

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
  late Timer _timer;

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

 
 
 
 
 
 
  Future<String?> getNumberOfPurchase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('purchaseLength');
  }

  Future<void> setPurchaseLength() async {
    String? length = await getNumberOfPurchase();
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

  void _startTimer() {
    const Duration duration = Duration(seconds: 2);
    _timer = Timer.periodic(duration, (Timer timer) {
      calculateTotal();
      calculateSundry();
    });
  }

  Future<void> createPurchase() async {
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
    if (selectedStatus == 'Debit') {
      purchaseController.dueAmountController.text =
          (TnetAmount + Ttotal).toString();
    } else {
      purchaseController.dueAmountController.text = '0';
    }
    final purchase = Purchase(
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
      totalamount: TfinalAmt.toStringAsFixed(2),
      roundoffDiff: double.parse(roundOffController.text),
      entries: _allValues.map((entry) {
        return PurchaseEntry(
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
            discount: double.tryParse(entry['discount']) ?? 0);
      }).toList(),
      sundry: _allValuesSundry.map((sundry) {
        return SundryEntry(
          sundryName: sundry['sndryName'] ?? 'ssss',
          amount: double.tryParse(sundry['sundryAmount']) ?? 0,
        );
      }).toList(),
      cashAmount: purchaseController.cashAmountController.text == ''
          ? '0'
          : purchaseController.cashAmountController.text,
      dueAmount: purchaseController.dueAmountController.text == ''
          ? '0'
          : purchaseController.dueAmountController.text,
    );
    await purchaseServices.createPurchase(purchase, context).then((value) {
      clearAll();
      fetchPurchaseEntries().then((_) {
        final newPurchaseEntry =
            fetchedPurchase.firstWhere((element) => element.no == purchase.no,
                orElse: () => Purchase(
                      id: '',
                      companyCode: '',
                      totalamount: '',
                      no: '',
                      date: '',
                      cashAmount: '',
                      dueAmount: '',
                      roundoffDiff: 0.00,
                      date2: '',
                      type: '',
                      ledger: '',
                      place: '',
                      billNumber: '',
                      remarks: '',
                      entries: [],
                      sundry: [],
                    ));
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
                    color: Colors.black),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => PurchasePrintBigReceipt(
                          'Purchase Receipt',
                          purchaseID: newPurchaseEntry.id,
                        ),
                      ),
                    );
                  },
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
                        return const PEMasterBody();
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
      print('Failed to create purchase: $error');
    });
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

      setState(() {
        itemsList = items;
      });
    } catch (error) {
      // ignore: avoid_print
      print('Failed to fetch ledger name: $error');
    }
  }

  Future<void> fetchAndSetTaxRates() async {
    try {
      final List<TaxRate> taxRates = await taxRateService.fetchTaxRates();

      setState(() {
        taxLists = taxRates;
      });
    } catch (error) {
      print('Failed to fetch Tax Rates: $error');
    }
  }

  Future<void> fetchMeasurementLimit() async {
    try {
      final List<MeasurementLimit> measurements =
          await measurementService.fetchMeasurementLimits();

      setState(() {
        measurement = measurements;
      });
    } catch (error) {
      print('Failed to fetch Tax Rates: $error');
    }
  }

  Future<void> fetchLedgers2() async {
    try {
      final List<Ledger> ledger = await ledgerService.fetchLedgers();
      // Add empty data on the 0 index

      setState(() {
        suggestionItems5 = ledger
            .where((element) =>
                element.status == 'Yes' &&
                element.ledgerGroup == '662f97d2a07ec73369c237b0')
            .toList();

        if (suggestionItems5.isNotEmpty) {
          selectedLedgerName =
              suggestionItems5.isNotEmpty ? suggestionItems5.first.id : null;
          ledgerAmount = suggestionItems5.first.debitBalance;
        }
      });
    } catch (error) {
      print('Failed to fetch ledger name: $error');
    }
  }

  
  
  
  
  Future<void> fetchPurchaseEntries() async {
    try {
      final List<Purchase> purchase = await purchaseServices.getPurchase();
      setState(() {
        fetchedPurchase = purchase;
      });

      print('Fetched Purchase: $fetchedPurchase');
    } catch (error) {
      print('Failed to fetch purchase name: $error');
    }
  }

  // Clear all the fields and widgets
  void clearAll() {
    setState(() {
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

      generateBillNumber();
    });
  }

  Future<void> _initializeData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await Future.wait([
        setCompanyCode(),
        setPurchaseLength(),
        fetchPurchaseEntries(),
        fetchLedgers2(),
        fetchItems(),
        fetchAndSetTaxRates(),
        fetchMeasurementLimit(),
        Future.delayed(const Duration(seconds: 1)),
      ]);
      generateBillNumber();
      purchaseController.typeController.text = selectedStatus;
      purchaseController.date2Controller.text =
          formatter.format(DateTime.now());
      purchaseController.dateController.text = formatter.format(DateTime.now());

      for (int i = 0; i < 5; i++) {
        final entryId = UniqueKey().toString();
        setState(() {
          _newWidget.add(
            PEntries(
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
              sellingPriceControllerP:
                  purchaseController.sellingPriceController,
              onSaveValues: saveValues,
              onDelete: (String entryId) {
                setState(
                  () {
                    _newWidget.removeWhere(
                        (widget) => widget.key == ValueKey(entryId));
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
                    calculateTotal();
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
              sellingPriceControllerP:
                  purchaseController.sellingPriceController,
              onSaveValues: saveValues,
              onDelete: (String entryId) {
                setState(
                  () {
                    _newWidget.removeWhere(
                        (widget) => widget.key == ValueKey(entryId));
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
                    calculateTotal();
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
              onSaveValues: saveSundry,
              onDelete: (String entryId) {
                setState(
                  () {
                    _newSundry.removeWhere(
                        (widget) => widget.key == ValueKey(entryId));
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
        });
      }
   
   
   
   
   
   
   
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   if (mounted) {
  //     FocusScope.of(context).requestFocus(noFocusNode);
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    purchaseController.dispose();
    _newSundry.clear();
    _allValues.clear();
    _allValuesSundry.clear();
    _timer.cancel();
    Provider.of<OnChangeItenProvider>(context, listen: false).clear();
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
    roundOffController = TextEditingController();
    roundOffFocusNode = FocusNode();

    roundOffController.text =
        TRoundOff.toStringAsFixed(2); // Initial value from TRoundOff

    roundOffController.addListener(() {
      if (roundOffFocusNode.hasFocus) {
        isManualRoundOffChange = true;
      }
    });

    _startTimer();
  }

  final _formKey = GlobalKey<FormState>();

  void createNewEntry() {
    final entryId = UniqueKey().toString();
    setState(() {
      _newWidget.add(
        PEntries(
          key: ValueKey(entryId),
          entryId: entryId,
          serialNumber: _newWidget.length + 1,
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
                calculateTotal();
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout
          return MobileLayout();
        } else if (constraints.maxWidth < 1200) {
          // Tablet layout
          return TabletLayout();
        } else {
          // Desktop layout
          return DesktopLayout();
        }
      },
    );
  }

  Widget MobileLayout() {
    return Container();
  }

  Widget TabletLayout() {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.escape): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.f2): const NavigateToListIntent(),
        LogicalKeySet(LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyL):
            const NavigateToLedgerIntent(),
        LogicalKeySet(LogicalKeyboardKey.f5): const NavigateToPaymentIntent(),
        LogicalKeySet(LogicalKeyboardKey.f6): const NavigateToReceiptIntent(),
        LogicalKeySet(LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyM):
            const CreateNewItemIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (ActivateIntent intent) {
              Navigator.of(context).pop();
              return KeyEventResult.handled;
            },
          ),
          NavigateToListIntent: CallbackAction<NavigateToListIntent>(
            onInvoke: (NavigateToListIntent intent) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const PEMasterBody(),
                ),
              );
              return KeyEventResult.handled;
            },
          ),
          NavigateToLedgerIntent: CallbackAction<NavigateToLedgerIntent>(
            onInvoke: (NavigateToLedgerIntent intent) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LGMyDesktopBody(),
                ),
              );
              return KeyEventResult.handled;
            },
          ),
          NavigateToPaymentIntent: CallbackAction<NavigateToPaymentIntent>(
            onInvoke: (NavigateToPaymentIntent intent) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const PMMyPaymentDesktopBody(),
                ),
              );
              return KeyEventResult.handled;
            },
          ),
          NavigateToReceiptIntent: CallbackAction<NavigateToReceiptIntent>(
            onInvoke: (NavigateToReceiptIntent intent) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const RVDesktopBody(),
                ),
              );
              return KeyEventResult.handled;
            },
          ),
          CreateNewEntryIntent: CallbackAction<CreateNewEntryIntent>(
            onInvoke: (CreateNewEntryIntent intent) {
              createNewEntry();
              return KeyEventResult.handled;
            },
          ),
          CreateNewItemIntent: CallbackAction<CreateNewItemIntent>(
            onInvoke: (CreateNewItemIntent intent) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const NIMyDesktopBody(),
                ),
              );
              return KeyEventResult.handled;
            },
          ),
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Add this line
              children: [
                PECustomAppBar(
                  title: 'Purchase Entry',
                  width1: 0.40,
                  width2: 0.60,
                  color: const Color(0xFFDAA520),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    purchaseTopText(
                      width: MediaQuery.of(context).size.width * 0.07,
                      text: 'No',
                    ),
                    PETextFieldsNo(
                      // onEditingComplete: () {
                      //   FocusScope.of(context).requestFocus(dateFocusNode1);

                      //   setState(() {});
                      // },
                      // focusNode: noFocusNode,
                      onSaved: (newValue) {
                        purchaseController.noController.text = newValue!;
                      },
                      width: MediaQuery.of(context).size.width * 0.37,
                      height: 40,
                      controller: purchaseController.noController,
                    ),
                    purchaseTopText(
                      width: MediaQuery.of(context).size.width * 0.07,
                      text: 'Date',
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.37,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(0),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 14.0),
                        child: TextFormField(
                          // focusNode: dateFocusNode1,
                          // onEditingComplete: () {
                          //   FocusScope.of(context).requestFocus(typeFocus);

                          //   setState(() {});
                          // },
                          controller: purchaseController.dateController,
                          onSaved: (newValue) {
                            purchaseController.dateController.text = newValue!;
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.035,
                      child: IconButton(
                          onPressed: _presentDatePICKER,
                          icon: const Icon(Icons.calendar_month)),
                    ),
                    const SizedBox(width: 50),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    purchaseTopText(
                      width: MediaQuery.of(context).size.width * 0.07,
                      text: 'Type',
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width * 0.37,
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
                            // FocusScope.of(context).requestFocus(partyFocus);
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
                    purchaseTopText(
                      width: MediaQuery.of(context).size.width * 0.07,
                      text: 'Party',
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width * 0.38,
                      height: 40,
                      padding: const EdgeInsets.all(2.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownMenu<Ledger>(
                          // focusNode: partyFocus,
                          requestFocusOnTap: true,
                          initialSelection: suggestionItems5.isNotEmpty
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
                          selectedTrailingIcon: const SizedBox.shrink(),
                          inputDecorationTheme: const InputDecorationTheme(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            isDense: true,
                            activeIndicatorBorder: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          expandedInsets: EdgeInsets.zero,
                          onSelected: (Ledger? value) {
                            // FocusScope.of(context).requestFocus(placeFocus);
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
                    SizedBox(width: MediaQuery.of(context).size.width * 0.041),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    purchaseTopText(
                      width: MediaQuery.of(context).size.width * 0.07,
                      text: 'Place',
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width * 0.37,
                      height: 40,
                      padding: const EdgeInsets.all(2.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownMenu<String>(
                          // focusNode: placeFocus,

                          requestFocusOnTap: true,

                          initialSelection: indianStates.first,
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
                            // FocusScope.of(context).requestFocus(billFocus);
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
                    purchaseTopText(
                      width: MediaQuery.of(context).size.width * 0.07,
                      text: 'Bill No',
                    ),
                    PETextFields(
                      // onEditingComplete: () {
                      //   FocusScope.of(context).requestFocus(dateFocusNode2);

                      //   setState(() {});
                      // },
                      // focusNode: billFocus,
                      onSaved: (newValue) {
                        purchaseController.billNumberController.text =
                            newValue!;
                      },
                      controller: purchaseController.billNumberController,
                      width: MediaQuery.of(context).size.width * 0.38,
                      height: 40,
                      readOnly: false,
                    ),
                  ],
                ),
                // Table Starts....

                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          TableHeaderText(
                            text: 'Sr',
                            width: MediaQuery.of(context).size.width * 0.030,
                          ),
                          TableHeaderText(
                            text: '   Item Name',
                            width: MediaQuery.of(context).size.width * 0.25,
                          ),
                          TableHeaderText(
                            text: 'Qty',
                            width: MediaQuery.of(context).size.width * 0.071,
                          ),
                          TableHeaderText(
                            text: 'Unit',
                            width: MediaQuery.of(context).size.width * 0.071,
                          ),
                          TableHeaderText(
                            text: 'Rate',
                            width: MediaQuery.of(context).size.width * 0.071,
                          ),
                          TableHeaderText(
                            text: 'Amount',
                            width: MediaQuery.of(context).size.width * 0.071,
                          ),
                          TableHeaderText(
                            text: 'Disc',
                            width: MediaQuery.of(context).size.width * 0.071,
                          ),
                          TableHeaderText(
                            text: 'Tax%',
                            width: MediaQuery.of(context).size.width * 0.071,
                          ),
                          TableHeaderText(
                            text: 'SGST',
                            width: MediaQuery.of(context).size.width * 0.071,
                          ),
                          TableHeaderText(
                            text: 'CGST',
                            width: MediaQuery.of(context).size.width * 0.071,
                          ),
                          TableHeaderText(
                            text: 'IGST',
                            width: MediaQuery.of(context).size.width * 0.071,
                          ),
                          TableHeaderText(
                            text: 'Net Amt.',
                            width: MediaQuery.of(context).size.width * 0.055,
                          ),
                          TableHeaderText(
                            text: 'Selling Amt.',
                            width: MediaQuery.of(context).size.width * 0.055,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: _newWidget2,
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.030,
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
                          width: MediaQuery.of(context).size.width * 0.25,
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
                          width: MediaQuery.of(context).size.width * 0.071,
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
                          width: MediaQuery.of(context).size.width * 0.071,
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
                          width: MediaQuery.of(context).size.width * 0.071,
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
                          width: MediaQuery.of(context).size.width * 0.071,
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
                          width: MediaQuery.of(context).size.width * 0.071,
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
                          width: MediaQuery.of(context).size.width * 0.071,
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
                          width: MediaQuery.of(context).size.width * 0.071,
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
                          width: MediaQuery.of(context).size.width * 0.071,
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
                          width: MediaQuery.of(context).size.width * 0.071,
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
                          width: MediaQuery.of(context).size.width * 0.055,
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
                          width: MediaQuery.of(context).size.width * 0.055,
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
                  ),
                ),

                // Table Ends....
                const SizedBox(height: 10),
                purchaseTopText(
                  width: MediaQuery.of(context).size.width * 0.5,
                  text: 'Remarks',
                ),
                PETextFields(
                  // focusNode: remarksFocus,
                  // onEditingComplete: () {
                  //   // FocusScope.of(
                  //   //         context)
                  //   //     .requestFocus(
                  //   //         typeFocus);

                  //   setState(() {});
                  // },
                  onSaved: (newValue) {
                    purchaseController.remarksController!.text = newValue!;
                  },
                  controller: purchaseController.remarksController,
                  width: MediaQuery.of(context).size.width * 0.93,
                  height: 40,
                ),
                const SizedBox(height: 10),
                // Ledger Information...
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 170,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 30,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Ledger Information',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF4B0082),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Limit',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      const Color(0xFF4B0082),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 2,
                                              height: 30,
                                              color: const Color.fromARGB(
                                                  255, 44, 43, 43),
                                            ),
                                            // Change Ledger Amount
                                            Expanded(
                                              child: Container(
                                                color: const Color(0xFFA0522D),
                                                child: Center(
                                                  child: Text(
                                                    (ledgerAmount +
                                                            (TnetAmount +
                                                                Ttotal))
                                                        .toStringAsFixed(2),
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        // ignore: prefer_const_constructors
                                                        GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 2,
                                              height: 30,
                                              color: const Color.fromARGB(
                                                  255, 44, 43, 43),
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Bal',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      const Color(0xFF4B0082),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 2,
                                              height: 30,
                                              color: const Color.fromARGB(
                                                  255, 44, 43, 43),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: const Color(0xFFA0522D),
                                                child: Center(
                                                  child: Text(
                                                    '0.00 Dr',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                            builder: (context, itemID, _) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.48,
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
                                        decoration: const BoxDecoration(
                                            border: Border(
                                          right: BorderSide(
                                            color: Colors.black,
                                          ),
                                        )),
                                        height: 30,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            backgroundColor:
                                                const Color(0xFFDAA520),
                                          ),
                                          child: Text(
                                            'Statements',
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
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
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF4B0082),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                          left: BorderSide(
                                            color: Colors.black,
                                          ),
                                        )),
                                        height: 30,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            backgroundColor:
                                                const Color(0xFFDAA520),
                                          ),
                                          child: Text(
                                            'Purchase',
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

                                // Table Starts Here
                                Container(
                                  padding: const EdgeInsets.all(4.0),
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
                                      color: Colors.black,
                                    ),
                                  )),
                                  child: Row(
                                    children: List.generate(
                                      headerTitles.length,
                                      (index) => SizedBox(
                                        width: 80,
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          headerTitles[index],
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

                                // Table Body

                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Table(
                                      border: TableBorder.all(
                                          width: 1.0, color: Colors.black),
                                      children: [
                                        // Iterate over all purchases' entries
                                        for (int i = 0;
                                            i < fetchedPurchase.length;
                                            i++)
                                          ...fetchedPurchase[i]
                                              .entries
                                              .where((entry) =>
                                                  entry.itemName ==
                                                  itemID.itemID)
                                              .map((entry) {
                                            // Find the corresponding ledger for the current entry
                                            String ledgerName = '';
                                            if (suggestionItems5.isNotEmpty) {
                                              final ledger =
                                                  suggestionItems5.firstWhere(
                                                (ledger) =>
                                                    ledger.id ==
                                                    fetchedPurchase[i].ledger,
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
                                                  fetchedPurchase[i]
                                                      .date
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  fetchedPurchase[i]
                                                      .billNumber
                                                      .toString(),
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
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 225,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.14,
                          height: 30,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0,
                            child: ElevatedButton(
                              onPressed: createPurchase,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color(0xFFFFFACD),
                                ),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
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
                      width: MediaQuery.of(context).size.width * 0.002,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.14,
                          height: 30,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color(0xFFFFFACD),
                                ),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
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
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.002,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.14,
                          height: 30,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0,
                            child: ElevatedButton(
                              onPressed: clearAll,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color(0xFFFFFACD),
                                ),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
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
                        ),
                      ],
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 20,
                                width: MediaQuery.of(context).size.width * 0.1,
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
                                width: MediaQuery.of(context).size.width * 0.1,
                                decoration: const BoxDecoration(
                                    // border: Border(
                                    //     bottom:
                                    //         BorderSide(width: 1)),
                                    ),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(12.0),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                  ),
                                  controller: roundOffController,
                                  focusNode: roundOffFocusNode,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          signed: true, decimal: true),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF4B0082),
                                  ),
                                  onChanged: (value) {
                                    double newRoundOff =
                                        double.tryParse(value) ?? 0.00;
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
                                width: MediaQuery.of(context).size.width * 0.1,
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
                                width: MediaQuery.of(context).size.width * 0.1,
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
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget DesktopLayout() {
    return FocusScope(
      descendantsAreFocusable: true,
      descendantsAreTraversable: true,
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.escape): const ActivateIntent(),
          LogicalKeySet(LogicalKeyboardKey.f2): const NavigateToListIntent(),
          LogicalKeySet(
                  LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyL):
              const NavigateToLedgerIntent(),
          LogicalKeySet(LogicalKeyboardKey.f5): const NavigateToPaymentIntent(),
          LogicalKeySet(LogicalKeyboardKey.f6): const NavigateToReceiptIntent(),
          LogicalKeySet(
                  LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyM):
              const CreateNewItemIntent(),
          LogicalKeySet(LogicalKeyboardKey.f4): const CreateNewEntryIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (ActivateIntent intent) {
                Navigator.of(context).pop();
                return KeyEventResult.handled;
              },
            ),
            NavigateToListIntent: CallbackAction<NavigateToListIntent>(
              onInvoke: (NavigateToListIntent intent) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const PEMasterBody(),
                  ),
                );
                return KeyEventResult.handled;
              },
            ),
            NavigateToLedgerIntent: CallbackAction<NavigateToLedgerIntent>(
              onInvoke: (NavigateToLedgerIntent intent) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LGMyDesktopBody(),
                  ),
                );
                return KeyEventResult.handled;
              },
            ),
            NavigateToPaymentIntent: CallbackAction<NavigateToPaymentIntent>(
              onInvoke: (NavigateToPaymentIntent intent) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const PMMyPaymentDesktopBody(),
                  ),
                );
                return KeyEventResult.handled;
              },
            ),
            NavigateToReceiptIntent: CallbackAction<NavigateToReceiptIntent>(
              onInvoke: (NavigateToReceiptIntent intent) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const RVDesktopBody(),
                  ),
                );
                return KeyEventResult.handled;
              },
            ),
            CreateNewEntryIntent: CallbackAction<CreateNewEntryIntent>(
              onInvoke: (CreateNewEntryIntent intent) {
                createNewEntry();
                return KeyEventResult.handled;
              },
            ),
            CreateNewItemIntent: CallbackAction<CreateNewItemIntent>(
              onInvoke: (CreateNewItemIntent intent) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const NIMyDesktopBody(),
                  ),
                );
                return KeyEventResult.handled;
              },
            ),
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  PECustomAppBar(
                    width1: 0.18,
                    title: 'Purchase Entry',
                    color: const Color(0xFFDAA520),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          purchaseTopText(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
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
                                              purchaseController.noController
                                                  .text = newValue!;
                                            },
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                            height: 40,
                                            controller:
                                                purchaseController.noController,
                                          ),
                                          purchaseTopText(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06,
                                            text: 'Date',
                                          ),
                                          Flexible(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.075,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
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
                                                    purchaseController
                                                        .dateController
                                                        .text = newValue!;
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        _selectedDate == null
                                                            ? '12/12/2023'
                                                            : formatter.format(
                                                                _selectedDate!),
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.035,
                                            child: IconButton(
                                                onPressed: _presentDatePICKER,
                                                icon: const Icon(
                                                    Icons.calendar_month)),
                                          ),
                                          const SizedBox(width: 50),
                                          purchaseTopText(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06,
                                            text: 'Type',
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                              color: Colors.white,
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
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
                                                trailingIcon:
                                                    const SizedBox.shrink(),
                                                textStyle: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
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
                                                  // FocusScope.of(context)
                                                  //     .requestFocus(partyFocus);
                                                  setState(() {
                                                    selectedStatus = value!;
                                                    purchaseController
                                                        .typeController
                                                        .text = selectedStatus;
                                                    // Set Type
                                                  });
                                                },
                                                dropdownMenuEntries: status.map<
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          purchaseTopText(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06,
                                            text: 'Party',
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                              color: Colors.white,
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.265,
                                            height: 40,
                                            padding: const EdgeInsets.all(2.0),
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
                                                selectedTrailingIcon:
                                                    const SizedBox.shrink(),
                                                inputDecorationTheme:
                                                    const InputDecorationTheme(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 8),
                                                  isDense: true,
                                                  activeIndicatorBorder:
                                                      BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                                expandedInsets: EdgeInsets.zero,
                                                onSelected: (Ledger? value) {
                                                  // FocusScope.of(context)
                                                  //     .requestFocus(placeFocus);
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
                                                          suggestionItems5
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .id ==
                                                                      selectedLedgerName);

                                                      ledgerAmount =
                                                          selectedLedger
                                                              .debitBalance;
                                                    }
                                                  });
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
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.041),
                                          purchaseTopText(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06,
                                            text: 'Place',
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                              color: Colors.white,
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            height: 40,
                                            padding: const EdgeInsets.all(2.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownMenu<String>(
                                                // focusNode: placeFocus,

                                                requestFocusOnTap: true,

                                                initialSelection:
                                                    indianStates.first,
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
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
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
                                                    // color: Colors.black,
                                                  ),
                                                ),
                                                expandedInsets: EdgeInsets.zero,
                                                onSelected: (String? value) {
                                                  // FocusScope.of(context)
                                                  //     .requestFocus(billFocus);
                                                  setState(() {
                                                    selectedState = value;
                                                    purchaseController
                                                        .placeController
                                                        .text = selectedState!;
                                                  });
                                                },
                                                dropdownMenuEntries:
                                                    indianStates.map<
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
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
                                              purchaseController
                                                  .billNumberController
                                                  .text = newValue!;
                                            },
                                            controller: purchaseController
                                                .billNumberController,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.265,
                                            height: 40,
                                            readOnly: false,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.041,
                                          ),
                                          purchaseTopText(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
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
                                                border: Border.all(
                                                    color: Colors.black),
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
                                                    hintText: _pickedDateData ==
                                                            null
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
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
                                    height: MediaQuery.of(context).size.height *
                                        0.02),

                                //table header
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Row(
                                    children: [
                                      TableHeaderText(
                                        text: 'Sr',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.023,
                                      ),
                                      TableHeaderText(
                                        text: '   Item Name',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                      ),
                                      TableHeaderText(
                                        text: 'Qty',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.061,
                                      ),
                                      TableHeaderText(
                                        text: 'Unit',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.061,
                                      ),
                                      TableHeaderText(
                                        text: 'Rate',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.061,
                                      ),
                                      TableHeaderText(
                                        text: 'Amount',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.061,
                                      ),
                                      TableHeaderText(
                                        text: 'Disc',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.061,
                                      ),
                                      TableHeaderText(
                                        text: 'Tax%',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.061,
                                      ),
                                      TableHeaderText(
                                        text: 'SGST',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.061,
                                      ),
                                      TableHeaderText(
                                        text: 'CGST',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.061,
                                      ),
                                      TableHeaderText(
                                        text: 'IGST',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.061,
                                      ),
                                      TableHeaderText(
                                        text: 'Net Amt.',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.055,
                                      ),
                                      TableHeaderText(
                                        text: 'Selling Amt.',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.055,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),

                                isLoading
                                    ? const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 7.0),
                                        child: TableExample(rows: 7, cols: 13))
                                    :
                                    //table body
                                    Column(
                                        children: [
                                          SizedBox(
                                            height: 200,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.055,
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
                                            MediaQuery.of(context).size.width *
                                                0.055,
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
                                    height: MediaQuery.of(context).size.height *
                                        0.04),
                                Column(
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
                                                        purchaseTopText(
                                                          width: MediaQuery.of(
                                                                      context)
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
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.6,
                                                          height: 40,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
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
                                                                            15,
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
                                                                              color: Colors.black,
                                                                              width: 1,
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
                                                                                    fontSize: 15,
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
                                                                                width: 2,
                                                                                height: 30,
                                                                                color: const Color.fromARGB(255, 44, 43, 43),
                                                                              ),
                                                                              Expanded(
                                                                                child: Text(
                                                                                  'Bal',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: GoogleFonts.poppins(
                                                                                    fontSize: 15,
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
                                                          const SizedBox(
                                                              width: 5),
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
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .black,
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
                                                                          decoration: const BoxDecoration(
                                                                              border: Border(
                                                                            right:
                                                                                BorderSide(
                                                                              color: Colors.black,
                                                                            ),
                                                                          )),
                                                                          height:
                                                                              30,
                                                                          child:
                                                                              ElevatedButton(
                                                                            onPressed:
                                                                                () {},
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(0),
                                                                              ),
                                                                              backgroundColor: const Color(0xFFDAA520),
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              'Statements',
                                                                              style: GoogleFonts.poppins(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.white,
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
                                                                        child:
                                                                            Text(
                                                                          'Recent Transaction for the item',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              GoogleFonts.poppins(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                const Color(0xFF4B0082),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 4,
                                                                        child:
                                                                            Container(
                                                                          decoration: const BoxDecoration(
                                                                              border: Border(
                                                                            left:
                                                                                BorderSide(
                                                                              color: Colors.black,
                                                                            ),
                                                                          )),
                                                                          height:
                                                                              30,
                                                                          child:
                                                                              ElevatedButton(
                                                                            onPressed:
                                                                                () {},
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(0),
                                                                              ),
                                                                              backgroundColor: const Color(0xFFDAA520),
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              'Purchase',
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

                                                                  // Table Starts Here
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            4.0),
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
                                                                      top:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    )),
                                                                    child: Row(
                                                                      children:
                                                                          List.generate(
                                                                        headerTitles
                                                                            .length,
                                                                        (index) =>
                                                                            Expanded(
                                                                          child:
                                                                              Text(
                                                                            headerTitles[index],
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              fontSize: 15,
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
                                                                            width:
                                                                                1.0,
                                                                            color:
                                                                                Colors.black),
                                                                        children: [
                                                                          // Iterate over all purchases' entries
                                                                          for (int i = 0;
                                                                              i < fetchedPurchase.length;
                                                                              i++)
                                                                            ...fetchedPurchase[i].entries.where((entry) => entry.itemName == itemID.itemID).map((entry) {
                                                                              // Find the corresponding ledger for the current entry
                                                                              String ledgerName = '';
                                                                              if (suggestionItems5.isNotEmpty) {
                                                                                final ledger = suggestionItems5.firstWhere(
                                                                                  (ledger) => ledger.id == fetchedPurchase[i].ledger,
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
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
                                                  decoration:
                                                      const BoxDecoration(
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
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              header2Titles[
                                                                  index],
                                                              textAlign:
                                                                  TextAlign
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.14,
                                          height: 30,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0,
                                            child: ElevatedButton(
                                              onPressed: createPurchase,
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(
                                                  const Color(0xFFFFFACD),
                                                ),
                                                shape: MaterialStateProperty
                                                    .all<OutlinedBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1.0),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.002,
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.14,
                                          height: 30,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(
                                                  const Color(0xFFFFFACD),
                                                ),
                                                shape: MaterialStateProperty
                                                    .all<OutlinedBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1.0),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.002,
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.14,
                                          height: 30,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0,
                                            child: ElevatedButton(
                                              onPressed: clearAll,
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(
                                                  const Color(0xFFFFFACD),
                                                ),
                                                shape: MaterialStateProperty
                                                    .all<OutlinedBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1.0),
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
                                            MediaQuery.of(context).size.width *
                                                0.20),
                                    // Round off area...
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                                    color:
                                                        const Color(0xFF4B0082),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                                  decoration:
                                                      const InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(12.0),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent),
                                                    ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent),
                                                    ),
                                                  ),
                                                  controller:
                                                      roundOffController,
                                                  focusNode: roundOffFocusNode,
                                                  keyboardType:
                                                      const TextInputType
                                                          .numberWithOptions(
                                                          signed: true,
                                                          decimal: true),
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xFF4B0082),
                                                  ),
                                                  onChanged: (value) {
                                                    double newRoundOff =
                                                        double.tryParse(
                                                                value) ??
                                                            0.00;
                                                    setState(() {
                                                      TRoundOff = newRoundOff;
                                                      TfinalAmt = TnetAmount +
                                                          TRoundOff;
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                                    color:
                                                        const Color(0xFF4B0082),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                                    color:
                                                        const Color(0xFF4B0082),
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
                                      builder: (context) =>
                                          const PEMasterBody(),
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
                                      PEntries(
                                        key: ValueKey(entryId),
                                        serialNumber: _newWidget.length + 1,
                                        itemNameControllerP: purchaseController
                                            .itemNameController,
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
                                        discountControllerP: purchaseController
                                            .discountController,
                                        sgstControllerP:
                                            purchaseController.sgstController,
                                        cgstControllerP:
                                            purchaseController.cgstController,
                                        igstControllerP:
                                            purchaseController.igstController,
                                        netAmountControllerP: purchaseController
                                            .netAmountController,
                                        sellingPriceControllerP:
                                            purchaseController
                                                .sellingPriceController,
                                        onSaveValues: saveValues,
                                        onDelete: (String entryId) {
                                          setState(
                                            () {
                                              _newWidget.removeWhere((widget) =>
                                                  widget.key ==
                                                  ValueKey(entryId));

                                              // Find the map in _allValues that contains the entry with the specified entryId
                                              Map<String, dynamic>?
                                                  entryToRemove;
                                              for (final entry in _allValues) {
                                                if (entry['uniqueKey'] ==
                                                    entryId) {
                                                  entryToRemove = entry;
                                                  break;
                                                }
                                              }

                                              // Remove the map from _allValues if found
                                              if (entryToRemove != null) {
                                                _allValues
                                                    .remove(entryToRemove);
                                              }
                                              calculateTotal();
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
                                      builder: (context) =>
                                          const LGMyDesktopBody(),
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
}

class NavigateToLedgerIntent extends Intent {
  const NavigateToLedgerIntent();
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
