import 'dart:async';
import 'dart:math';

import 'package:billingsphere/data/models/deliveryChallan/delivery_challan_model.dart';
import 'package:billingsphere/data/models/newCompany/store_model.dart';
import 'package:billingsphere/views/IC_responsive/table_footer_ic.dart';
import 'package:billingsphere/views/IC_responsive/table_header_ic.dart';
import 'package:billingsphere/views/SE_responsive/SE_desktop_body_POS.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/providers/onchange_item_provider.dart';
import '../../data/models/item/item_model.dart';
import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/measurementLimit/measurement_limit_model.dart';
import '../../data/models/newCompany/new_company_model.dart';
import '../../data/models/price/price_category.dart';
import '../../data/repository/delivery_challan_repository.dart';
import '../../data/repository/item_repository.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/measurement_limit_repository.dart';
import '../../data/repository/new_company_repository.dart';
import '../../data/repository/tax_category_repository.dart';
import '../../utils/controllers/inward_challan_controllers.dart';
import '../PM_responsive/payment_desktop.dart';
import '../RV_responsive/RV_desktopBody.dart';
import '../SE_responsive/SE_desktop_body.dart';
import 'DC_master.dart';
import '../IC_responsive/table_row_ic.dart';
import '../PEresponsive/PE_desktop_body.dart';
import '../SE_common/SE_form_buttons.dart';
import '../SE_common/SE_top_text.dart';
import '../SE_common/SE_top_textfield.dart';
import '../SE_variables/SE_variables.dart';
import '../SE_widgets/sundry_row.dart';
import '../sumit_screen/voucher _entry.dart/voucher_list_widget.dart';
import 'DC_receipt.dart';

class DCDesktopBody extends StatefulWidget {
  const DCDesktopBody({super.key});

  @override
  State<DCDesktopBody> createState() => _DCDesktopBodyState();
}

class _DCDesktopBodyState extends State<DCDesktopBody> {
  DateTime? _selectedDate;
  DateTime? _pickedDateData;
  late SharedPreferences _prefs;
  List<String> _companies = [];
  String? userGroup;
  String companyCode = '';
  double ledgerAmount = 0;
  late Timer _timer;
  String selectedsundry = 'Cash Discount';
  String selectedPlaceState = 'Gujarat';
  final List<IEntries> _newWidget = [];
  final List<SundryRow> _newSundry = [];
  List<StoreModel> stores = [];
  String selectedStore = '';
  int _currentSerialNumberSundry = 1;
  final List<Map<String, dynamic>> _allValues = [];
  final List<Map<String, dynamic>> _allValuesSundry = [];
  List<MeasurementLimit> measurement = [];
  List<Item> itemsList = [];
  double Ttotal = 0.00;
  double Tqty = 0.00;
  double Tamount = 0.00;
  double Tsgst = 0.00;
  double Tcgst = 0.00;
  double Tigst = 0.00;
  double TnetAmount = 0.00;

  // FocusNode for textfields
  // final FocusNode _itemFocusNode = FocusNode();
  // final FocusNode _qtyFocusNode = FocusNode();
  // final FocusNode _rateFocusNode = FocusNode();
  // final FocusNode _sundryFocusNode = FocusNode();
  // final FocusNode _amountFocusNode = FocusNode();
  // final FocusNode _noFocusNode = FocusNode();
  // final FocusNode _date1FocusNode = FocusNode();
  // final FocusNode _dcNoFocusNode = FocusNode();
  // final FocusNode _date2FocusNode = FocusNode();
  // final FocusNode _remarkFocusNode = FocusNode();

  final List<NewCompany> _companyList = [];
  bool _isLoading = false;
  String selectedCompany = '';
  final NewCompanyRepository _newCompanyRepository = NewCompanyRepository();

  // Backend Services
  ItemsService itemsService = ItemsService();
  TaxRateService taxRateService = TaxRateService();
  MeasurementLimitService measurementService = MeasurementLimitService();
  DeliveryChallanServices deliver = DeliveryChallanServices();
  List<String>? company;
  Future<List<String>?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('companies');
  }

  Future<void> setCompanyCode() async {
    List<String>? code = await getCompanyCode();
    setState(() {
      company = code;
    });
  }

  Future<void> getCompany() async {
    final allCompany = await _newCompanyRepository.getAllCompanies();

    allCompany.insert(
      0,
      NewCompany(
        id: '',
        acYear: '',
        companyType: '',
        companyCode: '',
        companyName: '',
        country: '',
        taxation: '',
        acYearTo: '',
        password: '',
        email: '',
      ),
    );
    _companyList.addAll(allCompany);

    print("Company List: $_companyList");
  }

  DeliveryChallanServices deliveryChallanRepo = DeliveryChallanServices();
  List<DeliveryChallan> fetchedDelivery = [];
  String? selectedId;
  String? selectedPriceTypeId;
  List<PriceCategory> pricecategory = [];
  LedgerService ledgerService = LedgerService();
  List<Ledger> suggestionItems5 = [];
  String? selectedLedgerName;

  InwardChallanController inwardChallanController = InwardChallanController();
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
    'Delhi',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal'
  ];

  Future<void> fetchAllDC() async {
    try {
      final List<DeliveryChallan> dc =
          await deliveryChallanRepo.fetchDeliveryChallan();

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        if (dc.isNotEmpty) {
          fetchedDelivery = dc;
          selectedId = fetchedDelivery[0].id;
        } else {
          fetchedDelivery = dc;
        }
      });
    } catch (error) {
      print('Failed to fetch Devlivery Challan: $error');
    }
  }

  void _initializeEverything() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _initializaControllers();
      _generateBillNumber();
      await Future.wait([
        fetchLedgers(),
        fetchItems(),
        fetchMeasurementLimit(),
        fetchAllDC(),
        // getCompany(),
        initialize(),
      ]);

      _generateEntries();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchMeasurementLimit() async {
    try {
      final List<MeasurementLimit> measurements =
          await measurementService.fetchMeasurementLimits();

      setState(() {
        measurement = measurements;
        // selectedmeasurementId =
        //     measurement.isNotEmpty ? measurement.first.id : null;
      });
    } catch (error) {
      print('Failed to fetch Tax Rates: $error');
    }
  }

  Future<void> fetchItems() async {
    try {
      final List<Item> items = await itemsService.fetchItems();

      items.insert(
        0,
        Item(
          id: '',
          itemName: '',
          itemGroup: '',
          itemBrand: '',
          hsnCode: '',
          mrp: 0.0,
          taxCategory: '',
          measurementUnit: '',
          secondaryUnit: '',
          barcode: '',
          codeNo: '0',
          date: DateTime.now().toString(),
          dealer: 0,
          maximumStock: 0,
          minimumStock: 0,
          monthlySalesQty: 0,
          openingStock: '0',
          price: 0,
          printName: '',
          retail: 0,
          status: '',
          storeLocation: '',
          subDealer: 0,
          openingBalance: [],
          openingBalanceAmt: 0.00,
          openingBalanceQty: 0.00,
        ),
      );

      setState(() {
        itemsList = items;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> fetchLedgers() async {
    try {
      final List<Ledger> ledger = await ledgerService.fetchLedgers();

      // Add empty data on the 0 index
      ledger.insert(
        0,
        Ledger(
          id: '',
          address: '',
          aliasName: '',
          bankName: '',
          branchName: '',
          date: '',
          ifsc: '',
          accName: '',
          accNo: '',
          bilwiseAccounting: '',
          city: '',
          contactPerson: '',
          creditDays: 0,
          cstDated: '',
          cstNo: '',
          email: '',
          fax: 0,
          gst: '',
          gstDated: '',
          ledgerCode: 0,
          ledgerGroup: '',
          ledgerType: '',
          mobile: 0,
          lstDated: '',
          lstNo: '',
          mailingName: '',
          name: '',
          openingBalance: 0,
          debitBalance: 0,
          panNo: '',
          pincode: 0,
          priceListCategory: '',
          printName: '',
          region: '',
          registrationType: '',
          registrationTypeDated: '',
          remarks: '',
          serviceTaxDated: '',
          serviceTaxNo: '',
          sms: 0,
          state: '',
          status: 'Yes',
          tel: 0,
        ),
      );

      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        suggestionItems5 = ledger;
      });
    } catch (error) {}
  }

  @override
  void initState() {
    super.initState();
    setCompanyCode();
    _initializeEverything();
    _companyFuture = getCompany();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  late Future<void> _companyFuture;

  Future<void> createChallan() async {
    // Check for empty fields
    if (inwardChallanController.noController.text.isEmpty ||
        inwardChallanController.dateController1.text.isEmpty ||
        inwardChallanController.dcNoController.text.isEmpty ||
        inwardChallanController.dateController2.text.isEmpty ||
        _allValues.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields'),
        ),
      );
      return;
    }
    final challan = DeliveryChallan(
      no: int.parse(inwardChallanController.noController.text),
      date: inwardChallanController.dateController1.text,
      party: selectedCompany,
      place: selectedPlaceState,
      ledger: selectedLedgerName!,
      dcNo: inwardChallanController.dcNoController.text,
      date2: inwardChallanController.dateController2.text,
      remark: inwardChallanController.remarkController.text,
      id: '1',
      companyCode: selectedStore,
      type: company!.first,
      totalamount: (TnetAmount + Ttotal).toString(),
      entries: _allValues.map((entry) {
        return DEntry(
          itemName: entry['itemName'],
          qty: int.tryParse(entry['qty']) ?? 0,
          rate: double.tryParse(entry['rate']) ?? 0,
          unit: entry['unit'],
          netAmount: double.tryParse(entry['netAmount']) ?? 0,
        );
      }).toList(),
      sundry: _allValuesSundry.map((sundry) {
        return DSundry2(
          sundryName: sundry['sndryName'],
          amount: double.tryParse(sundry['sundryAmount']) ?? 0,
        );
      }).toList(),
    );

    final DeliveryChallanServices deliveryChallanServices =
        DeliveryChallanServices();

    await deliveryChallanServices.createDeliveryChallan(challan);

    fetchAllDC().then((_) {
      final newDeliveryChallan = fetchedDelivery.firstWhere(
        (element) => element.no == challan.no,
        orElse: () => DeliveryChallan(
          id: '',
          companyCode: '',
          no: 0,
          date: '',
          type: '',
          party: '',
          place: '',
          ledger: '',
          dcNo: '',
          date2: '',
          totalamount: '',
          entries: [],
          sundry: [],
          remark: '',
        ),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Print Receipt?'),
            content: const Text('Do you want to print the receipt?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => DCReceipt(
                          deliveryChallan: newDeliveryChallan.id,
                          'Print Delivery Challan Receipt'),
                    ),
                  );
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  // Add code here to handle printing the receipt
                  Navigator.of(context).pop();
                },
                child: const Text('No'),
              ),
            ],
          );
        },
      );
    });

    // Show dialog for printing receipt
    clearAllData();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Challan created successfully'),
      ),
    );
  }

  void clearAllData() {
    setState(() {
      _newWidget.clear();
      _allValues.clear();
      _newSundry.clear();
      _allValuesSundry.clear();
      Ttotal = 0.00;
      Tqty = 0.00;
      Tamount = 0.00;
      Tsgst = 0.00;
      Tcgst = 0.00;
      Tigst = 0.00;
      TnetAmount = 0.00;
      inwardChallanController.amountController.clear();
      inwardChallanController.itemNameController.clear();
      inwardChallanController.qtyController.clear();
      inwardChallanController.rateController.clear();
      inwardChallanController.sundryController.clear();
      inwardChallanController.amountController.clear();
      inwardChallanController.noController.clear();
      inwardChallanController.dateController1.clear();
      inwardChallanController.dcNoController.clear();
      inwardChallanController.dateController2.clear();
      inwardChallanController.remarkController.clear();
    });

    _generateBillNumber();
    _generateEntries();
  }

  void addNewLine() {
    final entryId = Random().nextInt(100000);
    setState(() {
      _newWidget.add(IEntries(
        key: ValueKey(entryId),
        itemNameControllerP: inwardChallanController.itemNameController,
        qtyControllerP: inwardChallanController.qtyController,
        rateControllerP: inwardChallanController.rateController,
        unitControllerP: inwardChallanController.unitController,
        netAmountControllerP: inwardChallanController.netAmountController,
        selectedLegerId: '',
        serialNumber: _newWidget.length + 1,
        entryId: entryId.toString(),
        onSaveValues: saveValues,
        item: itemsList,
        measurementLimit: measurement,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.escape): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.f2): const NavigateToListIntent(),
        LogicalKeySet(LogicalKeyboardKey.f5): const NavigateToPaymentIntent(),
        LogicalKeySet(LogicalKeyboardKey.f6): const NavigateToReceiptIntent(),
        LogicalKeySet(LogicalKeyboardKey.f9): const CreateNewLineIntent(),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeliveryChallanHome(),
                ),
              );
              return KeyEventResult.handled;
            },
          ),
          NavigateToPaymentIntent: CallbackAction<NavigateToPaymentIntent>(
            onInvoke: (NavigateToPaymentIntent intent) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PMMyPaymentDesktopBody(),
                ),
              );
              return KeyEventResult.handled;
            },
          ),
          NavigateToReceiptIntent: CallbackAction<NavigateToReceiptIntent>(
            onInvoke: (NavigateToReceiptIntent intent) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RVDesktopBody(),
                ),
              );
              return KeyEventResult.handled;
            },
          ),
          CreateNewLineIntent: CallbackAction<CreateNewLineIntent>(
            onInvoke: (CreateNewLineIntent intent) {
              addNewLine();
              return KeyEventResult.handled;
            },
          ),
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 50.0, // Adjust the height as needed
            backgroundColor: Colors
                .transparent, // Make the background transparent for layering
            elevation: 0.0, // Remove the elevation to prevent shadow
            scrolledUnderElevation: 0.0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
            flexibleSpace: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width *
                      0.20, // Half the width of the screen
                  color: const Color(0xffA0522D),
                  child: Center(
                    child: Text(
                      'Delivery Challan',
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
                      color: Color(0xff0000FF),
                    ),
                    child: Center(
                      child: Text(
                        'Delivery Note Entry',
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
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.901,
                      child: Form(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, top: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        SETopText(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.08,
                                          height: 30,
                                          text: 'No',
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.00),
                                        ),
                                        SETopTextfield(
                                          // focusNode: _noFocusNode,
                                          controller: inwardChallanController
                                              .noController,
                                          onSaved: (newValue) {
                                            inwardChallanController
                                                .noController.text = newValue!;
                                          },
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
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: SETopText(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            height: 30,
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
                                          // focusNode: _date1FocusNode,
                                          controller: inwardChallanController
                                              .dateController1,
                                          onSaved: (newValue) {
                                            inwardChallanController
                                                .dateController1
                                                .text = newValue!;
                                          },
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.0925,
                                          height: 40,
                                          padding: const EdgeInsets.only(
                                              left: 8.0, bottom: 16.0),
                                          hintText: _selectedDate == null
                                              ? ''
                                              : formatter
                                                  .format(_selectedDate!),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          child: IconButton(
                                              onPressed: _presentDatePICKER,
                                              icon: const Icon(
                                                  Icons.calendar_month)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                              0.08,
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
                                                0.00,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all()),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.207,
                                          height: 40,
                                          padding: const EdgeInsets.all(2.0),
                                          child: FutureBuilder(
                                            future: _companyFuture,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return const SizedBox.shrink();
                                              }
                                              return DropdownButtonHideUnderline(
                                                child: DropdownMenu<NewCompany>(
                                                  requestFocusOnTap: true,
                                                  initialSelection:
                                                      _companyList.isNotEmpty
                                                          ? _companyList.first
                                                          : null,
                                                  enableSearch: true,
                                                  trailingIcon:
                                                      const SizedBox.shrink(),
                                                  textStyle:
                                                      GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
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
                                                  expandedInsets:
                                                      EdgeInsets.zero,
                                                  onSelected:
                                                      (NewCompany? value) {
                                                    setState(() {
                                                      selectedCompany =
                                                          value!.companyCode!;
                                                    });
                                                    print(selectedCompany);
                                                    final selectedCompanyStores =
                                                        _companyList
                                                            .where((element) =>
                                                                element
                                                                    .companyCode ==
                                                                selectedCompany)
                                                            .toList();

                                                    print(
                                                        selectedCompanyStores);
                                                    final stores =
                                                        selectedCompanyStores[0]
                                                            .stores;
                                                    setState(() {
                                                      this.stores = stores!;
                                                      selectedStore =
                                                          stores[0].code!;
                                                    });
                                                  },
                                                  dropdownMenuEntries:
                                                      _companyList.map<
                                                              DropdownMenuEntry<
                                                                  NewCompany>>(
                                                          (NewCompany value) {
                                                    return DropdownMenuEntry<
                                                        NewCompany>(
                                                      value: value,
                                                      label: value.companyName!,
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
                                              );
                                            },
                                          ),

                                          // child: DropdownButtonHideUnderline(
                                          //   child: DropdownButton<String>(
                                          //     value: selectedCompany,
                                          //     underline: Container(),
                                          //     onChanged: (String? newValue) {
                                          //       setState(() {
                                          //         selectedCompany = newValue!;
                                          //       });
                                          //       final selectedCompanyStores =
                                          //           _companyList
                                          //               .where((element) =>
                                          //                   element
                                          //                       .companyCode ==
                                          //                   selectedCompany)
                                          //               .toList();
                                          //       print(selectedCompanyStores);
                                          //       final stores =
                                          //           selectedCompanyStores[0]
                                          //               .stores;
                                          //       setState(() {
                                          //         this.stores = stores!;
                                          //         selectedStore =
                                          //             stores[0].code!;
                                          //       });
                                          //     },
                                          //     items: _companyList
                                          //         .map((NewCompany company) {
                                          //       return DropdownMenuItem<
                                          //           String>(
                                          //         value: company.companyCode!,
                                          //         child: Row(
                                          //           mainAxisAlignment:
                                          //               MainAxisAlignment
                                          //                   .spaceBetween,
                                          //           children: [
                                          //             Text(company
                                          //                 .companyName!
                                          //                 .toUpperCase()),
                                          //           ],
                                          //         ),
                                          //       );
                                          //     }).toList(),
                                          //   ),
                                          // ),
                                        ),
                                        const SizedBox(width: 40),
                                        SETopText(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.08,
                                          height: 30,
                                          text: 'Place',
                                          padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.005,
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.00,
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.00,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all()),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.14,
                                          height: 40,
                                          padding: const EdgeInsets.all(2.0),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownMenu<StoreModel>(
                                              requestFocusOnTap: true,
                                              initialSelection:
                                                  stores.isNotEmpty
                                                      ? stores.first
                                                      : null,
                                              enableSearch: true,
                                              trailingIcon:
                                                  const SizedBox.shrink(),
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
                                              onSelected: (StoreModel? value) {
                                                setState(() {
                                                  // selectedPlaceState =
                                                  //     newValue!;
                                                  // inwardChallanController
                                                  //         .placeController
                                                  //         .text =
                                                  //     selectedPlaceState;

                                                  selectedStore = value!.code!;
                                                });
                                              },
                                              dropdownMenuEntries: stores.map<
                                                      DropdownMenuEntry<
                                                          StoreModel>>(
                                                  (StoreModel value) {
                                                return DropdownMenuEntry<
                                                    StoreModel>(
                                                  value: value,
                                                  label:
                                                      value.city.toUpperCase(),
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

                                          // child: DropdownButtonHideUnderline(
                                          //   child: DropdownButton<String>(
                                          //     menuMaxHeight: 300,
                                          //     isExpanded: true,
                                          //     value: selectedStore,
                                          //     underline: Container(),
                                          //     onChanged: (String? newValue) {
                                          //       setState(() {
                                          //         // selectedPlaceState =
                                          //         //     newValue!;
                                          //         // inwardChallanController
                                          //         //         .placeController
                                          //         //         .text =
                                          //         //     selectedPlaceState;

                                          //         selectedStore = newValue!;
                                          //       });
                                          //     },
                                          //     items: stores
                                          //         .map((StoreModel value) {
                                          //       return DropdownMenuItem<
                                          //           String>(
                                          //         value: value.code,
                                          //         child: Padding(
                                          //           padding:
                                          //               const EdgeInsets.all(
                                          //                   2.0),
                                          //           child: Text(
                                          //             value.city
                                          //                 .toUpperCase(),
                                          //           ),
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
                            const SizedBox(height: 2),
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
                                              0.08,
                                          height: 30,
                                          text: 'Store Ledger ',
                                          padding: EdgeInsets.only(
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.00,
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.00,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.207,
                                          height: 40,
                                          padding: const EdgeInsets.all(2.0),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownMenu<Ledger>(
                                              requestFocusOnTap: true,
                                              initialSelection:
                                                  suggestionItems5.isNotEmpty
                                                      ? suggestionItems5.first
                                                      : null,
                                              enableSearch: true,
                                              enableFilter: true,
                                              filterCallback: (List<
                                                          DropdownMenuEntry<
                                                              Ledger>>
                                                      entries,
                                                  String filter) {
                                                final String trimmedFilter =
                                                    filter.trim().toLowerCase();

                                                if (trimmedFilter.isEmpty) {
                                                  return entries;
                                                }

                                                final filteredEntries =
                                                    entries.where((entry) {
                                                  final ledger = entry.value;
                                                  return ledger.name
                                                      .toLowerCase()
                                                      .contains(trimmedFilter);
                                                }).toList();

                                                if (filteredEntries.isEmpty) {
                                                  return [];
                                                }

                                                return filteredEntries;
                                              },
                                              trailingIcon:
                                                  const SizedBox.shrink(),
                                              textStyle: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                decoration: TextDecoration.none,
                                              ),
                                              menuHeight: 300,
                                              width: 400,
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
                                              onSelected: (Ledger? value) {
                                                setState(() {
                                                  if (value != null) {
                                                    selectedLedgerName =
                                                        value.id;
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
                            const SizedBox(height: 2),
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
                                              0.08,
                                          height: 30,
                                          text: 'DC No',
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
                                          // focusNode: _dcNoFocusNode,
                                          controller: inwardChallanController
                                              .dcNoController,
                                          onSaved: (newValue) {
                                            inwardChallanController
                                                .dcNoController
                                                .text = newValue!;
                                          },
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.207,
                                          height: 40,
                                          padding: const EdgeInsets.only(
                                              left: 8.0, bottom: 16.0),
                                          hintText: '',
                                        ),
                                        const SizedBox(width: 40),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 0.0, left: 8.0),
                                          child: SETopText(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.08,
                                            height: 30,
                                            text: 'Date',
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.00),
                                          ),
                                        ),
                                        SETopTextfield(
                                          // focusNode: _date2FocusNode,
                                          controller: inwardChallanController
                                              .dateController2,
                                          onSaved: (newValue) {
                                            inwardChallanController
                                                .dateController2
                                                .text = newValue!;
                                          },
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.14,
                                          height: 40,
                                          padding: const EdgeInsets.only(
                                              left: 8.0, bottom: 16.0),
                                          hintText: _pickedDateData == null
                                              ? ''
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
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            _isLoading
                                ? const TableExample(rows: 7, cols: 13)
                                : Column(
                                    children: [
                                      const NotaTable2(),
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
                                          NotaTableFooter2(
                                            qty: Tqty,
                                            amount: Tamount,
                                            netAmount: TnetAmount,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
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
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: const Color(
                                                                0xff4B0082),
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: SETopTextfield(
                                                          // focusNode:
                                                          //     _remarkFocusNode,
                                                          controller:
                                                              inwardChallanController
                                                                  .remarkController,
                                                          onSaved: (newValue) {
                                                            inwardChallanController
                                                                .dateController2
                                                                .text = newValue!;
                                                          },
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.67,
                                                          height: 40,
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  bottom: 16.0),
                                                          hintText: '',
                                                        ),
                                                      ),

                                                      // Flexible(
                                                      //   child: Container(
                                                      //     width: MediaQuery.of(
                                                      //                 context)
                                                      //             .size
                                                      //             .width *
                                                      //         0.67,
                                                      //     height: 40,
                                                      //     decoration:
                                                      //         BoxDecoration(
                                                      //       border: Border.all(
                                                      //           color: Colors
                                                      //               .black),
                                                      //       borderRadius:
                                                      //           BorderRadius
                                                      //               .circular(
                                                      //                   0),
                                                      //     ),
                                                      //     child: Padding(
                                                      //       padding:
                                                      //           const EdgeInsets
                                                      //               .all(8.0),
                                                      //       child:
                                                      //           TextFormField(
                                                      //         controller:
                                                      //             inwardChallanController
                                                      //                 .remarkController,
                                                      //         onSaved:
                                                      //             (newValue) {
                                                      //           inwardChallanController
                                                      //                   .remarkController
                                                      //                   .text =
                                                      //               newValue!;
                                                      //         },
                                                      //         style:
                                                      //             const TextStyle(
                                                      //           fontWeight:
                                                      //               FontWeight
                                                      //                   .bold,
                                                      //           fontSize: 17,
                                                      //           height: 1,
                                                      //         ),
                                                      //         decoration:
                                                      //             const InputDecoration(
                                                      //           border:
                                                      //               InputBorder
                                                      //                   .none,
                                                      //         ),
                                                      //       ),
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
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
                                                          border: Border.all(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                44, 43, 43),
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
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                    color: const Color(
                                                                        0xff4B0082),
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
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.3,
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
                                                                    child:
                                                                        SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.5,
                                                                      height:
                                                                          30,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              'Limit',
                                                                              textAlign: TextAlign.center,
                                                                              style: GoogleFonts.poppins(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 16,
                                                                                color: const Color(0xff4B0082),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                2,
                                                                            height:
                                                                                30,
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                44,
                                                                                43,
                                                                                43),
                                                                          ),
                                                                          // Change Ledger Amount
                                                                          Expanded(
                                                                            child:
                                                                                Container(
                                                                              color: const Color(0xffA0522D),
                                                                              child: const Center(
                                                                                child: Text(
                                                                                  '',
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
                                                                            width:
                                                                                2,
                                                                            height:
                                                                                30,
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                44,
                                                                                43,
                                                                                43),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              'Bal',
                                                                              textAlign: TextAlign.center,
                                                                              style: GoogleFonts.poppins(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 16,
                                                                                color: const Color(0xff4B0082),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                2,
                                                                            height:
                                                                                30,
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                44,
                                                                                43,
                                                                                43),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Container(
                                                                              color: const Color(0xffA0522D),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  '0.00 Dr',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: GoogleFonts.poppins(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 16,
                                                                                    color: const Color(0xffffffff),
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
                                                              0.4,
                                                          height: 170,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: const Color
                                                                  .fromARGB(255,
                                                                  44, 43, 43),
                                                              width: 2,
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
                                                                          BoxDecoration(
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      height:
                                                                          30,
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
                                                                              const Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            243,
                                                                            132,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          'Statements',
                                                                          style:
                                                                              GoogleFonts.poppins(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                const Color(0xff000000),
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
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            16,
                                                                        color: const Color(
                                                                            0xff4B0082),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 4,
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      height:
                                                                          30,
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
                                                                          backgroundColor: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              255,
                                                                              243,
                                                                              132),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          'Purchase',
                                                                          style:
                                                                              GoogleFonts.poppins(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                const Color(0xff000000),
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
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                child: Row(
                                                                  children: List
                                                                      .generate(
                                                                    headerTitles
                                                                        .length,
                                                                    (index) =>
                                                                        Expanded(
                                                                      child:
                                                                          Text(
                                                                        headerTitles[
                                                                            index],
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              const Color(0xff4B0082),
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
                                                                    children: const [
                                                                      // Iterate over all purchases' entries
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.22,
                                        height: 210,
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: const Color(
                                                            0xff4B0082),
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
                                                          color: Colors.black),
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {},
                                                      child: Text(
                                                        'Save All',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: const Color(
                                                              0xff000000),
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
                                                          color: Colors.black),
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
                                                                    inwardChallanController
                                                                        .sundryController,
                                                                sundryControllerQ:
                                                                    inwardChallanController
                                                                        .amountController,
                                                                onSaveValues:
                                                                    (p0) {},
                                                                entryId:
                                                                    entryId,
                                                                onDelete: (String
                                                                    entryId) {
                                                                  setState(() {
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
                                                                      if (entry[
                                                                              'uniqueKey'] ==
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
                                                                          .remove(
                                                                              entryToRemove);
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
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: const Color(
                                                              0xff000000),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.14,
                                      height: 30,
                                      onPressed: createChallan,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.14,
                                      height: 30,
                                      onPressed: () {},
                                      buttonText: 'Delete',
                                    )
                                  ],
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 20,
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: Text(
                                      'Amount: ',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: const Color(0xff000000),
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
                                        bottom: BorderSide(width: 2),
                                      ),
                                    ),
                                    child: Text(
                                      '${TnetAmount + Ttotal}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: const Color(0xff000000),
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
                    Shortcuts(
                      shortcuts: {
                        LogicalKeySet(LogicalKeyboardKey.f3):
                            const ActivateIntent(),
                        LogicalKeySet(LogicalKeyboardKey.f4):
                            const ActivateIntent(),
                      },
                      child: Focus(
                        autofocus: true,
                        onKey: (node, event) {
                          if (event is RawKeyDownEvent &&
                              event.logicalKey == LogicalKeyboardKey.f2) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DeliveryChallanHome(),
                              ),
                            );
                            return KeyEventResult.handled;
                          } else if (event is RawKeyDownEvent &&
                              event.logicalKey == LogicalKeyboardKey.f12) {
                            final entryId = UniqueKey().toString();
                          } else if (event is RawKeyDownEvent &&
                              event.logicalKey == LogicalKeyboardKey.keyM) {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => ItemHome(),
                            //   ),
                            // );
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
                                      builder: (context) =>
                                          const DeliveryChallanHome(),
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
                                  Skey: "P", name: "Print", onTap: () {}),
                              CustomList(Skey: "", name: "", onTap: () {}),
                              CustomList(
                                  Skey: "F5", name: "Payment", onTap: () {}),
                              CustomList(Skey: "", name: "", onTap: () {}),
                              CustomList(
                                  Skey: "F6", name: "Receipt", onTap: () {}),
                              CustomList(
                                Skey: "F7",
                                name: "Journal",
                                onTap: () {},
                              ),
                              CustomList(
                                Skey: "F9",
                                name: "Add Line",
                                onTap: addNewLine,
                              ),
                              CustomList(Skey: "", name: "", onTap: () {}),
                              CustomList(
                                Skey: "",
                                name: "",
                                onTap: () {},
                              ),
                              CustomList(Skey: "", name: "", onTap: () {}),
                              CustomList(Skey: "", name: "", onTap: () {}),
                              CustomList(
                                  Skey: "PgUp", name: "Previous", onTap: () {}),
                              CustomList(
                                  Skey: "PgDn", name: "Next", onTap: () {}),
                              CustomList(Skey: "", name: "", onTap: () {}),
                              CustomList(
                                  Skey: "G", name: "Attach. Img", onTap: () {}),
                              CustomList(Skey: "", name: "", onTap: () {}),
                              CustomList(
                                  Skey: "G", name: "Vch Setup", onTap: () {}),
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
              ],
            ),
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
        inwardChallanController.dateController1.text =
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
        inwardChallanController.dateController2.text =
            formatter.format(pickedDate);
      });
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

  // Calculate total debit and credit
  void calculateTotal() {
    double qty = 0.00;
    double netAmount = 0.00;
    for (var values in _allValues) {
      qty += double.tryParse(values['qty']) ?? 0;
      netAmount += double.tryParse(values['netAmount']) ?? 0;
    }
    setState(() {
      Tqty = qty;
      TnetAmount = netAmount;
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
  }

  void _startTimer() {
    const Duration duration = Duration(seconds: 2);
    _timer = Timer.periodic(duration, (Timer timer) {
      calculateTotal();
      calculateSundry();
    });
  }

  void _generateBillNumber() {
    Random random = Random();
    int randomNumber = random.nextInt(9000) + 1000;
    String monthAbbreviation = _getMonthAbbreviation(DateTime.now().month);
    String billNumber = 'BIL$randomNumber$monthAbbreviation';

    if (mounted) {
      setState(() {
        inwardChallanController.dcNoController.text = billNumber;
        inwardChallanController.noController.text = randomNumber.toString();
      });
    }
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

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> initialize() async {
    await _initPrefs().then((value) => {
          setState(() {
            _companies = _prefs.getStringList('companies') ?? [];
            userGroup = _prefs.getString('usergroup');
          })
        });
  }

  void _generateEntries() {
    for (int i = 0; i < 5; i++) {
      final entryId = UniqueKey().toString();
      setState(() {
        _newWidget.add(IEntries(
          key: ValueKey(entryId),
          itemNameControllerP: inwardChallanController.itemNameController,
          qtyControllerP: inwardChallanController.qtyController,
          rateControllerP: inwardChallanController.rateController,
          unitControllerP: inwardChallanController.unitController,
          netAmountControllerP: inwardChallanController.netAmountController,
          selectedLegerId: '',
          serialNumber: i + 1,
          entryId: entryId,
          onSaveValues: saveValues,
          item: itemsList,
          measurementLimit: measurement,
        ));
      });
    }
  }

  void _initializaControllers() {
    inwardChallanController.dateController1.text =
        formatter.format(DateTime.now());
    inwardChallanController.dateController2.text =
        formatter.format(DateTime.now());
  }
}

class CreateNewLineIntent extends Intent {
  const CreateNewLineIntent();
}

class NavigateToReceiptIntent extends Intent {
  const NavigateToReceiptIntent();
}

class NavigateToPaymentIntent extends Intent {
  const NavigateToPaymentIntent();
}
