import 'package:billingsphere/views/RA_widgets/RA_D_appbar.dart';
import 'package:billingsphere/views/RA_widgets/RA_M_Button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

class SalesSummaryMyMobileBody extends StatefulWidget {
  bool _isChecked1 = false;
  SalesSummaryMyMobileBody({
    super.key,
  });

  @override
  State<SalesSummaryMyMobileBody> createState() =>
      _SalesSummaryMyMobileBodyState();
}

class _SalesSummaryMyMobileBodyState extends State<SalesSummaryMyMobileBody> {
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
            Column(
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.97,
                              height: 250,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Report Critaria',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
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
                                              0.3,
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
                                                0.25,
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
                                              decoration: const InputDecoration(
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
                                              0.06,
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
                                              0.25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
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
                                            decoration: const InputDecoration(
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
                                              0.3,
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
                                              0.58,
                                          height: 25,
                                          child: TextField(
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              height: 0.8,
                                            ),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0.0),
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
                                              0.3,
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
                                              0.58,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                          ),
                                          child: SearchField(
                                            suggestions: suggestionItems,
                                            searchStyle: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.29,
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
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          0.0),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.50,
                                                child: const Text(
                                                  'Show Periodic Total',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.3,
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
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  height: 40,
                                                  text: 'Show',
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
                                                            0.3,
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
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            RAMButtons(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: 40,
                              text: 'Report',
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width *
                                      0.035),
                              child: RAMButtons(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 40,
                                text: 'Print',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width *
                                      0.035),
                              child: RAMButtons(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 40,
                                text: 'Filters',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            RAMButtons(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: 40,
                              text: 'Sales Chart',
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width *
                                      0.035),
                              child: RAMButtons(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 40,
                                text: 'Profit Chart',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width *
                                      0.035),
                              child: RAMButtons(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 40,
                                text: 'Disc. Chart',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            RAMButtons(
                              width: MediaQuery.of(context).size.width * 0.97,
                              height: 40,
                              text: 'Export-Excel',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
