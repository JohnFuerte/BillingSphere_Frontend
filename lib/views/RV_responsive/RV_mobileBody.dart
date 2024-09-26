import 'package:billingsphere/views/RV_widgets/cstmTextField.dart';
import 'package:billingsphere/views/RV_widgets/myRow.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RVMobileBody extends StatefulWidget {
  const RVMobileBody({super.key});

  @override
  State<RVMobileBody> createState() => _RVMobileBodyState();
}

class _RVMobileBodyState extends State<RVMobileBody> {
  DateTime? _selectedDate;
// Define a TextEditingController
  final TextEditingController _datecontroller = TextEditingController();
// ...
  Color backgroundColor = Colors.transparent;
  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _datecontroller.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
        print(_datecontroller.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: MediaQuery.of(context).size.height * .07,
            width: MediaQuery.of(context).size.width * 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: const Color.fromARGB(255, 161, 78, 53),
                    child: const Center(
                        child: Text(
                      'Receipt',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    color: Colors.green[300],
                    child: const Center(
                        child: Text(
                      'Voucher Entry',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2, right: 2),
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              height: MediaQuery.of(context).size.height * .8,
              width: MediaQuery.of(context).size.width * 1,
              child: Column(children: [
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: RVCustomTextFieldWidget(
                            controller: _datecontroller,
                            labelText: 'No ',
                            textFieldHeight: 30,
                            textFieldWidth:
                                MediaQuery.of(context).size.width * .2)),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            'Date:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.28,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _datecontroller,
                                  // focusNode: _focusNode,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                  cursorHeight: 21,
                                  cursorColor: Colors.white,
                                  cursorWidth: 1,
                                  textAlignVertical: TextAlignVertical.top,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: backgroundColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.calendar_month,
                                ),
                                onPressed: () {
                                  _selectDate(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: 45,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Row(children: [
                    const Text('Dr/Cr',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.deepPurple)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .01,
                    ),
                    const Expanded(
                      child: Text('Ledger Name',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.deepPurple)),
                    ),
                    const Expanded(
                      child: Text('Remark',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.deepPurple)),
                    ),
                    const Expanded(
                      child: Text('Debit',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.deepPurple)),
                    ),
                    const Expanded(
                      child: Text('Credit',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.deepPurple)),
                    ),
                  ]),
                ),
                // RVMyRow(
                //     // flexValues: [2, 2, 2, 2],
                //     )
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2, right: 2, bottom: 4),
            child: Container(
              height: MediaQuery.of(context).size.height * .6,
              width: MediaQuery.of(context).size.width * 1,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: RVCustomTextFieldWidget(
                        controller: _datecontroller,
                        labelText: 'Narration',
                        textFieldHeight: 50,
                        textFieldWidth: MediaQuery.of(context).size.width * .6),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .7,
                    height: MediaQuery.of(context).size.height * .3,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Column(
                      children: [
                        const Text('Ledger Information',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.deepPurple)),
                        Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width * .7,
                          decoration: const BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: Colors.black),
                                  bottom: BorderSide(color: Colors.black))),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: const Center(
                                    child: Text(
                                      'Limit',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.deepPurple),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: const Color.fromARGB(255, 161, 78, 53),
                                  child: const Center(
                                    child: Text(
                                      '50,000.00',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: const Center(
                                    child: Text(
                                      'Bal',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.deepPurple),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: const Color.fromARGB(255, 161, 78, 53),
                                  child: const Center(
                                    child: Text(
                                      '983.00 Dr',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Text(
                          'Gurugram',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .07,
                      ),
                      const Expanded(
                          child: TextField(
                        decoration: InputDecoration(
                            helperText: '[0] Dr',
                            helperStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.deepPurple)),
                      )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .07,
                      ),
                      const Expanded(
                          child: TextField(
                        decoration: InputDecoration(
                            helperText: '[0] Cr',
                            helperStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple)),
                      )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .07,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width * .25,
                                    10),
                                shape: const BeveledRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black, width: .3)),
                                backgroundColor: Colors.yellow.shade100),
                            onPressed: () {},
                            child: const Text(
                              'Save [F4]',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .002,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width * .25,
                                    10),
                                shape: const BeveledRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black, width: .3)),
                                backgroundColor: Colors.yellow.shade100),
                            onPressed: () {},
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .002,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width * .25,
                                    10),
                                shape: const BeveledRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black, width: .3)),
                                backgroundColor: Colors.yellow.shade100),
                            onPressed: () {},
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
