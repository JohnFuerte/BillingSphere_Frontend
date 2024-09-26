import 'dart:io';
import 'dart:math';

import 'package:billingsphere/views/DB_widgets/Desktop_widgets/d_custom_buttons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/newCompany/new_company_model.dart';
import '../../data/models/newCompany/store_model.dart';
import '../../data/repository/new_company_repository.dart';
import '../CM_homepage.dart';

class CMNEditDesktopBody extends StatefulWidget {
  const CMNEditDesktopBody(
      {super.key, required this.companyId, required this.companyName});

  final String companyId;
  final String companyName;

  @override
  State<CMNEditDesktopBody> createState() => _CMNEditDesktopBodyState();
}

class _CMNEditDesktopBodyState extends State<CMNEditDesktopBody> {
  NewCompanyRepository newCompanyRepository = NewCompanyRepository();
  List<Uint8List> _selectedImages = [];
  List<Uint8List> _selectedImages2 = [];
  List<File> files = [];

  Future<void> fetchCompanyById() {
    print(newCompanyRepository.getCompanyById);
    return newCompanyRepository.getCompanyById(widget.companyId).then((value) {
      setState(() {
        companyNameController.text = value.companyName!;
        companyCodeController.text = value.companyCode!;
        selectedType = value.companyType!;
        selectedCountry = value.country!;
        selectedTaxation = value.taxation!;
        lstNoController.text = value.lstNo!;
        gstNoController.text = value.gstin!;
        panNoController.text = value.pan!;
        ewaybillController.text = value.ewayBill!;
        designationController.text = value.designation!;
        signatoryController.text = value.signatory!;
        cachingController.text = value.caching!;
        dateController.text = value.acYear!;
        dateController2.text = value.acYearTo!;
        emailIDController.text = value.email!;
        passwordController.text = value.password!;
        taglineController.text = value.tagline!;
        tC1Controller.text = value.tc1!;
        tC2Controller.text = value.tc2!;
        tC3Controller.text = value.tc3!;
        tC4Controller.text = value.tc4!;
        tC5Controller.text = value.tc5!;
        if (value.logo1 != null && value.logo1!.isNotEmpty) {
          // Assuming logo1 is a list of images represented as bytes
          _selectedImages = value.logo1!.map((e) => e.data).toList();
        }
        if (value.logo1 != null && value.logo1!.isNotEmpty) {
          // Assuming logo1 is a list of images represented as bytes
          _selectedImages2 = value.logo2!.map((e) => e.data).toList();
        }
        stores.clear();
        storesData.clear();
        for (var i = 0; i < value.stores!.length; i++) {
          var storeControllers = initializeControllers();
          storesData.add({
            'key': storeControllers['key'],
            'address': value.stores![i].address,
            'city': value.stores![i].city,
            'state': value.stores![i].state,
            'pincode': value.stores![i].pincode,
            'phone': value.stores![i].phone,
            'bankName': value.stores![i].bankName,
            'branch': value.stores![i].branch,
            'accountName': value.stores![i].accountName,
            'accountNo': value.stores![i].accountNo,
            'upi': value.stores![i].upi,
            'ifsc': value.stores![i].ifsc,
            'status': value.stores![i].status,
            'email': value.stores![i].email,
            'password': value.stores![i].password,
            'code': value.stores![i].code,
          });
          storeControllers['companyAddressController']!.text =
              value.stores![i].address;
          storeControllers['pincodeController']!.text =
              value.stores![i].pincode;
          storeControllers['phoneController']!.text = value.stores![i].phone;
          storeControllers['bankNameController']!.text =
              value.stores![i].bankName;
          storeControllers['bankBranchController']!.text =
              value.stores![i].branch;
          storeControllers['accNameController']!.text =
              value.stores![i].accountName;
          storeControllers['accNoController']!.text =
              value.stores![i].accountNo;
          storeControllers['upiController']!.text = value.stores![i].upi;
          storeControllers['ifscController']!.text = value.stores![i].ifsc;
          storeControllers['statusController']!.text = value.stores![i].status;
          storeControllers['locationEmailIdController']!.text =
              value.stores![i].email;
          storeControllers['locationPasswordController']!.text =
              value.stores![i].password;
          storeControllers['selectedCity'] =
              value.stores![i].city; // Update selected city
          storeControllers['selectedState'] = value.stores![i].state;
          storeControllers['code'] = value.stores![i].code;

          stores.add(buildStoresDetails(storeControllers));
        }
      });
    });
  }

  String selectedType = 'Private Limited';
  String selectedCountry = 'India';
  String? selectedState;
  String selectedTaxation = 'GST';
  String? selectedCity;
  bool isPasswordVisible = false;
  bool isPasswordlocationVisible = false;
  bool isLoading = false;

  TextEditingController companyNameController = TextEditingController();
// Store [
  late TextEditingController companyAddressController;
  late TextEditingController pincodeController;
  late TextEditingController phoneController;
  late TextEditingController bankNameController;
  late TextEditingController bankBranchController;
  late TextEditingController accNameController;
  late TextEditingController accNoController;
  late TextEditingController upiController;
  late TextEditingController ifscController;
  late TextEditingController statusController;
  late TextEditingController locationEmailIdController;
  late TextEditingController locationPasswordController;

// ]

  TextEditingController lstNoController = TextEditingController();
  TextEditingController gstNoController = TextEditingController();
  TextEditingController panNoController = TextEditingController();
  TextEditingController ewaybillController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController signatoryController = TextEditingController();
  TextEditingController cachingController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController dateController2 = TextEditingController();
  TextEditingController emailIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController taglineController = TextEditingController();
  TextEditingController companyCodeController = TextEditingController();
  TextEditingController tC1Controller = TextEditingController();
  TextEditingController tC2Controller = TextEditingController();
  TextEditingController tC3Controller = TextEditingController();
  TextEditingController tC4Controller = TextEditingController();
  TextEditingController tC5Controller = TextEditingController();
  final List<Widget> stores = [];

  List<String> companyType = [
    'Private Limited',
    'Public Limited',
    'Partnership',
    'Proprietorship',
    'LLP',
    'Trust',
    'Society',
    'Section 8 Company',
    'Government',
    'Others',
  ];

  List<String> countries = [
    'India',
    'United States',
    'China',
    'Brazil',
    'Pakistan',
    'Nigeria',
    'Bangladesh',
    'Russia',
    'Mexico',
    'Japan',
    'Philippines',
    'Vietnam',
    'Ethiopia',
    'Egypt',
    'Algeria',
    'Iraq',
    'Morocco',
    'Afghanistan',
    'Saudi Arabia',
    'Peru',
    'Uzbekistan',
    'Malaysia',
    'Angola',
    'Ghana',
    'Yemen',
    'Nepal',
    'Venezuela',
    'Mozambique',
    'Cameroon',
    'Madagascar',
    'Australia',
    'North Korea',
  ];

  List<String> indianStates = [
    'Andhra',
    'Arunachal',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil',
    'Telangana',
    'Tripura',
    'Uttar',
    'Uttarakhand',
    'West Bengal',
    'Chandigarh',
    'Delhi',
  ];

  List<String> taxation = [
    'GST',
    'GST + VAT',
    'VAT',
    'Others              ',
  ];
  List<String> city = [
    'Ranpur',
    'Chotila',
    'Wankaner',
    'Rajkot',
  ];

  Map<String, String> storesList = {};
  final List<Map<String, dynamic>> storesData = [];

  void printData() {
    // Iterate over StoreData and print the values

    for (var i = 0; i < storesData.length; i++) {
      print(storesData[i]);
    }
  }

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        dateController2.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  void updateCompany() async {
    setState(() {
      isLoading = true;
    });
    List<ImageData>? imageList;
    if (_selectedImages.isNotEmpty) {
      imageList = _selectedImages
          .map((image) => ImageData(
                data: image,
                contentType: 'image/jpeg',
                filename: 'filename.jpg',
              ))
          .toList();
    }
    List<ImageData>? imageList2;
    if (_selectedImages2.isNotEmpty) {
      imageList2 = _selectedImages2
          .map((image) => ImageData(
                data: image,
                contentType: 'image/jpeg',
                filename: 'filename.jpg',
              ))
          .toList();
    }

    if (storesData.isEmpty) {
      setState(() {
        isLoading = false;
      });
      showToast('Please add store details');

      return;
    } else if (companyNameController.text.isEmpty ||
        selectedType.isEmpty ||
        selectedCountry.isEmpty ||
        selectedTaxation.isEmpty ||
        lstNoController.text.isEmpty ||
        gstNoController.text.isEmpty ||
        panNoController.text.isEmpty ||
        ewaybillController.text.isEmpty ||
        designationController.text.isEmpty ||
        signatoryController.text.isEmpty ||
        cachingController.text.isEmpty ||
        dateController.text.isEmpty ||
        dateController2.text.isEmpty ||
        emailIDController.text.isEmpty ||
        passwordController.text.isEmpty ||
        taglineController.text.isEmpty) {
      setState(() {
        isLoading = false;
      });
      showToast('Please fill all the fields');
      return;
    } else {
      await newCompanyRepository
          .updateNewCompany(
            NewCompany(
              id: widget.companyId,
              ewayBill: ewaybillController.text,
              gstin: gstNoController.text,
              pan: panNoController.text,
              companyCode: companyCodeController.text,
              companyName: companyNameController.text,
              companyType: selectedType,
              country: selectedCountry,
              email: emailIDController.text,
              password: passwordController.text,
              lstNo: lstNoController.text,
              cstNo: lstNoController.text,
              designation: designationController.text,
              signatory: signatoryController.text,
              caching: cachingController.text,
              taxation: selectedTaxation,
              acYear: dateController.text,
              acYearTo: dateController2.text,
              tc1: tC1Controller.text,
              tc2: tC2Controller.text,
              tc3: tC3Controller.text,
              tc4: tC4Controller.text,
              tc5: tC5Controller.text,
              tagline: taglineController.text,
              logo1: imageList ?? [],
              logo2: imageList2 ?? [],
              signature: [],
              stores: storesData.map((e) {
                return StoreModel(
                  address: e['address'],
                  city: e['city'],
                  state: e['state'],
                  pincode: e['pincode'],
                  phone: e['phone'],
                  bankName: e['bankName'],
                  branch: e['branch'],
                  accountNo: e['accountNo'],
                  accountName: e['accountName'],
                  upi: e['upi'],
                  ifsc: e['ifsc'],
                  status: e['status'],
                  email: e['email'],
                  password: e['password'],
                  code: e['code'] ?? '',
                );
              }).toList(),
            ),
            context,
          )
          .then((value) => {
                setState(() {
                  isLoading = false;
                }),

                // Clear the textfields
                companyNameController.clear(),
                companyAddressController.clear(),
                gstController.clear(),
                dateController.clear(),
                dateController2.clear(),
                emailIDController.clear(),
                passwordController.clear(),
                lstNoController.clear(),
                panNoController.clear(),
                ewaybillController.clear(),
                designationController.clear(),
                signatoryController.clear(),
                cachingController.clear(),
                taglineController.clear(),
                storesData.clear(),
                imageList = [],
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const CMHomepage(),
                  ),
                ),
              });

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    companyNameController.dispose();
    companyAddressController.dispose();
    gstController.dispose();
    dateController.dispose();
    dateController2.dispose();
    emailIDController.dispose();
    passwordController.dispose();
    lstNoController.dispose();
    panNoController.dispose();
    ewaybillController.dispose();
    designationController.dispose();
    signatoryController.dispose();
    cachingController.dispose();
    taglineController.dispose();
    super.dispose();
  }

  Map<String, dynamic> initializeControllers() {
    Map<String, dynamic> controllers = {
      'companyAddressController': TextEditingController(),
      'pincodeController': TextEditingController(),
      'phoneController': TextEditingController(),
      'bankNameController': TextEditingController(),
      'bankBranchController': TextEditingController(),
      'accNameController': TextEditingController(),
      'accNoController': TextEditingController(),
      'upiController': TextEditingController(),
      'ifscController': TextEditingController(),
      'statusController': TextEditingController(),
      'locationEmailIdController': TextEditingController(),
      'locationPasswordController': TextEditingController(),
      'selectedCity': 'Rajkot',
      'selectedState': 'Gujarat',
      'key': Random().nextInt(1000).toString(),
      'code': '',
    };
    return controllers;
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void initState() {
    super.initState();
    fetchCompanyById();
  }

  Widget buildStoresDetails(Map<String, dynamic> storeControllers) {
    String selectedCity = storeControllers['selectedCity'];
    String selectedState = storeControllers['selectedState'];

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            const SizedBox(height: 15),
            Container(
              color: Colors.yellow[300],
              width: MediaQuery.of(context).size.width * 0.8,
              child: const Text(
                'Store Details',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(
                            'State',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        // Textfield
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.26,
                          height: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                padding: EdgeInsets.zero,
                                value: selectedState,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedState = newValue!;
                                  });
                                },
                                items: indianStates
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 1),
                                      child: Text(value),
                                    ),
                                  );
                                }).toList(),
                              ),
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
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(
                            'City',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),

                        // Textfield
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2579,
                          height: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                padding: EdgeInsets.zero,
                                value: selectedCity,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCity = newValue!;
                                  });
                                },
                                items: city.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 1),
                                      child: Text(value.toUpperCase()),
                                    ),
                                  );
                                }).toList(),
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Text(
                      'Address',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  // Textfield
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.singleLineFormatter,
                            AllCapsTextFormatter(),
                          ],
                          controller:
                              storeControllers['companyAddressController'],
                          style: const TextStyle(
                            fontSize: 17,
                            height: 1,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 3,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
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
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(
                            'Pincode No',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        // Textfield
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.26,
                          height: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, bottom: 16.0),
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .singleLineFormatter,
                                  AllCapsTextFormatter(),
                                ],
                                controller:
                                    storeControllers['pincodeController'],
                                style: const TextStyle(
                                  fontSize: 17,
                                  height: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
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
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(
                            'Phone',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),

                        // Textfield
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2579,
                          height: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, bottom: 16.0),
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .singleLineFormatter,
                                  AllCapsTextFormatter(),
                                ],
                                controller: storeControllers['phoneController'],
                                style: const TextStyle(
                                  fontSize: 17,
                                  height: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(
                            'Bank Name',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        // Textfield
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.26,
                          height: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, bottom: 16.0),
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .singleLineFormatter,
                                  AllCapsTextFormatter(),
                                ],
                                controller:
                                    storeControllers['bankNameController'],
                                style: const TextStyle(
                                  fontSize: 17,
                                  height: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
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
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(
                            'Branch Name',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),

                        // Textfield
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2579,
                          height: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, bottom: 16.0),
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .singleLineFormatter,
                                  AllCapsTextFormatter(),
                                ],
                                controller:
                                    storeControllers['bankBranchController'],
                                style: const TextStyle(
                                  fontSize: 17,
                                  height: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(
                            'A/c Name',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        // Textfield
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.26,
                          height: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, bottom: 16.0),
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .singleLineFormatter,
                                  AllCapsTextFormatter(),
                                ],
                                controller:
                                    storeControllers['accNameController'],
                                style: const TextStyle(
                                  fontSize: 17,
                                  height: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
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
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(
                            'A/c No',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),

                        // Textfield
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2579,
                          height: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, bottom: 16.0),
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .singleLineFormatter,
                                  AllCapsTextFormatter(),
                                ],
                                controller: storeControllers['accNoController'],
                                style: const TextStyle(
                                  fontSize: 17,
                                  height: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(
                            'UPI',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        // Textfield
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.26,
                          height: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, bottom: 16.0),
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .singleLineFormatter,
                                  AllCapsTextFormatter(),
                                ],
                                controller: storeControllers['upiController'],
                                style: const TextStyle(
                                  fontSize: 17,
                                  height: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
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
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(
                            'Status',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),

                        // Textfield
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2579,
                          height: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, bottom: 16.0),
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .singleLineFormatter,
                                  AllCapsTextFormatter(),
                                ],
                                controller:
                                    storeControllers['statusController'],
                                style: const TextStyle(
                                  fontSize: 17,
                                  height: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(
                            'IFSC',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        // Textfield
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.26,
                          height: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, bottom: 16.0),
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .singleLineFormatter,
                                  AllCapsTextFormatter(),
                                ],
                                controller: storeControllers['ifscController'],
                                style: const TextStyle(
                                  fontSize: 17,
                                  height: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(
                            'Email-ID',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        // Textfield
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.26,
                          height: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, bottom: 16.0),
                              child: TextField(
                                controller: storeControllers[
                                    'locationEmailIdController'],
                                style: const TextStyle(
                                  fontSize: 17,
                                  height: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
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
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(
                            'Password',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2579,
                          height: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, bottom: 16.0),
                              child: TextField(
                                controller: storeControllers[
                                    'locationPasswordController'],
                                style: const TextStyle(
                                  fontSize: 17,
                                  height: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                                obscureText:
                                    isPasswordlocationVisible ? true : false,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isPasswordlocationVisible =
                                            !isPasswordlocationVisible;
                                      });
                                    },
                                    child: Icon(
                                      size: 30,
                                      isPasswordlocationVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.black,
                                    ),
                                  ),
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                      ),
                      color: Colors.green, // Set the button's color to green
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (storeControllers['companyAddressController']
                                .text
                                .isEmpty ||
                            storeControllers['pincodeController']
                                .text
                                .isEmpty ||
                            storeControllers['phoneController'].text.isEmpty ||
                            storeControllers['bankNameController']
                                .text
                                .isEmpty ||
                            storeControllers['bankBranchController']
                                .text
                                .isEmpty ||
                            storeControllers['accNameController']
                                .text
                                .isEmpty ||
                            storeControllers['accNoController'].text.isEmpty ||
                            storeControllers['upiController'].text.isEmpty ||
                            storeControllers['ifscController'].text.isEmpty ||
                            storeControllers['statusController'].text.isEmpty ||
                            storeControllers['locationEmailIdController']
                                .text
                                .isEmpty ||
                            storeControllers['locationPasswordController']
                                .text
                                .isEmpty ||
                            selectedCity.isEmpty ||
                            selectedState.isEmpty) {
                          showToast('Please fill all the fields');
                          return;
                        }
                        // Add the store details to the map
                        storesList = {
                          'key': storeControllers['key'],
                          'state': selectedState,
                          'city': selectedCity,
                          'address':
                              storeControllers['companyAddressController'].text,
                          'pincode': storeControllers['pincodeController'].text,
                          'phone': storeControllers['phoneController'].text,
                          'bankName':
                              storeControllers['bankNameController'].text,
                          'branch':
                              storeControllers['bankBranchController'].text,
                          'accountName':
                              storeControllers['accNameController'].text,
                          'accountNo': storeControllers['accNoController'].text,
                          'upi': storeControllers['upiController'].text,
                          'ifsc': storeControllers['ifscController'].text,
                          'status': storeControllers['statusController'].text,
                          'email': storeControllers['locationEmailIdController']
                              .text,
                          'password':
                              storeControllers['locationPasswordController']
                                  .text,
                          'code': storeControllers['code'] ?? '',
                        };

                        // if key already exists, then update else create new
                        if (storesData
                            .where((element) =>
                                element['key'] == storesList['key'])
                            .isNotEmpty) {
                          storesData[storesData.indexWhere((element) =>
                                  element['key'] == storesList['key'])] =
                              storesList;

                          showToast('Store details updated successfully');
                        } else {
                          storesData.add(storesList);
                          showToast('Store details added successfully');
                        }
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ), // Set text color to white
                      ),
                    )),
                const SizedBox(width: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red,
                    ),
                    color: Colors.red, // Set the button's color to green
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        stores.removeAt(stores.length - 1);
                        // printData();
                      });
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ), // Set text color to white
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.1;
    double buttonHeight = MediaQuery.of(context).size.height * 0.03;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 4, 12, 241),
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
                  SizedBox(width: MediaQuery.of(context).size.width * 0.45),
                  Text(
                    'EDIT ${widget.companyName.toUpperCase()}',
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Center(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: Text(
                                  'Company Name',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              // Textfield
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.65,
                                height: 30,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 16.0),
                                    child: TextField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .singleLineFormatter,
                                        AllCapsTextFormatter(),
                                      ],
                                      controller: companyNameController,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        height: 1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
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
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: Text(
                                  'Company Type',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02),
                              // Textfield
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.65,
                                height: 30,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedType,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedType = newValue!;
                                        });
                                      },
                                      items: companyType
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Text(value),
                                          ),
                                        );
                                      }).toList(),
                                    ),
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
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: Text(
                                  'Tagline',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              // Textfield
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.65,
                                height: 30,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 16.0),
                                    child: TextField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .singleLineFormatter,
                                        AllCapsTextFormatter(),
                                      ],
                                      controller: taglineController,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        height: 1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
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
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      child: Text(
                                        'Lst No',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    // Textfield
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.26,
                                      height: 30,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, bottom: 16.0),
                                          child: TextField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .singleLineFormatter,
                                              AllCapsTextFormatter(),
                                            ],
                                            controller: lstNoController,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              height: 1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                          ),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      child: Text(
                                        'GST No',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),

                                    // Textfield
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2579,
                                      height: 30,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, bottom: 16.0),
                                          child: TextField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .singleLineFormatter,
                                              AllCapsTextFormatter(),
                                            ],
                                            controller: gstNoController,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              height: 1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
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
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      child: Text(
                                        'Pan No',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    // Textfield
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.26,
                                      height: 30,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, bottom: 16.0),
                                          child: TextField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .singleLineFormatter,
                                              AllCapsTextFormatter(),
                                            ],
                                            controller: panNoController,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              height: 1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                          ),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      child: Text(
                                        'E-way Bill Place',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    // Textfield
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2579,
                                      height: 30,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, bottom: 16.0),
                                          child: TextField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .singleLineFormatter,
                                              AllCapsTextFormatter(),
                                            ],
                                            controller: ewaybillController,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              height: 1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
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
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      child: Text(
                                        'Designation',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    // Textfield
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.26,
                                      height: 30,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, bottom: 16.0),
                                          child: TextField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .singleLineFormatter,
                                              AllCapsTextFormatter(),
                                            ],
                                            controller: designationController,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              height: 1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                          ),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      child: Text(
                                        'Signatory',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),

                                    // Textfield
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2579,
                                      height: 30,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, bottom: 16.0),
                                          child: TextField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .singleLineFormatter,
                                              AllCapsTextFormatter(),
                                            ],
                                            controller: signatoryController,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              height: 1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
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
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      child: Text(
                                        'Caching',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    // Textfield
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.26,
                                      height: 30,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, bottom: 16.0),
                                          child: TextField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .singleLineFormatter,
                                              AllCapsTextFormatter(),
                                            ],
                                            controller: cachingController,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              height: 1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                          ),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      child: Text(
                                        'Taxation',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2579,
                                      height: 30,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            padding: EdgeInsets.zero,
                                            value: selectedTaxation,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedTaxation = newValue!;
                                              });
                                            },
                                            items: taxation
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 1),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: Text(value),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Textfield
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Terms & Conditions : ',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        //Terms and Condition's 1
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: Text(
                                  'T&C. 1',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              // Textfield
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.65,
                                height: 30,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 16.0),
                                    child: TextField(
                                      // inputFormatters: [
                                      //   FilteringTextInputFormatter
                                      //       .singleLineFormatter,
                                      //   AllCapsTextFormatter(),
                                      // ],
                                      controller: tC1Controller,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        height: 1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        //Terms and Condition's 2

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: Text(
                                  'T&C. 2',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              // Textfield
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.65,
                                height: 30,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 16.0),
                                    child: TextField(
                                      // inputFormatters: [
                                      //   FilteringTextInputFormatter
                                      //       .singleLineFormatter,
                                      //   AllCapsTextFormatter(),
                                      // ],
                                      controller: tC2Controller,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        height: 1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        //Terms and Condition's 3

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: Text(
                                  'T&C. 3',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              // Textfield
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.65,
                                height: 30,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 16.0),
                                    child: TextField(
                                      // inputFormatters: [
                                      //   FilteringTextInputFormatter
                                      //       .singleLineFormatter,
                                      //   AllCapsTextFormatter(),
                                      // ],
                                      controller: tC3Controller,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        height: 1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),
                        //Terms and Condition's 4

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: Text(
                                  'T&C. 4',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              // Textfield
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.65,
                                height: 30,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 16.0),
                                    child: TextField(
                                      // inputFormatters: [
                                      //   FilteringTextInputFormatter
                                      //       .singleLineFormatter,
                                      //   AllCapsTextFormatter(),
                                      // ],
                                      controller: tC4Controller,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        height: 1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        //Terms and Condition's 5

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: Text(
                                  'T&C. 5',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              // Textfield
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.65,
                                height: 30,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 16.0),
                                    child: TextField(
                                      // inputFormatters: [
                                      //   FilteringTextInputFormatter
                                      //       .singleLineFormatter,
                                      //   AllCapsTextFormatter(),
                                      // ],
                                      controller: tC5Controller,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        height: 1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.height * 0.8,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          child: Text(
                                            'A/c Year',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02),
                                        // Textfield
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.08,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: Colors.black,
                                              ),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                _selectDate(context);
                                              },
                                              child: AbsorbPointer(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          bottom: 16.0),
                                                  child: TextField(
                                                    controller: dateController,
                                                    decoration:
                                                        const InputDecoration(
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'To',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.021),
                                        // Textfield
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.08,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: Colors.black,
                                              ),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                _selectDate2(context);
                                              },
                                              child: AbsorbPointer(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          bottom: 16.0),
                                                  child: TextField(
                                                    controller: dateController2,
                                                    decoration:
                                                        const InputDecoration(
                                                      border: InputBorder.none,
                                                    ),
                                                    readOnly: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          child: Text(
                                            'Email ID',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02),
                                        // Textfield
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: Colors.black,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, bottom: 16.0),
                                              child: TextField(
                                                controller: emailIDController,
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  height: 1,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          child: Text(
                                            'Password',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02),
                                        // Textfield
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          height: 35,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: Colors.black,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, bottom: 16.0),
                                              child: TextField(
                                                controller: passwordController,
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  height: 1,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                obscureText: isPasswordVisible
                                                    ? true
                                                    : false,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  suffixIcon: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        isPasswordVisible =
                                                            !isPasswordVisible;
                                                      });
                                                    },
                                                    child: Icon(
                                                      size: 30,
                                                      isPasswordVisible
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: MediaQuery.of(context).size.height * 0.8,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.098,
                                    ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black)),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          child: _selectedImages.isEmpty
                                              ? const Center(
                                                  child:
                                                      Text('No Logo Selected'))
                                              : Image.memory(
                                                  _selectedImages[0]),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    FilePickerResult? result =
                                                        await FilePicker
                                                            .platform
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
                                                          fileBytesList = [];

                                                      for (PlatformFile file
                                                          in result.files) {
                                                        Uint8List fileBytes =
                                                            file.bytes!;
                                                        fileBytesList
                                                            .add(fileBytes);
                                                      }

                                                      setState(() {
                                                        _selectedImages.clear();
                                                        _selectedImages.addAll(
                                                            fileBytesList);
                                                      });

                                                      // print(_selectedImages);
                                                    } else {
                                                      // User canceled the picker
                                                      print(
                                                          'File picking canceled by the user.');
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.black,
                                                    backgroundColor:
                                                        Colors.white,
                                                    fixedSize: Size(buttonWidth,
                                                        buttonHeight),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                    ),
                                                    side: const BorderSide(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Add',
                                                    style: TextStyle(
                                                        fontSize:
                                                            screenWidth < 1030
                                                                ? 11.0
                                                                : 13.0),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.black,
                                                    backgroundColor:
                                                        Colors.white,
                                                    fixedSize: Size(buttonWidth,
                                                        buttonHeight),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                    ),
                                                    side: const BorderSide(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        fontSize:
                                                            screenWidth < 1030
                                                                ? 11.0
                                                                : 13.0),
                                                  )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black)),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          child: _selectedImages2.isEmpty
                                              ? const Center(
                                                  child: Text(
                                                      'No Signature Selected'))
                                              : Image.memory(
                                                  _selectedImages2[0]),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    FilePickerResult? result =
                                                        await FilePicker
                                                            .platform
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
                                                          fileBytesList = [];

                                                      for (PlatformFile file
                                                          in result.files) {
                                                        Uint8List fileBytes =
                                                            file.bytes!;
                                                        fileBytesList
                                                            .add(fileBytes);
                                                      }

                                                      setState(() {
                                                        _selectedImages2
                                                            .clear();
                                                        _selectedImages2.addAll(
                                                            fileBytesList);
                                                      });

                                                      // print(_selectedImages);
                                                    } else {
                                                      // User canceled the picker
                                                      print(
                                                          'File picking canceled by the user.');
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.black,
                                                    backgroundColor:
                                                        Colors.white,
                                                    fixedSize: Size(buttonWidth,
                                                        buttonHeight),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                    ),
                                                    side: const BorderSide(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Add',
                                                    style: TextStyle(
                                                        fontSize:
                                                            screenWidth < 1030
                                                                ? 11.0
                                                                : 13.0),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.black,
                                                    backgroundColor:
                                                        Colors.white,
                                                    fixedSize: Size(buttonWidth,
                                                        buttonHeight),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                    ),
                                                    side: const BorderSide(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          fontSize:
                                                              screenWidth < 1030
                                                                  ? 11.0
                                                                  : 13.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),

                        Column(
                          children: stores,
                        ),

                        const SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: Text(
                                  'Locations',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02),
                              // Textfield

                              Container(
                                width: MediaQuery.of(context).size.width * 0.65,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  // color: Colors
                                  //     .green, // Set the button's color to green
                                ),
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.lightBlue),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      var storeController =
                                          initializeControllers();
                                      stores.add(
                                          buildStoresDetails(storeController));
                                    });
                                  },
                                  child: Text(
                                    '+ Add Store Location',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        // Buttons
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: DButtons(
                                  text: 'SAVE [F4]',
                                  onPressed: updateCompany,
                                  // onPressed: printData,
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: DButtons(
                                  text: 'CANCEL [F8]',
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AllCapsTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
