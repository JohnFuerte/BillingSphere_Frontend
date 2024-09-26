// ignore_for_file: camel_case_types

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/measurementLimit/measurement_limit_model.dart';
import '../../../data/repository/measurement_limit_repository.dart';
import '../../../utils/controllers/measurement_unit_text_controller.dart';
import '../sumit_responsive.dart';

class Responsive_measurementunit extends StatefulWidget {
  const Responsive_measurementunit({super.key});

  @override
  State<Responsive_measurementunit> createState() =>
      _Responsive_measurementunitState();
}

class _Responsive_measurementunitState
    extends State<Responsive_measurementunit> {
  MeasurementLimitService measurementUnitService = MeasurementLimitService();
  MeaseurementUnitFormController measurementunitFormController =
      MeaseurementUnitFormController();

  void createunitCodeEntry() {
    final measurementunit = MeasurementLimit(
      id: '',
      measurement: measurementunitFormController.measurementUnitController.text,
      updatedOn: DateTime.now(),
      createdOn: DateTime.now(),
    );
    measurementUnitService.addMeasurementUnitEntry(measurementunit, context);
    measurementunitFormController.measurementUnitController.clear();
  }

  @override
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
                      'New Item Measurement Unit',
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
                    height: 300,
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8, left: 8, right: 8, bottom: 5),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  "Measurement Unit",
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
                                    controller: measurementunitFormController
                                        .measurementUnitController,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.10,
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  child: SizedBox(
                                    child: ElevatedButton(
                                      onPressed: createunitCodeEntry,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.10,
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
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
