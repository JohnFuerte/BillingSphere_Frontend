import 'package:billingsphere/views/RA_widgets/RA_D_appbar.dart';
import 'package:billingsphere/views/RA_widgets/RA_D_side_buttons.dart';
import 'package:billingsphere/views/RA_widgets/RA_M_Button.dart';
import 'package:flutter/material.dart';

class MyDesktopBody extends StatefulWidget {
  int? selectedOption; // Declare the variable here
  bool _isChecked = false;
  bool _isChecked1 = false;
  MyDesktopBody({super.key, required this.selectedOption});

  @override
  State<MyDesktopBody> createState() => _MyDesktopBodyState();
}

class _MyDesktopBodyState extends State<MyDesktopBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  const RACustomAppBar(),
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.01,
                      left: MediaQuery.of(context).size.width * 0.01,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 615,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height: 330,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Report Critaria',
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
                                              value:
                                                  0, // Assign a unique value to each radio button
                                              groupValue: widget.selectedOption,
                                              onChanged: (value) {
                                                // Handle radio button selection
                                                setState(() {
                                                  widget.selectedOption = value;
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
                                              value:
                                                  1, // Assign a unique value to each radio button
                                              groupValue: widget.selectedOption,
                                              onChanged: (value) {
                                                // Handle radio button selection
                                                setState(() {
                                                  widget.selectedOption = value;
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
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.46,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                              ),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.005,
                                                          bottom: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.004),
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
                                                                0.1,
                                                            child: const Text(
                                                              '  Region',
                                                              style: TextStyle(
                                                                fontSize: 16,
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
                                                                0.20,
                                                            height: 25,
                                                            child: TextField(
                                                              style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                height: 0.8,
                                                              ),
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0.0),
                                                                ),
                                                              ),

                                                              cursorHeight:
                                                                  15.0, // Adjust cursor height
                                                              cursorWidth: 1.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                          child: const Text(
                                                            '  Ledger Name',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.27,
                                                          height: 25,
                                                          child: TextField(
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              height: 0.8,
                                                            ),
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0.0),
                                                              ),
                                                            ),
                                                            cursorHeight: 15.0,
                                                            cursorWidth: 1.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.095),
                                                      child: Row(
                                                        children: [
                                                          Checkbox(
                                                            value: widget
                                                                ._isChecked, // Use the defined variable
                                                            onChanged:
                                                                (bool? value) {
                                                              setState(() {
                                                                widget._isChecked =
                                                                    value!; // Update the variable on state change
                                                              });
                                                            },
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0.0),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.1,
                                                            child: const Text(
                                                              'Show All Bills',
                                                              style: TextStyle(
                                                                fontSize: 15,
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
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 50),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Checkbox(
                                                    value: widget
                                                        ._isChecked1, // Use the defined variable
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        widget._isChecked1 =
                                                            value!; // Update the variable on state change
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
                                                ],
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
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.11,
                                                    height: 30,
                                                    text: 'Show [F4]',
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
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                height: 700,
                child: Column(
                  children: [
                    DSideBUtton(
                      onTapped: () {},
                      text: 'P Print',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: 'F2 Report',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: 'F5 Make Receipt',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
