// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:async';

import 'package:billingsphere/data/models/salesEntries/sales_entrires_model.dart';
import 'package:billingsphere/utils/controllers/sales_text_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/item/item_model.dart';
import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/measurementLimit/measurement_limit_model.dart';
import '../../data/models/price/price_category.dart';
import '../../data/models/taxCategory/tax_category_model.dart';
import '../../data/repository/item_repository.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/measurement_limit_repository.dart';
import '../../data/repository/price_category_repository.dart';
import '../../data/repository/sales_enteries_repository.dart';
import '../../data/repository/tax_category_repository.dart';
import '../../utils/controllers/sundry_controller.dart';
import '../Barcode_responsive/barcode_print_desktop_body.dart';
import '../LG_responsive/LG_desktop_body.dart';
import '../NI_responsive.dart/NI_desktopBody.dart';
import '../RA_widgets/RA_D_side_buttons.dart';
import '../SE_common/SE_form_buttons.dart';
import '../SE_common/SE_top_text.dart';
import '../SE_common/SE_top_textfield.dart';
import '../SE_variables/SE_variables.dart';
import '../SE_widgets/SE_desktop_appbar.dart';
import '../SE_widgets/sundry_row_edit.dart';
import '../SE_widgets/table_footer.dart';
import '../SE_widgets/table_header.dart';
import '../SE_widgets/table_row_edit.dart';
import '../searchable_dropdown.dart';
import '../sumit_screen/voucher _entry.dart/voucher_list_widget.dart';
import 'SE_desktop_body.dart';
import 'SE_master.dart';
import 'SE_multimode.dart';
import 'SE_receipt_2.dart';

class SalesEditScreen extends StatefulWidget {
  final SalesEntry salesEntryId;

  const SalesEditScreen({super.key, required this.salesEntryId});

  @override
  State<SalesEditScreen> createState() => _SalesEditScreenState();
}

class _SalesEditScreenState extends State<SalesEditScreen> {
  //date
  DateTime? _selectedDate;
  DateTime? _pickedDateData;
  final formatter = DateFormat.yMd();
  bool isLoading = false;
  //type
  List<String> status = ['CASH', 'DEBIT', 'MULTI MODE'];
  String selectedStatus = 'DEBIT';
  String? selectedItemName;
  String? selectedPriceTypeId;
  List<Item> suggestionItems = [];
  final List<SEEntries> _newWidget = [];
  final List<Map<String, dynamic>> _allValues = [];
  final List<Map<String, dynamic>> _allValuesSundry = [];
  final List<SundryRowEdit> _newSundry = [];
  final Map<String, dynamic> multimodeDetails = {};

  final Map<String, dynamic> moreDetails = {};
  TextEditingController _advpaymentControllerM = TextEditingController();
  TextEditingController _advpaymentdateControllerM = TextEditingController();
  TextEditingController _installmentControllerM = TextEditingController();
  TextEditingController _toteldebitamountControllerM = TextEditingController();

  List<PriceCategory> pricecategory = [];
  List<TaxRate> taxLists = [];
  List<MeasurementLimit> measurement = [];

  void saveMoreDetailsValues() {
    moreDetails['advpayment'] = _advpaymentControllerM.text;
    moreDetails['advpaymentdate'] = _advpaymentdateControllerM.text;
    moreDetails['installment'] = _installmentControllerM.text;
    moreDetails['toteldebitamount'] = _toteldebitamountControllerM.text;

    Navigator.of(context).pop();
  }

  // Sales
  SalesEntry? salesEntry;
  SalesEntryFormController salesEntryFormController =
      SalesEntryFormController();

  ItemsService itemService = ItemsService();
  SundryFormController sundryFormController = SundryFormController();
  SalesEntryService salesEntryService = SalesEntryService();
  PriceCategoryRepository pricetypeService = PriceCategoryRepository();
  TaxRateService taxRateService = TaxRateService();
  MeasurementLimitService measurementService = MeasurementLimitService();

  //place
  String selectedPlaceState = 'Gujarat';
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

  late Timer _timer;

  void _startTimer() {
    const Duration duration = Duration(seconds: 2);
    _timer = Timer.periodic(duration, (Timer timer) {
      calculateTotal();
      calculateSundry();
    });
  }

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
      // ledgerAmount -= (TnetAmount + total);
    }

    setState(() {
      Ttotal = total;
    });

    // Fluttertoast.showToast(
    //   msg: "Values added to list successfully!",
    //   toastLength: Toast.LENGTH_LONG,
    //   gravity: ToastGravity.CENTER_RIGHT,
    //   webPosition: "right",
    //   timeInSecForIosWeb: 1,
    //   backgroundColor: Colors.black,
    //   textColor: Colors.white,
    // );
  }

  //shared prefferance
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

  //ledger
  String? selectedLedgerName;
  List<Ledger> suggestionItems5 = [];
  LedgerService ledgerService = LedgerService();
// fetch ledger
  Future<void> fetchLedgers2() async {
    try {
      final List<Ledger> ledger = await ledgerService.fetchLedgers();

      setState(() {
        suggestionItems5 =
            ledger.where((element) => element.status == 'Yes').toList();

        selectedLedgerName =
            suggestionItems5.isNotEmpty ? suggestionItems5.first.id : null;
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

  Future<void> fetchItem() async {
    try {
      final List<Item> item = await itemService.fetchItems();

      suggestionItems = item;

      selectedItemName =
          suggestionItems.isNotEmpty ? suggestionItems.first.id : null;
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

  Future<void> fetchSalesData() async {
    final sales = widget.salesEntryId;

    setState(() {
      salesEntry = sales;
      salesEntryFormController.noController.text = sales.no.toString();
      salesEntryFormController.dateController1.text = sales.date.toString();
      salesEntryFormController.typeController.text = sales.type.toString();
      salesEntryFormController.dcNoController.text = sales.dcNo.toString();
      salesEntryFormController.dateController2.text = sales.date2.toString();
      salesEntryFormController.placeController.text = sales.place.toString();
      salesEntryFormController.remarkController?.text = sales.remark.toString();
      selectedLedgerName = sales.party;
      selectedStatus = sales.type.toString();

      // Map through new entry and add to _newWidget
      // Iterate over the entries in sales
      for (final entry in sales.entries) {
        TextEditingController stockController = TextEditingController();
        for (Item item in suggestionItems) {
          if (item.id == entry.itemName) {
            stockController.text = item.maximumStock.toString();
          }
        }
        final entryId = UniqueKey().toString();
        TextEditingController itemControllerM =
            TextEditingController(text: entry.itemName);
        TextEditingController qtyControllerM =
            TextEditingController(text: entry.qty.toString());
        TextEditingController rateControllerM =
            TextEditingController(text: entry.baseRate.toString());
        TextEditingController rate2ControllerM =
            TextEditingController(text: entry.rate.toString());
        TextEditingController unitControllerM =
            TextEditingController(text: entry.unit.toString());
        TextEditingController amountControllerM =
            TextEditingController(text: entry.amount.toString());
        TextEditingController taxControllerM =
            TextEditingController(text: entry.tax.toString());
        TextEditingController sgstControllerM =
            TextEditingController(text: entry.sgst.toString());
        TextEditingController cgstControllerM =
            TextEditingController(text: entry.cgst.toString());
        TextEditingController igstControllerM =
            TextEditingController(text: entry.igst.toString());
        TextEditingController netAmountControllerM =
            TextEditingController(text: entry.netAmount.toString());
        TextEditingController discountControllerM =
            TextEditingController(text: entry.discount.toString());
        TextEditingController additionalInfoControllerM =
            TextEditingController(text: entry.additionalInfo.toString());

        // Add values to the list
        _allValues.add({
          'uniqueKey': entryId,
          'itemName': entry.itemName,
          'qty': entry.qty.toString(),
          'rate': entry.rate.toString(),
          'baseRate': entry.baseRate.toString(),
          'unit': entry.unit,
          'amount': entry.amount.toString(),
          'discount': entry.discount.toString(),
          'originaldiscount': entry.originaldiscount.toString(),
          'tax': entry.tax,
          'sgst': entry.sgst.toString(),
          'cgst': entry.cgst.toString(),
          'igst': entry.igst.toString(),
          'netAmount': entry.netAmount.toString(),
          'additionalInfo': entry.additionalInfo.toString(),
        });

        // Add SEEntries widget to the list
        _newWidget.add(
          SEEntries(
            serialNo: _newWidget.length + 1,
            key: ValueKey(entryId),
            itemNameControllerP: itemControllerM,
            qtyControllerP: qtyControllerM,
            rateControllerP: rateControllerM,
            rate2ControllerP: rate2ControllerM,
            unitControllerP: unitControllerM,
            amountControllerP: amountControllerM,
            taxControllerP: taxControllerM,
            sgstControllerP: sgstControllerM,
            cgstControllerP: cgstControllerM,
            igstControllerP: igstControllerM,
            netAmountControllerP: netAmountControllerM,
            discountControllerP: discountControllerM,
            selectedLegerId: sales.party,
            additionalInfoControllerP: additionalInfoControllerM,
            onSaveValues: saveValues,
            itemsList: suggestionItems,
            measurement: measurement,
            taxLists: taxLists,
            onDelete: (String entryId) {
              setState(() {
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
                // Calculate total
                calculateTotal();
              });
            },
            entryId: entryId,
            stockControllerP: stockController,
          ),
        );
      }

// Add blank widgets if less than 5 entries
      while (_newWidget.length < 5) {
        _newWidget.add(
          SEEntries(
            serialNo: _newWidget.length + 1,
            key: ValueKey(UniqueKey().toString()),
            itemNameControllerP: TextEditingController(),
            qtyControllerP: TextEditingController(),
            rateControllerP: TextEditingController(),
            rate2ControllerP: TextEditingController(),
            unitControllerP: TextEditingController(),
            amountControllerP: TextEditingController(),
            taxControllerP: TextEditingController(),
            sgstControllerP: TextEditingController(),
            cgstControllerP: TextEditingController(),
            igstControllerP: TextEditingController(),
            netAmountControllerP: TextEditingController(),
            discountControllerP: TextEditingController(),
            selectedLegerId: sales.party,
            additionalInfoControllerP: TextEditingController(),
            onSaveValues: saveValues,
            itemsList: suggestionItems,
            measurement: measurement,
            taxLists: taxLists,
            onDelete: (String entryId) {
              setState(() {
                _newWidget
                    .removeWhere((widget) => widget.key == ValueKey(entryId));
                // Calculate total
                calculateTotal();
              });
            },
            entryId: UniqueKey().toString(),
            stockControllerP: TextEditingController(),
          ),
        );
      }

      for (final moredetails in sales.moredetails) {
        TextEditingController advpaymentController =
            TextEditingController(text: moredetails.advpayment);
        TextEditingController advpaymentdateController =
            TextEditingController(text: moredetails.advpaymentdate);
        TextEditingController installmentController =
            TextEditingController(text: moredetails.installment);
        TextEditingController toteldebitamountController =
            TextEditingController(text: moredetails.toteldebitamount);

        setState(() {
          _advpaymentControllerM = advpaymentController;
          _advpaymentdateControllerM = advpaymentdateController;
          _installmentControllerM = installmentController;
          _toteldebitamountControllerM = toteldebitamountController;
        });
      }

      // Map through new entry and add to _newSundry
      for (final entry in sales.sundry) {
        final entryId = UniqueKey().toString();
        // Create a controller and add entry data to it
        sundryFormController.sundryController.text = entry.sundryName;
        sundryFormController.amountController.text = entry.amount.toString();

        _allValuesSundry.add({
          'uniqueKey': entryId,
          'sndryName': entry.sundryName,
          'sundryAmount': entry.amount.toString(),
        });

        _newSundry.add(
          SundryRowEdit(
            key: ValueKey(entryId),
            sundryControllerP: sundryFormController.sundryController,
            sundryControllerQ: sundryFormController.amountController,
            onSaveValues: saveSundry,
            entryId: entryId,
            onDelete: (String entryId) {
              setState(() {
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
              });
            },
          ),
        );
      }
    });

    calculateTotal();
    calculateSundry();
  }

  void _initializeData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Future.wait([
        fetchItem(),
        setCompanyCode(),
        fetchLedgers2(),
        fetchAndSetTaxRates(),
        fetchMeasurementLimit(),
        fetchPriceCategoryType(),
      ]);

      await fetchSalesData();
    } catch (e) {
    } finally {}
  }

  void printData() {
    print('No: ${salesEntryFormController.noController.text}');
    print('Date: ${salesEntryFormController.dateController1.text}');
    print('Type: ${salesEntryFormController.typeController.text}');
    print('Party: $selectedLedgerName');
    print('Place: ${salesEntryFormController.placeController.text}');
    print('Bill No: ${salesEntryFormController.dcNoController.text}');
    print('Date2: ${salesEntryFormController.dateController2.text}');
    print('Total Amount: ${(TnetAmount + Ttotal).toString()}');
    print('Remark: ${salesEntryFormController.remarkController?.text}');

    for (final sundry in _allValuesSundry) {
      print('Sundry Name: ${sundry['sndryName']}');
      print('Amount: ${sundry['sundryAmount']}');
    }

    for (final entry in _allValues) {
      print('Item Name: ${entry['itemName']}');
      print('Qty: ${entry['qty']}');
      print('Unit: ${entry['unit']}');
      print('Rate: ${entry['rate']}');
      print('baseRate: ${entry['baseRate']}');
      print('Amount: ${entry['amount']}');
      print('Tax: ${entry['tax']}');
      print('discount: ${entry['discount']}');
      print('originaldiscount: ${entry['originaldiscount']}');
      print('SGST: ${entry['sgst']}');
      print('CGST: ${entry['cgst']}');
      print('IGST: ${entry['igst']}');
      print('Net Amount: ${entry['netAmount']}');
      print('additionalInfo: ${entry['additionalInfo']}');
    }
  }

  Future<void> updateSalesEntry() async {
    try {
      updateDueAmountController();

      SalesEntry updatedSalesEntry = SalesEntry(
        companyCode: companyCode!.first,
        id: widget.salesEntryId.id,
        no: int.parse(salesEntryFormController.noController.text),
        date: salesEntryFormController.dateController1.text,
        type: salesEntryFormController.typeController.text,
        party: selectedLedgerName!,
        place: salesEntryFormController.placeController.text,
        dcNo: salesEntryFormController.dcNoController.text,
        date2: salesEntryFormController.dateController2.text,
        totalamount: TfinalAmt.toStringAsFixed(2),
        remark: salesEntryFormController.remarkController?.text ?? 'No remark',
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
            qty: int.parse(entry['qty']),
            rate: double.parse(entry['rate']),
            baseRate: double.parse(entry['baseRate']),
            unit: entry['unit'],
            amount: double.parse(entry['amount']),
            tax: entry['tax'],
            discount: double.parse(entry['discount']),
            originaldiscount: double.parse(entry['originaldiscount']),
            sgst: double.parse(entry['sgst']),
            cgst: double.parse(entry['cgst']),
            igst: double.parse(entry['igst']),
            netAmount: double.parse(entry['netAmount']),
            additionalInfo: entry['additionalInfo'],
          );
        }).toList(),
        sundry: _allValuesSundry.map((sundry) {
          return Sundry2(
            sundryName: sundry['sndryName'],
            amount: double.parse(sundry['sundryAmount']),
          );
        }).toList(),
        dispatch: [
          Dispatch(
            transAgency: 'Not Applicable',
            docketNo: 'Not Applicable',
            vehicleNo: 'Not Applicable',
            fromStation: 'Not Applicable',
            fromDistrict: 'Not Applicable',
            transMode: 'Not Applicable',
            parcel: 'Not Applicable',
            freight: 'Not Applicable',
            kms: 'Not Applicable',
            toState: 'Not Applicable',
            ewayBill: 'Not Applicable',
            billingAddress: 'Not Applicable',
            shippedTo: 'Not Applicable',
            shippingAddress: 'Not Applicable',
            phoneNo: 'Not Applicable',
            gstNo: 'Not Applicable',
            remarks: 'Not Applicable',
            licenceNo: 'Not Applicable',
            issueState: 'Not Applicable',
            name: 'Not Applicable',
            address: 'Not Applicable ',
          )
        ],
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

      await salesEntryService.updateSalesEntry(updatedSalesEntry, context);
    } catch (e) {
      print("Error $e");
    }
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

  // FocusNode for the textfield
  final FocusNode noFocus = FocusNode();
  final FocusNode dcNoFocus = FocusNode();
  final FocusNode dateFocus = FocusNode();
  final FocusNode typeFocus = FocusNode();
  final FocusNode partyFocus = FocusNode();
  final FocusNode placeFocus = FocusNode();
  final FocusNode dcNoFocus2 = FocusNode();
  final FocusNode dateFocus2 = FocusNode();
  final FocusNode totalAmountFocus = FocusNode();
  final FocusNode cashAmountFocus = FocusNode();
  final FocusNode dueAmountFocus = FocusNode();
  final FocusNode roundOffFocus = FocusNode();
  final FocusNode remarkFocus = FocusNode();
  final FocusNode itemNameFocus = FocusNode();
  final FocusNode qtyFocus = FocusNode();
  final FocusNode rateFocus = FocusNode();
  final FocusNode unitFocus = FocusNode();
  final FocusNode amountFocus = FocusNode();
  final FocusNode discountFocus = FocusNode();
  final FocusNode taxFocus = FocusNode();
  final FocusNode sgstFocus = FocusNode();
  final FocusNode cgstFocus = FocusNode();
  final FocusNode igstFocus = FocusNode();
  final FocusNode netAmountFocus = FocusNode();
  final FocusNode sundryFocus = FocusNode();
  final FocusNode sundryAmountFocus = FocusNode();
  final FocusNode dispatchFocus = FocusNode();
  final FocusNode transAgencyFocus = FocusNode();
  final FocusNode docketNoFocus = FocusNode();
  final FocusNode vehicleNoFocus = FocusNode();
  final FocusNode fromStationFocus = FocusNode();
  final FocusNode fromDistrictFocus = FocusNode();
  final FocusNode transModeFocus = FocusNode();
  final FocusNode parcelFocus = FocusNode();
  final FocusNode freightFocus = FocusNode();
  final FocusNode kmsFocus = FocusNode();
  final FocusNode toStateFocus = FocusNode();
  final FocusNode ewayBillFocus = FocusNode();
  final FocusNode billingAddressFocus = FocusNode();
  final FocusNode shippedToFocus = FocusNode();
  final FocusNode shippingAddressFocus = FocusNode();
  final FocusNode phoneNoFocus = FocusNode();
  final FocusNode gstNoFocus = FocusNode();
  final FocusNode remarksFocus = FocusNode();
  final FocusNode licenceNoFocus = FocusNode();
  final FocusNode issueStateFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final FocusNode addressFocus = FocusNode();
  final FocusNode cashFocus = FocusNode();
  final FocusNode debitFocus = FocusNode();
  final FocusNode adjustedAmountFocus = FocusNode();
  final FocusNode pendingAmountFocus = FocusNode();
  final FocusNode finalAmountFocus = FocusNode();
  final FocusNode advPaymentFocus = FocusNode();
  final FocusNode advPaymentDateFocus = FocusNode();
  final FocusNode installmentFocus = FocusNode();
  final FocusNode totalDebitAmountFocus = FocusNode();

  @override
  void dispose() {
    noFocus.dispose();
    dcNoFocus.dispose();
    dateFocus.dispose();
    typeFocus.dispose();
    partyFocus.dispose();
    placeFocus.dispose();
    dcNoFocus2.dispose();
    dateFocus2.dispose();
    totalAmountFocus.dispose();
    cashAmountFocus.dispose();
    dueAmountFocus.dispose();
    roundOffFocus.dispose();
    remarkFocus.dispose();
    itemNameFocus.dispose();
    qtyFocus.dispose();
    rateFocus.dispose();
    unitFocus.dispose();
    amountFocus.dispose();
    discountFocus.dispose();
    taxFocus.dispose();
    sgstFocus.dispose();
    cgstFocus.dispose();
    igstFocus.dispose();
    netAmountFocus.dispose();
    sundryFocus.dispose();
    sundryAmountFocus.dispose();
    dispatchFocus.dispose();
    transAgencyFocus.dispose();
    docketNoFocus.dispose();
    vehicleNoFocus.dispose();
    fromStationFocus.dispose();
    fromDistrictFocus.dispose();
    transModeFocus.dispose();
    parcelFocus.dispose();
    freightFocus.dispose();
    kmsFocus.dispose();
    toStateFocus.dispose();
    ewayBillFocus.dispose();
    billingAddressFocus.dispose();
    shippedToFocus.dispose();
    shippingAddressFocus.dispose();
    phoneNoFocus.dispose();
    gstNoFocus.dispose();
    remarksFocus.dispose();
    licenceNoFocus.dispose();
    issueStateFocus.dispose();
    nameFocus.dispose();
    addressFocus.dispose();
    cashFocus.dispose();
    debitFocus.dispose();
    adjustedAmountFocus.dispose();
    pendingAmountFocus.dispose();
    finalAmountFocus.dispose();
    advPaymentFocus.dispose();
    advPaymentDateFocus.dispose();
    installmentFocus.dispose();
    totalDebitAmountFocus.dispose();
    moreDetails.clear();
    multimodeDetails.clear();
    salesEntryFormController.dispose();
    sundryFormController.dispose();
    _newSundry.clear();
    _allValues.clear();
    _allValuesSundry.clear();
    _timer.cancel();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
    _startTimer();
    roundOffController = TextEditingController();
    roundOffFocusNode = FocusNode();

    roundOffController.text =
        TRoundOff.toStringAsFixed(2); // Initial value from TRoundOff

    roundOffController.addListener(() {
      if (roundOffFocusNode.hasFocus) {
        isManualRoundOffChange = true;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (mounted) {
      FocusScope.of(context).requestFocus(noFocus);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    SEDesktopAppbar(
                      text1: 'Tax Invoice GST',
                      text2: 'Sales Entry EDIT',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SETopText(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                  height: 40,
                                  text: 'No',
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.width *
                                          0.00),
                                ),
                                SETopTextfield(
                                  // focusNode: noFocus,
                                  controller:
                                      salesEntryFormController.noController,
                                  onSaved: (newValue) {
                                    salesEntryFormController.noController.text =
                                        newValue!;
                                  },
                                  width:
                                      MediaQuery.of(context).size.width * 0.07,
                                  height: 40,
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 16.0),
                                  hintText: '',
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: SETopText(
                                    width: MediaQuery.of(context).size.width *
                                        0.04,
                                    height: 40,
                                    text: 'Date',
                                    padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.width *
                                          0.00,
                                      left: MediaQuery.of(context).size.width *
                                          0.0005,
                                    ),
                                  ),
                                ),
                                SETopTextfield(
                                  // focusNode: dateFocus,
                                  controller:
                                      salesEntryFormController.dateController1,
                                  onSaved: (newValue) {
                                    salesEntryFormController
                                        .dateController1.text = newValue!;
                                  },
                                  width:
                                      MediaQuery.of(context).size.width * 0.09,
                                  height: 40,
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 16.0),
                                  hintText: _selectedDate == null
                                      ? '12/12/2023'
                                      : formatter.format(_selectedDate!),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.03,
                                  child: IconButton(
                                      onPressed: _presentDatePICKER,
                                      icon: const Icon(Icons.calendar_month)),
                                ),
                                SETopText(
                                  width:
                                      MediaQuery.of(context).size.width * 0.04,
                                  height: 40,
                                  text: 'Type',
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.0005,
                                      top: MediaQuery.of(context).size.width *
                                          0.00),
                                ),
                                Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height: 40,
                                  padding: const EdgeInsets.all(2.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownMenu<String>(
                                      requestFocusOnTap: true,

                                      initialSelection: selectedStatus,
                                      enableSearch: true,
                                      // enableFilter: true,
                                      // leadingIcon: const SizedBox.shrink(),
                                      trailingIcon: const SizedBox.shrink(),
                                      textStyle: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
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
                                          color: typeFocus.hasFocus
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      expandedInsets: EdgeInsets.zero,
                                      onSelected: (String? value) {
                                        FocusScope.of(context)
                                            .requestFocus(partyFocus);
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
                                                  fontWeight: FontWeight.bold,
                                                  color: typeFocus.hasFocus
                                                      ? Colors.white
                                                      : Colors.black,
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
                      padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SETopText(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                  height: 30,
                                  text: 'Party',
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.00,
                                      top: MediaQuery.of(context).size.width *
                                          0.00),
                                ),

                                Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  width:
                                      MediaQuery.of(context).size.width * 0.377,
                                  height: 40,
                                  padding: const EdgeInsets.all(2.0),

                                  child: DropdownButtonHideUnderline(
                                    child: DropdownMenu<Ledger>(
                                      requestFocusOnTap: true,
                                      initialSelection:
                                          suggestionItems5.isNotEmpty &&
                                                  selectedLedgerName!.isNotEmpty
                                              ? suggestionItems5.firstWhere(
                                                  (element) =>
                                                      element.id ==
                                                      selectedLedgerName)
                                              : null,
                                      enableSearch: true,
                                      trailingIcon: const SizedBox.shrink(),
                                      textStyle: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.none,
                                      ),
                                      menuHeight: 300,
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
                                      expandedInsets: EdgeInsets.zero,
                                      onSelected: (Ledger? value) {
                                        setState(() {
                                          selectedLedgerName = value!.id;
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

                                  // child: DropdownButtonHideUnderline(
                                  //   child: DropdownButton<String>(
                                  //     value: selectedLedgerName,
                                  //     underline: Container(),
                                  //     onChanged: (String? newValue) {
                                  //       setState(() {
                                  //         selectedLedgerName = newValue;
                                  //       });
                                  //     },
                                  //     items:
                                  //         suggestionItems5.map((Ledger ledger) {
                                  //       return DropdownMenuItem<String>(
                                  //         value: ledger.id,
                                  //         child: Row(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.spaceBetween,
                                  //           children: [
                                  //             Text(ledger.name),
                                  //           ],
                                  //         ),
                                  //       );
                                  //     }).toList(),
                                  //   ),
                                  // ),
                                ),

                                SETopText(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                  height: 30,
                                  text: 'Place',
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.01,
                                      right: MediaQuery.of(context).size.width *
                                          0.00,
                                      top: MediaQuery.of(context).size.width *
                                          0.00),
                                ),
                                // Custom Textfield

                                Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  width:
                                      MediaQuery.of(context).size.width * 0.14,
                                  height: 40,
                                  padding: const EdgeInsets.all(2.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownMenu<String>(
                                      focusNode: placeFocus,
                                      requestFocusOnTap: true,
                                      initialSelection: selectedPlaceState,
                                      enableSearch: true,
                                      // enableFilter: true,
                                      // leadingIcon: const SizedBox.shrink(),
                                      trailingIcon: const SizedBox.shrink(),
                                      textStyle: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: placeFocus.hasFocus
                                            ? Colors.white
                                            : Colors.black,
                                        decoration: TextDecoration.none,
                                      ),
                                      menuHeight: 300,
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
                                        setState(() {
                                          selectedPlaceState = value!;
                                          salesEntryFormController
                                              .placeController
                                              .text = selectedPlaceState;
                                          // Set Type
                                        });
                                      },
                                      dropdownMenuEntries: placestate
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
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ));
                                      }).toList(),
                                    ),
                                  ),

                                  // child: DropdownButtonHideUnderline(
                                  //   child: DropdownButton<String>(
                                  //     menuMaxHeight: 300,
                                  //     isExpanded: true,
                                  //     value: selectedPlaceState,
                                  //     underline: Container(),
                                  //     onChanged: (String? newValue) {
                                  //       setState(() {
                                  //         selectedPlaceState = newValue!;
                                  //         salesEntryFormController.placeController
                                  //             .text = selectedPlaceState;
                                  //       });
                                  //     },
                                  //     items: placestate.map((String value) {
                                  //       return DropdownMenuItem<String>(
                                  //         value: value,
                                  //         child: Padding(
                                  //           padding: const EdgeInsets.all(2.0),
                                  //           child: Text(value),
                                  //         ),
                                  //       );
                                  //     }).toList(),
                                  //   ),
                                  // ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SETopText(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                  height: 30,
                                  text: 'Bill No',
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.00,
                                      top: MediaQuery.of(context).size.width *
                                          0.00),
                                ),
                                SETopTextfield(
                                  // focusNode: dcNoFocus,
                                  controller:
                                      salesEntryFormController.dcNoController,
                                  onSaved: (newValue) {
                                    salesEntryFormController
                                        .dcNoController.text = newValue!;
                                  },
                                  width:
                                      MediaQuery.of(context).size.width * 0.248,
                                  height: 40,
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 16.0),
                                  hintText: '',
                                ),
                                const SizedBox(width: 20),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: SETopText(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    height: 30,
                                    text: 'Date',
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.0005,
                                        top: MediaQuery.of(context).size.width *
                                            0.00),
                                  ),
                                ),
                                SETopTextfield(
                                  // focusNode: dateFocus2,
                                  controller:
                                      salesEntryFormController.dateController2,
                                  onSaved: (newValue) {
                                    salesEntryFormController
                                        .dateController2.text = newValue!;
                                  },
                                  width:
                                      MediaQuery.of(context).size.width * 0.09,
                                  height: 40,
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 16.0),
                                  hintText: _pickedDateData == null
                                      ? '12/12/2023'
                                      : formatter.format(_pickedDateData!),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.03,
                                  child: IconButton(
                                      onPressed: _showDataPICKER,
                                      icon: const Icon(Icons.calendar_month)),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SEFormButton(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
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
                                                  backgroundColor:
                                                      const Color(0xFF4169E1),
                                                  automaticallyImplyLeading:
                                                      false,
                                                  centerTitle: true,
                                                  title: Text(
                                                    'More Details',
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                body: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 200,
                                                            child: Text(
                                                              '1. ADVANCE PAYMENT',
                                                              style: GoogleFonts.poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      109,
                                                                      17,
                                                                      189)),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child: Container(
                                                              width: 400,
                                                              height: 30,
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
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0,
                                                                        bottom:
                                                                            16.0),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _advpaymentControllerM,
                                                                  onSaved:
                                                                      (newValue) {
                                                                    _advpaymentControllerM
                                                                            .text =
                                                                        newValue!;
                                                                  },
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        17,
                                                                    height: 1,
                                                                  ),
                                                                  decoration:
                                                                      const InputDecoration(
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
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 200,
                                                            child: Text(
                                                              '2. ADVANCE PAYMENT DATE',
                                                              style: GoogleFonts.poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      109,
                                                                      17,
                                                                      189)),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child: Container(
                                                              width: 400,
                                                              height: 30,
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
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0,
                                                                        bottom:
                                                                            16.0),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _advpaymentdateControllerM,
                                                                  onSaved:
                                                                      (newValue) {
                                                                    _advpaymentdateControllerM
                                                                            .text =
                                                                        newValue!;
                                                                  },
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        17,
                                                                    height: 1,
                                                                  ),
                                                                  decoration:
                                                                      const InputDecoration(
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
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 200,
                                                            child: Text(
                                                              '3. INSTALLMENT',
                                                              style: GoogleFonts.poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      109,
                                                                      17,
                                                                      189)),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child: Container(
                                                              width: 400,
                                                              height: 30,
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
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0,
                                                                        bottom:
                                                                            16.0),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _installmentControllerM,
                                                                  onSaved:
                                                                      (newValue) {
                                                                    _installmentControllerM
                                                                            .text =
                                                                        newValue!;
                                                                  },
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        17,
                                                                    height: 1,
                                                                  ),
                                                                  decoration:
                                                                      const InputDecoration(
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
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 200,
                                                            child: Text(
                                                              '4. TOTAL DEBIT AMOUNT',
                                                              style: GoogleFonts.poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      109,
                                                                      17,
                                                                      189)),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child: Container(
                                                              width: 400,
                                                              height: 30,
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
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0,
                                                                        bottom:
                                                                            16.0),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _toteldebitamountControllerM,
                                                                  onSaved:
                                                                      (newValue) {
                                                                    _toteldebitamountControllerM
                                                                            .text =
                                                                        newValue!;
                                                                  },
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        17,
                                                                    height: 1,
                                                                  ),
                                                                  decoration:
                                                                      const InputDecoration(
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
                                                    ),
                                                    const SizedBox(height: 50),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SEFormButton(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                          height: 30,
                                                          onPressed:
                                                              saveMoreDetailsValues,
                                                          buttonText: 'Save',
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        SEFormButton(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                          height: 30,
                                                          onPressed: () {
                                                            moreDetails.clear();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
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
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    isLoading
                        ? const TableExample(rows: 7, cols: 13)
                        : Column(
                            children: [
                              const NotaTable(),
                              SizedBox(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Column(
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
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.06,
                                                child: Text(
                                                  'Remarks',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xFF4B0082),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            bottom: 16.0),
                                                    child: TextFormField(
                                                      controller:
                                                          salesEntryFormController
                                                              .remarkController,
                                                      onSaved: (newValue) {
                                                        salesEntryFormController
                                                            .remarkController!
                                                            .text = newValue!;
                                                      },
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            remarkFocus.hasFocus
                                                                ? Colors.white
                                                                : Colors.black,
                                                      ),
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
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
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.22,
                                height: 210,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 44, 43, 43),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    // Header
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: Row(
                                        children: List.generate(
                                          header2Titles.length,
                                          (index) => Expanded(
                                            child: Text(
                                              header2Titles[index],
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF4B0082),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 120,
                                      width: MediaQuery.of(context).size.width,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: _newSundry,
                                        ),
                                      ),
                                    ),

                                    // Padding(
                                    //   padding: const EdgeInsets.only(
                                    //       right: 18.0, bottom: 8.0),
                                    //   child: Row(
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.end,
                                    //     mainAxisAlignment: MainAxisAlignment.end,
                                    //     children: [
                                    //       Container(
                                    //         width: 100,
                                    //         height: 25,
                                    //         decoration: BoxDecoration(
                                    //           border:
                                    //               Border.all(color: Colors.black),
                                    //         ),
                                    //         child: InkWell(
                                    //           onTap: calculateSundry,
                                    //           child: const Text(
                                    //             'Save All',
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
                                    //       Container(
                                    //         width: 100,
                                    //         height: 25,
                                    //         decoration: BoxDecoration(
                                    //           border:
                                    //               Border.all(color: Colors.black),
                                    //         ),
                                    //         child: InkWell(
                                    //           onTap: () {
                                    //             final entryId =
                                    //                 UniqueKey().toString();

                                    //             setState(() {
                                    //               _newSundry.add(
                                    //                 SundryRowEdit(
                                    //                     key: ValueKey(entryId),
                                    //                     sundryControllerP:
                                    //                         sundryFormController
                                    //                             .sundryController,
                                    //                     sundryControllerQ:
                                    //                         sundryFormController
                                    //                             .amountController,
                                    //                     onSaveValues: saveSundry,
                                    //                     entryId: entryId,
                                    //                     onDelete:
                                    //                         (String entryId) {
                                    //                       setState(() {
                                    //                         _newSundry.removeWhere(
                                    //                             (widget) =>
                                    //                                 widget.key ==
                                    //                                 ValueKey(
                                    //                                     entryId));

                                    //                         Map<String, dynamic>?
                                    //                             entryToRemove;
                                    //                         for (final entry
                                    //                             in _allValuesSundry) {
                                    //                           if (entry[
                                    //                                   'uniqueKey'] ==
                                    //                               entryId) {
                                    //                             entryToRemove =
                                    //                                 entry;
                                    //                             break;
                                    //                           }
                                    //                         }

                                    //                         // Remove the map from _allValues if found
                                    //                         if (entryToRemove !=
                                    //                             null) {
                                    //                           _allValuesSundry
                                    //                               .remove(
                                    //                                   entryToRemove);
                                    //                         }
                                    //                         calculateSundry();
                                    //                       });
                                    //                     }),
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
                              width: MediaQuery.of(context).size.width * 0.14,
                              height: 30,
                              // onPressed: updateSalesEntry,
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
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        content: Text(
                                          'Please select a ledger!',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
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
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        content: Text(
                                          'Please add an item!',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
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
                                } else if (selectedStatus == 'MULTI MODE') {
                                  // Show the multi-mode details dialog
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        contentPadding: EdgeInsets.zero,
                                        content: SizedBox(
                                          width: 700,
                                          height: 700,
                                          child: PoPUP(
                                            multimodeDetails: multimodeDetails,
                                            onSaveData: updateSalesEntry,
                                            totalAmount: TnetAmount + Ttotal,
                                            listWidget: Expanded(
                                              child: ListView.builder(
                                                itemCount: _allValues.length,
                                                itemBuilder: (context, index) {
                                                  Map<String, dynamic> e =
                                                      _allValues[index];
                                                  return Row(
                                                    children: [
                                                      Container(
                                                        width: 145,
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Text(
                                                            suggestionItems
                                                                .firstWhere((item) =>
                                                                    item.id ==
                                                                    e['itemName'])
                                                                .itemName,
                                                            style:
                                                                const TextStyle(
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
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Text(
                                                            '${e['netAmount']}',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        18),
                                                            textAlign:
                                                                TextAlign.end,
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
                                  // Unfocus all nodes using FocusScope
                                  FocusScope.of(context).unfocus();
                                  // Proceed with creating sales entry
                                  updateSalesEntry();
                                }
                              },

                              buttonText: 'Update',
                            )
                          ],
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.002),
                        Column(
                          children: [
                            SEFormButton(
                              width: MediaQuery.of(context).size.width * 0.14,
                              height: 30,
                              onPressed: () {
                                // openDialog(context);
                              },
                              buttonText: 'Dispatch',
                            )
                          ],
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.002),
                        Column(
                          children: [
                            SEFormButton(
                              width: MediaQuery.of(context).size.width * 0.14,
                              height: 30,
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => const SEHomePage(),
                                //   ),
                                // );
                              },
                              buttonText: 'Cancel',
                            )
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.002,
                        ),
                        Column(
                          children: [
                            SEFormButton(
                              width: MediaQuery.of(context).size.width * 0.14,
                              height: 30,
                              onPressed: () {},
                              buttonText: 'Delete',
                            )
                          ],
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15),
                        Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 20,
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 20,
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(12.0),
                                      ),
                                      controller: roundOffController,
                                      focusNode: roundOffFocusNode,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              signed: true, decimal: true),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: roundOffFocusNode.hasFocus
                                            ? Colors.white
                                            : Colors.black,
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
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: Text(
                                      'Net Amount: ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(width: 2))),
                                    child: Text(
                                      TfinalAmt.toStringAsFixed(2),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: netAmountFocus.hasFocus
                                            ? Colors.white
                                            : Colors.black,
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
              Shortcuts(
                shortcuts: {
                  LogicalKeySet(LogicalKeyboardKey.f3): const ActivateIntent(),
                  LogicalKeySet(LogicalKeyboardKey.f4): const ActivateIntent(),
                },
                child: Focus(
                  autofocus: true,
                  onKey: (node, event) {
                    if (event is RawKeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.f2) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SalesHome(
                            item: suggestionItems,
                          ),
                        ),
                      );
                      return KeyEventResult.handled;
                    } else if (event is RawKeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.keyB) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const BarcodePrintD(),
                        ),
                      );
                    } else if (event is RawKeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.keyM) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const NIMyDesktopBody(),
                        ),
                      );
                    } else if (event is RawKeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.keyL) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LGMyDesktopBody(),
                        ),
                      );
                    } else if (event is RawKeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.keyP) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrintBigReceipt(
                            sales: widget.salesEntryId,
                            ledger: suggestionItems5.firstWhere(
                                (item) => item.id == selectedLedgerName),
                            'Print Sales Receipt',
                          ),
                        ),
                      );
                    } else if (event is RawKeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.keyA) {
                      final entryId = UniqueKey().toString();
                      TextEditingController itemNameController =
                          TextEditingController();
                      TextEditingController qtyController =
                          TextEditingController();
                      TextEditingController rateController =
                          TextEditingController();
                      TextEditingController rate2Controller =
                          TextEditingController();
                      TextEditingController unitController =
                          TextEditingController();
                      TextEditingController amountController =
                          TextEditingController();
                      TextEditingController taxController =
                          TextEditingController();
                      TextEditingController sgstController =
                          TextEditingController();
                      TextEditingController cgstController =
                          TextEditingController();
                      TextEditingController igstController =
                          TextEditingController();
                      TextEditingController netAmountController =
                          TextEditingController();
                      TextEditingController stockController =
                          TextEditingController();
                      TextEditingController discountController =
                          TextEditingController();
                      TextEditingController additionalInfoController =
                          TextEditingController();
                      setState(() {
                        _newWidget.add(SEEntries(
                          serialNo: _newWidget.length + 1,
                          key: ValueKey(entryId),
                          itemNameControllerP: itemNameController,
                          qtyControllerP: qtyController,
                          rateControllerP: rateController,
                          rate2ControllerP: rate2Controller,
                          unitControllerP: unitController,
                          amountControllerP: amountController,
                          taxControllerP: taxController,
                          sgstControllerP: sgstController,
                          cgstControllerP: cgstController,
                          igstControllerP: igstController,
                          netAmountControllerP: netAmountController,
                          discountControllerP: discountController,
                          selectedLegerId: selectedLedgerName!,
                          additionalInfoControllerP: additionalInfoController,
                          onSaveValues: saveValues,
                          onDelete: (String entryId) {
                            setState(() {
                              _newWidget.removeWhere(
                                  (widget) => widget.key == ValueKey(entryId));
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
                          stockControllerP: stockController,
                        ));
                      });
                    }
                    return KeyEventResult.ignored;
                  },
                  child: SizedBox(
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
                                  item: suggestionItems,
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
                        CustomList(
                            Skey: "P",
                            name: "Print",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PrintBigReceipt(
                                    sales: widget.salesEntryId,
                                    ledger: suggestionItems5.firstWhere(
                                        (item) =>
                                            item.id == selectedLedgerName),
                                    'Print Sales Receipt',
                                  ),
                                ),
                              );
                            }),
                        CustomList(
                          Skey: "A",
                          name: "Add",
                          onTap: () {
                            final entryId = UniqueKey().toString();
                            TextEditingController itemNameController =
                                TextEditingController();
                            TextEditingController qtyController =
                                TextEditingController();
                            TextEditingController rateController =
                                TextEditingController();
                            TextEditingController rate2Controller =
                                TextEditingController();
                            TextEditingController unitController =
                                TextEditingController();
                            TextEditingController amountController =
                                TextEditingController();
                            TextEditingController taxController =
                                TextEditingController();
                            TextEditingController sgstController =
                                TextEditingController();
                            TextEditingController cgstController =
                                TextEditingController();
                            TextEditingController igstController =
                                TextEditingController();
                            TextEditingController netAmountController =
                                TextEditingController();
                            TextEditingController stockController =
                                TextEditingController();
                            TextEditingController discountController =
                                TextEditingController();
                            TextEditingController additionalInfoController =
                                TextEditingController();

                            setState(() {
                              _newWidget.add(SEEntries(
                                serialNo: _newWidget.length + 1,
                                key: ValueKey(entryId),
                                itemNameControllerP: itemNameController,
                                qtyControllerP: qtyController,
                                rateControllerP: rateController,
                                rate2ControllerP: rate2Controller,
                                unitControllerP: unitController,
                                amountControllerP: amountController,
                                taxControllerP: taxController,
                                sgstControllerP: sgstController,
                                cgstControllerP: cgstController,
                                igstControllerP: igstController,
                                netAmountControllerP: netAmountController,
                                discountControllerP: discountController,
                                selectedLegerId: selectedLedgerName!,
                                additionalInfoControllerP:
                                    additionalInfoController,
                                onSaveValues: saveValues,
                                onDelete: (String entryId) {
                                  setState(() {
                                    _newWidget.removeWhere((widget) =>
                                        widget.key == ValueKey(entryId));
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
                                stockControllerP: stockController,
                              ));
                            });
                          },
                        ),
                        CustomList(
                            Skey: "F5", name: "Change Type", onTap: () {}),
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
                        CustomList(
                            Skey: "F12", name: "Audit Trail", onTap: () {}),
                        CustomList(
                            Skey: "PgUp", name: "Previous", onTap: () {}),
                        CustomList(Skey: "PgDn", name: "Next", onTap: () {}),
                        CustomList(Skey: "", name: "", onTap: () {}),
                        CustomList(
                            Skey: "G", name: "Attach. Img", onTap: () {}),
                        CustomList(Skey: "", name: "", onTap: () {}),
                        CustomList(Skey: "G", name: "Vch Setup", onTap: () {}),
                        CustomList(
                            Skey: "T", name: "Print Setup", onTap: () {}),
                        CustomList(Skey: "", name: "", onTap: () {}),
                      ],
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
