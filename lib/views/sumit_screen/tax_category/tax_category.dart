// ignore_for_file: camel_case_types

import 'package:billingsphere/utils/controllers/tax_text_controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/taxCategory/tax_category_model.dart';
import '../../../data/repository/tax_category_repository.dart';
import '../sumit_responsive.dart';

class Responsive_NewTaxCategory extends StatefulWidget {
  const Responsive_NewTaxCategory({super.key});

  @override
  State<Responsive_NewTaxCategory> createState() =>
      _Responsive_NewTaxCategoryState();
}

class _Responsive_NewTaxCategoryState extends State<Responsive_NewTaxCategory> {
  List<String> isactive = ['Yes', 'No'];
  String selectedisactive = 'Yes';
  List<String> addcess = ['Yes', 'No'];
  String selectedaddcess = 'Yes';
  List<String> exempted = ['Yes', 'No'];
  String selectedexempted = 'Yes';

  TaxRateService taxRateService = TaxRateService();
  TaxRateFormController taxRateFormController = TaxRateFormController();

  void createTaxRateEntry() {
    final taxRate = TaxRate(
      id: '',
      rate: taxRateFormController.rateController.text,
      updatedOn: DateTime.now(),
      createdOn: DateTime.now(),
    );
    taxRateService.addTaxRateEntry(taxRate, context);
    taxRateFormController.rateController.clear();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobile: Container(),
        tablet: Container(),
        desktop: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 30,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[400],
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
                      'New Tax Category',
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
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: Container(
                    height: 350,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8, left: 8, right: 8, bottom: 5),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 2,
                                child: Text(
                                  "Add Tax",
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Container(
                                  color: Colors.white,
                                  height: 30,
                                  child: TextFormField(
                                    controller:
                                        taxRateFormController.rateController,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      height: 1,
                                    ),
                                    cursorHeight: 15,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            0.0), // Adjust the border radius as needed
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 55),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.10,
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                    child: SizedBox(
                                      child: ElevatedButton(
                                        onPressed: createTaxRateEntry,
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(
                                                172, 236, 226, 137),
                                          ),
                                          shape: MaterialStateProperty.all<
                                              OutlinedBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(1.0),
                                              side: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 88, 81, 11),
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: const Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Save [F4]',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            ),
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
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.10,
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                    child: SizedBox(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(
                                                172, 236, 226, 137),
                                          ),
                                          shape: MaterialStateProperty.all<
                                              OutlinedBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(1.0),
                                              side: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 88, 81, 11),
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: const Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Close',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
