// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:billingsphere/views/RA_widgets/RA_M_Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/ledgerGroup/ledger_group_model.dart';
import '../../data/repository/ledger_group_respository.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/receiveable_adjustment_respository.dart';
import '../searchable_dropdown.dart';
import '../sumit_screen/voucher _entry.dart/voucher_list_widget.dart';
import 'RA_adjustment.dart';

class RAMyDesktopBody extends StatefulWidget {
  RAMyDesktopBody({
    super.key,
  });

  @override
  State<RAMyDesktopBody> createState() => _RAMyDesktopBodyState();
}

class _RAMyDesktopBodyState extends State<RAMyDesktopBody> {
  String selectedStatus = 'GUJARAT';
  bool isLoading = false;
  int selectedOption = 1;
  bool _isChecked = false;
  bool _isChecked1 = false;
  DateTime? startDateLG;
  DateTime? endDateLG;
  DateTime? startDateL;
  DateTime? endDateL;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchController2 = TextEditingController();

  // Ledger Service
  LedgerService ledgerService = LedgerService();
  LedgerGroupService ledgerGroupService = LedgerGroupService();
  ReceiveableAdjustmentService receiveableAdjustmentService =
      ReceiveableAdjustmentService();

  List<Ledger> fetchedLedgers = [];
  List<Ledger> filteredLedger = [];

  List<LedgerGroup> fetchedLedgerGroup = [];
  List<LedgerGroup> filteredLedgerGroup = [];

  String? selectedId;
  String? selectedIdLG;

  String? companyCode;
  Future<String?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('companyCode');
  }

  Future<void> setCompanyCode() async {
    String? code = await getCompanyCode();
    setState(() {
      companyCode = code;
    });
  }

  Future<void> fetchLedgers() async {
    setState(() {
      isLoading = true;
    });
    try {
      final List<Ledger> ledger = await ledgerService.fetchLedgers();

      ledger.insert(
        0,
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
          status: 'Yes',
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
      ); // Modify this line according to your Ledger class

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        fetchedLedgers = ledger
            .where((element) =>
                element.status == 'Yes' &&
                element.ledgerGroup != '662f97d2a07ec73369c237b0')
            .toList();
        selectedIdLG = fetchedLedgers[0].id;
        isLoading = false;
      });
    } catch (error) {
      print('Failed to fetch ledger name: $error');
    }
  }

  Future<void> fetchLedgerGroup() async {
    setState(() {
      isLoading = true;
    });
    try {
      final List<LedgerGroup> ledgerGroup =
          await ledgerGroupService.fetchLedgerGroups();

      ledgerGroup.insert(
        0,
        LedgerGroup(
          id: '',
          name: '',
        ),
      ); // Modify this line according to your Ledger class

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        fetchedLedgerGroup = ledgerGroup;
        selectedId = fetchedLedgerGroup[0].id;
        isLoading = false;
      });
    } catch (error) {
      print('Failed to fetch ledger Group: $error');
    }
  }

  Future<void> initialize() async {
    await setCompanyCode();
    await fetchLedgerGroup();
    await fetchLedgers();
  }

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

  Future<void> fetchReceiveable() async {
    try {
      final List<Ledger>? ledger =
          await receiveableAdjustmentService.fetchReceiveable(
        selectedStatus,
        selectedId,
      );

      if (ledger != null) {
        //  Push to New Screen
        setState(() {
          filteredLedger = ledger;
        });

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RA2MyDesktopBody(
              location: selectedStatus,
              ledgerID: [selectedId!],
              selectedIdLG: selectedIdLG!,
              startDateL: startDateL,
              endDateL: endDateL,
              startDateLG: startDateLG,
              endDateLG: endDateLG,
              payableType: selectedOption,
            ),
          ),
        );
      } else if (ledger == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No data found'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to fetch receivables'),
          ),
        );
      }
    } catch (e) {
      print('Error fetching receivables: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RECEVIABLE ADJUSTMENT',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 33, 65, 243),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    // width: MediaQuery.of(context).size.width * 0.9,
                    height: 850,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 550,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: SingleChildScrollView(
                            child: isLoading
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: 550,
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: CircularProgressIndicator(
                                            color: Color.fromARGB(
                                                255, 33, 65, 243),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Report Criteria',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                            child: const Text(
                                              '  View',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Radio(
                                            value: 0,
                                            groupValue: selectedOption,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedOption = value!;
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.09,
                                            child: const Text('Datewise'),
                                          ),
                                          Radio(
                                            value: 1,
                                            groupValue: selectedOption,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedOption = value!;
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.09,
                                            child: const Text('Ledgerwise'),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          if (selectedOption == 0)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.46,
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black),
                                                ),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.09,
                                                              child: const Text(
                                                                'Date Range',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.10,
                                                              height: 30,
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  // Show Date Picker for Start Date
                                                                  showDatePicker(
                                                                    context:
                                                                        context,
                                                                    initialDate:
                                                                        startDateLG ??
                                                                            DateTime.now(),
                                                                    firstDate:
                                                                        DateTime(
                                                                            2000),
                                                                    lastDate:
                                                                        DateTime(
                                                                            2100),
                                                                    builder: (BuildContext
                                                                            context,
                                                                        Widget?
                                                                            child) {
                                                                      return Theme(
                                                                        data: ThemeData
                                                                            .light(), // Change to dark if needed
                                                                        child:
                                                                            child!,
                                                                      );
                                                                    },
                                                                  ).then((DateTime?
                                                                      selectedDate) {
                                                                    if (selectedDate !=
                                                                        null) {
                                                                      setState(
                                                                          () {
                                                                        startDateLG =
                                                                            selectedDate;
                                                                      });
                                                                    }
                                                                  });
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all<
                                                                              Color>(
                                                                          Colors
                                                                              .white),
                                                                  elevation: MaterialStateProperty.all<
                                                                          double>(
                                                                      0), // Remove elevation
                                                                  shape: MaterialStateProperty
                                                                      .all<
                                                                          RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0),
                                                                      side: const BorderSide(
                                                                          color:
                                                                              Colors.black), // Border color
                                                                    ),
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  startDateLG !=
                                                                          null
                                                                      ? dateFormat
                                                                          .format(
                                                                              startDateLG!)
                                                                      : 'Start Date',
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black, // Text color
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            const Text(
                                                              'to',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.10,
                                                              height: 30,
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  // Show Date Picker for End Date with constraints
                                                                  showDatePicker(
                                                                    context:
                                                                        context,
                                                                    initialDate:
                                                                        endDateLG ??
                                                                            DateTime.now(),
                                                                    firstDate: startDateLG ??
                                                                        DateTime(
                                                                            2000),
                                                                    lastDate:
                                                                        DateTime(
                                                                            2100),
                                                                    builder: (BuildContext
                                                                            context,
                                                                        Widget?
                                                                            child) {
                                                                      return Theme(
                                                                        data: ThemeData
                                                                            .light(), // Change to dark if needed
                                                                        child:
                                                                            child!,
                                                                      );
                                                                    },
                                                                  ).then((DateTime?
                                                                      selectedDate) {
                                                                    if (selectedDate !=
                                                                        null) {
                                                                      setState(
                                                                          () {
                                                                        endDateLG =
                                                                            selectedDate;
                                                                      });
                                                                    }
                                                                  });
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all<
                                                                              Color>(
                                                                          Colors
                                                                              .white),
                                                                  elevation: MaterialStateProperty.all<
                                                                          double>(
                                                                      0), // Remove elevation
                                                                  shape: MaterialStateProperty
                                                                      .all<
                                                                          RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0),
                                                                      side: const BorderSide(
                                                                          color:
                                                                              Colors.black), // Border color
                                                                    ),
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  endDateLG !=
                                                                          null
                                                                      ? dateFormat
                                                                          .format(
                                                                              endDateLG!)
                                                                      : 'End Date',
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black, // Text color
                                                                    fontSize:
                                                                        14,
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
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.09,
                                                              child: const Text(
                                                                'Ledger Group',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.22,
                                                              height: 30,
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                child:
                                                                    SearchableDropDown(
                                                                  controller:
                                                                      searchController,
                                                                  searchController:
                                                                      searchController,
                                                                  value:
                                                                      selectedIdLG,
                                                                  onChanged:
                                                                      (String?
                                                                          newValue) {
                                                                    setState(
                                                                        () {
                                                                      selectedIdLG =
                                                                          newValue;
                                                                    });
                                                                  },
                                                                  items: fetchedLedgerGroup.map(
                                                                      (LedgerGroup
                                                                          ledgerG) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          ledgerG
                                                                              .id,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            2.0),
                                                                        child: Text(
                                                                            ledgerG.name),
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                  searchMatchFn:
                                                                      (item,
                                                                          searchValue) {
                                                                    final itemMLimit = fetchedLedgerGroup
                                                                        .firstWhere((e) =>
                                                                            e.id ==
                                                                            item.value)
                                                                        .name;
                                                                    return itemMLimit
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            searchValue.toLowerCase());
                                                                  },
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
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.09,
                                                              child: const Text(
                                                                'Voucher Type',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.22,
                                                              height: 30,
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                child:
                                                                    TextFormField(
                                                                  readOnly:
                                                                      true,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            left: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.095),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              child: Row(
                                                                children: [
                                                                  Checkbox(
                                                                    value:
                                                                        _isChecked,
                                                                    onChanged:
                                                                        (bool?
                                                                            value) {
                                                                      setState(
                                                                          () {
                                                                        _isChecked =
                                                                            value!;
                                                                      });
                                                                    },
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0.0),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.1,
                                                                    child:
                                                                        const Text(
                                                                      'Show for Due Date Range',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              child: Row(
                                                                children: [
                                                                  Checkbox(
                                                                    value:
                                                                        _isChecked,
                                                                    onChanged:
                                                                        (bool?
                                                                            value) {
                                                                      setState(
                                                                          () {
                                                                        _isChecked =
                                                                            value!;
                                                                      });
                                                                    },
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0.0),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.1,
                                                                    child:
                                                                        const Text(
                                                                      'Include All Adjuments',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
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
                                                ),
                                              ),
                                            ),
                                          if (selectedOption == 1)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.46,
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black),
                                                ),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.09,
                                                              child: const Text(
                                                                'Date Range',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.10,
                                                              height: 30,
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  // Show Date Picker for Start Date
                                                                  showDatePicker(
                                                                    context:
                                                                        context,
                                                                    initialDate:
                                                                        startDateL ??
                                                                            DateTime.now(),
                                                                    firstDate:
                                                                        DateTime(
                                                                            2000),
                                                                    lastDate:
                                                                        DateTime(
                                                                            2100),
                                                                    builder: (BuildContext
                                                                            context,
                                                                        Widget?
                                                                            child) {
                                                                      return Theme(
                                                                        data: ThemeData
                                                                            .light(), // Change to dark if needed
                                                                        child:
                                                                            child!,
                                                                      );
                                                                    },
                                                                  ).then((DateTime?
                                                                      selectedDate) {
                                                                    if (selectedDate !=
                                                                        null) {
                                                                      setState(
                                                                          () {
                                                                        startDateL =
                                                                            selectedDate;
                                                                      });
                                                                    }
                                                                  });
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all<
                                                                              Color>(
                                                                          Colors
                                                                              .white),
                                                                  elevation: MaterialStateProperty.all<
                                                                          double>(
                                                                      0), // Remove elevation
                                                                  shape: MaterialStateProperty
                                                                      .all<
                                                                          RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0),
                                                                      side: const BorderSide(
                                                                          color:
                                                                              Colors.black), // Border color
                                                                    ),
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  startDateL !=
                                                                          null
                                                                      ? dateFormat
                                                                          .format(
                                                                              startDateL!)
                                                                      : 'Start Date',
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black, // Text color
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            const Text(
                                                              'to',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.10,
                                                              height: 30,
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  // Show Date Picker for End Date with constraints
                                                                  showDatePicker(
                                                                    context:
                                                                        context,
                                                                    initialDate:
                                                                        endDateL ??
                                                                            DateTime.now(),
                                                                    firstDate: startDateL ??
                                                                        DateTime(
                                                                            2000),
                                                                    lastDate:
                                                                        DateTime(
                                                                            2100),
                                                                    builder: (BuildContext
                                                                            context,
                                                                        Widget?
                                                                            child) {
                                                                      return Theme(
                                                                        data: ThemeData
                                                                            .light(), // Change to dark if needed
                                                                        child:
                                                                            child!,
                                                                      );
                                                                    },
                                                                  ).then((DateTime?
                                                                      selectedDate) {
                                                                    if (selectedDate !=
                                                                        null) {
                                                                      setState(
                                                                          () {
                                                                        endDateL =
                                                                            selectedDate;
                                                                      });
                                                                    }
                                                                  });
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all<
                                                                              Color>(
                                                                          Colors
                                                                              .white),
                                                                  elevation: MaterialStateProperty.all<
                                                                          double>(
                                                                      0), // Remove elevation
                                                                  shape: MaterialStateProperty
                                                                      .all<
                                                                          RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0),
                                                                      side: const BorderSide(
                                                                          color:
                                                                              Colors.black), // Border color
                                                                    ),
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  endDateL !=
                                                                          null
                                                                      ? dateFormat
                                                                          .format(
                                                                              endDateL!)
                                                                      : 'End Date',
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black, // Text color
                                                                    fontSize:
                                                                        14,
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
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.09,
                                                              child: const Text(
                                                                'Ledger Name',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.22,
                                                              height: 30,
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                child:
                                                                    SearchableDropDown(
                                                                  controller:
                                                                      searchController2,
                                                                  searchController:
                                                                      searchController2,
                                                                  value:
                                                                      selectedId,
                                                                  onChanged:
                                                                      (String?
                                                                          newValue) {
                                                                    setState(
                                                                        () {
                                                                      selectedId =
                                                                          newValue;
                                                                    });
                                                                  },
                                                                  items: fetchedLedgers
                                                                      .map((Ledger
                                                                          ledger) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          ledger
                                                                              .id,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            2.0),
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width * 0.14,
                                                                              child: Text(
                                                                                ledger.name,
                                                                                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                                                                                overflow: TextOverflow.ellipsis,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              ledger.debitBalance.toStringAsFixed(2),
                                                                              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                  searchMatchFn:
                                                                      (item,
                                                                          searchValue) {
                                                                    final itemMLimit = fetchedLedgers
                                                                        .firstWhere((e) =>
                                                                            e.id ==
                                                                            item.value)
                                                                        .name;
                                                                    return itemMLimit
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            searchValue.toLowerCase());
                                                                  },
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
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    value: _isChecked,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        _isChecked = value!;
                                                      });
                                                    },
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.0),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                    child: const Text(
                                                      'Show Stock Detail in Print',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    value: _isChecked,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        _isChecked = value!;
                                                      });
                                                    },
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.0),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                    child: const Text(
                                                      'Show Bill Adjument Detail',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    value: _isChecked,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        _isChecked = value!;
                                                      });
                                                    },
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.0),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                    child: const Text(
                                                      'Overdue Bills Only',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                  Checkbox(
                                                    value: _isChecked,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        _isChecked = value!;
                                                      });
                                                    },
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.0),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                    child: const Text(
                                                      'Show Bank Info in Print',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    value: _isChecked,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        _isChecked = value!;
                                                      });
                                                    },
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.0),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                    child: const Text(
                                                      'Show On Accounts Diff',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                              bottom: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                            ),
                                            child: Row(
                                              children: [
                                                RAMButtons(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.11,
                                                  height: 30,
                                                  text: 'Show [F4]',
                                                  onPressed: fetchReceiveable,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: RAMButtons(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.11,
                                                    height: 30,
                                                    text: 'Close',
                                                    onPressed: () {},
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              child: Shortcuts(
                shortcuts: {
                  LogicalKeySet(LogicalKeyboardKey.f3): const ActivateIntent(),
                  LogicalKeySet(LogicalKeyboardKey.f4): const ActivateIntent(),
                },
                child: Focus(
                  autofocus: true,
                  onKey: (node, event) {
                    if (event is RawKeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.f2) {
                      return KeyEventResult.handled;
                    } else if (event is RawKeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.keyB) {
                    } else if (event is RawKeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.keyM) {
                    } else if (event is RawKeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.keyL) {
                    } else if (event is RawKeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.keyA) {}
                    return KeyEventResult.ignored;
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.099,
                    child: Column(
                      children: [
                        // CustomList(Skey: "P", name: "Print", onTap: () {}),
                        // CustomList(Skey: "F2", name: "Report", onTap: () {}),
                        // CustomList(Skey: "", name: "", onTap: () {}),
                        // CustomList(Skey: "S", name: "Statement", onTap: () {}),
                        // CustomList(
                        //     Skey: "F5", name: "Make Payment", onTap: () {}),
                        // CustomList(Skey: "", name: "", onTap: () {}),
                        // CustomList(Skey: "", name: "", onTap: () {}),
                        // CustomList(Skey: "", name: "", onTap: () {}),
                        // CustomList(Skey: "", name: "", onTap: () {}),
                        // CustomList(Skey: "", name: "", onTap: () {}),
                        // CustomList(Skey: "L", name: "Prn Color", onTap: () {}),
                        // CustomList(Skey: "", name: "", onTap: () {}),
                        // CustomList(Skey: "T", name: "Prn Short", onTap: () {}),
                        // CustomList(Skey: "X", name: "XLS", onTap: () {}),
                        // CustomList(Skey: "", name: "", onTap: () {}),
                        // CustomList(Skey: "", name: "", onTap: () {}),
                        // CustomList(Skey: "F3", name: "Find", onTap: () {}),
                        // CustomList(Skey: "F3", name: "Find Next", onTap: () {}),
                        // CustomList(
                        //   Skey: "Q",
                        //   name: "Quick Entry",
                        //   onTap: () {
                        //     // Navigator.push(
                        //     //   context,
                        //     //   MaterialPageRoute(
                        //     //     builder: (context) =>
                        //     //         const LGMyDesktopBody(),
                        //     //   ),
                        //     // );
                        //   },
                        // ),
                        // CustomList(Skey: "W", name: "Whatsapp", onTap: () {}),
                        // CustomList(Skey: "", name: "", onTap: () {}),
                        // CustomList(Skey: "", name: "", onTap: () {}),
                        // CustomList(Skey: "", name: "", onTap: () {}),
                        // CustomList(Skey: "", name: "", onTap: () {}),
                        // CustomList(Skey: "", name: "", onTap: () {}),
                        // CustomList(Skey: "", name: "", onTap: () {}),
                        // CustomList(Skey: "", name: "", onTap: () {}),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
