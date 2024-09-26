import 'package:billingsphere/data/repository/sales_man_repository.dart';
import 'package:billingsphere/views/sumit_screen/sumit_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/salesMan/sales_man_model.dart';
import '../../data/repository/ledger_repository.dart';
import '../SE_common/SE_top_textfield.dart';

class SalesManDesktopbody extends StatefulWidget {
  const SalesManDesktopbody({super.key});

  @override
  State<SalesManDesktopbody> createState() => _SalesManDesktopbodyState();
}

class _SalesManDesktopbodyState extends State<SalesManDesktopbody> {
  List<Ledger> ledgerList = [];
  LedgerService ledgerService = LedgerService();
  SalesManRepository salesManRepository = SalesManRepository();

  String? selectedAC;
  String? selectedIsActive;
  String? selectedAc;

  // TextEditingControllers for all TextFields
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fixedCommissionController = TextEditingController();

  // FocusNode for all TextFields
  FocusNode nameFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode mobileNoFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode fixedCommissionFocusNode = FocusNode();

  // Radio
  int? selectedRadio;

  // Fetch all Ledgers
  Future<void> fetchAllLedgers() async {
    try {
      final List<Ledger> ledgers = await ledgerService.fetchLedgers();

      setState(() {
        ledgerList = ledgers;
        selectedAC = ledgers[0].id;
      });
    } catch (error) {
      print('Failed to fetch Ledgers: $error');
    }
  }

  //  Create New SalesMan
  Future<void> createNewSalesMan() async {
    final SalesMan newSalesMan = SalesMan(
      id: '',
      ledger: selectedAC!,
      name: nameController.text,
      address: addressController.text,
      mobile: addressController.text,
      email: emailController.text,
      fixedCommission: double.parse(fixedCommissionController.text),
      postInAc: selectedAc,
      isActive: selectedIsActive,
    );

    await salesManRepository.createNewSalesMan(newSalesMan, context);

    clearAllTextFields();
  }

  // Clear all TextFields
  void clearAllTextFields() {
    nameController.clear();
    addressController.clear();
    mobileNoController.clear();
    emailController.clear();
    fixedCommissionController.clear();
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    mobileNoController.dispose();
    emailController.dispose();
    fixedCommissionController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    fetchAllLedgers();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (mounted) {
      FocusScope.of(context).requestFocus(nameFocusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.escape): const ActivateIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (ActivateIntent intent) {
                Navigator.of(context).pop();
                return null;
              },
            ),
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: const Color(0xFF8A2BE2),
              leading: Container(),
              centerTitle: true,
              title: Text(
                'NEW S.Man',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Close button action
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            body: FocusScope(
              child: Responsive(
                mobile: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 1,
                      maxHeight: MediaQuery.of(context).size.height * 0.60,
                    ),
                    width: MediaQuery.of(context).size.width / 1,
                    height: MediaQuery.of(context).size.height * 0.60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Name",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " *",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SETopTextfield(
                                  controller: nameController,
                                  // focusNode: nameFocusNode,
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(nameFocusNode);
                                    setState(() {});
                                  },
                                  // onEditingComplete: () {
                                  //   FocusScope.of(context)
                                  //       .requestFocus(fixedCommissionFocusNode);
                                  //   setState(() {});
                                  // },
                                  onSaved: (newValue) {},
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height: 40,
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 16.0),
                                  hintText: '',
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Ledger",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " *",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height: 40,
                                  padding: const EdgeInsets.all(2.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedAC,
                                      menuMaxHeight: 400.0,
                                      isDense: true,
                                      isExpanded: true,
                                      underline: Container(),
                                      icon: const SizedBox.shrink(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedAC = newValue;
                                        });
                                      },
                                      items: ledgerList
                                          .map<DropdownMenuItem<String>>(
                                              (Ledger value) {
                                        return DropdownMenuItem<String>(
                                          value: value.id,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0, left: 5),
                                            child: Text(
                                              value.name,
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  child: Text(
                                    "Post In A/C",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height: 40,
                                  padding: const EdgeInsets.all(2.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedAc,
                                      underline: Container(),
                                      icon: const SizedBox.shrink(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedAc = newValue;
                                        });
                                      },
                                      items: ["Yes", "No"]
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0, left: 5),
                                            child: Text(
                                              value,
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Fixed Commission %",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                ),
                                SETopTextfield(
                                  controller: fixedCommissionController,
                                  // focusNode: fixedCommissionFocusNode,
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(fixedCommissionFocusNode);

                                    setState(() {});
                                  },
                                  // onEditingComplete: () {
                                  //   FocusScope.of(context)
                                  //       .requestFocus(addressFocusNode);
                                  //   setState(() {});
                                  // },
                                  onSaved: (newValue) {},
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height: 40,
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 16.0),
                                  hintText: '',
                                  alignment: TextAlign.end,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      // Radio button
                                      Row(
                                        children: [
                                          Radio(
                                            value: 1,
                                            groupValue: selectedRadio,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedRadio = value;
                                              });
                                            },
                                          ),
                                          Text(
                                            "on Net Amount",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurple,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Radio button
                                      Row(
                                        children: [
                                          Radio(
                                            value: 2,
                                            groupValue: selectedRadio,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedRadio = value;
                                              });
                                            },
                                          ),
                                          Text(
                                            "on Taxable Amount",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurple,
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  child: Text(
                                    "Address",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                                SETopTextfield(
                                  controller: addressController,
                                  // focusNode: addressFocusNode,
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(addressFocusNode);
                                    setState(() {});
                                  },
                                  // onEditingComplete: () {
                                  //   FocusScope.of(context)
                                  //       .requestFocus(mobileNoFocusNode);
                                  //   setState(() {});
                                  // },
                                  onSaved: (newValue) {},
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 8.0, top: 8.0),
                                  hintText: '',
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  child: Text(
                                    "Mobile No",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                                SETopTextfield(
                                  controller: mobileNoController,
                                  // focusNode: mobileNoFocusNode,
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(mobileNoFocusNode);

                                    setState(() {});
                                  },
                                  // onEditingComplete: () {
                                  //   FocusScope.of(context)
                                  //       .requestFocus(emailFocusNode);
                                  //   setState(() {});
                                  // },
                                  onSaved: (newValue) {},
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height: 40,
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 16.0),
                                  hintText: '',
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  child: Text(
                                    "Email Address",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                                SETopTextfield(
                                  controller: emailController,
                                  // focusNode: emailFocusNode,
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(emailFocusNode);
                                    setState(() {});
                                  },
                                  // onEditingComplete: () {
                                  //   FocusScope.of(context)
                                  //       .requestFocus(nameFocusNode);
                                  //   setState(() {});
                                  // },
                                  onSaved: (newValue) {},
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height: 40,
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 16.0),
                                  hintText: '',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  child: Text(
                                    "Is Active",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height: 40,
                                  padding: const EdgeInsets.all(2.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedIsActive,
                                      underline: Container(),
                                      icon: const SizedBox.shrink(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedIsActive = newValue;
                                        });
                                      },
                                      items: ["Yes", "No"]
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0, left: 5),
                                            child: Text(
                                              value,
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: createNewSalesMan,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFFACD),
                                      border: Border.all(
                                        color: const Color(0xFFFFFACD),
                                        width: 1,
                                      ),
                                    ),
                                    width: MediaQuery.of(context).size.width *
                                        0.30,
                                    height: 40,
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
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFFACD),
                                      border: Border.all(
                                        color: const Color(0xFFFFFACD),
                                        width: 1,
                                      ),
                                    ),
                                    width: MediaQuery.of(context).size.width *
                                        0.30,
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
                        ],
                      ),
                    ),
                  ),
                ),
                tablet: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 1,
                        maxHeight: MediaQuery.of(context).size.height * 0.60,
                      ),
                      width: MediaQuery.of(context).size.width / 1,
                      height: MediaQuery.of(context).size.height * 0.60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Name",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurple,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " *",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SETopTextfield(
                                    controller: nameController,
                                    // focusNode: nameFocusNode,
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(nameFocusNode);
                                      setState(() {});
                                    },
                                    // onEditingComplete: () {
                                    //   FocusScope.of(context).requestFocus(
                                    //       fixedCommissionFocusNode);
                                    //   setState(() {});
                                    // },
                                    onSaved: (newValue) {},
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: 40,
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 16.0),
                                    hintText: '',
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Ledger",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurple,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " *",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    height: 40,
                                    padding: const EdgeInsets.all(2.0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: selectedAC,
                                        menuMaxHeight: 400.0,
                                        isDense: true,
                                        isExpanded: true,
                                        underline: Container(),
                                        icon: const SizedBox.shrink(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedAC = newValue;
                                          });
                                        },
                                        items: ledgerList
                                            .map<DropdownMenuItem<String>>(
                                                (Ledger value) {
                                          return DropdownMenuItem<String>(
                                            value: value.id,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 0, left: 5),
                                              child: Text(
                                                value.name,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Text(
                                      "Post In A/C",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    height: 40,
                                    padding: const EdgeInsets.all(2.0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: selectedAc,
                                        underline: Container(),
                                        icon: const SizedBox.shrink(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedAc = newValue;
                                          });
                                        },
                                        items: ["Yes", "No"]
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 0, left: 5),
                                              child: Text(
                                                value,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "Fixed Commission %",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SETopTextfield(
                                    controller: fixedCommissionController,
                                    // focusNode: fixedCommissionFocusNode,
                                    onTap: () {
                                      FocusScope.of(context).requestFocus(
                                          fixedCommissionFocusNode);

                                      setState(() {});
                                    },
                                    // onEditingComplete: () {
                                    //   FocusScope.of(context)
                                    //       .requestFocus(addressFocusNode);
                                    //   setState(() {});
                                    // },
                                    onSaved: (newValue) {},
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: 40,
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 16.0),
                                    hintText: '',
                                    alignment: TextAlign.end,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        // Radio button
                                        Row(
                                          children: [
                                            Radio(
                                              value: 1,
                                              groupValue: selectedRadio,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedRadio = value;
                                                });
                                              },
                                            ),
                                            Text(
                                              "on Net Amount",
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepPurple,
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Radio button
                                        Row(
                                          children: [
                                            Radio(
                                              value: 2,
                                              groupValue: selectedRadio,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedRadio = value;
                                                });
                                              },
                                            ),
                                            Text(
                                              "on Taxable Amount",
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepPurple,
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Text(
                                      "Address",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  SETopTextfield(
                                    controller: addressController,
                                    // focusNode: addressFocusNode,
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(addressFocusNode);
                                      setState(() {});
                                    },
                                    // onEditingComplete: () {
                                    //   FocusScope.of(context)
                                    //       .requestFocus(mobileNoFocusNode);
                                    //   setState(() {});
                                    // },
                                    onSaved: (newValue) {},
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 8.0, top: 8.0),
                                    hintText: '',
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Text(
                                      "Mobile No",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  SETopTextfield(
                                    controller: mobileNoController,
                                    // focusNode: mobileNoFocusNode,
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(mobileNoFocusNode);

                                      setState(() {});
                                    },
                                    // onEditingComplete: () {
                                    //   FocusScope.of(context)
                                    //       .requestFocus(emailFocusNode);
                                    //   setState(() {});
                                    // },
                                    onSaved: (newValue) {},
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: 40,
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 16.0),
                                    hintText: '',
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Text(
                                      "Email Address",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  SETopTextfield(
                                    controller: emailController,
                                    // focusNode: emailFocusNode,
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(emailFocusNode);
                                      setState(() {});
                                    },
                                    // onEditingComplete: () {
                                    //   FocusScope.of(context)
                                    //       .requestFocus(nameFocusNode);
                                    //   setState(() {});
                                    // },
                                    onSaved: (newValue) {},
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: 40,
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 16.0),
                                    hintText: '',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Text(
                                      "Is Active",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: 40,
                                    padding: const EdgeInsets.all(2.0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: selectedIsActive,
                                        underline: Container(),
                                        icon: const SizedBox.shrink(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedIsActive = newValue;
                                          });
                                        },
                                        items: ["Yes", "No"]
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 0, left: 5),
                                              child: Text(
                                                value,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: createNewSalesMan,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFFACD),
                                        border: Border.all(
                                          color: const Color(0xFFFFFACD),
                                          width: 1,
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      height: 40,
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
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFFACD),
                                        border: Border.all(
                                          color: const Color(0xFFFFFACD),
                                          width: 1,
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                desktop: Center(
                  child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 1.5,
                        maxHeight: MediaQuery.of(context).size.height * 0.60,
                      ),
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: MediaQuery.of(context).size.height * 0.60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Name",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurple,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " *",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SETopTextfield(
                                    controller: nameController,
                                    // focusNode: nameFocusNode,
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(nameFocusNode);
                                      setState(() {});
                                    },
                                    // onEditingComplete: () {
                                    //   FocusScope.of(context).requestFocus(
                                    //       fixedCommissionFocusNode);
                                    //   setState(() {});
                                    // },
                                    onSaved: (newValue) {},
                                    width: MediaQuery.of(context).size.width *
                                        0.40,
                                    height: 40,
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 16.0),
                                    hintText: '',
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Ledger",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurple,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " *",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    width: MediaQuery.of(context).size.width *
                                        0.40,
                                    height: 40,
                                    padding: const EdgeInsets.all(2.0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: selectedAC,
                                        menuMaxHeight: 400.0,
                                        isDense: true,
                                        isExpanded: true,
                                        underline: Container(),
                                        icon: const SizedBox.shrink(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedAC = newValue;
                                          });
                                        },
                                        items: ledgerList
                                            .map<DropdownMenuItem<String>>(
                                                (Ledger value) {
                                          return DropdownMenuItem<String>(
                                            value: value.id,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 0, left: 5),
                                              child: Text(
                                                value.name,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      child: Text(
                                        "Post In A/C",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration:
                                          BoxDecoration(border: Border.all()),
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      height: 40,
                                      padding: const EdgeInsets.all(2.0),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: selectedAc,
                                          underline: Container(),
                                          icon: const SizedBox.shrink(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedAc = newValue;
                                            });
                                          },
                                          items: ["Yes", "No"]
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 0, left: 5),
                                                child: Text(
                                                  value,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          "Fixed Commission",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SETopTextfield(
                                      controller: fixedCommissionController,
                                      // focusNode: fixedCommissionFocusNode,
                                      onTap: () {
                                        FocusScope.of(context).requestFocus(
                                            fixedCommissionFocusNode);

                                        setState(() {});
                                      },
                                      // onEditingComplete: () {
                                      //   FocusScope.of(context)
                                      //       .requestFocus(addressFocusNode);
                                      //   setState(() {});
                                      // },
                                      onSaved: (newValue) {},
                                      width: MediaQuery.of(context).size.width *
                                          0.08,
                                      height: 40,
                                      padding: const EdgeInsets.only(
                                          left: 8.0, bottom: 16.0),
                                      hintText: '',
                                      alignment: TextAlign.end,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          // Radio button
                                          Row(
                                            children: [
                                              Radio(
                                                value: 1,
                                                groupValue: selectedRadio,
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedRadio = value;
                                                  });
                                                },
                                              ),
                                              Text(
                                                "Net Amount",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.deepPurple,
                                                ),
                                              ),
                                            ],
                                          ),

                                          // Radio button
                                          Row(
                                            children: [
                                              Radio(
                                                value: 2,
                                                groupValue: selectedRadio,
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedRadio = value;
                                                  });
                                                },
                                              ),
                                              Text(
                                                "Txble Amount",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.deepPurple,
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
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Text(
                                      "Address",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  SETopTextfield(
                                    controller: addressController,
                                    // focusNode: addressFocusNode,
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(addressFocusNode);
                                      setState(() {});
                                    },
                                    // onEditingComplete: () {
                                    //   FocusScope.of(context)
                                    //       .requestFocus(mobileNoFocusNode);
                                    //   setState(() {});
                                    // },
                                    onSaved: (newValue) {},
                                    width: MediaQuery.of(context).size.width *
                                        0.40,
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 8.0, top: 8.0),
                                    hintText: '',
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Text(
                                      "Mobile No",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  SETopTextfield(
                                    controller: mobileNoController,
                                    // focusNode: mobileNoFocusNode,
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(mobileNoFocusNode);

                                      setState(() {});
                                    },
                                    // onEditingComplete: () {
                                    //   FocusScope.of(context)
                                    //       .requestFocus(emailFocusNode);
                                    //   setState(() {});
                                    // },
                                    onSaved: (newValue) {},
                                    width: MediaQuery.of(context).size.width *
                                        0.40,
                                    height: 40,
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 16.0),
                                    hintText: '',
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Text(
                                      "Email Address",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  SETopTextfield(
                                    controller: emailController,
                                    // focusNode: emailFocusNode,
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(emailFocusNode);
                                      setState(() {});
                                    },
                                    // onEditingComplete: () {
                                    //   FocusScope.of(context)
                                    //       .requestFocus(nameFocusNode);
                                    //   setState(() {});
                                    // },
                                    onSaved: (newValue) {},
                                    width: MediaQuery.of(context).size.width *
                                        0.40,
                                    height: 40,
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 16.0),
                                    hintText: '',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Text(
                                      "Is Active",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    width: MediaQuery.of(context).size.width *
                                        0.40,
                                    height: 40,
                                    padding: const EdgeInsets.all(2.0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: selectedIsActive,
                                        underline: Container(),
                                        icon: const SizedBox.shrink(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedIsActive = newValue;
                                          });
                                        },
                                        items: ["Yes", "No"]
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 0, left: 5),
                                              child: Text(
                                                value,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: createNewSalesMan,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFFACD),
                                        border: Border.all(
                                          color: const Color(0xFFFFFACD),
                                          width: 1,
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      height: 40,
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
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFFACD),
                                        border: Border.all(
                                          color: const Color(0xFFFFFACD),
                                          width: 1,
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
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
                          ],
                        ),
                      )),
                ),
              ),
            ),
          ),
        ));
  }
}
