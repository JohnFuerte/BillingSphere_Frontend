import 'dart:math';

import 'package:billingsphere/data/repository/ledger_repository.dart';
import 'package:billingsphere/utils/constant.dart';
import 'package:billingsphere/utils/controllers/ledger_text_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'dart:html' as html;

import '../../data/models/ledgerGroup/ledger_group_model.dart';
import '../../data/models/price/price_category.dart';
import '../../data/repository/ledger_group_respository.dart';
import '../../data/repository/price_category_repository.dart';
import '../DB_homepage.dart';
import '../searchable_dropdown.dart';
import 'LG_HOME.dart';

class LGMyDesktopBody extends StatefulWidget {
  const LGMyDesktopBody({super.key});

  @override
  State<LGMyDesktopBody> createState() => _LGMyDesktopBodyState();
}

class _LGMyDesktopBodyState extends State<LGMyDesktopBody> {
  LedgerFormController controller = LedgerFormController();
  final _formKey = GlobalKey<FormState>();
  final LedgerService ledgerService = LedgerService();
  bool _isSaving = false;
  final formatter = DateFormat.yMd();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchController2 = TextEditingController();
  // Dropdown Data
  List<LedgerGroup> fetchedLedgerGroups = [];
  List<PriceCategory> fetchedPriceCategories = [];
  late FocusNode ledgerName;
  late FocusNode ledgerGroup;
  late FocusNode ledgerCode;
  late FocusNode printName;
  late FocusNode aliasName;
  late FocusNode billwiseAccountingN;
  late FocusNode creditDays;
  late FocusNode openingBalance;
  late FocusNode debitBalance;
  late FocusNode ledgerType;
  late FocusNode priceListCategory;
  late FocusNode remarks;
  late FocusNode status;
  late FocusNode mailingName;
  late FocusNode address;
  late FocusNode city;
  late FocusNode region;
  late FocusNode state;
  late FocusNode pincode;
  late FocusNode tel;
  late FocusNode fax;
  late FocusNode mobile;
  late FocusNode mobile2;
  late FocusNode sms;
  late FocusNode email;
  late FocusNode contactPerson;
  late FocusNode bankName;
  late FocusNode branchName;
  late FocusNode ifsc;
  late FocusNode accName;
  late FocusNode accNo;
  late FocusNode panNo;
  late FocusNode gst;
  late FocusNode gstDated;
  late FocusNode cstNo;
  late FocusNode cstDated;
  late FocusNode lstNo;
  late FocusNode lstDated;
  late FocusNode serviceTaxNo;
  late FocusNode serviceTaxDated;
  late FocusNode registrationType;
  late FocusNode registrationTypeDated;

  @override
  void dispose() {
    ledgerName.dispose();
    ledgerGroup.dispose();
    ledgerCode.dispose();
    printName.dispose();
    aliasName.dispose();
    billwiseAccountingN.dispose();
    creditDays.dispose();
    openingBalance.dispose();
    debitBalance.dispose();
    ledgerType.dispose();
    priceListCategory.dispose();
    remarks.dispose();
    status.dispose();
    mailingName.dispose();
    address.dispose();
    city.dispose();
    region.dispose();
    state.dispose();
    pincode.dispose();
    tel.dispose();
    fax.dispose();
    mobile.dispose();
    mobile2.dispose();
    sms.dispose();
    email.dispose();
    contactPerson.dispose();
    bankName.dispose();
    branchName.dispose();
    ifsc.dispose();
    accName.dispose();
    accNo.dispose();
    panNo.dispose();
    gst.dispose();
    gstDated.dispose();
    cstNo.dispose();
    cstDated.dispose();
    lstNo.dispose();
    lstDated.dispose();
    serviceTaxNo.dispose();
    serviceTaxDated.dispose();
    registrationType.dispose();
    registrationTypeDated.dispose();
    ledgerName.dispose();

    super.dispose();
  }

  // Dropdown Values
  String? selectedLedgerGId;
  String? selectedPriceCId;
  String? ledgerTitle;
  String? billwiseAccounting;
  String? isActived;
  String selectedPriceType = 'DEALER';
  List<String> pricetype = ['DEALER', 'SUB DEALER', 'RETAIL', 'MRP'];

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

  final LedgerGroupService ledgerGroupService = LedgerGroupService();
  final PriceCategoryRepository priceCategoryRepository =
      PriceCategoryRepository();

  Future<void> fetchLedgerGroups() async {
    try {
      List<LedgerGroup> groups = await ledgerGroupService.fetchLedgerGroups();

      setState(() {
        fetchedLedgerGroups = groups;
        selectedLedgerGId = fetchedLedgerGroups[0].id;
      });
    } catch (error) {
      // Handle errors here
      print('Error fetching ledger groups: $error');
    }
  }

  // Future<void> fetchPriceCategories() async {
  //   try {
  //     List<PriceCategory> categories =
  //         await priceCategoryRepository.fetchPriceCategories();
  //     setState(() {
  //       fetchedPriceCategories = categories;
  //       selectedPriceCId = fetchedPriceCategories[0].id;
  //     });
  //     print('Price Categories: $fetchedPriceCategories');
  //   } catch (error) {
  //     // Handle errors here
  //     print('Error fetching price categories: $error');
  //   }
  // }

  void setRandomNumberToController() {
    Random random = Random();
    int randomNumber = random.nextInt(
        1000000); // Generates a random number between 0 and 999999 (inclusive)
    setState(() {
      controller.ledgerCodeController.text = randomNumber.toString();
    });
  }

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

  @override
  void initState() {
    initializeFocusNode();
    fetchLedgerGroups();
    // fetchPriceCategories();
    setRandomNumberToController();
    controller.debitBalanceController.text = '0.00';

    setState(() {
      ledgerTitle = 'Dr';
      billwiseAccounting = 'Yes';
      isActived = 'Yes';
    });

    super.initState();
  }

  void initializeFocusNode() {
    ledgerName = FocusNode();
    ledgerGroup = FocusNode();
    ledgerCode = FocusNode();
    printName = FocusNode();
    aliasName = FocusNode();
    billwiseAccountingN = FocusNode();
    creditDays = FocusNode();
    openingBalance = FocusNode();
    debitBalance = FocusNode();
    ledgerType = FocusNode();
    priceListCategory = FocusNode();
    remarks = FocusNode();
    status = FocusNode();
    mailingName = FocusNode();
    address = FocusNode();
    city = FocusNode();
    region = FocusNode();
    state = FocusNode();
    pincode = FocusNode();
    tel = FocusNode();
    fax = FocusNode();
    mobile = FocusNode();
    mobile2 = FocusNode();
    sms = FocusNode();
    email = FocusNode();
    contactPerson = FocusNode();
    bankName = FocusNode();
    branchName = FocusNode();
    ifsc = FocusNode();
    accName = FocusNode();
    accNo = FocusNode();
    panNo = FocusNode();
    gst = FocusNode();
    gstDated = FocusNode();
    cstNo = FocusNode();
    cstDated = FocusNode();
    lstNo = FocusNode();
    lstDated = FocusNode();
    serviceTaxNo = FocusNode();
    serviceTaxDated = FocusNode();
    registrationType = FocusNode();
    registrationTypeDated = FocusNode();
  }

  void createLedger() async {
    if (controller.nameController.text.isEmpty ||
        controller.printNameController.text.isEmpty ||
        controller.openingBalanceController.text.isEmpty ||
        controller.ledgerCodeController.text.isEmpty ||
        controller.regionController.text.isEmpty ||
        controller.mobileController.text.isEmpty) {
      setState(() {
        _isSaving = false;
      });
      Fluttertoast.showToast(
        msg: 'Please fill all the fields as they are required.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      return;
    } else {
      setState(() {
        _isSaving = true;
      });
      try {
        final justCreatedLedger = ledgerService.createLedger(
          name: controller.nameController.text,
          printName: controller.printNameController.text,
          aliasName: controller.aliasNameController.text,
          ledgerGroup: selectedLedgerGId!,
          date: formatter.format(DateTime.now()),
          bilwiseAccounting: billwiseAccounting!,
          creditDays: int.tryParse(controller.creditDaysController.text) ?? 0,
          openingBalance:
              double.tryParse(controller.openingBalanceController.text) ?? 0.00,
          debitBalance:
              double.tryParse(controller.debitBalanceController.text) ?? 0.00,
          ledgerType: ledgerTitle!,
          priceListCategory: selectedPriceType,
          remarks: controller.remarksController.text,
          status: isActived!,
          ledgerCode: int.tryParse(controller.ledgerCodeController.text) ?? 0,
          mailingName: controller.mailingNameController.text,
          address: controller.addressController.text,
          city: controller.cityController.text,
          region: controller.regionController.text,
          state: selectedPlaceState,
          pincode: int.tryParse(controller.pincodeController.text) ?? 0,
          tel: int.tryParse(controller.telController.text) ?? 0,
          fax: int.tryParse(controller.faxController.text) ?? 0,
          mobile: int.tryParse(controller.mobileController.text) ?? 0,
          sms: int.tryParse(controller.smscontroller.text) ?? 0,
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
          registrationTypeDated:
              controller.registrationTypeDatedController.text,
          context: context,
        );

        // Delay...
        await Future.delayed(const Duration(seconds: 1));

        Navigator.of(context).pop(justCreatedLedger);
      } catch (e) {
        print('Error creating ledger: $e');
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (mounted) {
      FocusScope.of(context).requestFocus(ledgerName);
    }
  }

  final List<String> ledgers = ['Dr', 'Cr'];
  final List<String> billwiseAccount = ['Yes', 'No'];
  final List<String> isActive = ['Yes', 'No'];

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return _isSaving
        ? Scaffold(
            body: Center(child: Constants.loadingIndicator),
          )
        : FocusScope(
            canRequestFocus: true,
            child: Scaffold(
              backgroundColor: Colors.white,
              // backgroundColor: const Color.fromARGB(255, 215, 215, 215),
              body: SingleChildScrollView(
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
                              height: 1164,
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
                                        decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 113, 8, 170),
                                        ),
                                        child: SizedBox(
                                          child: Text(
                                            ' NEW Ledger',
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
                                                                      color:
                                                                          const Color(
                                                                        0xFF590D82,
                                                                      ),
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
                                                        ledgerName,
                                                        // ledgerName,
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
                                                  printName,
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
                                                  aliasName,
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
                                                  printName,
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
                                                // NEW DROPDOWN....

                                                Flexible(
                                                  child: Container(
                                                    width:
                                                        mediaQuery.size.width *
                                                            0.90,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                    ),
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                      child: DropdownMenu<
                                                          LedgerGroup>(
                                                        // focusNode: partyFocus,
                                                        requestFocusOnTap: true,
                                                        initialSelection:
                                                            fetchedLedgerGroups
                                                                    .isNotEmpty
                                                                ? fetchedLedgerGroups
                                                                    .first
                                                                : null,
                                                        enableSearch: true,
                                                        trailingIcon:
                                                            const SizedBox
                                                                .shrink(),
                                                        textStyle:
                                                            GoogleFonts.poppins(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          // color: partyFocus.hasFocus
                                                          //     ? Colors.white
                                                          //     : Colors.black,
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
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          16),
                                                          isDense: true,
                                                          activeIndicatorBorder:
                                                              BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                        ),
                                                        expandedInsets:
                                                            EdgeInsets.zero,
                                                        focusNode: FocusNode(),
                                                        onSelected:
                                                            (LedgerGroup?
                                                                value) {
                                                          // Remove the focus from the textfield above
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          setState(() {
                                                            selectedLedgerGId =
                                                                value!.id;
                                                          });
                                                        },
                                                        dropdownMenuEntries:
                                                            fetchedLedgerGroups.map<
                                                                    DropdownMenuEntry<
                                                                        LedgerGroup>>(
                                                                (LedgerGroup
                                                                    value) {
                                                          return DropdownMenuEntry<
                                                              LedgerGroup>(
                                                            value: value,
                                                            label: value.name,
                                                            style: ButtonStyle(
                                                              textStyle:
                                                                  WidgetStateProperty
                                                                      .all(
                                                                GoogleFonts
                                                                    .poppins(
                                                                  fontSize: 16,
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
                                                          height: 35,
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
                                                              value:
                                                                  billwiseAccounting,
                                                              isExpanded: true,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          5.0),
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
                                                                0.058,
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
                                                        creditDays,
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
                                                                        'Op. Balance(${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year.toString().substring(2)})',
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
                                                          height: 35,
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
                                                                  .allow(
                                                                RegExp(
                                                                    r'^\d+\.?\d{0,2}'),
                                                              ),
                                                              LengthLimitingTextInputFormatter(
                                                                  10),
                                                            ],
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
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
                                                            height: 35,
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
                                                                isExpanded:
                                                                    true,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            5.0),
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
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                    ),
                                                    child: TextFormField(
                                                      cursorHeight: 18,
                                                      onSaved: (newValue) {
                                                        controller
                                                            .debitBalanceController
                                                            .text = newValue!;
                                                      },
                                                      inputFormatters: <TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .allow(
                                                          RegExp(
                                                              r'^\d+\.?\d{0,2}'),
                                                        ),
                                                        LengthLimitingTextInputFormatter(
                                                            10),
                                                      ],
                                                      controller: controller
                                                          .debitBalanceController,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
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
                                                    height: 35,
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
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: const Color(
                                                              0xFF590D82),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
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
                                                    child: TextFormField(
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
                                                            FontWeight.bold,
                                                      ),
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
                                                            0.09,
                                                    height: 35,
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
                                                        underline: Container(),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 5.0),
                                                        value: isActived,
                                                        isExpanded: true,
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
                                      height: 809,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                        ),
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
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 0, 0, 0),
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
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                                            0.95,
                                                            controller
                                                                .ledgerCodeController,
                                                            TextInputType.text,
                                                            false,
                                                            ledgerCode,
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
                                                            mailingName,
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
                                                                    contentPadding: EdgeInsets.only(
                                                                        left:
                                                                            0.0,
                                                                        bottom:
                                                                            8.0),
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
                                                                  false,
                                                                  region,
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                _buildText(
                                                                  mediaQuery,
                                                                  'State',
                                                                  0.04,
                                                                  '*',
                                                                ),
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
                                                                          .only(
                                                                    left: 5.0,
                                                                  ),
                                                                  child:
                                                                      SearchableDropDown(
                                                                    controller:
                                                                        _searchController2,
                                                                    searchController:
                                                                        _searchController2,
                                                                    value:
                                                                        selectedPlaceState,
                                                                    onChanged:
                                                                        (String?
                                                                            newValue) {
                                                                      setState(
                                                                          () {
                                                                        selectedPlaceState =
                                                                            newValue!;
                                                                      });
                                                                    },
                                                                    items: placestate
                                                                        .map((String
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
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                    searchMatchFn:
                                                                        (item,
                                                                            searchValue) {
                                                                      final itemValue =
                                                                          item.value
                                                                              as String;
                                                                      return itemValue
                                                                          .toLowerCase()
                                                                          .contains(
                                                                              searchValue.toLowerCase());
                                                                    },
                                                                  ),

                                                                  //     DropdownButtonHideUnderline(
                                                                  //   child:
                                                                  //       DropdownButton<
                                                                  //           String>(
                                                                  //     menuMaxHeight:
                                                                  //         300,
                                                                  //     isExpanded:
                                                                  //         true,
                                                                  //     value:
                                                                  //         selectedPlaceState,
                                                                  //     underline:
                                                                  //         Container(),
                                                                  //     onChanged:
                                                                  //         (String?
                                                                  //             newValue) {
                                                                  //       setState(
                                                                  //           () {
                                                                  //         selectedPlaceState =
                                                                  //             newValue!;
                                                                  //       });
                                                                  //     },
                                                                  //     items: placestate
                                                                  //         .map((String
                                                                  //             value) {
                                                                  //       return DropdownMenuItem<
                                                                  //           String>(
                                                                  //         value:
                                                                  //             value,
                                                                  //         child:
                                                                  //             Text(
                                                                  //           value,
                                                                  //           style:
                                                                  //               GoogleFonts.poppins(
                                                                  //             fontWeight:
                                                                  //                 FontWeight.bold,
                                                                  //           ),
                                                                  //           overflow:
                                                                  //               TextOverflow.ellipsis,
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
                                                            city,
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
                                                            fax,
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
                                                                  true,
                                                                  pincode,
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                _buildText(
                                                                    mediaQuery,
                                                                    'Tele No',
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
                                                                  tel,
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
                                                                  mobile,
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
                                                                  mobile2,
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
                                                              TextInputType
                                                                  .text,
                                                              false,
                                                              email),
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
                                                            TextInputType.text,
                                                            false,
                                                            contactPerson,
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
                                                            bankName,
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
                                                            branchName,
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
                                                            ifsc,
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
                                                            accName,
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
                                                            accNo,
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
                                      height: 355,
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
                                                Column(
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
                                                              _buildText(
                                                                  mediaQuery,
                                                                  '  PAN No.',
                                                                  0.10,
                                                                  ''),
                                                              _buildTextWidget(
                                                                mediaQuery,
                                                                0.40,
                                                                controller
                                                                    .panNoController,
                                                                TextInputType
                                                                    .text,
                                                                false,
                                                                panNo,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Stack(
                                                      children: [
                                                        // Regex for GST Number (\d{2}[A-Z]{5}\d{4}[A-Z]{1}[A-Z\d]{1}[Z]{1}[A-Z\d]{1})
                                                        Positioned(
                                                          left: 80,
                                                          top: 0,
                                                          bottom: 10,
                                                          child: TextButton(
                                                            onPressed: () {
                                                              if (controller
                                                                  .gstController
                                                                  .text
                                                                  .isEmpty) {
                                                                PanaraConfirmDialog
                                                                    .showAnimatedGrow(
                                                                  context,
                                                                  title:
                                                                      "BillingSphere",
                                                                  message:
                                                                      "GST No. is empty. Please enter GST No. to check.",
                                                                  confirmButtonText:
                                                                      "Confirm",
                                                                  cancelButtonText:
                                                                      "Cancel",
                                                                  onTapCancel:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  onTapConfirm:
                                                                      () {
                                                                    // pop screen
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  panaraDialogType:
                                                                      PanaraDialogType
                                                                          .error,
                                                                );

                                                                print(
                                                                    'GST is empty');
                                                                return;
                                                              }
                                                              if (!RegExp(
                                                                      r'\d{2}[A-Z]{5}\d{4}[A-Z][A-Z\d]Z[A-Z\d]')
                                                                  .hasMatch(controller
                                                                      .gstController
                                                                      .text)) {
                                                                PanaraConfirmDialog
                                                                    .showAnimatedGrow(
                                                                  context,
                                                                  title:
                                                                      "BillingSphere",
                                                                  message:
                                                                      "GST No. is not valid. Please enter valid GST No. to check.",
                                                                  confirmButtonText:
                                                                      "Confirm",
                                                                  cancelButtonText:
                                                                      "Cancel",
                                                                  onTapCancel:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  onTapConfirm:
                                                                      () {
                                                                    // pop screen
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  panaraDialogType:
                                                                      PanaraDialogType
                                                                          .error,
                                                                );
                                                                print(
                                                                    'GST is not valid');
                                                                return;
                                                              } else {
                                                                // Call API
                                                                const url =
                                                                    'https://services.gst.gov.in/services/searchtp';

                                                                // Open the URL in a new browser tab
                                                                html.window.open(
                                                                    url,
                                                                    '_blank');
                                                              }
                                                            },
                                                            child: Text(
                                                              'Check',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                color: Colors
                                                                    .blueAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                decorationColor:
                                                                    Colors
                                                                        .blueAccent,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
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
                                                                      '  GST No.',
                                                                      0.10,
                                                                      ''),
                                                                  _buildTextWidget(
                                                                    mediaQuery,
                                                                    0.40,
                                                                    controller
                                                                        .gstController,
                                                                    TextInputType
                                                                        .text,
                                                                    false,
                                                                    gst,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )
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
                                                              _buildText(
                                                                  mediaQuery,
                                                                  '  Registration Type',
                                                                  0.10,
                                                                  ''),
                                                              _buildTextWidget(
                                                                mediaQuery,
                                                                0.40,
                                                                controller
                                                                    .registrationTypeController,
                                                                TextInputType
                                                                    .text,
                                                                false,
                                                                registrationType,
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
                                                              _buildText(
                                                                  mediaQuery,
                                                                  '  CST No.',
                                                                  0.10,
                                                                  ''),
                                                              _buildTextWidget(
                                                                  mediaQuery,
                                                                  0.40,
                                                                  controller
                                                                      .cstNoController,
                                                                  TextInputType
                                                                      .text,
                                                                  false,
                                                                  cstNo),
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
                                                              _buildText(
                                                                  mediaQuery,
                                                                  '  LST No.',
                                                                  0.10,
                                                                  ''),
                                                              _buildTextWidget(
                                                                mediaQuery,
                                                                0.40,
                                                                controller
                                                                    .lstNoController,
                                                                TextInputType
                                                                    .text,
                                                                false,
                                                                lstNo,
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
                                                              _buildText(
                                                                  mediaQuery,
                                                                  '  Service Tax No. ',
                                                                  0.10,
                                                                  ''),
                                                              _buildTextWidget(
                                                                mediaQuery,
                                                                0.40,
                                                                controller
                                                                    .serviceTypeController,
                                                                TextInputType
                                                                    .text,
                                                                false,
                                                                serviceTaxNo,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                  ],
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
                                            onPressed: createLedger,
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
            ),
          );
  }

  Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      controller.text = formattedDate;
      print(controller.text);
    }
  }

  Row _buildRowWidget(
    MediaQueryData mediaQuery,
    String text1,
    TextEditingController controller1,
    TextEditingController controller2,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildText(mediaQuery, text1, 0.10, ''),
        _buildTextWidget(mediaQuery, 0.26, controller1, TextInputType.text,
            false, FocusNode()),
        const SizedBox(
          width: 10,
        ),
        _buildText(mediaQuery, 'Dated', 0.04, ''),
        _buildTextWidget(mediaQuery, 0.20, controller2, TextInputType.text,
            false, FocusNode()),
        IconButton(
          onPressed: () {
            selectDate(context, controller2);
          },
          icon: const Icon(
            Icons.calendar_today,
            size: 15,
          ),
          color: Colors.black,
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
    FocusNode? focusNode,
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
          focusNode: focusNode ?? FocusNode(),
          cursorHeight: 18,
          keyboardType: keyboardType ?? TextInputType.number,
          inputFormatters: enableFormatting != null && enableFormatting
              ? <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ]
              : null,
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
