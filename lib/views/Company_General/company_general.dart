import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/newCompany/new_company_model.dart';
import '../../data/models/newCompany/store_model.dart';
import '../../data/repository/new_company_repository.dart';
import '../DB_widgets/Desktop_widgets/d_custom_buttons.dart';
import 'custom_textbox.dart';

class CompanyGeneral extends StatefulWidget {
  const CompanyGeneral({super.key});

  @override
  State<CompanyGeneral> createState() => _CompanyGeneralState();
}

class _CompanyGeneralState extends State<CompanyGeneral> {
  TextEditingController companyNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController inActiveController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController taglineController = TextEditingController();
  TextEditingController lstNoController = TextEditingController();
  TextEditingController cstNoController = TextEditingController();
  TextEditingController gstinController = TextEditingController();
  TextEditingController signatoryController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController panNoController = TextEditingController();
  TextEditingController ewayBillController = TextEditingController();
  TextEditingController cachingController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController upiController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();

  TextEditingController storePhoneController = TextEditingController();
  TextEditingController storeStatusController = TextEditingController();
  TextEditingController storeEmailController = TextEditingController();
  TextEditingController storePasswordController = TextEditingController();
  TextEditingController storeCodeController = TextEditingController();

  // not in use
  TextEditingController taxationController = TextEditingController();
  TextEditingController acYearController = TextEditingController();
  TextEditingController acYearToController = TextEditingController();
  TextEditingController emailIDController = TextEditingController();
  TextEditingController companyTypeController = TextEditingController();

  NewCompanyRepository newCompanyRepo = NewCompanyRepository();

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

  List<NewCompany> selectedComapny = [];
  String? selectedId;
  String id = '';
  String newcompanycode = '';

  Future<void> fetchNewCompany() async {
    try {
      final List<NewCompany> newcom = await newCompanyRepo.getAllCompanies();
      // Iterate over newcom and then access the stores and iterate over it and compare the code to the companyCode, if matched then add it to the selectedCompany

      List<NewCompany> filteredNewCompany = newcom
          .where((element) =>
              element.stores!.any((store) => companyCode!.contains(store.code)))
          .toList();

      final stores = filteredNewCompany[0]
          .stores!
          .where((element) => companyCode!.contains(element.code))
          .toList();

      setState(() {
        selectedComapny = filteredNewCompany;
        companyNameController.text = selectedComapny.first.companyName!;
        addressController.text = stores.first.address;
        inActiveController.text = stores.first.status.toString();
        cityController.text = stores.first.city;
        pincodeController.text = stores.first.pincode;
        stateController.text = stores.first.state;
        bankNameController.text = stores.first.bankName;
        ifscController.text = stores.first.ifsc;
        branchController.text = stores.first.branch;
        upiController.text = stores.first.upi;
        accountNoController.text = stores.first.accountNo;
        accountNameController.text = stores.first.accountName;
        storePhoneController.text = stores.first.phone;
        storeStatusController.text = stores.first.status;
        storeEmailController.text = stores.first.email;
        storePasswordController.text = stores.first.password;
        storeCodeController.text = stores.first.code.toString();
        id = selectedComapny.first.id;
        newcompanycode = selectedComapny.first.companyCode!;
        gstinController.text = selectedComapny.first.gstin!;
        countryController.text = selectedComapny.first.country!;
        taglineController.text = selectedComapny.first.tagline!;
        lstNoController.text = selectedComapny.first.lstNo!;
        cstNoController.text = selectedComapny.first.cstNo!;
        signatoryController.text = selectedComapny.first.signatory!;
        designationController.text = selectedComapny.first.designation!;
        panNoController.text = selectedComapny.first.pan!;
        ewayBillController.text = selectedComapny.first.ewayBill!;
        cachingController.text = selectedComapny.first.caching!;
        taxationController.text = selectedComapny.first.taxation!;
        acYearController.text = selectedComapny.first.acYear!;
        acYearToController.text = selectedComapny.first.acYearTo!;
        emailIDController.text = selectedComapny.first.email!;
        companyTypeController.text = selectedComapny.first.companyType!;
        passwordController.text = selectedComapny.first.password!;
        emailController.text = selectedComapny.first.email!;
        _logo1 = selectedComapny.first.logo1!.map((e) => e.data).toList();

        _logo2 = selectedComapny.first.logo2!.map((e) => e.data).toList();
        _signature =
            selectedComapny.first.signature!.map((e) => e.data).toList();
        _stores = stores;
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

  List<Uint8List> _logo1 = [];
  List<Uint8List> _logo2 = [];
  List<Uint8List> _signature = [];
  List<StoreModel> _stores = [];

  Future<void> updateCompany() async {
    List<ImageData>? logo1List;
    if (_logo1.isNotEmpty) {
      logo1List = _logo1
          .map((image) => ImageData(
                data: image,
                contentType: 'image/jpeg',
                filename: 'filename.jpg',
              ))
          .toList();

      print(logo1List.first.data);
    }
    List<ImageData>? logo2List;
    if (_logo2.isNotEmpty) {
      logo2List = _logo2
          .map((image) => ImageData(
                data: image,
                contentType: 'image/jpeg',
                filename: 'filename.jpg',
              ))
          .toList();
    }
    List<ImageData>? signatureList;
    if (_signature.isNotEmpty) {
      signatureList = _signature
          .map((image) => ImageData(
                data: image,
                contentType: 'image/jpeg',
                filename: 'filename.jpg',
              ))
          .toList();
    }

    try {
      NewCompany updatedCompany = NewCompany(
        id: id,
        companyCode: newcompanycode,
        companyName: companyNameController.text,
        companyType: companyTypeController.text,
        password: passwordController.text,
        country: countryController.text,
        tagline: taglineController.text,
        lstNo: lstNoController.text,
        cstNo: cstNoController.text,
        signatory: signatoryController.text,
        designation: designationController.text,
        pan: panNoController.text,
        ewayBill: ewayBillController.text,
        caching: cachingController.text,
        taxation: taxationController.text,
        acYear: acYearController.text,
        acYearTo: acYearToController.text,
        email: emailController.text,
        gstin: gstinController.text,
        stores: _stores,
        logo1: logo1List ?? [],
        logo2: logo2List ?? [],
        signature: signatureList ?? [],
      );

      await newCompanyRepo.updateNewCompany(updatedCompany, context);

      Fluttertoast.showToast(
        msg: 'User updated successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (error) {
      // Show a toast message indicating the error
      Fluttertoast.showToast(
        msg: 'Error updating company data: $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await setCompanyCode();
    await fetchNewCompany();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        backgroundColor: const Color.fromARGB(255, 10, 51, 234),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.arrow_left,
            color: Colors.white,
            size: 18,
          ),
        ),
        title: Center(
          child: Text(
            "COMPANY GENERAL",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black),
                      color: const Color.fromARGB(255, 4, 4, 244),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Editable Fields are in Blue Color",
                    style: GoogleFonts.poppins(
                      color: const Color.fromARGB(255, 4, 4, 244),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 28,
                        width: w * 0.7,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Company Name",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.purple.shade600),
                              ),
                            ),
                            Expanded(
                              flex: 9,
                              child: TextFormField(
                                readOnly: true,
                                controller: companyNameController,
                                onSaved: (newValue) {
                                  companyNameController.text = newValue!;
                                },
                                cursorHeight: 20,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(8.0),
                                    fillColor: Colors.black,
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(0))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 75,
                        width: w * 0.7,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 3,
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.purple.shade600,
                                    ),
                                    children: const <TextSpan>[
                                      TextSpan(text: 'Address '),
                                      TextSpan(
                                        text: '*',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 4, 4, 244),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Expanded(
                              flex: 9,
                              child: TextFormField(
                                controller: addressController,
                                onSaved: (newValue) {
                                  addressController.text = newValue!;
                                },
                                cursorHeight: 20,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(0))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 25),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 52,
                          width: w * 0.20,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "InActive Company",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.purple.shade600),
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 28,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: inActiveController,
                                  onSaved: (newValue) {
                                    inActiveController.text = newValue!;
                                  },
                                  cursorHeight: 20,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(8.0),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(0))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 52,
                          width: w * 0.20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Password",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.purple.shade600),
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 28,
                                child: TextFormField(
                                  readOnly: true,
                                  obscureText: true,
                                  controller: passwordController,
                                  onSaved: (newValue) {
                                    passwordController.text = newValue!;
                                  },
                                  cursorHeight: 20,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(8.0),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(0))),
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
              Row(
                children: [
                  CustomTextFormFieldRow(
                    readOnly: true,
                    controller: cityController,
                    onSaved: (newValue) {
                      cityController.text = newValue!;
                    },
                    labelText: 'City/Town',
                    firstFlex: 3,
                    secondFlex: 2,
                    containerWidth: 0.29,
                  ),
                  SizedBox(
                    width: w * 0.01,
                  ),
                  CustomTextFormFieldRow(
                    readOnly: true,
                    controller: pincodeController,
                    onSaved: (newValue) {
                      pincodeController.text = newValue!;
                    },
                    labelText: 'Pincode',
                    firstFlex: 2,
                    secondFlex: 3,
                    containerWidth: 0.1831,
                  ),
                  SizedBox(
                    width: w * 0.01,
                  ),
                  CustomTextFormFieldRow(
                    readOnly: true,
                    controller: countryController,
                    onSaved: (newValue) {
                      countryController.text = newValue!;
                    },
                    labelText: 'Country',
                    firstFlex: 2,
                    secondFlex: 3,
                    containerWidth: 0.1831,
                  ),
                  SizedBox(
                    width: w * 0.01,
                  ),
                  CustomTextFormFieldRow(
                    readOnly: true,
                    controller: stateController,
                    onSaved: (newValue) {
                      stateController.text = newValue!;
                    },
                    labelText: 'State',
                    firstFlex: 2,
                    secondFlex: 3,
                    containerWidth: 0.1838,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextFormFieldRow(
                readOnly: true,
                controller: taglineController,
                onSaved: (newValue) {
                  taglineController.text = newValue!;
                },
                labelText: 'Business Tagline',
                firstFlex: 3,
                secondFlex: 12,
                containerWidth: 0.87,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  CustomTextFormFieldRow(
                    readOnly: true,
                    controller: lstNoController,
                    onSaved: (newValue) {
                      lstNoController.text = newValue!;
                    },
                    labelText: 'LST No',
                    firstFlex: 4,
                    secondFlex: 3,
                    containerWidth: 0.3045,
                  ),
                  SizedBox(
                    width: w * 0.03,
                  ),
                  CustomTextFormFieldRow(
                    readOnly: true,
                    controller: cstNoController,
                    onSaved: (newValue) {
                      cstNoController.text = newValue!;
                    },
                    labelText: 'CST NO',
                    firstFlex: 3,
                    secondFlex: 4,
                    containerWidth: 0.253,
                  ),
                  SizedBox(
                    width: w * 0.0297,
                  ),
                  CustomTextFormFieldRow(
                    readOnly: true,
                    controller: gstinController,
                    onSaved: (newValue) {
                      gstinController.text = newValue!;
                    },
                    labelText: 'GSTIN',
                    firstFlex: 3,
                    secondFlex: 4,
                    containerWidth: 0.253,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  CustomTextFormFieldRow(
                    readOnly: true,
                    controller: signatoryController,
                    onSaved: (newValue) {
                      signatoryController.text = newValue!;
                    },
                    labelText: 'Autho. Signatory Person',
                    firstFlex: 4,
                    secondFlex: 3,
                    containerWidth: 0.3045,
                  ),
                  SizedBox(
                    width: w * 0.03,
                  ),
                  CustomTextFormFieldRow(
                    readOnly: true,
                    controller: designationController,
                    onSaved: (newValue) {
                      designationController.text = newValue!;
                    },
                    labelText: 'Designation',
                    firstFlex: 3,
                    secondFlex: 4,
                    containerWidth: 0.253,
                  ),
                  SizedBox(
                    width: w * 0.0297,
                  ),
                  CustomTextFormFieldRow(
                    readOnly: true,
                    controller: panNoController,
                    onSaved: (newValue) {
                      panNoController.text = newValue!;
                    },
                    labelText: 'PAN No',
                    firstFlex: 3,
                    secondFlex: 4,
                    containerWidth: 0.253,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  CustomTextFormFieldRow(
                    readOnly: true,
                    controller: ewayBillController,
                    onSaved: (newValue) {
                      ewayBillController.text = newValue!;
                    },
                    labelText: 'Eway Bill Place',
                    firstFlex: 4,
                    secondFlex: 3,
                    containerWidth: 0.3045,
                  ),
                  SizedBox(
                    width: w * 0.03,
                  ),
                  CustomTextFormFieldRow(
                    readOnly: true,
                    controller: cachingController,
                    onSaved: (newValue) {
                      cachingController.text = newValue!;
                    },
                    labelText: 'Caching',
                    firstFlex: 3,
                    secondFlex: 4,
                    containerWidth: 0.253,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bank Detail",
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: Colors.purple.shade600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      CustomTextFormFieldRow(
                        readOnly: false,
                        isEditable: true,
                        controller: bankNameController,
                        onSaved: (newValue) {
                          bankNameController.text = newValue!;
                        },
                        labelText: 'Bank Name',
                        firstFlex: 4,
                        secondFlex: 5,
                        containerWidth: 0.24,
                      ),
                      SizedBox(
                        width: w * 0.01,
                      ),
                      CustomTextFormFieldRow(
                        readOnly: false,
                        isEditable: true,
                        controller: branchController,
                        onSaved: (newValue) {
                          branchController.text = newValue!;
                        },
                        labelText: 'Branch',
                        firstFlex: 3,
                        secondFlex: 5,
                        containerWidth: 0.23,
                      ),
                      SizedBox(
                        width: w * 0.01,
                      ),
                      CustomTextFormFieldRow(
                        readOnly: true,
                        isEditable: true,
                        controller: ifscController,
                        onSaved: (newValue) {
                          ifscController.text = newValue!;
                        },
                        labelText: 'IFSC',
                        firstFlex: 3,
                        secondFlex: 5,
                        containerWidth: 0.23,
                      ),
                      SizedBox(
                        width: w * 0.01,
                      ),
                      CustomTextFormFieldRow(
                        isEditable: true,
                        readOnly: false,
                        controller: upiController,
                        onSaved: (newValue) {
                          upiController.text = newValue!;
                        },
                        labelText: 'UPI',
                        firstFlex: 3,
                        secondFlex: 7,
                        containerWidth: 0.25,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      CustomTextFormFieldRow(
                        readOnly: false,
                        isEditable: true,
                        controller: accountNoController,
                        onSaved: (newValue) {
                          accountNoController.text = newValue!;
                        },
                        labelText: 'A/C No',
                        firstFlex: 4,
                        secondFlex: 5,
                        containerWidth: 0.24,
                      ),
                      SizedBox(
                        width: w * 0.01,
                      ),
                      CustomTextFormFieldRow(
                        readOnly: false,
                        isEditable: true,
                        controller: accountNameController,
                        onSaved: (newValue) {
                          accountNameController.text = newValue!;
                        },
                        labelText: 'A/C Name',
                        firstFlex: 2,
                        secondFlex: 9,
                        containerWidth: 0.47,
                      ),
                      SizedBox(
                        width: w * 0.01,
                      ),
                      const CustomTextFormFieldRow(
                        readOnly: false,
                        isEditable: false,
                        labelText: 'Height',
                        firstFlex: 4,
                        secondFlex: 3,
                        containerWidth: 0.132,
                      ),
                      const Spacer(),
                      const CustomTextFormFieldRow(
                        readOnly: false,
                        isEditable: false,
                        labelText: 'Width',
                        firstFlex: 2,
                        secondFlex: 3,
                        containerWidth: 0.1,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Company Logo 1",
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                                color: Colors.purple.shade600),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 150,
                                    width: w * 0.1,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                    ),
                                    child: _logo1.isEmpty
                                        ? const Center(
                                            child: Text('No Image Selected'),
                                          )
                                        : Image.memory(
                                            _logo1[0],
                                          ),
                                  ),
                                  Container(
                                    height: 30,
                                    width: w * 0.1,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: DButtons(
                                          text: "Download",
                                          onPressed: () {},
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 25,
                                          width: w * 0.08,
                                          child: DButtons(
                                            text: "Select",
                                            onPressed: () async {
                                              FilePickerResult? result =
                                                  await FilePicker.platform
                                                      .pickFiles(
                                                type: FileType.custom,
                                                allowedExtensions: [
                                                  'jpg',
                                                  'jpeg',
                                                  'png',
                                                  'gif'
                                                ],
                                              );

                                              if (result != null) {
                                                // setState(() {
                                                //   _filePickerResult =
                                                //       result;
                                                // });
                                                List<Uint8List>
                                                    fileBytesLogo1List = [];

                                                for (PlatformFile file
                                                    in result.files) {
                                                  Uint8List fileBytes =
                                                      file.bytes!;
                                                  fileBytesLogo1List
                                                      .add(fileBytes);
                                                }

                                                setState(() {
                                                  _logo1.addAll(
                                                      fileBytesLogo1List);
                                                });

                                                // print(_selectedImages);
                                              } else {
                                                // User canceled the picker
                                                print(
                                                    'File picking canceled by the user.');
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: w * 0.002,
                                        ),
                                        SizedBox(
                                          height: 25,
                                          width: w * 0.08,
                                          child: DButtons(
                                            text: "CLear",
                                            onPressed: () {},
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const CustomTextFormFieldRow(
                                      readOnly: false,
                                      labelText: 'Width',
                                      firstFlex: 2,
                                      secondFlex: 3,
                                      containerWidth: 0.12,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const CustomTextFormFieldRow(
                                      readOnly: false,
                                      labelText: 'Width',
                                      firstFlex: 2,
                                      secondFlex: 3,
                                      containerWidth: 0.12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        width: w * 0.05,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Company Logo 2",
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                                color: Colors.purple.shade600),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 150,
                                    width: w * 0.1,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.grey)),
                                    child: _logo2.isEmpty
                                        ? const Center(
                                            child: Text('No Image Selected'),
                                          )
                                        : Image.memory(
                                            _logo2[0],
                                          ),
                                  ),
                                  Container(
                                    height: 30,
                                    width: w * 0.1,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.grey)),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: DButtons(
                                          text: "Download",
                                          onPressed: () {},
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 25,
                                          width: w * 0.08,
                                          child: SizedBox(
                                            width: w * 0.1,
                                            child: DButtons(
                                              text: "Select",
                                              onPressed: () async {
                                                FilePickerResult? result =
                                                    await FilePicker.platform
                                                        .pickFiles(
                                                  type: FileType.custom,
                                                  allowedExtensions: [
                                                    'jpg',
                                                    'jpeg',
                                                    'png',
                                                    'gif'
                                                  ],
                                                );

                                                if (result != null) {
                                                  // setState(() {
                                                  //   _filePickerResult =
                                                  //       result;
                                                  // });
                                                  List<Uint8List>
                                                      fileBytesLogo2List = [];

                                                  for (PlatformFile file
                                                      in result.files) {
                                                    Uint8List fileBytes =
                                                        file.bytes!;
                                                    fileBytesLogo2List
                                                        .add(fileBytes);
                                                  }

                                                  setState(() {
                                                    _logo2.addAll(
                                                        fileBytesLogo2List);
                                                  });

                                                  print(_logo2);
                                                } else {
                                                  // User canceled the picker
                                                  print(
                                                      'File picking canceled by the user.');
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: w * 0.002,
                                        ),
                                        SizedBox(
                                          height: 25,
                                          width: w * 0.08,
                                          child: SizedBox(
                                              width: w * 0.1,
                                              child: DButtons(
                                                  text: "Clear",
                                                  onPressed: () {})),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const CustomTextFormFieldRow(
                                      readOnly: false,
                                      labelText: 'Width',
                                      firstFlex: 2,
                                      secondFlex: 3,
                                      containerWidth: 0.12,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const CustomTextFormFieldRow(
                                      readOnly: false,
                                      labelText: 'Width',
                                      firstFlex: 2,
                                      secondFlex: 3,
                                      containerWidth: 0.12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        width: w * 0.05,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Signature",
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                                color: Colors.purple.shade600),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 150,
                                    width: w * 0.1,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.grey)),
                                    child: _signature.isEmpty
                                        ? const Center(
                                            child: Text('No Image Selected'),
                                          )
                                        : Image.memory(
                                            _signature[0],
                                          ),
                                  ),
                                  Container(
                                    height: 30,
                                    width: w * 0.1,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.grey)),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: DButtons(
                                          text: "Download",
                                          onPressed: () {},
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 25,
                                          width: w * 0.08,
                                          child: DButtons(
                                            text: "Select",
                                            onPressed: () async {
                                              FilePickerResult? result =
                                                  await FilePicker.platform
                                                      .pickFiles(
                                                type: FileType.custom,
                                                allowedExtensions: [
                                                  'jpg',
                                                  'jpeg',
                                                  'png',
                                                  'gif'
                                                ],
                                              );

                                              if (result != null) {
                                                // setState(() {
                                                //   _filePickerResult =
                                                //       result;
                                                // });
                                                List<Uint8List>
                                                    fileBytesSignatureList = [];

                                                for (PlatformFile file
                                                    in result.files) {
                                                  Uint8List fileBytes =
                                                      file.bytes!;
                                                  fileBytesSignatureList
                                                      .add(fileBytes);
                                                }

                                                setState(() {
                                                  _signature.addAll(
                                                      fileBytesSignatureList);
                                                });

                                                // print(_signature);
                                              } else {
                                                // User canceled the picker
                                                print(
                                                    'File picking canceled by the user.');
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: w * 0.002,
                                        ),
                                        SizedBox(
                                          height: 25,
                                          width: w * 0.08,
                                          child: DButtons(
                                            text: "Clear",
                                            onPressed: () {},
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const CustomTextFormFieldRow(
                                      readOnly: false,
                                      labelText: 'Width',
                                      firstFlex: 2,
                                      secondFlex: 3,
                                      containerWidth: 0.12,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const CustomTextFormFieldRow(
                                      readOnly: false,
                                      labelText: 'Width',
                                      firstFlex: 2,
                                      secondFlex: 3,
                                      containerWidth: 0.12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: w * 0.1,
                        child:
                            DButtons(text: "Save", onPressed: updateCompany)),
                    SizedBox(
                        width: w * 0.1,
                        child: DButtons(text: "Cancel", onPressed: () {})),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
