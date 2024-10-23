import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:billingsphere/data/models/salesPos/sales_pos_model.dart';
import 'package:billingsphere/utils/constant.dart';
import 'package:billingsphere/views/SE_responsive/SE_Multimode_POS.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../data/models/customer/new_customer_model.dart';
import '../../data/models/item/item_model.dart';
import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/measurementLimit/measurement_limit_model.dart';
import '../../data/models/salesMan/sales_man_model.dart';
import '../../data/models/taxCategory/tax_category_model.dart';
import '../../data/repository/barcode_repository.dart';
import '../../data/repository/item_repository.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/measurement_limit_repository.dart';
import '../../data/repository/new_customer_repository.dart';
import '../../data/repository/sales_man_repository.dart';
import '../../data/repository/sales_pos_repository.dart';
import '../../data/repository/tax_category_repository.dart';
import '../CUSTOMERS/new_customer_desktop.dart';
import '../SALESMAN/sales_man_desktopbody.dart';
import '../SE_common/SE_top_text.dart';
import '../SE_common/SE_top_textfield.dart';
import '../SE_widgets/SE_desktop_appbar.dart';
import 'SE_desktop_body_POS.dart';
import 'SE_master_POS.dart';

class SalesPosEditScreen extends StatefulWidget {
  const SalesPosEditScreen({super.key, required this.salesPos});

  final SalesPos salesPos;

  @override
  State<SalesPosEditScreen> createState() => _SalesPosEditScreenState();
}

class _SalesPosEditScreenState extends State<SalesPosEditScreen> {
  Timer? _debounce;

  late AudioCache _audioCache;

  final AudioPlayer _audioPlayer = AudioPlayer();

  String selectedState = 'Gujarat';
  String? selectedItemId;
  String? selectedItemName;

  UniqueKey tableKey = UniqueKey();
  int? selectedRowIndex;
  int myIndex = 0;
  bool isLoading = false;
  bool isDeleting = false;

  // Lists of data
  List<Item> itemList = [];
  List<Item> rowItems = [];

  List<TaxRate> taxLists = [];
  late List<TableRow> tables = [];
  late List<TableRow> Ctables = [];
  late List<TableRow> Ctables2 = [];
  List<String>? companyCode;
  List<SalesPos> salesPosList = [];
  List<SalesMan> salesManList = [];
  List<Ledger> ledgerList = [];
  List<Map<String, dynamic>> values = [];
  List<MeasurementLimit> measurement = [];
  List<NewCustomerModel> customerList = [];
  final Map<String, dynamic> multimodeDetails = {};

  // Services/Repositories
  ItemsService itemsService = ItemsService();

  TaxRateService taxRateService = TaxRateService();
  MeasurementLimitService measurementService = MeasurementLimitService();
  BarcodeRepository barcodeService = BarcodeRepository();
  SalesPosRepository salesPosRepository = SalesPosRepository();
  LedgerService ledgerService = LedgerService();
  NewCustomerRepository newCustomerRepository = NewCustomerRepository();
  SalesManRepository salesManRepository = SalesManRepository();

  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _discPerController = TextEditingController();
  final TextEditingController _discRsController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  final TextEditingController _netAmountController = TextEditingController();
  final TextEditingController _basicController = TextEditingController();
  final TextEditingController _noController = TextEditingController();
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _acController = TextEditingController();

  final TextEditingController _pointController = TextEditingController();
  final TextEditingController _batchNoController = TextEditingController();
  final TextEditingController _baseController = TextEditingController();
  final TextEditingController _mrpController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  TextEditingController _controller = TextEditingController();
  late TextEditingController _controller2;

  final TextEditingController _billedToController = TextEditingController();
  final TextEditingController? _remarkController = TextEditingController();
  final TextEditingController _advanceController =
      TextEditingController(text: '0.00');
  final TextEditingController _pointBalanceController =
      TextEditingController(text: '0.00');
  final TextEditingController _redeemPointController =
      TextEditingController(text: '0.00');
  final TextEditingController _additionController =
      TextEditingController(text: "0.00");
  final TextEditingController _lessController =
      TextEditingController(text: "0.00");
  final TextEditingController _roundOffController =
      TextEditingController(text: "0.00");
  final TextEditingController dataText = TextEditingController();

  double overralTotal = 0.00;
  String _discountType = "Fixed Percentage";

  final TextEditingController _basicAmountController = TextEditingController();
  final TextEditingController _discountPer =
      TextEditingController(text: "0.00");
  final TextEditingController _discountAmt =
      TextEditingController(text: "0.00");
  final TextEditingController _receivable = TextEditingController(text: "0.00");

  final TextEditingController _netTotalDiscController = TextEditingController();

  // FocusNode
  final FocusNode _salesManFocusMode = FocusNode();
  final FocusNode _focusNode = FocusNode();
  FocusNode itemFocus = FocusNode();
  FocusNode qtyFocus = FocusNode();
  FocusNode unitFocus = FocusNode();
  FocusNode rateFocus = FocusNode();
  FocusNode discPerFocus = FocusNode();
  FocusNode discRsFocus = FocusNode();
  FocusNode taxFocus = FocusNode();
  FocusNode netAmountFocus = FocusNode();
  FocusNode amountFocus = FocusNode();
  FocusNode perFocus = FocusNode();
  FocusNode noFocus = FocusNode();
  FocusNode dateFocus = FocusNode();
  FocusNode billedToFocus = FocusNode();
  FocusNode remarkFocus = FocusNode();
  FocusNode advanceFocus = FocusNode();
  FocusNode additionFocus = FocusNode();
  FocusNode lessFocus = FocusNode();
  FocusNode roundOffFocus = FocusNode();
  FocusNode netTotalFocus = FocusNode();
  FocusNode redeemPoints = FocusNode();
  FocusNode pointBalance = FocusNode();

  // Dropdown Select
  String? selectedAC;
  String? selectedCustomer;
  String selecteSetDiscount = 'No';
  String selectedType = "Cash";
  String? selectedSalesMan;

  void _playBeep() async {
    try {
      await _audioPlayer.play(AssetSource('beep.mp3'));
    } catch (e) {
      print('Error playing beep sound: $e');
    }
  }

  void _initializeData() async {
    try {
      await Future.wait([
        fetchItems(),
        fetchAllSalesMan(),
        fetchAllLedgers(),
        fetchAllCustomers(),
        fetchAndSetTaxRates(),
        fetchMeasurementLimit(),
        fetchAllPOS(),
        setCompanyCode(),
      ]);

      await setDataAfterAfterwards();
    } catch (e) {
      print('Error initializing data: $e');
    } finally {
      print("Table Length: ${tables.length}");
    }
  }

  void clearScreen() {
    setState(() {
      _controller.text = DateFormat('MM/dd/yyyy').format(DateTime.now());
      selectedState = 'Gujarat';
      selectedItemId = null;
      selectedItemName = null;
      _qtyController.text = '';
      _unitController.text = '';
      _rateController.text = '';
      _discPerController.text = '';
      _discRsController.text = '';
      _taxController.text = '';
      _netAmountController.text = '';
      _noController.text = '';
      _customerController.text = '';
      _remarkController?.text = '';
      _additionController.text = '0.00';
      _lessController.text = '0.00';
      _roundOffController.text = '0.00';
      _netTotalDiscController.text = '0.00';
      values.clear();
      tables.clear();
    });
  }

  Future<void> updatePOSEntry() async {
    setState(() {
      isLoading = true;
    });

    try {
      print('Selected AC: $selectedAC');
      print('Advance: ${_advanceController.text}');
      print('Addition: ${_additionController.text}');
      print('Less: ${_lessController.text}');
      print('Round Off: ${_roundOffController.text}');
      print('Set Discount: $selecteSetDiscount');
      print('Type: $selectedType');
      print('Company Code: ${companyCode![0]}');
      print('Date: ${_controller.text}');
      print('No: ${_noController.text}');
      print('Place: $selectedState');
      print('Customer: ${selectedCustomer}');
      print('Billed To: $selectedState');
      print('Remarks: ${_remarkController?.text ?? 'No Remarks'}');
      print('Total Amount: ${_netTotalDiscController.text}');
      print('Entries:');
      values.forEach((value) {
        print('Item Name: ${value['itemName']}');
        print('Qty: ${value['qty']}');
        print('Rate: ${value['rate']}');
        print('Unit: ${value['unit']}');
        print('Basic: ${value['basic']}');
        print('Discount Rs: ${value['discRs']}');
        print('Discount %: ${value['discPer']}');
        print('Tax: ${value['tax']}');
        print('Net Amount: ${value['netAmount']}');
      });

      print('Multimode Details: $multimodeDetails');

      final salesPos = SalesPos(
        id: widget.salesPos.id,
        ac: selectedAC!,
        advance: double.parse(_advanceController.text),
        addition: double.parse(_additionController.text),
        less: double.parse(_lessController.text),
        roundOff: double.parse(_roundOffController.text),
        setDiscount: selecteSetDiscount,
        type: selectedType,
        noc: 'N/A',
        companyCode: companyCode![0],
        date: _controller.text,
        no: int.parse(_noController.text),
        place: selectedState,
        entries: values.map((value) {
          return POSEntry(
            itemName: value['itemName'],
            qty: int.parse(value['qty']),
            rate: double.parse(value['rate']),
            unit: value['unit'],
            basic: double.parse(value['basic']),
            dis: double.parse(value['discRs']),
            disc: double.parse(value['discPer']),
            tax: double.parse(value['tax']),
            netAmount: double.parse(value['netAmount']),
            amount: double.parse(value['amount']),
            base: double.parse(value['base']),
            mrp: double.parse(value['mrp']),
          );
        }).toList(),
        multimode: multimodeDetails.isNotEmpty
            ? [
                Multimode(
                  cash: multimodeDetails['cash'] ?? 0.0,
                  debit: multimodeDetails['debit'] ?? 0.0,
                  adjustedAmount: multimodeDetails['adjustedamount'] ?? 0.0,
                  pending: multimodeDetails['pendingAmount'] ?? 0.0,
                  finalAmount: multimodeDetails['finalAmount'] ?? 0.0,
                ),
              ]
            : [],
        customer: selectedCustomer!,
        billedTo: _billedToController.text,
        remarks: _remarkController?.text ?? 'No Remarks',
        totalAmount: double.parse(_netTotalDiscController.text),
        createdAt: widget.salesPos.createdAt,
        updatedAt: DateTime.now().toString(),
      );

      await restorePreviousState();
      await salesPosRepository.updatePosEntry(salesPos);

      if (selectedType == 'Credit') {
        Ledger? ledger = await ledgerService.fetchLedgerById(selectedAC!);
        ledger!.debitBalance += double.parse(_netTotalDiscController.text);
        ledgerService.updateLedger2(
          ledger,
        );
      } else if (selectedType == 'Multimode') {
        Ledger? ledger = await ledgerService.fetchLedgerById(selectedAC!);
        ledger!.debitBalance += multimodeDetails['debit'];
        ledgerService.updateLedger2(
          ledger,
        );
      }
      Fluttertoast.showToast(
        msg: 'POS Entry updated successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        timeInSecForIosWeb: 3,
      );
    } catch (e) {
      print('Failed to update POS Entry: $e');
    } finally {
      setState(() {
        isLoading = false;
      });

      clearScreen();
    }
  }

  Future<void> restorePreviousState() async {
    print("entering restore");
    try {
      if (widget.salesPos.type == 'Credit') {
        Ledger? ledger =
            await ledgerService.fetchLedgerById(widget.salesPos.ac);
        if (ledger != null) {
          ledger.debitBalance -= widget.salesPos.totalAmount;
          await ledgerService.updateLedger2(ledger);
        }
      } else if (widget.salesPos.type == 'Multimode') {
        if (widget.salesPos.multimode.isNotEmpty) {
          double? debit = widget.salesPos.multimode[0].debit;
          if (debit != null) {
            Ledger? ledger =
                await ledgerService.fetchLedgerById(widget.salesPos.ac);
            if (ledger != null) {
              ledger.debitBalance -= debit;
              await ledgerService.updateLedger2(ledger);
            }
          } else {
            print('No debit value found in multimode entry.');
          }
        } else {
          print('No multimode data available.');
        }
      } else {
        print('Selected type is not Credit or Multimode.');
      }
    } catch (e) {
      print('Error in restorePreviousState: $e');
    }
  }

  Future<void> setDataAfterAfterwards() async {
    final salesPosData = widget.salesPos;

    setState(() {
      _noController.text = salesPosData.no.toString();
      _controller = TextEditingController(text: salesPosData.date);
      _controller2 = TextEditingController(
          text: DateFormat('MM/dd/yyyy').format(DateTime.now()));
      selectedState = salesPosData.place;
      selectedCustomer = salesPosData.customer;
      selectedAC = salesPosData.ac;
      selectedSalesMan = '';
      selectedType = salesPosData.type;
      selecteSetDiscount = salesPosData.setDiscount;
      _billedToController.text = salesPosData.billedTo;
      _remarkController!.text = salesPosData.remarks!;
      _advanceController.text = salesPosData.advance.toString();
      // _netAmountController.text = salesPosData.totalAmount.toString();
      _netTotalDiscController.text = salesPosData.totalAmount.toString();

      salesPosData.entries.map(
        (e) {
          final salesEntries = e;
          print("ITEM LIST FROM MAP LEN: ${itemList.length}");
          final item = itemList.firstWhere((element) {
            return element.id == salesEntries.itemName;
          });
          final TextEditingController qtyController =
              TextEditingController(text: salesEntries.qty.toString());
          final TextEditingController unitController =
              TextEditingController(text: salesEntries.unit.toString());
          final TextEditingController rateController =
              TextEditingController(text: salesEntries.rate.toString());
          final TextEditingController discPerController =
              TextEditingController(text: salesEntries.disc.toString());
          final TextEditingController discRsController =
              TextEditingController(text: salesEntries.dis.toString());
          final TextEditingController taxController =
              TextEditingController(text: salesEntries.tax.toStringAsFixed(2));
          final TextEditingController netAmountController =
              TextEditingController(
                  text: salesEntries.netAmount.toStringAsFixed(2));
          final TextEditingController basicController = TextEditingController(
              text: salesEntries.basic.toStringAsFixed(2));
          final TextEditingController amountController = TextEditingController(
              text: salesEntries.amount.toStringAsFixed(2));
          final TextEditingController mrpController =
              TextEditingController(text: salesEntries.mrp.toStringAsFixed(2));
          final TextEditingController baseController =
              TextEditingController(text: salesEntries.base.toStringAsFixed(2));

          final tableKey = ValueKey(salesEntries.itemName);

          addTableRow4firstTime(
            selectedItemName: item.itemName,
            qtyController: qtyController,
            unitController: unitController,
            rateController: rateController,
            discPerController: discPerController,
            discRsController: discRsController,
            taxController: taxController,
            netAmountController: netAmountController,
            basicController: basicController,
            mrpController: mrpController,
            baseController: baseController,
            tableKey: tableKey,
            index: myIndex,
          );

          saveItems4FirstTime(
            tableKey: tableKey,
            selectedItemId: item.id,
            selectedItemName: item.itemName,
            qtyController: qtyController,
            unitController: unitController,
            baseController: baseController,
            rateController: rateController,
            mrpController: mrpController,
            basicController: basicController,
            discPerController: discPerController,
            discRsController: discRsController,
            taxController: taxController,
            amountController: amountController,
            netAmountController: netAmountController,
          );

          myIndex++;
        },
      ).toList();

      // Check if type is Multimode
    });
  }

  // InitState
  @override
  void initState() {
    super.initState();
    _initializeData();

    _audioCache = AudioCache(prefix: 'assets/audio/');
    _audioPlayer.audioCache = _audioCache;
    _audioCache.load('beep.mp3');
    //  Request focus for noFocus
    noFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Constants.loadingIndicator,
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SEDesktopAppbar(
                      text1: 'Tax Invoice GST',
                      text2: 'SALES ENTRY POS EDIT',
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Rows....
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 8, left: 10, bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SETopText(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
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
                                              controller: _noController,
                                              onSaved: (newValue) {},
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .requestFocus(noFocus);

                                                setState(() {});
                                              },
                                              // focusNode: noFocus,
                                              // onEditingComplete: () {
                                              //   FocusScope.of(context)
                                              //       .requestFocus(dateFocus);

                                              //   setState(() {});
                                              // },
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.07,
                                              height: 40,
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, bottom: 16.0),
                                              hintText: '',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: SETopText(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
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
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .requestFocus(dateFocus);

                                                  setState(() {});
                                                },
                                                controller: _controller,
                                                // focusNode: dateFocus,
                                                // onEditingComplete: () {
                                                //   FocusScope.of(context)
                                                //       .requestFocus(
                                                //           billedToFocus);

                                                //   setState(() {});
                                                // },
                                                onSaved: (newValue) {},
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.09,
                                                height: 40,
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, bottom: 16.0),
                                                hintText: '12/12/12'),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                              child: IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                      Icons.calendar_month)),
                                            ),
                                            SETopText(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04,
                                              height: 30,
                                              text: ' Place',
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
                                                  border: Border.all()),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              height: 40,
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownMenu<String>(
                                                  requestFocusOnTap: true,
                                                  initialSelection:
                                                      selectedState.isNotEmpty
                                                          ? selectedState
                                                          : null,
                                                  enableSearch: true,
                                                  // enableFilter: true,
                                                  // leadingIcon: const SizedBox.shrink(),
                                                  trailingIcon:
                                                      const SizedBox.shrink(),
                                                  textStyle:
                                                      GoogleFonts.poppins(
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
                                                            vertical: 16),
                                                    isDense: true,
                                                    activeIndicatorBorder:
                                                        const BorderSide(
                                                      color: Colors.transparent,
                                                    ),
                                                    counterStyle:
                                                        GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  expandedInsets:
                                                      EdgeInsets.zero,
                                                  onSelected: (String? value) {
                                                    setState(() {
                                                      selectedState = value!;
                                                    });
                                                  },
                                                  dropdownMenuEntries: <String>[
                                                    'Gujarat',
                                                    'Maharashtra',
                                                    'Karnataka',
                                                    'Tamil Nadu'
                                                  ].map<
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
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ));
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, top: 2.0, bottom: 8.0),
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
                                          text: 'Item[F8]',
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
                                              border: Border.all()),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.377,
                                          height: 40,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownMenu<Item>(
                                              controller: dataText,
                                              requestFocusOnTap: true,
                                              focusNode: itemFocus,
                                              initialSelection: null,
                                              enableSearch: true,
                                              trailingIcon:
                                                  const SizedBox.shrink(),
                                              textStyle: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xff000000),
                                                decoration: TextDecoration.none,
                                              ),
                                              menuHeight: 300,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.19,
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
                                              filterCallback:
                                                  (List<DropdownMenuEntry<Item>>
                                                          entries,
                                                      String filter) {
                                                final String trimmedFilter =
                                                    filter.trim().toLowerCase();

                                                if (trimmedFilter.isEmpty) {
                                                  return entries;
                                                }

                                                // Filter the entries based on the query
                                                return entries.where((entry) {
                                                  return entry.value.itemName
                                                      .toLowerCase()
                                                      .contains(trimmedFilter);
                                                }).toList();
                                              },
                                              onSelected: (Item? value) {
                                                _playBeep();
                                                setState(() {
                                                  final selectedItem = value;

                                                  selectedItemName =
                                                      selectedItem!.itemName;

                                                  selectedItemId =
                                                      selectedItem.id;

                                                  String newId = '';
                                                  String newId2 = '';

                                                  for (Item item in itemList) {
                                                    if (item.id ==
                                                        selectedItemId) {
                                                      newId = item.taxCategory;
                                                      newId2 =
                                                          item.measurementUnit;
                                                    }
                                                  }

                                                  for (TaxRate tax
                                                      in taxLists) {
                                                    if (tax.id == newId) {
                                                      setState(() {
                                                        _taxController.text =
                                                            tax.rate;
                                                      });
                                                    }
                                                  }
                                                  for (MeasurementLimit meu
                                                      in measurement) {
                                                    if (meu.id == newId2) {
                                                      setState(() {
                                                        _unitController.text =
                                                            meu.measurement
                                                                .toString();
                                                      });
                                                    }
                                                  }

                                                  // Calculate the Rate
                                                  double ratepercent =
                                                      (double.parse(
                                                              _taxController
                                                                  .text) /
                                                          100);

                                                  ratepercent += 1.00;

                                                  print(ratepercent);

                                                  double mpr = selectedItem.mrp;

                                                  double rate =
                                                      mpr / ratepercent;

                                                  _qtyController.text = "1";
                                                  _rateController.text =
                                                      rate.toStringAsFixed(2);
                                                  _discPerController.text =
                                                      "0.00";
                                                  _discRsController.text =
                                                      "0.00";
                                                  _basicController.text =
                                                      rate.toStringAsFixed(2);

                                                  _amountController.text =
                                                      rate.toStringAsFixed(2);

                                                  _mrpController.text =
                                                      selectedItem.mrp
                                                          .toStringAsFixed(2);
                                                  _baseController.text =
                                                      selectedItem.mrp
                                                          .toStringAsFixed(2);

                                                  final tax =
                                                      selectedItem.mrp - rate;

                                                  // Change to taxAmountController

                                                  _taxController.text =
                                                      tax.toStringAsFixed(2);

                                                  // For Net Amount, multiply qty with real rate
                                                  double qty = double.parse(
                                                      _qtyController.text);
                                                  double rate2 = double.parse(
                                                      selectedItem.mrp
                                                          .toString());

                                                  double netAmount =
                                                      qty * rate2;

                                                  _netAmountController.text =
                                                      netAmount
                                                          .toStringAsFixed(2)
                                                          .toString();

                                                  openDialog2(item: value!);
                                                });
                                              },
                                              dropdownMenuEntries: itemList
                                                  .map<DropdownMenuEntry<Item>>(
                                                      (Item value) {
                                                return DropdownMenuEntry<Item>(
                                                  value: value,
                                                  label: value.itemName,
                                                  trailingIcon: Text(
                                                    'Qty: ${value.maximumStock}',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, left: 10),
                              child: Container(
                                height: 350,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color:
                                          Colors.purple[900] ?? Colors.purple,
                                      width: 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Table(
                                          border: TableBorder.all(
                                              width: 1, color: Colors.black),
                                          columnWidths: const {
                                            0: FlexColumnWidth(1),
                                            1: FlexColumnWidth(5),
                                            2: FlexColumnWidth(3),
                                            3: FlexColumnWidth(3),
                                            4: FlexColumnWidth(3),
                                            5: FlexColumnWidth(3),
                                            6: FlexColumnWidth(3),
                                            7: FlexColumnWidth(3),
                                            8: FlexColumnWidth(3),
                                            9: FlexColumnWidth(3),
                                            10: FlexColumnWidth(3),
                                            11: FlexColumnWidth(3),
                                            12: FlexColumnWidth(3),
                                            13: FlexColumnWidth(3),
                                            14: FlexColumnWidth(3),
                                          },
                                          children: [
                                            TableRow(children: [
                                              TableCell(
                                                  child: SizedBox(
                                                height: 40,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Sr",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: const Color(
                                                          0xff4B0082),
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
                                                      "Item Name(^F8)",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xff4B0082),
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
                                                      "Points",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xff4B0082),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: SizedBox(
                                                  height: 40,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        "Batch No",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: const Color(
                                                              0xff4B0082),
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
                                                      "Qty",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xff4B0082),
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
                                                      "Unit",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xff4B0082),
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
                                                      "Base",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xff4B0082),
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
                                                      "Rate",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xff4B0082),
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
                                                      "MRP",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xff4B0082),
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
                                                      "Basic",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xff4B0082),
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
                                                      "Dis%",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xff4B0082),
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
                                                      "Disc",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xff4B0082),
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
                                                      "Tax",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xff4B0082),
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
                                                      "Net.Amt",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xff4B0082),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                            ...tables,
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, left: 10),
                              child: Container(
                                // height: 280,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color:
                                          Colors.purple[900] ?? Colors.purple,
                                      width: 1),
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          SizedBox(
                                            width: w * 0.32,
                                            // height: 190,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 2),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.08,
                                                              child: Text(
                                                                "Set Discount",
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .deepPurple,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      border: Border
                                                                          .all()),
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.05,
                                                              height: 40,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              child:
                                                                  DropdownButtonHideUnderline(
                                                                child:
                                                                    DropdownButton<
                                                                        String>(
                                                                  value:
                                                                      selecteSetDiscount,
                                                                  underline:
                                                                      Container(),
                                                                  icon: const SizedBox
                                                                      .shrink(),
                                                                  onChanged:
                                                                      (String?
                                                                          newValue) {
                                                                    setState(
                                                                        () {
                                                                      selecteSetDiscount =
                                                                          newValue!;
                                                                      if (selecteSetDiscount ==
                                                                              "Yes" &&
                                                                          double.parse(_netTotalDiscController.text) >
                                                                              0) {
                                                                        _showAlert(
                                                                            context);
                                                                      }
                                                                    });
                                                                  },
                                                                  items: [
                                                                    "No",
                                                                    "Yes",
                                                                  ].map<
                                                                      DropdownMenuItem<
                                                                          String>>((String
                                                                      value) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          value,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            bottom:
                                                                                0,
                                                                            left:
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          value,
                                                                          style:
                                                                              GoogleFonts.poppins(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
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
                                                      ),
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.04,
                                                              child: Text(
                                                                "Type",
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .deepPurple,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      border: Border
                                                                          .all()),
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.1,
                                                              height: 40,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              child:
                                                                  DropdownButtonHideUnderline(
                                                                child:
                                                                    DropdownButton<
                                                                        String>(
                                                                  value:
                                                                      selectedType,
                                                                  underline:
                                                                      Container(),
                                                                  icon: const SizedBox
                                                                      .shrink(),
                                                                  onChanged:
                                                                      (String?
                                                                          newValue) {
                                                                    setState(
                                                                        () {
                                                                      selectedType =
                                                                          newValue!;
                                                                    });
                                                                  },
                                                                  items: [
                                                                    "Cash",
                                                                    "Credit",
                                                                    "Multimode",
                                                                  ].map<
                                                                      DropdownMenuItem<
                                                                          String>>((String
                                                                      value) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          value,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            bottom:
                                                                                0,
                                                                            left:
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          value,
                                                                          style:
                                                                              GoogleFonts.poppins(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
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
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 10.0),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                      child: Text(
                                                        "A/c",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.deepPurple,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all()),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      height: 40,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child:
                                                          DropdownButtonHideUnderline(
                                                        child: DropdownMenu<
                                                            Ledger>(
                                                          controller:
                                                              _acController,
                                                          width: 400,
                                                          requestFocusOnTap:
                                                              true,
                                                          initialSelection: selectedAC !=
                                                                  null
                                                              ? ledgerList.firstWhere(
                                                                  (ledger) =>
                                                                      ledger
                                                                          .id ==
                                                                      selectedAC)
                                                              : null,
                                                          enableSearch: true,
                                                          trailingIcon:
                                                              const SizedBox
                                                                  .shrink(),
                                                          textStyle: GoogleFonts
                                                              .poppins(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                          ),
                                                          menuHeight: 300,
                                                          selectedTrailingIcon:
                                                              const SizedBox
                                                                  .shrink(),
                                                          inputDecorationTheme:
                                                              const InputDecorationTheme(
                                                            border: InputBorder
                                                                .none,
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            8,
                                                                        vertical:
                                                                            0),
                                                            isDense: true,
                                                            activeIndicatorBorder:
                                                                BorderSide(
                                                              color: Colors
                                                                  .transparent,
                                                            ),
                                                          ),
                                                          expandedInsets:
                                                              EdgeInsets.zero,
                                                          onSelected:
                                                              (Ledger? value) {
                                                            if (value != null) {
                                                              setState(() {
                                                                selectedAC =
                                                                    value.id;
                                                                selectedCustomer =
                                                                    "67188c95ce238809ff47a745";
                                                                _billedToController
                                                                        .text =
                                                                    value.name;
                                                                _customerController
                                                                        .text =
                                                                    "Registered Ledger";
                                                              });
                                                            }
                                                          },
                                                          dropdownMenuEntries:
                                                              ledgerList.map<
                                                                  DropdownMenuEntry<
                                                                      Ledger>>((Ledger
                                                                  value) {
                                                            return DropdownMenuEntry<
                                                                Ledger>(
                                                              value: value,
                                                              label: value.name,
                                                              style:
                                                                  ButtonStyle(
                                                                textStyle:
                                                                    WidgetStateProperty
                                                                        .all(
                                                                  GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black,
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
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.08,
                                                        child: Text(
                                                          "Customer/Mob.",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .deepPurple,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(),
                                                        ),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.18,
                                                        height: 40,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: IgnorePointer(
                                                            ignoring:
                                                                selectedType !=
                                                                    'Cash',
                                                            child: Opacity(
                                                              opacity:
                                                                  selectedType ==
                                                                          'Cash'
                                                                      ? 1.0
                                                                      : 1.0,
                                                              child: DropdownMenu<
                                                                  NewCustomerModel>(
                                                                controller:
                                                                    _customerController,
                                                                width: 400,
                                                                requestFocusOnTap:
                                                                    true,
                                                                initialSelection:
                                                                    selectedCustomer !=
                                                                            null
                                                                        ? customerList
                                                                            .firstWhere(
                                                                            (customer) =>
                                                                                customer.id ==
                                                                                selectedCustomer,
                                                                          )
                                                                        : null,
                                                                enableSearch:
                                                                    true,
                                                                trailingIcon:
                                                                    const SizedBox
                                                                        .shrink(),
                                                                textStyle:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .none,
                                                                ),
                                                                menuHeight: 300,
                                                                selectedTrailingIcon:
                                                                    const SizedBox
                                                                        .shrink(),
                                                                inputDecorationTheme:
                                                                    const InputDecorationTheme(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  contentPadding:
                                                                      EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              8,
                                                                          vertical:
                                                                              0),
                                                                  isDense: true,
                                                                  activeIndicatorBorder:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .transparent,
                                                                  ),
                                                                ),
                                                                expandedInsets:
                                                                    EdgeInsets
                                                                        .zero,
                                                                onSelected:
                                                                    (NewCustomerModel?
                                                                        value) {
                                                                  if (value !=
                                                                      null) {
                                                                    setState(
                                                                        () {
                                                                      selectedCustomer =
                                                                          value
                                                                              .id;
                                                                      selectedAC =
                                                                          "6676b4f41383f35fe6ba9abc";
                                                                    });

                                                                    for (NewCustomerModel customer
                                                                        in customerList) {
                                                                      if (customer
                                                                              .id ==
                                                                          value
                                                                              .id) {
                                                                        _billedToController.text =
                                                                            '${customer.fname} M.(${customer.mobile})';
                                                                      }
                                                                    }
                                                                  }
                                                                },
                                                                dropdownMenuEntries: customerList
                                                                    .where((customer) =>
                                                                        customer
                                                                            .id !=
                                                                        '67188c95ce238809ff47a745')
                                                                    .map<
                                                                        DropdownMenuEntry<
                                                                            NewCustomerModel>>((NewCustomerModel
                                                                        value) {
                                                                  return DropdownMenuEntry<
                                                                      NewCustomerModel>(
                                                                    value:
                                                                        value,
                                                                    label: value
                                                                        .fname,
                                                                    style:
                                                                        ButtonStyle(
                                                                      textStyle:
                                                                          WidgetStateProperty
                                                                              .all(
                                                                        GoogleFonts
                                                                            .poppins(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      InkWell(
                                                        onTap: selectedCustomer ==
                                                                "67188c95ce238809ff47a745"
                                                            ? null
                                                            : showCustomerHistory,
                                                        child: Container(
                                                          width: 60,
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.more_horiz,
                                                              size: 40.0,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.08,
                                                        child: Text(
                                                          "Billed to",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .deepPurple,
                                                          ),
                                                        ),
                                                      ),

                                                      // Billed To
                                                      SETopTextfield(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  billedToFocus);
                                                          setState(() {});
                                                        },
                                                        // focusNode:
                                                        //     billedToFocus,
                                                        // onEditingComplete: () {
                                                        //   FocusScope.of(context)
                                                        //       .requestFocus(
                                                        //           remarkFocus);
                                                        //   setState(() {});
                                                        // },
                                                        controller:
                                                            _billedToController,
                                                        onSaved: (newValue) {},
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                        height: 40,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8.0,
                                                                bottom: 16.0),
                                                        hintText: '',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.08,
                                                        child: Text(
                                                          "Remarks",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .deepPurple,
                                                          ),
                                                        ),
                                                      ),
                                                      SETopTextfield(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  remarkFocus);
                                                          setState(() {});
                                                        },
                                                        controller:
                                                            _remarkController,
                                                        // focusNode: remarkFocus,
                                                        // onEditingComplete: () {
                                                        //   FocusScope.of(context)
                                                        //       .requestFocus(
                                                        //           advanceFocus);
                                                        //   setState(() {});
                                                        // },
                                                        onSaved: (newValue) {},
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                        height: 40,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8.0,
                                                                bottom: 16.0),
                                                        hintText: '',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: w * 0.35,
                                            // height: 170,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 50),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  SizedBox(
                                                    width: w * 0.30,
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            "S. Man",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .deepPurple,
                                                            ),
                                                          ),
                                                        ),

                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  border: Border
                                                                      .all()),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                          height: 40,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child:
                                                              DropdownButtonHideUnderline(
                                                            child: DropdownMenu<
                                                                SalesMan>(
                                                              width: 400,
                                                              requestFocusOnTap:
                                                                  true,
                                                              initialSelection:
                                                                  salesManList
                                                                          .isNotEmpty
                                                                      ? salesManList
                                                                          .first
                                                                      : null,
                                                              enableSearch:
                                                                  true,
                                                              trailingIcon:
                                                                  const SizedBox
                                                                      .shrink(),
                                                              textStyle:
                                                                  GoogleFonts
                                                                      .poppins(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                                decoration:
                                                                    TextDecoration
                                                                        .none,
                                                              ),
                                                              menuHeight: 300,
                                                              selectedTrailingIcon:
                                                                  const SizedBox
                                                                      .shrink(),
                                                              inputDecorationTheme:
                                                                  const InputDecorationTheme(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            8,
                                                                        vertical:
                                                                            0),
                                                                isDense: true,
                                                                activeIndicatorBorder:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .transparent,
                                                                ),
                                                              ),
                                                              expandedInsets:
                                                                  EdgeInsets
                                                                      .zero,
                                                              onSelected:
                                                                  (SalesMan?
                                                                      value) {
                                                                setState(() {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .requestFocus(
                                                                          _salesManFocusMode);
                                                                  setState(() {
                                                                    selectedSalesMan =
                                                                        value!
                                                                            .id;
                                                                  });
                                                                });
                                                              },
                                                              dropdownMenuEntries:
                                                                  salesManList.map<
                                                                      DropdownMenuEntry<
                                                                          SalesMan>>((SalesMan
                                                                      value) {
                                                                return DropdownMenuEntry<
                                                                    SalesMan>(
                                                                  value: value,
                                                                  label: value
                                                                      .name,
                                                                  style:
                                                                      ButtonStyle(
                                                                    textStyle:
                                                                        WidgetStateProperty
                                                                            .all(
                                                                      GoogleFonts
                                                                          .poppins(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                            ),
                                                          ),
                                                        ),

                                                        // SETopTextfield(
                                                        //   controller:
                                                        //       _salesManController,
                                                        //   onSaved:
                                                        //       (newValue) {},
                                                        //   width: MediaQuery.of(
                                                        //               context)
                                                        //           .size
                                                        //           .width *
                                                        //       0.1,
                                                        //   height: 40,
                                                        //   padding: const EdgeInsets
                                                        //       .only(
                                                        //       left: 8.0,
                                                        //       bottom:
                                                        //           16.0),
                                                        //   hintText: '',
                                                        //   alignment:
                                                        //       TextAlign
                                                        //           .end,
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  SizedBox(
                                                    width: w * 0.25,
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            "Advance",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .deepPurple,
                                                            ),
                                                          ),
                                                        ),
                                                        SETopTextfield(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    advanceFocus);
                                                            setState(() {});
                                                          },
                                                          // focusNode:
                                                          //     advanceFocus,
                                                          // onEditingComplete:
                                                          //     () {
                                                          //   FocusScope.of(
                                                          //           context)
                                                          //       .requestFocus(
                                                          //           pointBalance);

                                                          //   setState(() {});
                                                          // },
                                                          alignment:
                                                              TextAlign.end,
                                                          controller:
                                                              _advanceController,
                                                          onSaved:
                                                              (newValue) {},
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                          height: 40,
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  bottom: 16.0),
                                                          hintText: '',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  SizedBox(
                                                    width: w * 0.30,
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            "Point Balance",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .deepPurple,
                                                            ),
                                                          ),
                                                        ),
                                                        SETopTextfield(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    pointBalance);
                                                            setState(() {});
                                                          },
                                                          // focusNode:
                                                          //     pointBalance,
                                                          // onEditingComplete:
                                                          //     () {
                                                          //   FocusScope.of(
                                                          //           context)
                                                          //       .requestFocus(
                                                          //           redeemPoints);
                                                          //   setState(() {});
                                                          // },
                                                          alignment:
                                                              TextAlign.end,
                                                          controller:
                                                              _pointBalanceController,
                                                          onSaved:
                                                              (newValue) {},
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                          height: 40,
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  bottom: 16.0),
                                                          hintText: '',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  SizedBox(
                                                    width: w * 0.30,
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            "Redeem Points",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .deepPurple,
                                                            ),
                                                          ),
                                                        ),
                                                        SETopTextfield(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    redeemPoints);
                                                            setState(() {});
                                                          },
                                                          // focusNode:
                                                          //     redeemPoints,
                                                          // onEditingComplete:
                                                          //     () {
                                                          //   FocusScope.of(
                                                          //           context)
                                                          //       .requestFocus(
                                                          //           additionFocus);
                                                          //   setState(() {});
                                                          // },
                                                          controller:
                                                              _redeemPointController,
                                                          alignment:
                                                              TextAlign.end,
                                                          onSaved:
                                                              (newValue) {},
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                          height: 40,
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  bottom: 16.0),
                                                          hintText: '',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 100,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Text(
                                                        'Profit Check',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.blue,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationColor: Colors
                                                              .blue, // Change underline color
                                                          decorationThickness:
                                                              2.0, // Change underline thickness
                                                          decorationStyle:
                                                              TextDecorationStyle
                                                                  .solid, // Change underline style
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: w * 0.2,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            "Addition(F6)",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .deepPurple,
                                                            ),
                                                          ),
                                                        ),
                                                        SETopTextfield(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    additionFocus);
                                                            setState(() {});
                                                          },
                                                          // focusNode:
                                                          //     additionFocus,
                                                          // onEditingComplete:
                                                          //     () {
                                                          //   FocusScope.of(
                                                          //           context)
                                                          //       .requestFocus(
                                                          //           lessFocus);
                                                          //   setState(() {});
                                                          // },
                                                          alignment:
                                                              TextAlign.end,
                                                          controller:
                                                              _additionController,
                                                          onSaved:
                                                              (newValue) {},
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.15,
                                                          height: 40,
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  bottom: 16.0),
                                                          hintText: '',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: w * 0.2,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            "Less(F7)",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .deepPurple,
                                                            ),
                                                          ),
                                                        ),
                                                        SETopTextfield(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    lessFocus);
                                                            setState(() {});
                                                          },
                                                          // focusNode: lessFocus,
                                                          // onEditingComplete:
                                                          //     () {
                                                          //   FocusScope.of(
                                                          //           context)
                                                          //       .requestFocus(
                                                          //           roundOffFocus);
                                                          //   setState(() {});
                                                          // },
                                                          alignment:
                                                              TextAlign.end,
                                                          controller:
                                                              _lessController,
                                                          onSaved:
                                                              (newValue) {},
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.15,
                                                          height: 40,
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  bottom: 16.0),
                                                          hintText: '',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: w * 0.2,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            "Round off",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .deepPurple,
                                                            ),
                                                          ),
                                                        ),
                                                        SETopTextfield(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    roundOffFocus);
                                                            setState(() {});
                                                          },
                                                          // focusNode:
                                                          //     roundOffFocus,
                                                          // onEditingComplete:
                                                          //     () {
                                                          //   FocusScope.of(
                                                          //           context)
                                                          //       .requestFocus(
                                                          //           netTotalFocus);
                                                          //   setState(() {});
                                                          // },
                                                          alignment:
                                                              TextAlign.end,
                                                          controller:
                                                              _roundOffController,
                                                          onSaved:
                                                              (newValue) {},
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.15,
                                                          height: 40,
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  bottom: 16.0),
                                                          hintText: '',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: w * 0.2,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            "Net Total",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .deepPurple,
                                                            ),
                                                          ),
                                                        ),
                                                        SETopTextfield(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    netTotalFocus);
                                                            setState(() {});
                                                          },
                                                          // focusNode:
                                                          //     netTotalFocus,
                                                          // onEditingComplete:
                                                          //     () {
                                                          //   FocusScope.of(
                                                          //           context)
                                                          //       .requestFocus(
                                                          //           noFocus);
                                                          //   setState(() {});
                                                          // },
                                                          alignment:
                                                              TextAlign.end,
                                                          controller:
                                                              _netTotalDiscController,
                                                          onSaved:
                                                              (newValue) {},
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.15,
                                                          height: 40,
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  bottom: 16.0),
                                                          hintText: '',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                // const SizedBox(
                                                //   height: 35,
                                                // ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 10, left: 10, top: 10),
                              child: Row(
                                children: [
                                  const Button(
                                    name: "Hold",
                                  ),
                                  const Button(
                                    name: "Hold List",
                                  ),
                                  const Spacer(),
                                  Button(
                                    name: "Save",
                                    Skey: "[F4]",
                                    onTap: () {
                                      if (selectedType == 'Multimode') {
                                        openMultiModeDialog();
                                      } else {
                                        updatePOSEntry();
                                      }
                                    },
                                  ),
                                  const Button(
                                    name: "Cancel",
                                  ),
                                  Button(
                                    name: "Delete",
                                    onTap: () async {
                                      restorePreviousState();

                                      await salesPosRepository
                                          .deletePosEntry(widget.salesPos.id);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PosMaster(
                                              fetchedLedger: ledgerList,
                                            ),
                                          ));
                                    },
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Shortcuts(
                        shortcuts: {
                          LogicalKeySet(LogicalKeyboardKey.f3):
                              const ActivateIntent(),
                          LogicalKeySet(LogicalKeyboardKey.f4):
                              const ActivateIntent(),
                        },
                        child: Focus(
                          autofocus: true,
                          focusNode: _focusNode,
                          onKey: (node, event) {
                            if (event is RawKeyDownEvent &&
                                event.logicalKey == LogicalKeyboardKey.f3) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => const NewCustomer()),
                              );
                              return KeyEventResult.handled;
                            } else if (event is RawKeyDownEvent &&
                                event.logicalKey == LogicalKeyboardKey.f6) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SalesManDesktopbody(),
                                ),
                              );
                              return KeyEventResult.handled;
                            } else if (event is RawKeyDownEvent &&
                                event.logicalKey == LogicalKeyboardKey.escape) {
                              Navigator.of(context).pop();
                              return KeyEventResult.handled;
                            } else if (event is RawKeyDownEvent &&
                                event.logicalKey == LogicalKeyboardKey.f2) {
                              PanaraConfirmDialog.showAnimatedGrow(
                                context,
                                title: "BillingSphere",
                                message:
                                    "Are you sure you want to cancel this entry?",
                                confirmButtonText: "Confirm",
                                cancelButtonText: "Cancel",
                                onTapCancel: () {
                                  Navigator.pop(context);
                                },
                                onTapConfirm: () {
                                  // pop screen
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return PosMaster(
                                        fetchedLedger: ledgerList,
                                      );
                                    },
                                  ));
                                },
                                panaraDialogType: PanaraDialogType.warning,
                              );

                              return KeyEventResult.handled;
                            } else if (event is RawKeyDownEvent &&
                                event.logicalKey == LogicalKeyboardKey.keyN) {
                              PanaraConfirmDialog.showAnimatedGrow(
                                context,
                                title: "BillingSphere",
                                message:
                                    "Are you sure you want to create a new entry?",
                                confirmButtonText: "Confirm",
                                cancelButtonText: "Cancel",
                                onTapCancel: () {
                                  Navigator.pop(context);
                                },
                                onTapConfirm: () {
                                  // pop screen
                                  Navigator.of(context).pop();
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) {
                                      return const SalesReturn();
                                    },
                                  ));
                                },
                                panaraDialogType: PanaraDialogType.warning,
                              );
                              return KeyEventResult.handled;
                            } else if (event is RawKeyDownEvent &&
                                event.logicalKey == LogicalKeyboardKey.pageUp) {
                              return KeyEventResult.handled;
                            } else if (event is RawKeyDownEvent &&
                                event.logicalKey ==
                                    LogicalKeyboardKey.pageDown) {
                              return KeyEventResult.handled;
                            } else if (event is RawKeyDownEvent &&
                                event.logicalKey == LogicalKeyboardKey.f4) {
                              return KeyEventResult.handled;
                            }
                            return KeyEventResult.ignored;
                          },
                          child: Container(
                            height: 700,
                            width: w * 0.1,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    width: 1,
                                    color: Colors.purple[900] ?? Colors.purple),
                                right: BorderSide(
                                    width: 1,
                                    color: Colors.purple[900] ?? Colors.purple),
                                bottom: BorderSide(
                                    width: 1,
                                    color: Colors.purple[900] ?? Colors.purple),
                                left: BorderSide(
                                    width: 1,
                                    color: Colors.purple[900] ?? Colors.purple),
                              ),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  List2(
                                    Skey: "F2",
                                    name: "List",
                                    onTap: () {
                                      PanaraConfirmDialog.showAnimatedGrow(
                                        context,
                                        title: "BillingSphere",
                                        message:
                                            "Are you sure you want to cancel this entry?",
                                        confirmButtonText: "Confirm",
                                        cancelButtonText: "Cancel",
                                        onTapCancel: () {
                                          Navigator.pop(context);
                                        },
                                        onTapConfirm: () {
                                          // pop screen
                                          Navigator.of(context).pop();
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) {
                                              return PosMaster(
                                                fetchedLedger: ledgerList,
                                              );
                                            },
                                          ));
                                        },
                                        panaraDialogType:
                                            PanaraDialogType.warning,
                                      );
                                    },
                                  ),
                                  List2(
                                    Skey: "F3",
                                    name: "New Customer",
                                    onTap: () {
                                      final result = Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const NewCustomer(),
                                        ),
                                      );

                                      result.then((value) {
                                        if (value != null) {
                                          setState(() {
                                            customerList.add(value);
                                          });
                                        }
                                      });

                                      print('Result: $result');
                                    },
                                  ),
                                  List2(
                                    Skey: "F6",
                                    name: "New S. Man",
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SalesManDesktopbody(),
                                        ),
                                      );
                                    },
                                  ),
                                  List2(
                                    Skey: "N",
                                    name: "New",
                                    onTap: () {
                                      PanaraConfirmDialog.showAnimatedGrow(
                                        context,
                                        title: "BillingSphere",
                                        message:
                                            "Are you sure you want to create a new entry?",
                                        confirmButtonText: "Confirm",
                                        cancelButtonText: "Cancel",
                                        onTapCancel: () {
                                          Navigator.pop(context);
                                        },
                                        onTapConfirm: () {
                                          // pop screen
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return const SalesReturn();
                                            },
                                          ));
                                        },
                                        panaraDialogType:
                                            PanaraDialogType.warning,
                                      );
                                    },
                                  ),
                                  // const List2(
                                  //   Skey: "P",
                                  //   name: "Print",
                                  // ),
                                  // const List2(
                                  //   Skey: "A",
                                  //   name: "Alt Print",
                                  // ),
                                  // const List2(
                                  //   Skey: "F5",
                                  //   name: "Change Type",
                                  // ),
                                  // const List2(),
                                  // const List2(
                                  //   Skey: "B",
                                  //   name: "Prn Barcode",
                                  // ),
                                  // const List2(),
                                  // const List2(
                                  //   Skey: "N",
                                  //   name: "Search No",
                                  // ),
                                  // const List2(
                                  //   Skey: "M",
                                  //   name: "Search Item",
                                  // ),
                                  // const List2(),
                                  // const List2(
                                  //   name: "Discount",
                                  //   Skey: "F12",
                                  // ),
                                  // const List2(
                                  //   Skey: "F12",
                                  //   name: "Audit Trail",
                                  // ),
                                  List2(
                                    Skey: "Pg Up",
                                    name: "Previous",
                                    onTap: () {},
                                  ),
                                  List2(
                                    Skey: "Pg Dn",
                                    name: "Next",
                                    onTap: () {},
                                  ),
                                  const List2(),
                                  const List2(),
                                  const List2(),
                                  const List2(),
                                  const List2(),
                                  const List2(),
                                  const List2(),
                                  const List2(),
                                  const List2(),
                                  const List2(),
                                  const List2(),
                                  const List2(),
                                  const List2(),
                                  // const List2(
                                  //   Skey: "G",
                                  //   name: "Attach. Img",
                                  // ),
                                  // const List2(),
                                  // const List2(
                                  //   Skey: "G",
                                  //   name: "Vch Setup",
                                  // ),
                                  // const List2(
                                  //   Skey: "T",
                                  //   name: "Print Setup",
                                  // ),
                                  // const List2(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
  }

  Future<void> fetchAllSalesMan() async {
    try {
      final List<SalesMan> salesMan = await salesManRepository.fetchSalesMan();

      salesManList = salesMan;
      selectedSalesMan = salesMan[0].id;

      print('SalesMan Length: ${salesManList.length}');
    } catch (error) {
      print('Failed to fetch Sales');
    }
  }

  // Fetch all POS
  Future<void> fetchAllPOS() async {
    try {
      final List<SalesPos> salesPos = await salesPosRepository.fetchSalesPos();

      salesPosList = salesPos;

      print('POS Length: ${salesPosList.length}');
    } catch (error) {
      print('Failed to fetch POS Entries: $error');
    }
  }

  // Fetch all Ledgers
  Future<void> fetchAllLedgers() async {
    try {
      final List<Ledger> ledgers = await ledgerService.fetchLedgers();

      ledgerList = ledgers;
      selectedAC = ledgers[0].id;

      print('Ledger Length: ${ledgerList.length}');
    } catch (error) {
      print('Failed to fetch Ledgers: $error');
    }
  }

  Future<void> fetchAndSetTaxRates() async {
    try {
      final List<TaxRate> taxRates = await taxRateService.fetchTaxRates();

      taxLists = taxRates;
      print('Tax Length: ${taxLists.length}');
    } catch (error) {
      print('Failed to fetch Tax Rates: $error');
    }
  }

  Future<void> fetchMeasurementLimit() async {
    try {
      final List<MeasurementLimit> measurements =
          await measurementService.fetchMeasurementLimits();

      measurement = measurements;

      print('Measurement Length: ${measurement.length}');
    } catch (error) {
      print('Failed to fetch Tax Rates: $error');
    }
  }

  // Fetch all Customers
  Future<void> fetchAllCustomers() async {
    try {
      final List<NewCustomerModel> customers =
          await newCustomerRepository.getAllCustomers();

      customerList = customers;
      selectedCustomer = customers[0].id;

      print('Customer Length: ${customerList.length}');
    } catch (error) {
      print('Failed to fetch Customers: $error');
    }
  }

  Future<void> fetchItems() async {
    final items = await itemsService.fetchITEMS();

    for (var entry in widget.salesPos.entries) {
      final Item? matchedItem = items.firstWhere(
        (item) => item.id == entry.itemName,
      );

      rowItems.add(matchedItem!);
    }

    itemList = items;
  }

  Future<List<String>?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('companies');
  }

  Future<void> setCompanyCode() async {
    List<String>? code = await getCompanyCode();
    companyCode = code;

    print('Company Code: $companyCode');
  }

  void updateselectedTable(int index) {
    print("length of table: ${tables.length}");
    print("length of rowItems: ${rowItems.length}");
    final key = tables[index].key;
    final rowIndex = tables.indexWhere((row) => row.key == key);
    print("row index : ${rowIndex}");
    openDialog2(rowIndex: rowIndex, item: rowItems[index]);
  }

  void addTableRow2() {
    print("selectedItemName : $selectedItemName");
    int existingIndex = tables.indexWhere((row) {
      final tableCell = _getTextFromTableRow(row, 1);
      return tableCell == selectedItemName;
    });

    if (existingIndex != -1) {
      _updateExistingRow(existingIndex);
    } else {
      _addNewRow();
    }
  }

  String _getTextFromTableRow(TableRow row, int index) {
    final isTableCell = row.children[index] is TableCell;
    final tableCell = isTableCell ? row.children[index] as TableCell : null;
    final isInkWell = tableCell?.child is InkWell;
    final inkWell = isInkWell ? tableCell!.child as InkWell : null;
    final isSizedBox = inkWell?.child is SizedBox;
    final sizedBox = isSizedBox ? inkWell!.child as SizedBox : null;
    final isAlign = sizedBox?.child is Align;
    final align = isAlign ? sizedBox!.child as Align : null;
    final isTextChild = align?.child is Text;
    return isTextChild ? ((align!.child as Text).data ?? 'N/A') : 'N/A';
  }

  void _updateExistingRow(int existingIndex) {
    _updateTableCell(existingIndex, 4, _qtyController.text);
    _updateTableCell(existingIndex, 10, _discPerController.text);
    _updateTableCell(existingIndex, 11, _discRsController.text);
    _updateTableCell(existingIndex, 12, _taxController.text);
    _updateTableCell(existingIndex, 13, _netAmountController.text);

    setState(() {
      tables = tables;
    });
  }

  void _updateTableCell(int rowIndex, int cellIndex, String value) {
    tables[rowIndex].children[cellIndex] = TableCell(
      child: InkWell(
        child: SizedBox(
          height: 40,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void _addNewRow() {
    int index = tables.length;

    setState(() {
      tables.add(
        TableRow(
          key: tableKey,
          decoration: const BoxDecoration(color: Colors.white),
          children: [
            _buildTableCell(index, (index + 1).toString()),
            _buildTableCell(index, selectedItemName ?? 'N/A'),
            _buildTableCell(index, '0'),
            _buildTableCell(index, ''),
            _buildTableCell(index, _qtyController.text),
            _buildTableCell(index, _unitController.text),
            _buildTableCell(index, _baseController.text),
            _buildTableCell(index, _rateController.text),
            _buildTableCell(index, _mrpController.text),
            _buildTableCell(index, _basicController.text),
            _buildTableCell(index, _discPerController.text),
            _buildTableCell(index, _discRsController.text),
            _buildTableCell(index, _taxController.text),
            _buildTableCell(index, _netAmountController.text),
          ],
        ),
      );
    });
  }

  TableCell _buildTableCell(int index, String value) {
    return TableCell(
      child: InkWell(
        onTap: () => updateselectedTable(index),
        child: SizedBox(
          height: 40,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void openDialog2({int? rowIndex, Item? item}) {
    if (rowItems.contains(item)) {
      rowIndex = rowItems.indexOf(item!);
    }
    if (rowIndex != null) {
      selectedRowIndex = rowIndex;
      final selectedItem = values[rowIndex];
      print(selectedItem);

      selectedItemName = selectedItem['Item_Name'];
      _qtyController.text = selectedItem['qty'];
      _unitController.text = selectedItem['unit'];
      _rateController.text = selectedItem['rate'];
      _discPerController.text = selectedItem['discPer'] ?? '';
      _basicController.text = selectedItem['basic'];
      _discRsController.text = selectedItem['discRs'] ?? '';
      _taxController.text = selectedItem['tax'] ?? '';
      _netAmountController.text = selectedItem['netAmount'];
      _baseController.text = selectedItem['base'];
      _mrpController.text = selectedItem['mrp'];
      _amountController.text = selectedItem['amount'];
    } else {
      final selectedItem = item;

      selectedItemName = selectedItem!.itemName;

      selectedItemId = selectedItem.id;

      String newId = '';
      String newId2 = '';

      for (Item item in itemList) {
        if (item.id == selectedItemId) {
          newId = item.taxCategory;
          newId2 = item.measurementUnit;
        }
      }
      for (TaxRate tax in taxLists) {
        if (tax.id == newId) {
          setState(() {
            _taxController.text = tax.rate;
          });
        }
      }
      for (MeasurementLimit meu in measurement) {
        if (meu.id == newId2) {
          setState(() {
            _unitController.text = meu.measurement.toString();
          });
        }
      }

      // Calculate the Rate
      double ratepercent = (double.parse(_taxController.text) / 100);

      ratepercent += 1.00;

      double mpr = selectedItem.mrp;

      double rate = mpr / ratepercent;

      _qtyController.text = "1";
      _rateController.text = rate.toStringAsFixed(2);
      _discPerController.text = "0.00";
      _discRsController.text = "0.00";
      _basicController.text = rate.toStringAsFixed(2);

      _amountController.text = rate.toStringAsFixed(2);

      _mrpController.text = selectedItem.mrp.toStringAsFixed(2);
      _baseController.text = selectedItem.mrp.toStringAsFixed(2);

      final tax = selectedItem.mrp - rate;

      // Change to taxAmountController

      _taxController.text = tax.toStringAsFixed(2);

      // For Net Amount, multiply qty with real rate
      double qty = double.parse(_qtyController.text);
      double rate2 = double.parse(selectedItem.mrp.toString());

      double netAmount = qty * rate2;

      _netAmountController.text = netAmount.toStringAsFixed(2).toString();
      tableKey = UniqueKey();
      selectedRowIndex = null;
    }
    showDialog(
      context: context,
      builder: (context) {
        // Request Focus to Qty
        // FocusScope.of(context).requestFocus(qtyFocus);
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          contentPadding: const EdgeInsets.all(0),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                  maxHeight: 200,
                ),
                height: 200,
                width: MediaQuery.of(context).size.width * 0.70,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Shortcuts(
                  shortcuts: {
                    LogicalKeySet(LogicalKeyboardKey.space):
                        const ActivateIntent(),
                  },
                  child: Focus(
                    autofocus: true,
                    onKey: (node, event) {
                      if (event is RawKeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.space) {
                        // Pop
                        Navigator.of(context).pop();
                        if (!rowItems.contains(item)) {
                          rowItems.add(item!);
                        }

                        _saveValues();
                        _calculateTotalAmount();
                        addTableRow2();
                        dataText.clear();

                        setState(() {});

                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 0, 56, 102),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Text(
                                "$selectedItemName",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: [
                                CustomTextField(
                                  name: "Qty",
                                  // focusNode: qtyFocus,
                                  controller: _qtyController,
                                  onchange: (String value) {
                                    double qty = double.parse(value);
                                    if (qty <= 0) {
                                      setState(() {
                                        _qtyController.text = '1';
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Quantity cannot be less than 1',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } else if (qty >
                                        (item?.maximumStock ??
                                            double.infinity)) {
                                      // Validate against maximum stock only if the item exists
                                      setState(() {
                                        _qtyController.text =
                                            item!.maximumStock.toString();
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Quantity cannot be greater than Maximum Stock',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } else {
                                      _performCalculations();
                                    }
                                  },
                                ),
                                CustomTextField(
                                  name: "Unit",
                                  // focusNode: unitFocus,
                                  isReadOnly: true,
                                  controller: _unitController,

                                  onchange: (String value) {},
                                ),
                                CustomTextField(
                                  name: "Rate",
                                  isReadOnly: true,
                                  // focusNode: rateFocus,
                                  controller: _rateController,
                                  onchange: (String value) {},
                                ),
                                CustomTextField(
                                  name: "Per",
                                  // focusNode: perFocus,
                                  isReadOnly: true,
                                  controller: _unitController,

                                  onchange: (String value) {},
                                ),
                                CustomTextField(
                                  name: "Amount",
                                  // focusNode: amountFocus,
                                  isReadOnly: true,
                                  controller: _amountController,
                                  textAlign: TextAlign.right,

                                  onchange: (String value) {},
                                ),
                                CustomTextField(
                                  name: "Disc.%",
                                  // focusNode: discPerFocus,
                                  controller: _discPerController,
                                  textAlign: TextAlign.right,

                                  onchange: (String value) {
                                    _performCalculations();
                                  },
                                ),
                                CustomTextField(
                                  name: "DiscRs",
                                  // focusNode: discRsFocus,
                                  controller: _discRsController,
                                  textAlign: TextAlign.right,

                                  onchange: (String value) {
                                    _performCalculationsforRS();
                                  },
                                ),
                                CustomTextField(
                                  name: "Tax",
                                  // focusNode: taxFocus,
                                  isReadOnly: true,
                                  controller: _taxController,
                                  textAlign: TextAlign.right,

                                  onchange: (String value) {},
                                ),
                                CustomTextField(
                                  name: "Net Amount",
                                  // focusNode: netAmountFocus,
                                  isReadOnly: true,
                                  controller: _netAmountController,

                                  textAlign: TextAlign.right,
                                  onchange: (String value) {},
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                          height: 40,
                          color: Colors.black,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 5, right: 5),
                              child: Buttons(
                                onTap: () {
                                  // Pop
                                  Navigator.of(context).pop();
                                  if (!rowItems.contains(item)) {
                                    rowItems.add(item!);
                                  }

                                  _saveValues();
                                  _calculateTotalAmount();
                                  addTableRow2();
                                  dataText.clear();
                                },
                                name: "Save",
                                Skey: "[space]",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Buttons(
                                onTap: () => Navigator.pop(context),
                                name: "Cancel",
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  bottom: 10, left: 5, right: 5),
                              child: Buttons(
                                name: "Delete",
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _performCalculations() {
    double qty = double.tryParse(_qtyController.text) ?? 1.0;
    double rate = double.tryParse(_rateController.text) ?? 0.0;
    double base = double.tryParse(_basicController.text) ?? 0.0;
    double mrp = double.tryParse(_mrpController.text) ?? 0.0;
    double discPer = double.tryParse(_discPerController.text) ?? 0.0;
    double discRs = double.tryParse(_discRsController.text) ?? 0.0;
    double tax = double.tryParse(_taxController.text) ?? 0.0;

    double netAmount = (qty * base);
    double amount = qty * rate;

    double taxAmount = tax * qty;
    netAmount += taxAmount;

    discRs = (discPer / 100) * netAmount;
    discPer = (discRs / netAmount) * 100;
    double discountedAmount = netAmount - discRs;

    double finalAmount = discountedAmount;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _amountController.text = amount.toStringAsFixed(2);
        _netAmountController.text = finalAmount.toStringAsFixed(2);
        _taxController.text = taxAmount.toStringAsFixed(2);
        _discPerController.text = discPer.toStringAsFixed(2);
        _discRsController.text = discRs.toStringAsFixed(2);
      });
    });
  }

  void _performCalculationsforRS() {
    double qty = double.tryParse(_qtyController.text) ?? 1.0;
    double rate = double.tryParse(_rateController.text) ?? 0.0;
    double base = double.tryParse(_basicController.text) ?? 0.0;
    double mrp = double.tryParse(_mrpController.text) ?? 0.0;
    double discPer = double.tryParse(_discPerController.text) ?? 0.0;
    double discRs = double.tryParse(_discRsController.text) ?? 0.0;
    double tax = double.tryParse(_taxController.text) ?? 0.0;

    double netAmount = (qty * base);
    double amount = qty * rate;

    double taxAmount = tax * qty;
    netAmount += taxAmount;

    discPer = (discRs / netAmount) * 100;

    discRs = (discPer / 100) * netAmount;
    double discountedAmount = netAmount - discRs;

    double finalAmount = discountedAmount;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _amountController.text = amount.toStringAsFixed(2);
        _netAmountController.text = finalAmount.toStringAsFixed(2);
        _taxController.text = taxAmount.toStringAsFixed(2);
        _discPerController.text = discPer.toStringAsFixed(2);
        _discRsController.text = discRs.toStringAsFixed(2);
      });
    });
  }

  void _showAlert(BuildContext context) {
    double totalBasicAmount = calculateTotalBasicAmount();
    _basicAmountController.text = totalBasicAmount.toStringAsFixed(2);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: InputBorder.none,
              content: Container(
                height: 350,
                width: 500,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.zero,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          left: 13, top: 10, bottom: 5, right: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border:
                            Border.all(color: Colors.grey.shade300, width: .5),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                "Set Discount",
                                style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    "Basic Amount",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                                SETopTextfield(
                                  readOnly: true,
                                  controller: _basicAmountController,
                                  width: 160,
                                  height: 40,
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 16.0),
                                  hintText: '',
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    "Discount Type",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Radio<String>(
                                        value: "Fixed Percentage",
                                        groupValue: _discountType,
                                        onChanged: (value) {
                                          setState(() {
                                            _discountType = value!;
                                          });
                                        },
                                      ),
                                      const Text("Fixed Percentage"),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Radio<String>(
                                        value: "Fixed Amount",
                                        groupValue: _discountType,
                                        onChanged: (value) {
                                          setState(() {
                                            _discountType = value!;
                                          });
                                        },
                                      ),
                                      const Text("Fixed Amount"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    "Discount %",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                                SETopTextfield(
                                  readOnly: _discountType == "Fixed Percentage"
                                      ? false
                                      : true,
                                  onChanged: (value) {
                                    _calculateDiscountFromPercentage();
                                  },
                                  controller: _discountPer,
                                  width: 160,
                                  height: 40,
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 16.0),
                                  hintText: '',
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    "Discount Amt",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                                SETopTextfield(
                                  readOnly: _discountType == "Fixed Percentage"
                                      ? false
                                      : true,
                                  onChanged: (newValue) {
                                    _calculateDiscountFromAmount();
                                  },
                                  controller: _discountAmt,
                                  width: 160,
                                  height: 40,
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 16.0),
                                  hintText: '',
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    "Receivable",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                                SETopTextfield(
                                  readOnly: _discountType != "Fixed Percentage"
                                      ? false
                                      : true,
                                  onChanged: (newValue) {
                                    _calculateDiscountFromReceivable();
                                  },
                                  controller: _receivable,
                                  width: 160,
                                  height: 40,
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 16.0),
                                  hintText: '',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Buttons(
                                  name: "Save",
                                  Skey: "[F4]",
                                  onTap: () {
                                    double discountPercent =
                                        double.tryParse(_discountPer.text) ??
                                            0.0;

                                    _applyDiscountToAllRows(discountPercent);
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Buttons(
                                  name: "Cancel",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ).px12(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _calculateDiscountFromPercentage() {
    double discPer = double.parse(_discountPer.text);
    double basicAmount = double.parse(_basicAmountController.text);
    double discountAmt = basicAmount * (discPer / 100);
    double receivable = basicAmount - discountAmt;
    _discountAmt.text = discountAmt.toStringAsFixed(2);
    _receivable.text = receivable.toStringAsFixed(2);
  }

  void _calculateDiscountFromAmount() {
    double discountAmt = double.parse(_discountAmt.text);
    double basicAmount = double.parse(_basicAmountController.text);
    double receivable = basicAmount - discountAmt;
    double discPer = (discountAmt / basicAmount) * 100;
    _discountPer.text = discPer.toStringAsFixed(2);
    _receivable.text = receivable.toStringAsFixed(2);
  }

  void _calculateDiscountFromReceivable() {
    double receivable = double.parse(_receivable.text);
    double basicAmount = double.parse(_basicAmountController.text);
    double discountAmt = basicAmount - receivable;
    double discPer = (discountAmt / basicAmount) * 100;
    _discountPer.text = discPer.toStringAsFixed(2);
    _discountAmt.text = discountAmt.toStringAsFixed(2);
  }

  void _applyDiscountToAllRows(double discountPercent) {
    for (int i = 0; i < tables.length; i++) {
      String quantityText = _getTextFromTableRow(tables[i], 4);
      double quantity = double.tryParse(quantityText) ?? 1.0;

      String basicText = _getTextFromTableRow(tables[i], 9);
      double basicAmount = double.tryParse(basicText) ?? 0.0;

      double totalBasicAmount = basicAmount * quantity;

      double discountAmount = (totalBasicAmount * discountPercent) / 100;

      double netAmount = totalBasicAmount - discountAmount;

      _updateTableCell(i, 10, discountPercent.toStringAsFixed(2));
      _updateTableCell(i, 11, discountAmount.toStringAsFixed(2));
      _updateTableCell(i, 13, netAmount.toStringAsFixed(2));
    }
    _calculateTotalAmount();
    setState(() {
      tables = tables;
    });
  }

  void saveItems4FirstTime({
    required ValueKey<String> tableKey,
    required String selectedItemId,
    required String selectedItemName,
    required TextEditingController qtyController,
    required TextEditingController unitController,
    required TextEditingController baseController,
    required TextEditingController rateController,
    required TextEditingController mrpController,
    required TextEditingController basicController,
    required TextEditingController discPerController,
    required TextEditingController discRsController,
    required TextEditingController taxController,
    required TextEditingController amountController,
    required TextEditingController netAmountController,
  }) {
    final newItem = {
      'uniqueKey': tableKey.toString(),
      'itemName': selectedItemId,
      'Item_Name': selectedItemName,
      'discPer': discPerController.text,
      'discRs': discRsController.text,
      'tax': taxController.text,
      'qty': qtyController.text,
      'unit': unitController.text,
      'rate': rateController.text,
      'basic': basicController.text,
      'base': baseController.text,
      'mrp': mrpController.text,
      'amount': amountController.text,
      'netAmount': netAmountController.text,
    };

    setState(() {
      values.add(newItem);
    });

    print('Values: $values');
  }

  void _saveValues() {
    final newItem = {
      'uniqueKey': tableKey.toString(),
      'itemName': selectedItemId,
      'Item_Name': selectedItemName,
      'discPer': _discPerController.text,
      'discRs': _discRsController.text,
      'tax': _taxController.text,
      'qty': _qtyController.text,
      'unit': _unitController.text,
      'rate': _rateController.text,
      'basic': _basicController.text,
      'base': _baseController.text,
      'mrp': _mrpController.text,
      'amount': _amountController.text,
      'netAmount': _netAmountController.text,
    };

    if (selectedRowIndex != null) {
      // Update the existing item in the list
      values[selectedRowIndex!] = newItem;
    } else {
      // Check if the item already exists in the list
      bool itemExists = false;
      int existingIndex = -1;
      for (int i = 0; i < values.length; i++) {
        if (values[i]['itemName'] == selectedItemId) {
          itemExists = true;
          existingIndex = i;
          break;
        }
      }

      if (itemExists) {
        // Update quantity and calculate net amount
        final qty = int.parse(values[existingIndex]['qty']) +
            int.parse(newItem['qty']!);
        final mrp = double.parse(values[existingIndex]['mrp']);
        final netAmount = qty * mrp;

        // Update values
        values[existingIndex]['qty'] = qty.toString();
        values[existingIndex]['netAmount'] = netAmount.toStringAsFixed(2);
      } else {
        if (newItem['itemName'] != null) {
          // Add new item to the list
          values.add(newItem);
        }
      }
    }
  }

  void openMultiModeDialog() {
    String? id;

    if (widget.salesPos.type == 'Multimode') {
      id = widget.salesPos.ac == selectedAC ? widget.salesPos.id : null;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 700,
            height: 700,
            child: PopUp2(
              id: id,
              multimodeDetails: multimodeDetails,
              onSaveData: updatePOSEntry,
              totalAmount: double.parse(_netTotalDiscController.text),
              listWidget: Expanded(
                child: ListView.builder(
                  itemCount: values.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> e = values[index];
                    return Row(
                      children: [
                        Container(
                          width: 145,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              width: 100,
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                itemList
                                    .firstWhereOrNull((element) =>
                                        element.id == e['itemName'])!
                                    .itemName,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 145,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              '${e['netAmount']}',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.end,
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
  }

// Calculate the total amount
  void _calculateTotalAmount() {
    double totalAmount = 0.0;
    for (var value in values) {
      totalAmount += double.parse(value['netAmount']);
    }

    setState(() {
      _netTotalDiscController.text = totalAmount.toStringAsFixed(2);
    });

    print(totalAmount);
  }

  double calculateTotalBasicAmount() {
    double totalBasic = 0.0;
    for (var item in rowItems) {
      totalBasic += item.mrp;
    }
    return totalBasic;
  }

  void addTableRow4firstTime({
    String? selectedItemName,
    required ValueKey<String> tableKey,
    required TextEditingController qtyController,
    required TextEditingController unitController,
    required TextEditingController baseController,
    required TextEditingController rateController,
    required TextEditingController mrpController,
    required TextEditingController basicController,
    required TextEditingController discPerController,
    required TextEditingController discRsController,
    required TextEditingController taxController,
    required TextEditingController netAmountController,
    required int index,
  }) {
    print('Index: $index');

    setState(() {
      tables.add(
        TableRow(
          key: tableKey,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          children: [
            // Index
            TableCell(
              child: InkWell(
                onTap: () => updateselectedTable(index),
                child: SizedBox(
                  height: 40,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      (tables.length + 1).toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            TableCell(
              child: InkWell(
                onTap: () => updateselectedTable(index),
                child: SizedBox(
                  height: 40,
                  width: 100,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      selectedItemName!,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            TableCell(
              child: InkWell(
                onTap: () => updateselectedTable(index),
                child: SizedBox(
                  height: 40,
                  width: 100,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      '0',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            TableCell(
              child: InkWell(
                onTap: () => updateselectedTable(index),
                child: SizedBox(
                  height: 40,
                  width: 100,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      '',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            TableCell(
              child: InkWell(
                onTap: () => updateselectedTable(index),
                child: SizedBox(
                  height: 40,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      qtyController.text,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            TableCell(
              child: InkWell(
                onTap: () => updateselectedTable(index),
                child: SizedBox(
                  height: 40,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      unitController.text,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            TableCell(
              child: InkWell(
                onTap: () => updateselectedTable(index),
                child: SizedBox(
                  height: 40,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      baseController.text,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            TableCell(
              child: InkWell(
                onTap: () => updateselectedTable(index),
                child: SizedBox(
                  height: 40,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      rateController.text,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            TableCell(
              child: InkWell(
                onTap: () => updateselectedTable(index),
                child: SizedBox(
                  height: 40,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      mrpController.text,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            TableCell(
              child: InkWell(
                child: SizedBox(
                  height: 40,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      basicController.text,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            TableCell(
              child: InkWell(
                onTap: () => updateselectedTable(index),
                child: SizedBox(
                  height: 40,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      discPerController.text,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            TableCell(
              child: InkWell(
                onTap: () => updateselectedTable(index),
                child: SizedBox(
                  height: 40,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      discRsController.text,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            TableCell(
              child: InkWell(
                onTap: () => updateselectedTable(index),
                child: SizedBox(
                  height: 40,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      taxController.text,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            TableCell(
              child: InkWell(
                onTap: () => updateselectedTable(index),
                child: SizedBox(
                  height: 40,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      netAmountController.text,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  String getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  void showCustomerHistory() {
    final List<SalesPos> selectedCustomerData = salesPosList
        .where((element) => element.customer == selectedCustomer)
        .toList();

    Map<String, List<SalesPos>> groupedData = groupBy(
      selectedCustomerData,
      (SalesPos salesPos) {
        final DateTime createdAt = DateTime.parse(salesPos.createdAt!);
        final String month = getMonthName(createdAt.month);
        final String year = createdAt.year.toString().substring(2);
        return '$month-$year';
      },
    );

    // Construct table rows from the map data

    final List<TableRow> tableRows =
        selectedCustomerData.expand((data) => data.entries).map((entry) {
      final item = itemList.firstWhere((item) => item.id == entry.itemName);

      return TableRow(
        children: [
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                item.itemName,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                entry.qty.toString(),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                entry.rate.toStringAsFixed(2),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                entry.netAmount.toStringAsFixed(2),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                '0',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ],
      );
    }).toList();

    setState(() {
      Ctables2 = tableRows;
    });

    // Construct table data
    final List<TableRow> tableData = selectedCustomerData.map((data) {
      return TableRow(
        children: [
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                extractDate(data.createdAt!),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                extractTime(data.createdAt!),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'TI-${data.no}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data.totalAmount.toStringAsFixed(2),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data.entries.length.toStringAsFixed(2),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '0',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '0',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ],
      );
    }).toList();

    setState(() {
      Ctables = tableData;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: AlignmentDirectional.bottomEnd,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          contentPadding: const EdgeInsets.all(0),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  // height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return Column(
                        children: [
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.85,
                            color: const Color(0xFF4169E1),
                            child: Stack(
                              children: [
                                Center(
                                  child: Text(
                                    'Customer History',
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.70,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SETopText(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            height: 30,
                                            text: 'Customer',
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.00),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all()),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.20,
                                            height: 40,
                                            padding: const EdgeInsets.all(2.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: selectedCustomer,
                                                underline: Container(),
                                                icon: const SizedBox.shrink(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    selectedCustomer =
                                                        newValue!;
                                                  });
                                                },
                                                items: customerList.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (NewCustomerModel value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value.id,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 0,
                                                              left: 5),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            value.fname,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          SizedBox(
                                                            width: 120,
                                                            child: Text(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              '(${value.mobile})',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: SETopText(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.06,
                                              height: 40,
                                              text: 'Date From',
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
                                              controller: _controller,
                                              // focusNode: FocusNode(),
                                              // onEditingComplete: () {},
                                              onSaved: (newValue) {},
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.09,
                                              height: 40,
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, bottom: 16.0),
                                              hintText: '12/12/12'),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                            child: IconButton(
                                                onPressed: () {
                                                  showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(2000),
                                                    lastDate: DateTime(2100),
                                                  ).then((value) {
                                                    if (value != null) {
                                                      setState(() {
                                                        _controller
                                                            .text = DateFormat(
                                                                'MM/dd/yyyy')
                                                            .format(value);
                                                      });
                                                    }
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.calendar_month)),
                                          ),
                                          SETopText(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                            height: 30,
                                            text: ' To',
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
                                          SETopTextfield(
                                              controller: _controller2,
                                              // focusNode: FocusNode(),
                                              // onEditingComplete: () {},
                                              onSaved: (newValue) {},
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.09,
                                              height: 40,
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, bottom: 16.0),
                                              hintText: '12/12/12'),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                            child: IconButton(
                                                onPressed: () {
                                                  showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(2000),
                                                    lastDate: DateTime(2100),
                                                  ).then((value) {
                                                    if (value != null) {
                                                      setState(() {
                                                        _controller2
                                                            .text = DateFormat(
                                                                'MM/dd/yyyy')
                                                            .format(value);
                                                      });
                                                    }
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.calendar_month)),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFFFACD),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFFFFFACD),
                                                  width: 1,
                                                ),
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                              height: 40,
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Center(
                                                child: Text(
                                                  'Show',
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
                                            onTap: () {},
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFFFACD),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFFFFFACD),
                                                  width: 1,
                                                ),
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                              height: 40,
                                              padding:
                                                  const EdgeInsets.all(2.0),
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
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.33,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.43,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Table(
                                                border: TableBorder.all(
                                                    width: 1,
                                                    color: Colors.black),
                                                columnWidths: const {
                                                  0: FlexColumnWidth(4),
                                                  1: FlexColumnWidth(2),
                                                  2: FlexColumnWidth(2),
                                                  3: FlexColumnWidth(3),
                                                  4: FlexColumnWidth(3),
                                                  5: FlexColumnWidth(3),
                                                  6: FlexColumnWidth(3),
                                                },
                                                children: [
                                                  TableRow(children: [
                                                    TableCell(
                                                        child: SizedBox(
                                                      height: 40,
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "Date",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: const Color(
                                                                0xff4B0082),
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                                    TableCell(
                                                      child: SizedBox(
                                                        height: 40,
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "Time",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: const Color(
                                                                  0xff4B0082),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    TableCell(
                                                      child: SizedBox(
                                                        height: 40,
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "No",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: const Color(
                                                                  0xff4B0082),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    TableCell(
                                                      child: SizedBox(
                                                        height: 40,
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Text(
                                                              "Amount",
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: const Color(
                                                                    0xff4B0082),
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
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Text(
                                                              "Items",
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: const Color(
                                                                    0xff4B0082),
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
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Text(
                                                              "Points",
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: const Color(
                                                                    0xff4B0082),
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
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Text(
                                                              "Redeem",
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: const Color(
                                                                    0xff4B0082),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                                  ...Ctables,
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.30,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.40,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Table(
                                                border: TableBorder.all(
                                                    width: 1,
                                                    color: Colors.black),
                                                columnWidths: const {
                                                  0: FlexColumnWidth(3),
                                                  1: FlexColumnWidth(2),
                                                  2: FlexColumnWidth(2),
                                                  3: FlexColumnWidth(2),
                                                  4: FlexColumnWidth(2),
                                                },
                                                children: [
                                                  TableRow(
                                                    children: [
                                                      TableCell(
                                                          child: SizedBox(
                                                        height: 40,
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "Month",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: const Color(
                                                                  0xff4B0082),
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                      TableCell(
                                                        child: SizedBox(
                                                          height: 40,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "Bill",
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
                                                                    0xff4B0082),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: SizedBox(
                                                          height: 40,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "Amount",
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
                                                                    0xff4B0082),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: SizedBox(
                                                          height: 40,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "Points",
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
                                                                    0xff4B0082),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: SizedBox(
                                                          height: 40,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "Redeem",
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
                                                                    0xff4B0082),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  ..._buildTableRows(
                                                      groupedData),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.65,
                                    width: MediaQuery.of(context).size.width *
                                        0.40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Table(
                                          border: TableBorder.all(
                                              width: 1, color: Colors.black),
                                          columnWidths: const {
                                            0: FlexColumnWidth(5),
                                            1: FlexColumnWidth(2),
                                            2: FlexColumnWidth(2),
                                            3: FlexColumnWidth(3),
                                            4: FlexColumnWidth(2),
                                          },
                                          children: [
                                            TableRow(children: [
                                              TableCell(
                                                  child: SizedBox(
                                                height: 40,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Text(
                                                      "Item Name",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xff4B0082),
                                                      ),
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
                                                      "Qty",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xff4B0082),
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
                                                      "Rate",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                            0xff4B0082),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: SizedBox(
                                                  height: 40,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        "Total Amount",
                                                        textAlign:
                                                            TextAlign.end,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: const Color(
                                                              0xff4B0082),
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
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        "Points",
                                                        textAlign:
                                                            TextAlign.end,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: const Color(
                                                              0xff4B0082),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                            ...Ctables2,
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          //  Total Amount Here....
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          'Total Amount: ',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          '₹ ${overralTotal.toStringAsFixed(2)}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Text(
                                          'Total Points: ',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          '0',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.08,
                                            height: 40,
                                            padding: const EdgeInsets.all(2.0),
                                            child: Center(
                                              child: Text(
                                                'XLS',
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
                                          onTap: () {},
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFFACD),
                                              border: Border.all(
                                                color: const Color(0xFFFFFACD),
                                                width: 1,
                                              ),
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.08,
                                            height: 40,
                                            padding: const EdgeInsets.all(2.0),
                                            child: Center(
                                              child: Text(
                                                'Print',
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
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String extractTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
  }

  String extractDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
  }

  List<TableRow> _buildTableRows(Map<String, List<SalesPos>> groupedData) {
    return groupedData.entries.map((entry) {
      String key = entry.key;
      List<SalesPos> value = entry.value;

      double totalAmountForGroup =
          value.fold(0, (sum, salesPos) => sum + salesPos.totalAmount);

      overralTotal = totalAmountForGroup;

      return TableRow(
        children: [
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                key,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '1.00',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                totalAmountForGroup.toStringAsFixed(2),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '0',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '0',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ],
      );
    }).toList();
  }
}
