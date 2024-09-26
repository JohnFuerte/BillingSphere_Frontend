// ignore_for_file: camel_case_types

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/hsn/hsn_model.dart';
import '../../../data/repository/hsn_repository.dart';
import '../../../utils/controllers/hsn_text_controllers.dart';
import '../sumit_responsive.dart';

class Responsive_NewHSNCommodity extends StatefulWidget {
  const Responsive_NewHSNCommodity({super.key});

  @override
  State<Responsive_NewHSNCommodity> createState() =>
      _Responsive_NewHSNCommodityState();
}

class _Responsive_NewHSNCommodityState
    extends State<Responsive_NewHSNCommodity> {
  HSNCodeService hsnCodeS = HSNCodeService();
  HsnFormController hsnFormController = HsnFormController();
  List<String> unitdropdown = ['Bags', 'KG'];
  String selectedStatus = 'Bags';

  void createHsnCodeEntry() {
    final hsnCode = HSNCode(
      id: '',
      hsn: hsnFormController.hsnController.text,
      unit: hsnFormController.unitController.text,
      description: hsnFormController.descriptionController.text,
      updatedOn: DateTime.now(),
      createdOn: DateTime.now(),
    );
    hsnCodeS.addHsnCodeEntry(hsnCode, context);
    hsnFormController.hsnController.clear();
    hsnFormController.unitController.clear();
    hsnFormController.descriptionController.clear();
  }

  String selectedValue = 'BAG-BAG';
  @override
  void initState() {
    super.initState();
    hsnFormController.unitController.text = selectedStatus;
  }

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
                      'New HSN Commodity',
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
                    height: 260,
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  "HSN Code",
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  color: Colors.white,
                                  height: 30,
                                  child: TextFormField(
                                    controller: hsnFormController.hsnController,
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
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  "Description",
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  color: Colors.white,
                                  height: 30,
                                  child: TextFormField(
                                    controller:
                                        hsnFormController.descriptionController,
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

                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       left: 8, right: 8, bottom: 5),
                        //   child: Row(
                        //     children: [
                        //       const Expanded(
                        //         flex: 1,
                        //         child: Text(
                        //           "Unit of Quantity",
                        //           style: TextStyle(
                        //             color: Colors.deepPurple,
                        //             fontSize: 16,
                        //             fontWeight: FontWeight.w400,
                        //           ),
                        //         ),
                        //       ),
                        //       Expanded(
                        //         flex: 3,
                        //         child: Container(
                        //           decoration:
                        //               BoxDecoration(border: Border.all()),
                        //           width:
                        //               MediaQuery.of(context).size.width * 0.1,
                        //           height: 30,
                        //           padding: const EdgeInsets.all(2.0),
                        //           child: DropdownButtonHideUnderline(
                        //             child: DropdownButton<String>(
                        //               value: selectedStatus,
                        //               underline: Container(),
                        //               onChanged: (String? newValue) {
                        //                 setState(() {
                        //                   selectedStatus = newValue!;
                        //                   hsnFormController.unitController
                        //                       .text = selectedStatus;
                        //                   // Set Type
                        //                 });

                        //                 print(hsnFormController
                        //                     .unitController.text);
                        //               },
                        //               items: unitdropdown.map((String value) {
                        //                 return DropdownMenuItem<String>(
                        //                   value: value,
                        //                   child: Padding(
                        //                     padding: const EdgeInsets.all(2.0),
                        //                     child: Text(value),
                        //                   ),
                        //                 );
                        //               }).toList(),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       left: 8, right: 8, bottom: 5),
                        //   child: Row(
                        //     children: [
                        //       const Expanded(
                        //         flex: 1,
                        //         child: Text(
                        //           "Description",
                        //           style: TextStyle(
                        //             color: Colors.deepPurple,
                        //             fontSize: 16,
                        //             fontWeight: FontWeight.w400,
                        //           ),
                        //         ),
                        //       ),
                        //       Expanded(
                        //         flex: 3,
                        //         child: Container(
                        //           color: Colors.white,
                        //           height: 30,
                        //           child: TextFormField(
                        //             controller:
                        //                 hsnFormController.descriptionController,
                        //             style: const TextStyle(
                        //               color: Colors.black,
                        //               fontSize: 17,
                        //               height: 1,
                        //             ),
                        //             cursorHeight: 15,
                        //             decoration: InputDecoration(
                        //               enabledBorder: OutlineInputBorder(
                        //                 borderRadius: BorderRadius.circular(
                        //                     0.0), // Adjust the border radius as needed
                        //               ),
                        //               focusedBorder: OutlineInputBorder(
                        //                 borderRadius:
                        //                     BorderRadius.circular(0.0),
                        //                 borderSide: const BorderSide(
                        //                     color: Colors.grey),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

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
                                        onPressed: createHsnCodeEntry,
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
