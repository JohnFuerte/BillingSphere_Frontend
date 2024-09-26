import 'package:billingsphere/data/repository/ledger_repository.dart';
import 'package:billingsphere/utils/controllers/ledger_text_controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/ledgerGroup/ledger_group_model.dart';
import '../../data/models/price/price_category.dart';
import '../../data/repository/ledger_group_respository.dart';
import '../../data/repository/price_category_repository.dart';
import '../DB_homepage.dart';
import '../searchable_dropdown.dart';
import 'LG_HOME.dart';

class LGUpdateEntry extends StatefulWidget {
  final String id;
  const LGUpdateEntry({super.key, required this.id});

  @override
  State<LGUpdateEntry> createState() => _LGMyDesktopBodyState();
}

class _LGMyDesktopBodyState extends State<LGUpdateEntry> {
  LedgerFormController controller = LedgerFormController();
  final _formKey = GlobalKey<FormState>();
  final bool _isSaving = false;
  Ledger? _ledgers;
  final TextEditingController _searchController = TextEditingController();

  // Dropdown Data
  List<LedgerGroup> fetchedLedgerGroups = [];
  List<PriceCategory> fetchedPriceCategories = [];
  FocusNode _focusNode = FocusNode();

  // Dropdown Values
  String? selectedLedgerGId;
  String? selectedPriceCId;
  String? ledgerTitle;
  String? billwiseAccounting;
  String? isActived;

  String? selectedPlaceState;
  String selectedPriceType = 'DEALER';
  List<String> pricetype = ['DEALER', 'SUB DEALER', 'RETAIL', 'MRP'];

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

  final LedgerGroupService ledgerGroupService = LedgerGroupService();
  final LedgerService ledgerService = LedgerService();
  final PriceCategoryRepository priceCategoryRepository =
      PriceCategoryRepository();

  Future<void> fetchLedger() async {
    try {
      final ledger = await ledgerService.fetchLedgerById(widget.id);
      setState(() {
        _ledgers = ledger;
      });

      setState(() {
        controller.nameController.text = _ledgers!.name;
        controller.printNameController.text = _ledgers!.printName;
        controller.aliasNameController.text = _ledgers!.aliasName;
        selectedLedgerGId = _ledgers!.ledgerGroup;
        billwiseAccounting = _ledgers!.bilwiseAccounting;
        controller.creditDaysController.text = _ledgers!.creditDays.toString();
        controller.openingBalanceController.text =
            _ledgers!.openingBalance.toString();
        controller.debitBalanceController.text =
            _ledgers!.debitBalance.toString();
        ledgerTitle = _ledgers!.ledgerType;
        selectedPriceType = _ledgers!.priceListCategory;
        controller.remarksController.text = _ledgers!.remarks;
        isActived = _ledgers!.status;
        controller.ledgerCodeController.text = _ledgers!.ledgerCode.toString();
        controller.mailingNameController.text = _ledgers!.mailingName;
        controller.addressController.text = _ledgers!.address;
        controller.cityController.text = _ledgers!.city;
        controller.regionController.text = _ledgers!.region;
        controller.stateController.text = _ledgers!.state;
        selectedPlaceState = _ledgers!.state;
        controller.pincodeController.text = _ledgers!.pincode.toString();
        controller.telController.text = _ledgers!.tel.toString();
        controller.faxController.text = _ledgers!.fax.toString();
        controller.emailController.text = _ledgers!.email;
        controller.contactPersonController.text = _ledgers!.contactPerson;
        controller.bankNameController.text = _ledgers!.bankName;
        controller.branchNameController.text = _ledgers!.branchName;
        controller.ifscCodeController.text = _ledgers!.ifsc;
        controller.accNameController.text = _ledgers!.accName;
        controller.accNoController.text = _ledgers!.accNo;
        controller.mobileController.text = _ledgers!.mobile.toString();
        controller.smscontroller.text = _ledgers!.sms.toString();
        controller.panNoController.text = _ledgers!.panNo;
        controller.gstController.text = _ledgers!.gst;
        controller.gstDatedController.text = _ledgers!.gstDated;
        controller.cstNoController.text = _ledgers!.cstNo;
        controller.cstNoDatedController.text = _ledgers!.cstDated;
        controller.lstNoController.text = _ledgers!.lstNo;
        controller.lstNoDatedController.text = _ledgers!.lstDated;
        controller.serviceTypeController.text = _ledgers!.serviceTaxNo;
        controller.serviceTypeDatedController.text = _ledgers!.serviceTaxDated;
        controller.registrationTypeController.text = _ledgers!.registrationType;
        controller.registrationTypeDatedController.text =
            _ledgers!.registrationTypeDated;
      });
    } catch (error) {
      // Handle errors here
      return;
    }
  }

  Future<void> fetchLedgerGroups() async {
    try {
      List<LedgerGroup> groups = await ledgerGroupService.fetchLedgerGroups();
      setState(() {
        fetchedLedgerGroups = groups;
      });
    } catch (error) {
      // Handle errors here
      return;
    }
  }

  // Future<void> fetchPriceCategories() async {
  //   try {
  //     List<PriceCategory> categories =
  //         await priceCategoryRepository.fetchPriceCategories();
  //     setState(() {
  //       fetchedPriceCategories = categories;
  //     });
  //   } catch (error) {
  //     // Handle errors here
  //     return;
  //   }
  // }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Exit"),
          content: const Text("Do you want to exit without saving?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        const DBHomePage(), // Replace with your dashboard screen widget
                  ),
                );
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

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

  final formatter = DateFormat.yMd();

  void updateLedgerData() {
    // Create a Ledger object with the updated values
    Ledger updatedLedger = Ledger(
      id: _ledgers!.id, // Assuming _ledgers is the original Ledger object

      name: controller.nameController.text,
      printName: controller.printNameController.text,
      aliasName: controller.aliasNameController.text,
      ledgerGroup: selectedLedgerGId!,
      date: formatter.format(DateTime.now()),
      bilwiseAccounting: billwiseAccounting!,
      creditDays: int.parse(controller.creditDaysController.text),
      openingBalance: double.parse(controller.openingBalanceController.text),
      debitBalance: double.parse(controller.debitBalanceController.text),

      ledgerType: ledgerTitle!,
      priceListCategory: selectedPriceType,
      remarks: controller.remarksController.text,
      status: isActived!,
      ledgerCode: int.parse(controller.ledgerCodeController.text),
      mailingName: controller.mailingNameController.text,
      address: controller.addressController.text,
      city: controller.cityController.text,
      region: controller.regionController.text,
      state: selectedPlaceState!,
      pincode: int.parse(controller.pincodeController.text),
      tel: int.parse(controller.telController.text),
      fax: int.parse(controller.faxController.text),
      email: controller.emailController.text,
      contactPerson: controller.contactPersonController.text,
      bankName: controller.bankNameController.text,
      branchName: controller.branchNameController.text,
      ifsc: controller.ifscCodeController.text,
      accName: controller.accNameController.text,
      accNo: controller.accNoController.text,
      panNo: controller.panNoController.text,
      gst: controller.gstController.text,
      gstDated: controller.gstDatedController.text,
      cstNo: controller.cstNoController.text,
      cstDated: controller.cstNoDatedController.text,
      lstNo: controller.lstNoController.text,
      lstDated: controller.lstNoDatedController.text,
      serviceTaxNo: controller.serviceTypeController.text,
      serviceTaxDated: controller.serviceTypeDatedController.text,
      registrationType: controller.registrationTypeController.text,
      registrationTypeDated: controller.registrationTypeDatedController.text,
      mobile: int.parse(controller.mobileController.text),
      sms: int.parse(controller.smscontroller.text),
    );

    ledgerService.updateLedger(updatedLedger, context);
  }

  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.f4) {
      // Execute your function when F3 key is pressed
      updateLedgerData();
    }
  }

  @override
  void initState() {
    super.initState();
    setCompanyCode();
    fetchLedgerGroups();
    // fetchPriceCategories();
    fetchLedger();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    RawKeyboard.instance.addListener(_handleKey);
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    RawKeyboard.instance.removeListener(_handleKey);
    _focusNode.dispose();

    super.dispose();
  }

  final List<String> ledgers = ['Dr', 'Cr'];
  final List<String> billwiseAccount = ['Yes', 'No'];
  final List<String> isActive = ['Yes', 'No'];

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          _showExitConfirmationDialog();
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Opacity(
                opacity: _isSaving ? 0.5 : 1.0,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              width: mediaQuery.size.width * 0.48,
                              height: 1153,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD2691E),
                                          border: Border.all(),
                                        ),
                                        child: SizedBox(
                                          child: Text(
                                            'EDIT Ledger',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              'Basic Details',
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: Colors.black,
                                                decorationThickness: 1.5,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: SizedBox(
                                                            width: mediaQuery
                                                                    .size
                                                                    .width *
                                                                0.10,
                                                            height: 25,
                                                            child: Text.rich(
                                                              TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Ledger Name',
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      color: const Color(
                                                                          0xFF590D82),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: '*',
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      color: Colors
                                                                          .red, // Set the color to red
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      _buildTextWidget(
                                                        mediaQuery,
                                                        0.90,
                                                        controller
                                                            .nameController,
                                                        TextInputType.text,
                                                        false,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                      width: mediaQuery
                                                              .size.width *
                                                          0.10,
                                                      height: 25,
                                                      child: Text(
                                                        'Print Name',
                                                        style: GoogleFonts.poppins(
                                                            color: const Color(
                                                                0xFF590D82),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                _buildTextWidget(
                                                  mediaQuery,
                                                  0.90,
                                                  controller
                                                      .printNameController,
                                                  TextInputType.text,
                                                  false,
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                      width: mediaQuery
                                                              .size.width *
                                                          0.10,
                                                      height: 25,
                                                      child: Text(
                                                        'Alias',
                                                        style: GoogleFonts.poppins(
                                                            color: const Color(
                                                                0xFF590D82),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                _buildTextWidget(
                                                  mediaQuery,
                                                  0.90,
                                                  controller
                                                      .aliasNameController,
                                                  TextInputType.text,
                                                  false,
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                        width: mediaQuery
                                                                .size.width *
                                                            0.10,
                                                        height: 25,
                                                        child: Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    'Print Name',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  color: const Color(
                                                                      0xFF590D82),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: '*',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  color: Colors
                                                                      .red, // Set the color to red
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                                _buildTextWidget(
                                                  mediaQuery,
                                                  0.90,
                                                  controller
                                                      .printNameController,
                                                  TextInputType.text,
                                                  false,
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                        width: mediaQuery
                                                                .size.width *
                                                            0.10,
                                                        height: 25,
                                                        child: Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    'Ledger Group',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  color: const Color(
                                                                      0xFF590D82),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: '*',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  color: Colors
                                                                      .red, // Set the color to red
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    width:
                                                        mediaQuery.size.width *
                                                            0.90,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                    ),
                                                    child: SearchableDropDown(
                                                      controller:
                                                          _searchController,
                                                      searchController:
                                                          _searchController,
                                                      value: selectedLedgerGId,
                                                      onChanged:
                                                          (String? newValue) {
                                                        // Update the state when the user selects a new fruit
                                                        setState(() {
                                                          selectedLedgerGId =
                                                              newValue;
                                                        });
                                                      },
                                                      items: fetchedLedgerGroups
                                                          .map((LedgerGroup
                                                              ledgerGroup) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: ledgerGroup.id,
                                                          child: Text(
                                                            ledgerGroup.name,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        );
                                                      }).toList(),
                                                      searchMatchFn:
                                                          (item, searchValue) {
                                                        final itemMLimit =
                                                            fetchedLedgerGroups
                                                                .firstWhere((e) =>
                                                                    e.id ==
                                                                    item.value)
                                                                .name;
                                                        return itemMLimit
                                                            .toLowerCase()
                                                            .contains(searchValue
                                                                .toLowerCase());
                                                      },
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: SizedBox(
                                                            width: mediaQuery
                                                                    .size
                                                                    .width *
                                                                0.10,
                                                            height: 30,
                                                            child: Text(
                                                              'Billwise Accounting',
                                                              style: GoogleFonts.poppins(
                                                                  color: const Color(
                                                                      0xFF590D82),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Container(
                                                          width: mediaQuery
                                                                  .size.width *
                                                              0.05,
                                                          height: 40,
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
                                                          child:
                                                              DropdownButtonHideUnderline(
                                                            child:
                                                                DropdownButton<
                                                                    String>(
                                                              underline:
                                                                  Container(),
                                                              isExpanded: true,
                                                              isDense: false,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          5.0),
                                                              value:
                                                                  billwiseAccounting,
                                                              items: billwiseAccount
                                                                  .map((String
                                                                      fruit) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value: fruit,
                                                                  child: Text(
                                                                    fruit,
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                );
                                                              }).toList(),
                                                              onChanged: (String?
                                                                  newValue) {
                                                                // Update the state when the user selects a new fruit
                                                                setState(() {
                                                                  billwiseAccounting =
                                                                      newValue;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: SizedBox(
                                                            width: mediaQuery
                                                                    .size
                                                                    .width *
                                                                0.057,
                                                            height: 30,
                                                            child: Text(
                                                              'Credit Days',
                                                              style: GoogleFonts.poppins(
                                                                  color: const Color(
                                                                      0xFF590D82),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      _buildTextWidget(
                                                        mediaQuery,
                                                        0.15,
                                                        controller
                                                            .creditDaysController,
                                                        TextInputType.number,
                                                        true,
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: SizedBox(
                                                            width: mediaQuery
                                                                    .size
                                                                    .width *
                                                                0.10,
                                                            height: 30,
                                                            child: Text.rich(
                                                              TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Op. Balance(${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year.toString().substring(2)})',
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      color: const Color(
                                                                          0xFF590D82),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: '*',
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      color: Colors
                                                                          .red, // Set the color to red
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          width: mediaQuery
                                                                  .size.width *
                                                              0.05,
                                                          height: 40,
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
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: TextFormField(
                                                            cursorHeight: 18,
                                                            controller: controller
                                                                .openingBalanceController,
                                                            keyboardType:
                                                                const TextInputType
                                                                    .numberWithOptions(
                                                              decimal: true,
                                                            ),
                                                            inputFormatters: <TextInputFormatter>[
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      r'^\d+\.?\d{0,2}')),
                                                              LengthLimitingTextInputFormatter(
                                                                  10),
                                                            ],
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter some text';
                                                              }
                                                              return null;
                                                            },
                                                            onSaved:
                                                                (newValue) {
                                                              controller
                                                                  .openingBalanceController
                                                                  .text = newValue!;
                                                            },
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            decoration:
                                                                const InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      left: 5.0,
                                                                      bottom:
                                                                          8.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5),
                                                          child: Container(
                                                            width: mediaQuery
                                                                    .size
                                                                    .width *
                                                                0.05,
                                                            height: 40,
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
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child:
                                                                DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownButton<
                                                                      String>(
                                                                underline:
                                                                    Container(),
                                                                isExpanded:
                                                                    true,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  left: 5.0,
                                                                ),
                                                                value:
                                                                    ledgerTitle,
                                                                items: ledgers
                                                                    .map((String
                                                                        fruit) {
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    value:
                                                                        fruit,
                                                                    child: Text(
                                                                      fruit,
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                                onChanged: (String?
                                                                    newValue) {
                                                                  // Update the state when the user selects a new fruit
                                                                  setState(() {
                                                                    ledgerTitle =
                                                                        newValue;
                                                                  });
                                                                },
                                                              ),
                                                            ),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                      width: mediaQuery
                                                              .size.width *
                                                          0.10,
                                                      height: 30,
                                                      child: Text(
                                                        'Debit Balance',
                                                        style: GoogleFonts.poppins(
                                                            color: const Color(
                                                                0xFF590D82),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    width:
                                                        mediaQuery.size.width *
                                                            0.90,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                    ),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: TextFormField(
                                                      cursorHeight: 18,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please enter some text';
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (newValue) {
                                                        controller
                                                            .debitBalanceController
                                                            .text = newValue!;
                                                      },
                                                      controller: controller
                                                          .debitBalanceController,
                                                      inputFormatters: <TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .allow(
                                                          RegExp(
                                                              r'^\d+\.?\d{0,2}'),
                                                        ),
                                                        LengthLimitingTextInputFormatter(
                                                            10),
                                                      ],
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                left: 5.0,
                                                                bottom: 8.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                      width: mediaQuery
                                                              .size.width *
                                                          0.10,
                                                      height: 30,
                                                      child: Text(
                                                        'Price List Category',
                                                        style: GoogleFonts.poppins(
                                                            color: const Color(
                                                                0xFF590D82),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    width:
                                                        mediaQuery.size.width *
                                                            0.90,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                    ),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                      child: DropdownButton<
                                                          String>(
                                                        menuMaxHeight: 300,
                                                        isExpanded: true,
                                                        value:
                                                            selectedPriceType,
                                                        underline: Container(),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 5.0),
                                                        onChanged:
                                                            (String? newValue) {
                                                          setState(() {
                                                            selectedPriceType =
                                                                newValue!;
                                                          });
                                                        },
                                                        items: pricetype.map(
                                                            (String value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value,
                                                            child: Text(
                                                              value,
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                      width: mediaQuery
                                                              .size.width *
                                                          0.10,
                                                      height: 30,
                                                      child: Text(
                                                        'Remarks',
                                                        style: GoogleFonts.poppins(
                                                            color: const Color(
                                                                0xFF590D82),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    width:
                                                        mediaQuery.size.width *
                                                            0.90,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                    ),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: TextFormField(
                                                      cursorHeight: 18,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please enter some text';
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (newValue) {
                                                        controller
                                                            .remarksController
                                                            .text = newValue!;
                                                      },
                                                      controller: controller
                                                          .remarksController,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                left: 5.0,
                                                                bottom: 8.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                      width: mediaQuery
                                                              .size.width *
                                                          0.10,
                                                      height: 30,
                                                      child: Text(
                                                        'Is Active',
                                                        style: GoogleFonts.poppins(
                                                            color: const Color(
                                                                0xFF590D82),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    width:
                                                        mediaQuery.size.width *
                                                            0.05,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                    ),
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                      child: DropdownButton<
                                                          String>(
                                                        isExpanded: true,
                                                        underline: Container(),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 5.0),
                                                        value: isActived,
                                                        items: isActive.map(
                                                            (String fruit) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: fruit,
                                                            child: Text(
                                                              fruit,
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          );
                                                        }).toList(),
                                                        onChanged:
                                                            (String? newValue) {
                                                          setState(() {
                                                            isActived =
                                                                newValue;
                                                          });
                                                        },
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
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Column(
                                  children: [
                                    Container(
                                      width: mediaQuery.size.width * 0.48,
                                      height: 810,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          right: mediaQuery.size.width * 0.06,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5),
                                                      child: Text(
                                                        'Mailing Details',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationColor:
                                                              Colors.black,
                                                          decorationThickness:
                                                              1.5,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                _buildText(
                                                                    mediaQuery,
                                                                    'Ledger Code',
                                                                    0.095,
                                                                    '*'),
                                                                _buildTextWidget(
                                                                    mediaQuery,
                                                                    0.01,
                                                                    controller
                                                                        .ledgerCodeController,
                                                                    TextInputType
                                                                        .number,
                                                                    true),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          _buildText(
                                                              mediaQuery,
                                                              'Mailing Name',
                                                              0.095,
                                                              ''),
                                                          _buildTextWidget(
                                                            mediaQuery,
                                                            0.90,
                                                            controller
                                                                .mailingNameController,
                                                            TextInputType.text,
                                                            false,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          _buildText(
                                                              mediaQuery,
                                                              'Address',
                                                              0.095,
                                                              ''),
                                                          Flexible(
                                                            flex: 3,
                                                            child: Container(
                                                              width: mediaQuery
                                                                      .size
                                                                      .width *
                                                                  0.99,
                                                              height: 100,
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
                                                                        .all(
                                                                        8.0),
                                                                child:
                                                                    TextFormField(
                                                                  maxLines: 2,
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Please enter some text';
                                                                    }
                                                                    return null;
                                                                  },
                                                                  onSaved:
                                                                      (newValue) {
                                                                    controller
                                                                            .addressController
                                                                            .text =
                                                                        newValue!;
                                                                  },
                                                                  controller:
                                                                      controller
                                                                          .addressController,
                                                                  style: GoogleFonts.poppins(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
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
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                _buildText(
                                                                    mediaQuery,
                                                                    'Region',
                                                                    0.095,
                                                                    '*'),
                                                                _buildTextWidget(
                                                                    mediaQuery,
                                                                    0.60,
                                                                    controller
                                                                        .regionController,
                                                                    TextInputType
                                                                        .text,
                                                                    false),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                _buildText(
                                                                    mediaQuery,
                                                                    'State',
                                                                    0.04,
                                                                    '*'),
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          border:
                                                                              Border.all()),
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.1,
                                                                  height: 40,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          2.0),
                                                                  child:
                                                                      DropdownButtonHideUnderline(
                                                                    child: DropdownButton<
                                                                        String>(
                                                                      menuMaxHeight:
                                                                          300,
                                                                      isExpanded:
                                                                          true,
                                                                      value:
                                                                          selectedPlaceState,
                                                                      underline:
                                                                          Container(),
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .only(
                                                                        left:
                                                                            5.0,
                                                                      ),
                                                                      onChanged:
                                                                          (String?
                                                                              newValue) {
                                                                        setState(
                                                                            () {
                                                                          selectedPlaceState =
                                                                              newValue!;
                                                                        });
                                                                      },
                                                                      items: placestate.map(
                                                                          (String
                                                                              value) {
                                                                        return DropdownMenuItem<
                                                                            String>(
                                                                          value:
                                                                              value,
                                                                          child:
                                                                              Text(
                                                                            value,
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
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
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          _buildText(
                                                              mediaQuery,
                                                              'City',
                                                              0.095,
                                                              ''),
                                                          _buildTextWidget(
                                                            mediaQuery,
                                                            0.30,
                                                            controller
                                                                .cityController,
                                                            TextInputType.text,
                                                            false,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          _buildText(
                                                              mediaQuery,
                                                              'Fax No',
                                                              0.04,
                                                              ''),
                                                          _buildTextWidget(
                                                            mediaQuery,
                                                            0.20,
                                                            controller
                                                                .faxController,
                                                            TextInputType.phone,
                                                            true,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                _buildText(
                                                                    mediaQuery,
                                                                    'Pincode',
                                                                    0.095,
                                                                    ''),
                                                                _buildTextWidget(
                                                                    mediaQuery,
                                                                    0.60,
                                                                    controller
                                                                        .pincodeController,
                                                                    TextInputType
                                                                        .number,
                                                                    true),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                _buildText(
                                                                    mediaQuery,
                                                                    'Tele NO',
                                                                    0.04,
                                                                    ''),
                                                                _buildTextWidget(
                                                                  mediaQuery,
                                                                  0.20,
                                                                  controller
                                                                      .telController,
                                                                  TextInputType
                                                                      .phone,
                                                                  true,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                _buildText(
                                                                    mediaQuery,
                                                                    'Mobile No',
                                                                    0.095,
                                                                    '*'),
                                                                _buildTextWidget(
                                                                  mediaQuery,
                                                                  0.30,
                                                                  controller
                                                                      .mobileController,
                                                                  TextInputType
                                                                      .phone,
                                                                  true,
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                _buildText(
                                                                    mediaQuery,
                                                                    'Mobile 2',
                                                                    0.04,
                                                                    ''),
                                                                _buildTextWidget(
                                                                  mediaQuery,
                                                                  0.20,
                                                                  controller
                                                                      .smscontroller,
                                                                  TextInputType
                                                                      .phone,
                                                                  true,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          _buildText(
                                                              mediaQuery,
                                                              'Email Address',
                                                              0.095,
                                                              ''),
                                                          _buildTextWidget(
                                                            mediaQuery,
                                                            0.90,
                                                            controller
                                                                .emailController,
                                                            TextInputType.text,
                                                            false,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          _buildText(
                                                              mediaQuery,
                                                              'Contact Person',
                                                              0.095,
                                                              ''),
                                                          _buildTextWidget(
                                                            mediaQuery,
                                                            0.90,
                                                            controller
                                                                .contactPersonController,
                                                            TextInputType.phone,
                                                            true,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          _buildText(
                                                              mediaQuery,
                                                              'Bank Name',
                                                              0.095,
                                                              ''),
                                                          _buildTextWidget(
                                                            mediaQuery,
                                                            0.30,
                                                            controller
                                                                .bankNameController,
                                                            TextInputType.text,
                                                            false,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          _buildText(
                                                              mediaQuery,
                                                              'Branch Name',
                                                              0.095,
                                                              ''),
                                                          _buildTextWidget(
                                                            mediaQuery,
                                                            0.30,
                                                            controller
                                                                .branchNameController,
                                                            TextInputType.text,
                                                            false,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          _buildText(
                                                              mediaQuery,
                                                              'IFSC Code',
                                                              0.095,
                                                              ''),
                                                          _buildTextWidget(
                                                            mediaQuery,
                                                            0.30,
                                                            controller
                                                                .ifscCodeController,
                                                            TextInputType.text,
                                                            false,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          _buildText(
                                                              mediaQuery,
                                                              'A/c Name',
                                                              0.095,
                                                              ''),
                                                          _buildTextWidget(
                                                            mediaQuery,
                                                            0.30,
                                                            controller
                                                                .accNameController,
                                                            TextInputType.text,
                                                            false,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          _buildText(
                                                              mediaQuery,
                                                              'A/c No.',
                                                              0.095,
                                                              ''),
                                                          _buildTextWidget(
                                                            mediaQuery,
                                                            0.30,
                                                            controller
                                                                .accNoController,
                                                            TextInputType.text,
                                                            false,
                                                          ),
                                                        ],
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
                                    Container(
                                      width: mediaQuery.size.width * 0.48,
                                      height: 343,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          right: mediaQuery.size.width * 0.06,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Text(
                                                    'Tax Information',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      decorationColor:
                                                          Colors.black,
                                                      decorationThickness: 1.5,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                _buildText(
                                                                    mediaQuery,
                                                                    'PAN No.',
                                                                    0.095,
                                                                    ''),
                                                                _buildTextWidget(
                                                                  mediaQuery,
                                                                  0.40,
                                                                  controller
                                                                      .panNoController,
                                                                  TextInputType
                                                                      .text,
                                                                  false,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                _buildText(
                                                                    mediaQuery,
                                                                    'GST No.',
                                                                    0.095,
                                                                    ''),
                                                                _buildTextWidget(
                                                                  mediaQuery,
                                                                  0.40,
                                                                  controller
                                                                      .gstController,
                                                                  TextInputType
                                                                      .text,
                                                                  false,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                _buildText(
                                                                    mediaQuery,
                                                                    'Registration Type',
                                                                    0.095,
                                                                    ''),
                                                                _buildTextWidget(
                                                                  mediaQuery,
                                                                  0.40,
                                                                  controller
                                                                      .registrationTypeController,
                                                                  TextInputType
                                                                      .text,
                                                                  false,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                _buildText(
                                                                    mediaQuery,
                                                                    'CST No.',
                                                                    0.095,
                                                                    ''),
                                                                _buildTextWidget(
                                                                  mediaQuery,
                                                                  0.40,
                                                                  controller
                                                                      .cstNoController,
                                                                  TextInputType
                                                                      .text,
                                                                  false,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                _buildText(
                                                                    mediaQuery,
                                                                    'LST No.',
                                                                    0.095,
                                                                    ''),
                                                                _buildTextWidget(
                                                                  mediaQuery,
                                                                  0.40,
                                                                  controller
                                                                      .lstNoController,
                                                                  TextInputType
                                                                      .text,
                                                                  false,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                _buildText(
                                                                    mediaQuery,
                                                                    'Service Tax No.',
                                                                    0.095,
                                                                    ''),
                                                                _buildTextWidget(
                                                                  mediaQuery,
                                                                  0.40,
                                                                  controller
                                                                      .serviceTypeController,
                                                                  TextInputType
                                                                      .text,
                                                                  false,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
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
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: Container(
                              alignment: Alignment.center,
                              width: mediaQuery.size.width * 0.96,
                              height: 65,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.10,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04,
                                        child: SizedBox(
                                          child: ElevatedButton(
                                            onPressed: updateLedgerData,
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                const Color.fromARGB(
                                                    172, 236, 226, 137),
                                              ),
                                              shape: MaterialStateProperty.all<
                                                  OutlinedBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1.0),
                                                  side: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 88, 81, 11),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Save [F4]',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.10,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LedgerHome(),
                                                  ),
                                                );
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(
                                                  const Color.fromARGB(
                                                      172, 236, 226, 137),
                                                ),
                                                shape: MaterialStateProperty
                                                    .all<OutlinedBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1.0),
                                                    side: const BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 88, 81, 11),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Cancel',
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              if (_isSaving)
                Center(
                  child: Lottie.asset('lottie/loading.json'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildRowWidget(
    MediaQueryData mediaQuery,
    String text1,
    TextEditingController controller1,
    TextEditingController controller2,
  ) {
    return Row(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(mediaQuery, text1, 0.10, ''),
              _buildTextWidget(
                mediaQuery,
                0.26,
                controller1,
                TextInputType.text,
                false,
              ),
              const SizedBox(
                width: 10,
              ),
              _buildText(mediaQuery, 'Dated', 0.04, ''),
              _buildTextWidget(
                mediaQuery,
                0.20,
                controller2,
                TextInputType.text,
                false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Flexible _buildText(
      MediaQueryData mediaQuery, String text, double width, String? text2) {
    return Flexible(
      child: SizedBox(
        width: mediaQuery.size.width * width,
        height: 25,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: text,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF590D82),
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: text2,
                style: GoogleFonts.poppins(
                  color: Colors.red, // Set the color to red
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Expanded _buildTextWidget(
    MediaQueryData mediaQuery,
    double width,
    TextEditingController controller,
    TextInputType? keyboardType,
    bool? enableFormatting,
  ) {
    return Expanded(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * width,
          maxHeight: 40,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(0),
        ),
        alignment: Alignment.centerLeft,
        child: TextFormField(
          textAlign: TextAlign.start,
          cursorHeight: 18,
          keyboardType: keyboardType ?? TextInputType.number,
          inputFormatters: enableFormatting != null && enableFormatting
              ? <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ]
              : null,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter correct values';
            }
            return null;
          },
          onSaved: (newValue) {
            controller.text = newValue!;
          },
          controller: controller,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 5.0, bottom: 8.0),
          ),
        ),
      ),
    );
  }
}
