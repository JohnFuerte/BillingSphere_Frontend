import 'package:billingsphere/views/sumit_screen/sumit_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../data/models/customer/new_customer_model.dart';
import '../../data/repository/new_customer_repository.dart';
import '../SE_common/SE_top_textfield.dart';

class NewCustomer extends StatefulWidget {
  const NewCustomer({super.key});

  @override
  State<NewCustomer> createState() => _NewCustomerState();
}

class _NewCustomerState extends State<NewCustomer> {
  // Controller for the textfield
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _customerIdController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _aadharCardController = TextEditingController();
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  String selectedSendSms = 'No';
  String selectedCustomerType = 'Walk In';
  String selectedIsActive = 'Yes';

  // Focus node for the textfield
  final FocusNode _mobileFocusNode = FocusNode();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _middleNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _customerIdFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _aadharCardFocusNode = FocusNode();
  final FocusNode _emailIdFocusNode = FocusNode();
  final FocusNode _birthDateFocusNode = FocusNode();

  // Services
  final NewCustomerRepository _newCustomerRepository = NewCustomerRepository();

  // Create New Customer
  void createNewCustomer() {
    // Validate MOBILE AND FIRST NAME
    if (_mobileController.text.isEmpty || _firstNameController.text.isEmpty) {
      PanaraInfoDialog.show(
        context,
        title: "BillingSphere",
        message: "BillingSphere says: Mobile and First Name are required",
        buttonText: "Okay",
        onTapDismiss: () {
          Navigator.pop(context);
        },
        panaraDialogType: PanaraDialogType.error,
        barrierDismissible: false,
      );
      return;
    }
    final newCustomer = NewCustomerModel(
      id: '',
      mobile: _mobileController.text,
      fname: _firstNameController.text,
      lname: _lastNameController.text,
      mname: _middleNameController.text,
      fullname: _fullNameController.text,
      sms: selectedSendSms,
      customerType: selectedCustomerType,
      customerId: _customerIdController.text,
      address: _addressController.text,
      city: _cityController.text,
      aadharCard: _aadharCardController.text,
      email: _emailIdController.text,
      birthdate: _birthDateController.text,
      isActive: selectedIsActive,
    );

    _newCustomerRepository.createNewCustomer(newCustomer, context);
    clearTextfield();
  }

  // Clear the textfield
  void clearTextfield() {
    _mobileController.clear();
    _firstNameController.clear();
    _middleNameController.clear();
    _lastNameController.clear();
    _fullNameController.clear();
    _customerIdController.clear();
    _addressController.clear();
    _cityController.clear();
    _aadharCardController.clear();
    _emailIdController.clear();
    _birthDateController.clear();
  }

  @override
  void dispose() {
    // Dispose the controller
    _mobileController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _fullNameController.dispose();
    _customerIdController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _aadharCardController.dispose();
    _emailIdController.dispose();
    _birthDateController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (mounted) {
      FocusScope.of(context).requestFocus(_mobileFocusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.escape): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.f4): const SubmitIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (ActivateIntent intent) {
              Navigator.of(context).pop();
              return null;
            },

          ),
          SubmitIntent: CallbackAction<SubmitIntent>(
            onInvoke: (SubmitIntent intent) {
              createNewCustomer();
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
              'NEW Customer',
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
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 10),
                        child: Row(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Mobile No",
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
                                )),
                            SETopTextfield(
                              controller: _mobileController,
                              // focusNode: _mobileFocusNode,
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_firstNameFocusNode);

                              //   setState(() {});
                              // },
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_mobileFocusNode);

                                setState(() {});
                              },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.6,
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
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "First Name",
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
                                )),
                            SETopTextfield(
                              controller: _firstNameController,
                              // focusNode: _firstNameFocusNode,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_firstNameFocusNode);

                                setState(() {});
                              },
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_middleNameFocusNode);

                              //   setState(() {});
                              // },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.6,
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
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                "Middle Name",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _middleNameController,
                              // focusNode: _middleNameFocusNode,
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_lastNameFocusNode);

                              //   setState(() {});
                              // },
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_middleNameFocusNode);

                                setState(() {});
                              },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.60,
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
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                "Last Name",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _lastNameController,
                              // focusNode: _lastNameFocusNode,
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_fullNameFocusNode);

                              //   setState(() {});
                              // },
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_lastNameFocusNode);

                                setState(() {});
                              },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.60,
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
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                "Full Name",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _fullNameController,
                              // focusNode: _fullNameFocusNode,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_fullNameFocusNode);

                                setState(() {});
                              },
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_customerIdFocusNode);

                              //   setState(() {});
                              // },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.60,
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
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                "Send SMS",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(border: Border.all()),
                              width: MediaQuery.of(context).size.width * 0.40,
                              height: 40,
                              padding: const EdgeInsets.all(2.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedSendSms,
                                  underline: Container(),
                                  icon: const SizedBox.shrink(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedSendSms = newValue!;
                                    });
                                  },
                                  items: ["No", "Yes"]
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
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                "Customer Type",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(border: Border.all()),
                              width: MediaQuery.of(context).size.width * 0.40,
                              height: 40,
                              padding: const EdgeInsets.all(2.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedCustomerType,
                                  underline: Container(),
                                  icon: const SizedBox.shrink(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCustomerType = newValue!;
                                    });
                                  },
                                  items: ["Walk In"]
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
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                "Customer ID",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _customerIdController,
                              // focusNode: _customerIdFocusNode,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_customerIdFocusNode);

                                setState(() {});
                              },
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_addressFocusNode);

                              //   setState(() {});
                              // },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.60,
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
                              width: MediaQuery.of(context).size.width * 0.3,
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
                              controller: _addressController,
                              // focusNode: _addressFocusNode,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_addressFocusNode);

                                setState(() {});
                              },
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_cityFocusNode);

                              //   setState(() {});
                              // },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.60,
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
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                "City/Town",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _cityController,
                              // focusNode: _cityFocusNode,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_cityFocusNode);

                                setState(() {});
                              },
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_aadharCardFocusNode);

                              //   setState(() {});
                              // },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.60,
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
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                "Aadhar Card",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _aadharCardController,
                              // focusNode: _aadharCardFocusNode,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_aadharCardFocusNode);

                                setState(() {});
                              },
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_emailIdFocusNode);

                              //   setState(() {});
                              // },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.60,
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
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                "Email ID",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _emailIdController,
                              // focusNode: _emailIdFocusNode,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_emailIdFocusNode);

                                setState(() {});
                              },
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_birthDateFocusNode);

                              //   setState(() {});
                              // },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.60,
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
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                "Birth Date",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _birthDateController,
                              // focusNode: _birthDateFocusNode,
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_mobileFocusNode);

                              //   setState(() {});
                              // },
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_birthDateFocusNode);

                                setState(() {});
                              },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.60,
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
                              width: MediaQuery.of(context).size.width * 0.3,
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
                              decoration: BoxDecoration(border: Border.all()),
                              width: MediaQuery.of(context).size.width * 0.40,
                              height: 40,
                              padding: const EdgeInsets.all(2.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedIsActive,
                                  underline: Container(),
                                  icon: const SizedBox.shrink(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedIsActive = newValue!;
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
                            vertical: 10, horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: createNewCustomer,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFACD),
                                  border: Border.all(
                                    color: const Color(0xFFFFFACD),
                                    width: 1,
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width * 0.3,
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
                                width: MediaQuery.of(context).size.width * 0.3,
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
              tablet: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.height * 0.80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 10),
                        child: Row(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Mobile No",
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
                                )),
                            SETopTextfield(
                              controller: _mobileController,
                              // focusNode: _mobileFocusNode,
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_firstNameFocusNode);

                              //   setState(() {});
                              // },
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_mobileFocusNode);

                                setState(() {});
                              },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.6,
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
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "First Name",
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
                                )),
                            SETopTextfield(
                              controller: _firstNameController,
                              // focusNode: _firstNameFocusNode,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_firstNameFocusNode);

                                setState(() {});
                              },
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_middleNameFocusNode);

                              //   setState(() {});
                              // },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.6,
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
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: Text(
                                "Middle Name",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _middleNameController,
                              // focusNode: _middleNameFocusNode,
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_lastNameFocusNode);

                              //   setState(() {});
                              // },
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_middleNameFocusNode);

                                setState(() {});
                              },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.60,
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
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: Text(
                                "Last Name",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _lastNameController,
                              // focusNode: _lastNameFocusNode,
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_fullNameFocusNode);

                              //   setState(() {});
                              // },
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_lastNameFocusNode);

                                setState(() {});
                              },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.60,
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
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: Text(
                                "Full Name",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _fullNameController,
                              // focusNode: _fullNameFocusNode,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_fullNameFocusNode);

                                setState(() {});
                              },
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_customerIdFocusNode);

                              //   setState(() {});
                              // },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.60,
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
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: Text(
                                "Send SMS",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(border: Border.all()),
                              width: MediaQuery.of(context).size.width * 0.40,
                              height: 40,
                              padding: const EdgeInsets.all(2.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedSendSms,
                                  underline: Container(),
                                  icon: const SizedBox.shrink(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedSendSms = newValue!;
                                    });
                                  },
                                  items: ["No", "Yes"]
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
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: Text(
                                "Customer Type",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(border: Border.all()),
                              width: MediaQuery.of(context).size.width * 0.40,
                              height: 40,
                              padding: const EdgeInsets.all(2.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedCustomerType,
                                  underline: Container(),
                                  icon: const SizedBox.shrink(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCustomerType = newValue!;
                                    });
                                  },
                                  items: ["Walk In"]
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
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: Text(
                                "Customer ID",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _customerIdController,
                              // focusNode: _customerIdFocusNode,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_customerIdFocusNode);

                                setState(() {});
                              },
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_addressFocusNode);

                              //   setState(() {});
                              // },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.60,
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
                              width: MediaQuery.of(context).size.width * 0.15,
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
                              controller: _addressController,
                              // focusNode: _addressFocusNode,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_addressFocusNode);

                                setState(() {});
                              },
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_cityFocusNode);

                              //   setState(() {});
                              // },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.60,
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
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: Text(
                                "City/Town",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _cityController,
                              // focusNode: _cityFocusNode,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_cityFocusNode);

                                setState(() {});
                              },
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_aadharCardFocusNode);

                              //   setState(() {});
                              // },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.60,
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
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: Text(
                                "Aadhar Card",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _aadharCardController,
                              // focusNode: _aadharCardFocusNode,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_aadharCardFocusNode);

                                setState(() {});
                              },
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_emailIdFocusNode);

                              //   setState(() {});
                              // },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.60,
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
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: Text(
                                "Email ID",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _emailIdController,
                              // focusNode: _emailIdFocusNode,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_emailIdFocusNode);

                                setState(() {});
                              },
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_birthDateFocusNode);

                              //   setState(() {});
                              // },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.60,
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
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: Text(
                                "Birth Date",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _birthDateController,
                              // focusNode: _birthDateFocusNode,
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_mobileFocusNode);

                              //   setState(() {});
                              // },
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_birthDateFocusNode);

                                setState(() {});
                              },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.60,
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
                              width: MediaQuery.of(context).size.width * 0.15,
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
                              decoration: BoxDecoration(border: Border.all()),
                              width: MediaQuery.of(context).size.width * 0.40,
                              height: 40,
                              padding: const EdgeInsets.all(2.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedIsActive,
                                  underline: Container(),
                                  icon: const SizedBox.shrink(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedIsActive = newValue!;
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
                            vertical: 10, horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: createNewCustomer,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFACD),
                                  border: Border.all(
                                    color: const Color(0xFFFFFACD),
                                    width: 1,
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width * 0.15,
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
                                width: MediaQuery.of(context).size.width * 0.15,
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
              desktop: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: MediaQuery.of(context).size.height * 0.80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 10),
                        child: Row(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.08,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Mobile No",
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
                                )),
                            SETopTextfield(
                              controller: _mobileController,
                              // focusNode: _mobileFocusNode,
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_firstNameFocusNode);

                              //   setState(() {});
                              // },
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_mobileFocusNode);

                                setState(() {});
                              },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.15,
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
                                width: MediaQuery.of(context).size.width * 0.08,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "First Name",
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
                                )),
                            SETopTextfield(
                              controller: _firstNameController,
                              // focusNode: _firstNameFocusNode,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_firstNameFocusNode);

                                setState(() {});
                              },
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_middleNameFocusNode);

                              //   setState(() {});
                              // },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.15,
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
                              width: MediaQuery.of(context).size.width * 0.08,
                              child: Text(
                                "Middle Name",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _middleNameController,
                              // focusNode: _middleNameFocusNode,
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_lastNameFocusNode);

                              //   setState(() {});
                              // },
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_middleNameFocusNode);

                                setState(() {});
                              },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.15,
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
                              width: MediaQuery.of(context).size.width * 0.08,
                              child: Text(
                                "Last Name",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _lastNameController,
                              // focusNode: _lastNameFocusNode,
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_fullNameFocusNode);

                              //   setState(() {});
                              // },
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_lastNameFocusNode);

                                setState(() {});
                              },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.15,
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
                              width: MediaQuery.of(context).size.width * 0.08,
                              child: Text(
                                "Full Name",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _fullNameController,
                              // focusNode: _fullNameFocusNode,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_fullNameFocusNode);

                                setState(() {});
                              },
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_customerIdFocusNode);

                              //   setState(() {});
                              // },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.3,
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
                              width: MediaQuery.of(context).size.width * 0.08,
                              child: Text(
                                "Send SMS",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(border: Border.all()),
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: 40,
                              padding: const EdgeInsets.all(2.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedSendSms,
                                  underline: Container(),
                                  icon: const SizedBox.shrink(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedSendSms = newValue!;
                                    });
                                  },
                                  items: ["No", "Yes"]
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
                              width: MediaQuery.of(context).size.width * 0.08,
                              child: Text(
                                "Customer Type",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(border: Border.all()),
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: 40,
                              padding: const EdgeInsets.all(2.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedCustomerType,
                                  underline: Container(),
                                  icon: const SizedBox.shrink(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCustomerType = newValue!;
                                    });
                                  },
                                  items: ["Walk In"]
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
                              width: MediaQuery.of(context).size.width * 0.08,
                              child: Text(
                                "Customer ID",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _customerIdController,
                              // focusNode: _customerIdFocusNode,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_customerIdFocusNode);

                                setState(() {});
                              },
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_addressFocusNode);

                              //   setState(() {});
                              // },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.3,
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
                              width: MediaQuery.of(context).size.width * 0.08,
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
                              controller: _addressController,
                              // focusNode: _addressFocusNode,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_addressFocusNode);

                                setState(() {});
                              },
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_cityFocusNode);

                              //   setState(() {});
                              // },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.3,
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
                              width: MediaQuery.of(context).size.width * 0.08,
                              child: Text(
                                "City/Town",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _cityController,
                              // focusNode: _cityFocusNode,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_cityFocusNode);

                                setState(() {});
                              },
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_aadharCardFocusNode);

                              //   setState(() {});
                              // },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.15,
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
                              width: MediaQuery.of(context).size.width * 0.08,
                              child: Text(
                                "Aadhar Card",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _aadharCardController,
                              // focusNode: _aadharCardFocusNode,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_aadharCardFocusNode);

                                setState(() {});
                              },
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_emailIdFocusNode);

                              //   setState(() {});
                              // },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.3,
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
                              width: MediaQuery.of(context).size.width * 0.08,
                              child: Text(
                                "Email ID",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _emailIdController,
                              // focusNode: _emailIdFocusNode,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_emailIdFocusNode);

                                setState(() {});
                              },
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_birthDateFocusNode);

                              //   setState(() {});
                              // },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.3,
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
                              width: MediaQuery.of(context).size.width * 0.08,
                              child: Text(
                                "Birth Date",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SETopTextfield(
                              controller: _birthDateController,
                              // focusNode: _birthDateFocusNode,
                              // onEditingComplete: () {
                              //   FocusScope.of(context)
                              //       .requestFocus(_mobileFocusNode);

                              //   setState(() {});
                              // },
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(_birthDateFocusNode);

                                setState(() {});
                              },
                              onSaved: (newValue) {},
                              width: MediaQuery.of(context).size.width * 0.1,
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
                              width: MediaQuery.of(context).size.width * 0.08,
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
                              decoration: BoxDecoration(border: Border.all()),
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: 40,
                              padding: const EdgeInsets.all(2.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedIsActive,
                                  underline: Container(),
                                  icon: const SizedBox.shrink(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedIsActive = newValue!;
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
                            vertical: 10, horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: createNewCustomer,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFACD),
                                  border: Border.all(
                                    color: const Color(0xFFFFFACD),
                                    width: 1,
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width * 0.08,
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
                                width: MediaQuery.of(context).size.width * 0.08,
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
        ),
      ),
    );
  }
}

class SubmitIntent extends Intent {
  const SubmitIntent();
}


class SaveIntent extends Intent {
  const SaveIntent();
}
