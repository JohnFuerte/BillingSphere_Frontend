import 'package:billingsphere/views/RA_widgets/RA_D_appbar.dart';
import 'package:billingsphere/views/RA_widgets/RA_D_side_buttons.dart';
import 'package:billingsphere/views/RA_widgets/RA_M_Button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

import '../sales_summary_homepage.dart';

class SalesSummaryMyDesktopBody extends StatefulWidget {
  bool _isChecked1 = false;
  SalesSummaryMyDesktopBody({
    super.key,
  });

  @override
  State<SalesSummaryMyDesktopBody> createState() =>
      _SalesSummaryMyDesktopBodyState();
}

class _SalesSummaryMyDesktopBodyState extends State<SalesSummaryMyDesktopBody> {
  final formatter = DateFormat.yMd();
  DateTime? _selectedDate;
  DateTime? _pickedDateData;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _dateController2 = TextEditingController();

  void _presentDatePICKER() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final _pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );

    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
        _dateController.text = formatter.format(_pickedDate);
      });
    }
  }

  void _showDataPICKER() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final _pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );
    if (_pickedDate != null) {
      setState(() {
        _pickedDateData = _pickedDate;
        _dateController2.text = formatter.format(_pickedDate);
      });
    }
  }

  List<SearchFieldListItem> suggestionItems = [
    SearchFieldListItem('India'),
    SearchFieldListItem('United States'),
    SearchFieldListItem('Canada'),
    SearchFieldListItem('Canada'),
    SearchFieldListItem('Canada'),
    SearchFieldListItem('Canada'),
    SearchFieldListItem('Canada'),
    SearchFieldListItem('Canada'),
    SearchFieldListItem('Canada'),
    SearchFieldListItem('Canada'),
    SearchFieldListItem('Canada'),
    SearchFieldListItem('Canada'),
    SearchFieldListItem('Canada'),
    SearchFieldListItem('Canada'),
    SearchFieldListItem('Canada'),
    // Add more items as needed
  ];

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
                  const RACustomAppBar(
                    text: 'Sale Summary',
                    color: Colors.green,
                  ),
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
                            width: MediaQuery.of(context).size.width * 0.90,
                            height: 615,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.37,
                                  height: 240,
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
                                            decoration:
                                                TextDecoration.underline,
                                            decorationThickness: 2.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.11,
                                              child: const Text(
                                                '  Date Range',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02,
                                              ),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.10,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ),
                                                child: TextFormField(
                                                  controller: _dateController,
                                                  style: const TextStyle(
                                                    height: 1,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: 'Select Date',
                                                    border: InputBorder.none,
                                                  ),
                                                  onTap: () {
                                                    _presentDatePICKER();
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                              child: const Text(
                                                'to',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.10,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                              ),
                                              child: TextFormField(
                                                controller: _dateController2,
                                                style: const TextStyle(
                                                  height: 1,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Select Date',
                                                  border: InputBorder.none,
                                                ),
                                                onTap: () {
                                                  _showDataPICKER();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.11,
                                              child: const Text(
                                                '  Format',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25,
                                              height: 25,
                                              child: TextField(
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  height: 0.8,
                                                ),
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                  ),
                                                ),
                                                cursorHeight: 15.0,
                                                cursorWidth: 1.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.11,
                                              child: const Text(
                                                '  Periodicity',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                              ),
                                              child: SearchField(
                                                suggestions: suggestionItems,
                                                searchStyle: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.105,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
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
                                                      'Show Periodic Total',
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
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.115,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
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
                                                      // onPressed: Navigator.push(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //     builder: (context) =>
                                                      //         const SS1HomePage(),
                                                      //   ),
                                                      // ),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.11,
                                                      height: 40,
                                                      text: 'Show [F4]',
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: RAMButtons(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.11,
                                                        height: 40,
                                                        text: 'Close',
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
              child: Container(
                width: MediaQuery.of(context).size.width * 0.1,
                height: 700,
                child: Column(
                  children: [
                    DSideBUtton(
                      onTapped: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const SS1HomePage(),
                        //   ),
                        // );
                      },
                      text: 'F2 Report',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: 'P Print',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: 'F Filters',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: 'X Export-Excel',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: '',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: 'C Sales Chart',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: 'D Profit Chart',
                    ),
                    DSideBUtton(
                      onTapped: () {},
                      text: 'E Dis. Chart',
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
