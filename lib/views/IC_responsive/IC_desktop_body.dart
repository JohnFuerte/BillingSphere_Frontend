import 'dart:async';
import 'dart:math';

import 'package:billingsphere/views/IC_responsive/table_footer_ic.dart';
import 'package:billingsphere/views/IC_responsive/table_header_ic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/providers/onchange_item_provider.dart';
import '../../data/models/inwardChallan/inward_challan_model.dart';
import '../../data/models/measurementLimit/measurement_limit_model.dart';
import '../../data/models/newCompany/new_company_model.dart';
import '../../data/models/newCompany/store_model.dart';
import '../../data/repository/inward_challan_repository.dart';
import '../../data/repository/new_company_repository.dart';
import '../../utils/controllers/inward_challan_controllers.dart';
import '../PEresponsive/PE_desktop_body.dart';
import '../RA_widgets/RA_D_side_buttons.dart';
import '../SE_common/SE_form_buttons.dart';
import '../SE_common/SE_top_text.dart';
import '../SE_common/SE_top_textfield.dart';
import '../SE_variables/SE_variables.dart';
import '../SE_widgets/sundry_row.dart';
import '../sumit_screen/voucher _entry.dart/voucher_list_widget.dart';
import 'IC_master.dart';
import 'table_row_ic.dart';

class ICDesktopBody extends StatefulWidget {
  const ICDesktopBody({super.key});

  @override
  State<ICDesktopBody> createState() => _ICDesktopBodyState();
}

class _ICDesktopBodyState extends State<ICDesktopBody> {
  DateTime? _selectedDate;
  DateTime? _pickedDateData;
  late SharedPreferences _prefs;
  List<String> _companies = [];
  String? userGroup;
  String companyCode = '';
  double ledgerAmount = 0;
  bool isLoading = false;
  late Timer _timer;
  String selectedsundry = 'Cash Discount';
  String selectedPlaceState = 'Gujarat';
  final List<IEntries> _newWidget = [];
  final List<SundryRow> _newSundry = [];
  int _currentSerialNumberSundry = 1;
  final List<Map<String, dynamic>> _allValues = [];
  final List<Map<String, dynamic>> _allValuesSundry = [];
  List<MeasurementLimit> measurement = [];
  double Ttotal = 0.00;
  double Tqty = 0.00;
  double Tamount = 0.00;
  double Tsgst = 0.00;
  double Tcgst = 0.00;
  double Tigst = 0.00;
  double TnetAmount = 0.00;

  final List<NewCompany> _companyList = [];
  bool _isLoading = false;
  List<StoreModel> stores = [];

  String selectedCompany = '';
  String selectedStore = '';

  final NewCompanyRepository _newCompanyRepository = NewCompanyRepository();

  Future<void> getCompany() async {
    setState(() {
      _isLoading = true;
    });
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

    setState(() {
      if (allCompany.isNotEmpty) {
        _companyList.addAll(allCompany);
      } else {
        _companyList.clear();
      }
      _isLoading = false;
    });
  }

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

  void _initializeEverything() async {
    setState(() {
      _isLoading = true;
    });
    await initialize();
    _initializaControllers();
    _generateBillNumber();

    // Delay
    Future.delayed(const Duration(milliseconds: 5000), () {});

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeEverything();
    _startTimer();
  }

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
    final challan = InwardChallan(
      no: int.parse(inwardChallanController.noController.text),
      date: inwardChallanController.dateController1.text,
      party: selectedCompany,
      place: selectedPlaceState,
      dcNo: inwardChallanController.dcNoController.text,
      date2: inwardChallanController.dateController2.text,
      remark: inwardChallanController.remarkController.text,
      id: '1',
      companyCode: selectedStore,
      type: selectedCompany,
      totalamount: (TnetAmount + Ttotal).toString(),
      entries: _allValues.map((entry) {
        return Entry(
          itemName: entry['itemName'],
          qty: int.tryParse(entry['qty']) ?? 0,
          rate: double.tryParse(entry['rate']) ?? 0,
          unit: entry['unit'],
          netAmount: double.tryParse(entry['netAmount']) ?? 0,
        );
      }).toList(),
      sundry: _allValuesSundry.map((sundry) {
        return Sundry2(
          sundryName: sundry['sndryName'],
          amount: double.tryParse(sundry['sundryAmount']) ?? 0,
        );
      }).toList(),
    );

    final InwardChallanServices inwardChallanServices = InwardChallanServices();

    inwardChallanServices.createInwardChallan(challan).then((value) => {
          clearAllData(),
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Challan created successfully'),
            ),
          ),
        });
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
      // Clear all the controllers
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

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.deepOrangeAccent,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            CupertinoIcons.arrow_left,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45),
                        Text(
                          'RECEIPT NOTE ENTRY',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
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
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
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
                                            controller: inwardChallanController
                                                .noController,
                                            onSaved: (newValue) {
                                              inwardChallanController
                                                  .noController
                                                  .text = newValue!;
                                            },
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.07,
                                            height: 30,
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
                                                0.09,
                                            height: 30,
                                            padding: const EdgeInsets.only(
                                                left: 8.0, bottom: 16.0),
                                            hintText: _selectedDate == null
                                                ? '12/12/2023'
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
                                            height: 30,
                                            padding: const EdgeInsets.all(2.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: selectedCompany,
                                                underline: Container(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    selectedCompany = newValue!;
                                                  });
                                                  final selectedCompanyStores =
                                                      _companyList
                                                          .where((element) =>
                                                              element
                                                                  .companyCode ==
                                                              selectedCompany)
                                                          .toList();

                                                  print(selectedCompanyStores);
                                                  final stores =
                                                      selectedCompanyStores[0]
                                                          .stores;
                                                  setState(() {
                                                    this.stores = stores!;
                                                    selectedStore =
                                                        stores[0].code!;
                                                  });
                                                },
                                                items: _companyList
                                                    .map((NewCompany company) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: company.companyCode!,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(company
                                                            .companyName!
                                                            .toUpperCase()),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 40),
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
                                                    0.005,
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
                                                0.14,
                                            height: 30,
                                            padding: const EdgeInsets.all(2.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                menuMaxHeight: 300,
                                                isExpanded: true,
                                                value: selectedStore,
                                                underline: Container(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    // selectedPlaceState =
                                                    //     newValue!;
                                                    // inwardChallanController
                                                    //         .placeController
                                                    //         .text =
                                                    //     selectedPlaceState;

                                                    selectedStore = newValue!;
                                                  });
                                                },
                                                items: stores
                                                    .map((StoreModel value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value.code,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: Text(value.city
                                                          .toUpperCase()),
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
                                                0.05,
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
                                                0.209,
                                            height: 30,
                                            padding: const EdgeInsets.only(
                                                left: 8.0, bottom: 16.0),
                                            hintText: '',
                                          ),
                                          const SizedBox(width: 40),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: SETopText(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02,
                                              height: 30,
                                              text: 'Date',
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.01,
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.00),
                                            ),
                                          ),
                                          SETopTextfield(
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
                                                0.09,
                                            height: 30,
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  const NotaTable2(),
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
                                                          child: const Text(
                                                            'Remarks',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        20,
                                                                        88,
                                                                        181)),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.67,
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
                                                                      left: 8.0,
                                                                      bottom:
                                                                          16.0),
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    inwardChallanController
                                                                        .remarkController,
                                                                onSaved:
                                                                    (newValue) {
                                                                  inwardChallanController
                                                                          .remarkController
                                                                          .text =
                                                                      newValue!;
                                                                },
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 17,
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
                                                                  border:
                                                                      Border(
                                                                    bottom:
                                                                        BorderSide(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          44,
                                                                          43,
                                                                          43),
                                                                      width: 2,
                                                                    ),
                                                                  ),
                                                                ),
                                                                child:
                                                                    const Center(
                                                                  child: Text(
                                                                    'Ledger Information',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          14,
                                                                          63,
                                                                          138),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          17,
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
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.5,
                                                                        height:
                                                                            30,
                                                                        child:
                                                                            Row(
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
                                                                0.4,
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
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(0),
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
                                                                              const Text(
                                                                            'Statements',
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 15),
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
                                                                    const Expanded(
                                                                      flex: 6,
                                                                      child:
                                                                          Text(
                                                                        'Recent Transaction for the item',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              20,
                                                                              88,
                                                                              181),
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
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(0),
                                                                            ),
                                                                            backgroundColor: const Color.fromARGB(
                                                                                255,
                                                                                255,
                                                                                243,
                                                                                132),
                                                                          ),
                                                                          child:
                                                                              const Text(
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
                                                                          style:
                                                                              const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                13,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                14,
                                                                                63,
                                                                                138),
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
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13,
                                                          color: Color.fromARGB(
                                                              255, 14, 63, 138),
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
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {},
                                                        child: const Text(
                                                          'Save All',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            fontSize: 15,
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
                                                        child: const Text(
                                                          'Add',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            fontSize: 15,
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                      child: const Text(
                                        'Amount: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 20,
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(width: 2))),
                                      child: Text(
                                        '${TnetAmount + Ttotal}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
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
                                      const InwardChallanHome(),
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
                                            const InwardChallanHome(),
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
                                    Skey: "F12",
                                    name: "Add Line",
                                    onTap: () {
                                      _newWidget;
                                    }),
                                CustomList(Skey: "", name: "", onTap: () {}),
                                CustomList(
                                  Skey: "",
                                  name: "",
                                  onTap: () {},
                                ),
                                CustomList(Skey: "", name: "", onTap: () {}),
                                CustomList(Skey: "", name: "", onTap: () {}),
                                CustomList(
                                    Skey: "PgUp",
                                    name: "Previous",
                                    onTap: () {}),
                                CustomList(
                                    Skey: "PgDn", name: "Next", onTap: () {}),
                                CustomList(Skey: "", name: "", onTap: () {}),
                                CustomList(
                                    Skey: "G",
                                    name: "Attach. Img",
                                    onTap: () {}),
                                CustomList(Skey: "", name: "", onTap: () {}),
                                CustomList(
                                    Skey: "G", name: "Vch Setup", onTap: () {}),
                                CustomList(
                                    Skey: "T",
                                    name: "Print Setup",
                                    onTap: () {}),
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

    setState(() {
      inwardChallanController.dcNoController.text = billNumber;
      inwardChallanController.noController.text = randomNumber.toString();
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

    await getCompany();

    _generateEntries();
  }

  void _generateEntries() {
    for (int i = 0; i < 15; i++) {
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
          item: [],
          measurementLimit: [],
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
