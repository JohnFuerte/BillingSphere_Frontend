import 'dart:ui' as ui;
import 'package:billingsphere/views/Daily_cash_resposive/daily_cash_master.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../data/models/dailyCash/daily_cash_model.dart';
import '../../data/repository/daily_cash_repository.dart';
import '../SE_common/SE_form_buttons.dart';
import 'daily_cash_receipt.dart';

class DailyCashCreate extends StatefulWidget {
  const DailyCashCreate({super.key});

  @override
  State<DailyCashCreate> createState() => _DailyCashCreateState();
}

class _DailyCashCreateState extends State<DailyCashCreate> {
  final TextEditingController _description = TextEditingController();
  final TextEditingController _cashier = TextEditingController();
  final TextEditingController _dateController1 = TextEditingController();
  final TextEditingController _controllerInput2000 = TextEditingController();
  final TextEditingController _controllerResult2000 = TextEditingController();
  final TextEditingController _controllerInput50 = TextEditingController();
  final TextEditingController _controllerResult50 = TextEditingController();
  final TextEditingController _controllerInput500 = TextEditingController();
  final TextEditingController _controllerResult500 = TextEditingController();
  final TextEditingController _controllerInput20 = TextEditingController();
  final TextEditingController _controllerResult20 = TextEditingController();
  final TextEditingController _controllerInput200 = TextEditingController();
  final TextEditingController _controllerResult200 = TextEditingController();
  final TextEditingController _controllerInput10 = TextEditingController();
  final TextEditingController _controllerResult10 = TextEditingController();
  final TextEditingController _controllerInput100 = TextEditingController();
  final TextEditingController _controllerResult100 = TextEditingController();
  final TextEditingController _controllerInputCoins = TextEditingController();
  final TextEditingController _controllerResultCoins = TextEditingController();
  final TextEditingController _controllerDenom = TextEditingController();
  final TextEditingController _controllerAsPerBook = TextEditingController();
  final TextEditingController _controllerShort = TextEditingController();

  void calculateGrandTotal() {
    double grandTotal = 0.00;
    grandTotal += double.tryParse(_controllerResult2000.text) ?? 0.00;
    grandTotal += double.tryParse(_controllerResult50.text) ?? 0.00;
    grandTotal += double.tryParse(_controllerResult500.text) ?? 0.00;
    grandTotal += double.tryParse(_controllerResult20.text) ?? 0.00;
    grandTotal += double.tryParse(_controllerResult200.text) ?? 0.00;
    grandTotal += double.tryParse(_controllerResult10.text) ?? 0.00;
    grandTotal += double.tryParse(_controllerResult100.text) ?? 0.00;
    grandTotal += double.tryParse(_controllerResultCoins.text) ?? 0.00;

    _controllerDenom.text = grandTotal.toStringAsFixed(2);
    _controllerShort.text = grandTotal.toStringAsFixed(2);
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1935),
      lastDate: DateTime(2035),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  DateTime selectedDate = DateTime.now();
  Future<bool> createDailyCashEntry() async {
    try {
      if (_dateController1.text.isEmpty) {
        _showToast("Date is required");
        return false;
      }

      if (_cashier.text.isEmpty) {
        _showToast("Cashier is required");
        return false;
      }

      if (_controllerShort.text.isEmpty) {
        _showToast("Short Amount is required");
        return false;
      }

      if (_controllerDenom.text.isEmpty) {
        _showToast("Denomination is required");
        return false;
      }

      // Create a DailyCashEntry object using the controller values
      DailyCashEntry dailyCashEntry = DailyCashEntry(
        id: 'id', // You may need to generate a unique ID for this entry
        date: _dateController1.text,
        description: _description.text,
        cashier: _cashier.text,
        twoThousand: _controllerInput2000.text.isNotEmpty
            ? [
                TwoThousand(
                  qty: double.tryParse(_controllerInput2000.text),
                  total: double.tryParse(_controllerResult2000.text),
                )
              ]
            : [],
        fiveHundred: _controllerInput500.text.isNotEmpty
            ? [
                FiveHundred(
                  qty: double.tryParse(_controllerInput500.text),
                  total: double.tryParse(_controllerResult500.text),
                )
              ]
            : [],
        twoHundred: _controllerInput200.text.isNotEmpty
            ? [
                TwoHundred(
                  qty: double.tryParse(_controllerInput200.text),
                  total: double.tryParse(_controllerResult200.text),
                )
              ]
            : [],
        oneHundred: _controllerInput100.text.isNotEmpty
            ? [
                OneHundred(
                  qty: double.tryParse(_controllerInput100.text),
                  total: double.tryParse(_controllerResult100.text),
                )
              ]
            : [],
        fifty: _controllerInput50.text.isNotEmpty
            ? [
                Fifty(
                  qty: double.tryParse(_controllerInput50.text),
                  total: double.tryParse(_controllerResult50.text),
                )
              ]
            : [],
        twenty: _controllerInput20.text.isNotEmpty
            ? [
                Twenty(
                  qty: double.tryParse(_controllerInput20.text),
                  total: double.tryParse(_controllerResult20.text),
                )
              ]
            : [],
        ten: _controllerInput10.text.isNotEmpty
            ? [
                Ten(
                  qty: double.tryParse(_controllerInput10.text),
                  total: double.tryParse(_controllerResult10.text),
                )
              ]
            : [],
        coins: _controllerInputCoins.text.isNotEmpty
            ? [
                Coins(
                  qty: double.tryParse(_controllerInputCoins.text),
                  total: double.tryParse(_controllerResultCoins.text),
                )
              ]
            : [],
        actualcash: double.parse(_controllerDenom.text),
        systemcash: _controllerAsPerBook.text.isNotEmpty
            ? double.parse(_controllerAsPerBook.text)
            : 0.00,
        excesscash: double.parse(_controllerShort.text),
      );
      // Send the DailyCashEntry object to the server
      bool success = await DailyCashServices().createDailyCash(dailyCashEntry);

      if (success) {
        _showToast("Daily Cash Added");
        fetchAllDailyCash().then((_) {
          final newDailyCash = fetchedDailycash.firstWhere(
            (element) => element.cashier == dailyCashEntry.cashier,
            orElse: () => DailyCashEntry(
              id: '',
              date: '',
              cashier: '',
              description: '',
              twoThousand: [],
              fiveHundred: [],
              twoHundred: [],
              oneHundred: [],
              fifty: [],
              twenty: [],
              ten: [],
              coins: [],
              actualcash: 0.00,
              excesscash: 0.00,
              systemcash: 0.00,
            ),
          );
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Print Receipt"),
                content: const Text("Do you want to print the receipt?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => DailyCashReceipt(
                            dailyCashID: newDailyCash.id,
                            title: 'Print Daily Cash Receipt',
                          ),
                        ),
                      );
                    },
                    child: const Text("No"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      // Add code to handle printing here
                    },
                    child: const Text("Yes"),
                  ),
                ],
              );
            },
          );
        });
      }

      return success;
    } catch (e) {
      print('Error creating daily cash entry: $e');
      return false;
    }
  }

  bool isLoading = false;
  List<DailyCashEntry> fetchedDailycash = [];
  String? selectedId;

  Future<void> fetchAllDailyCash() async {
    setState(() {
      isLoading = true;
    });

    try {
      final List<DailyCashEntry> dailycash =
          await DailyCashServices().fetchDailyCash();

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        if (dailycash.isNotEmpty) {
          fetchedDailycash = dailycash;
          selectedId = fetchedDailycash[0].id;
        } else {
          fetchedDailycash = dailycash;
        }
        isLoading = false;
      });

      print(dailycash);
    } catch (error) {
      print('Failed to fetch Devlivery Challan: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void initState() {
    super.initState();
    fetchAllDailyCash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: Text(
            'NEW Daily Cash Record',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 22.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              width: 25,
              height: 25,
              color: Colors.white,
              child: Center(
                  child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.black,
                ),
              )),
            ),
            const SizedBox(width: 10),
          ],
          backgroundColor: const Color.fromRGBO(138, 43, 226, 1),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                height: 560,
                width: 680,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // For Date Picker
                    Row(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 120,
                          child: subHeadingText("Date : ").pOnly(right: 15.0),
                        ),
                        SizedBox(
                          height: 35,
                          // width: w(MediaQuery.of(context).size.width / 6),
                          child: TextField(
                            controller: _dateController1,
                            onTap: () {
                              _selectDate(_dateController1);
                            },
                            onChanged: (value) {
                              setState(() {
                                _dateController1.text = value;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: "Date",
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10.0),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            readOnly: true,
                          ),
                        ).w(MediaQuery.of(context).size.width / 6),
                      ],
                    ),

                    10.heightBox,

                    // Description Text Field
                    Row(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 120,
                          child:
                              subHeadingText("Description:").pOnly(right: 15.0),
                        ),
                        Expanded(
                          child: customFormField(
                              text: "Enter The Description",
                              controller: _description),
                        )
                      ],
                    ),

                    10.heightBox,

                    // Cashier Text Field
                    Row(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 120,
                          child: subHeadingText("Cashier:").pOnly(right: 15.0),
                        ),
                        Expanded(
                          child: customFormField(
                              text: "Enter The Cashier", controller: _cashier),
                        ),
                        Expanded(child: Container())
                      ],
                    ),

                    15.heightBox,
                    subHeadingText("Denomination Detail:"),
                    10.heightBox,

                    // 1 Currency
                    Row(
                      children: [
                        CurrencyRow(
                            heading: "2000",
                            inputController: _controllerInput2000,
                            resultController: _controllerResult2000,
                            multiplier: 2000,
                            calculateGrandTotal: calculateGrandTotal),
                        40.widthBox,
                        CurrencyRow(
                            heading: "50",
                            inputController: _controllerInput50,
                            resultController: _controllerResult50,
                            multiplier: 50,
                            calculateGrandTotal: calculateGrandTotal),
                      ],
                    ).px12(),
                    10.heightBox,

                    // 2 Currency
                    Row(
                      children: [
                        CurrencyRow(
                            heading: "500",
                            inputController: _controllerInput500,
                            resultController: _controllerResult500,
                            multiplier: 500,
                            calculateGrandTotal: calculateGrandTotal),
                        40.widthBox,
                        CurrencyRow(
                            heading: "20",
                            inputController: _controllerInput20,
                            resultController: _controllerResult20,
                            multiplier: 20,
                            calculateGrandTotal: calculateGrandTotal),
                      ],
                    ).px12(),
                    10.heightBox,

                    // 3 Currency
                    Row(
                      children: [
                        CurrencyRow(
                            heading: "200",
                            inputController: _controllerInput200,
                            resultController: _controllerResult200,
                            multiplier: 200,
                            calculateGrandTotal: calculateGrandTotal),
                        40.widthBox,
                        CurrencyRow(
                            heading: "10",
                            inputController: _controllerInput10,
                            resultController: _controllerResult10,
                            multiplier: 10,
                            calculateGrandTotal: calculateGrandTotal),
                      ],
                    ).px12(),
                    10.heightBox,

                    // 4 Currency
                    Row(
                      children: [
                        CurrencyRow(
                            heading: "100",
                            inputController: _controllerInput100,
                            resultController: _controllerResult100,
                            multiplier: 100,
                            calculateGrandTotal: calculateGrandTotal),
                        40.widthBox,
                        CurrencyRow(
                            heading: "Coins",
                            inputController: _controllerInputCoins,
                            resultController: _controllerResultCoins,
                            multiplier: 1,
                            calculateGrandTotal: calculateGrandTotal),
                      ],
                    ).px12(),
                    20.heightBox,

                    // Denom Text Field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        subHeadingText("Denom. (Actual Cash)")
                            .pOnly(right: 25.0),
                        Container(
                          height: 30,
                          width: 200,
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextFormField(
                            controller: _controllerDenom,
                            textDirection: ui.TextDirection.rtl,
                            readOnly: true,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.poppins(
                                fontSize: 18.5, fontWeight: FontWeight.w500),
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 10.0),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero)),
                          ),
                        ),
                      ],
                    ),

                    20.heightBox,

                    // As Per Books Text Field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        subHeadingText("As per Books (System)")
                            .pOnly(right: 25.0),
                        Container(
                          height: 30,
                          width: 200,
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            textDirection: ui.TextDirection.rtl,
                            controller: _controllerAsPerBook,
                            style: GoogleFonts.poppins(
                                fontSize: 18.5, fontWeight: FontWeight.w500),
                            onChanged: (value) {
                              double input = double.tryParse(value) ?? 0.00;
                              double denomValue =
                                  double.tryParse(_controllerDenom.text) ??
                                      0.00;
                              _controllerShort.text =
                                  (denomValue - input).toStringAsFixed(2);
                            },
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 10.0),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero)),
                          ),
                        ),
                      ],
                    ),

                    // Small Get System Cash Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.topRight,
                          height: 15,
                          width: 200,
                          child: InkWell(
                            onTap: () {},
                            child: const Text(
                              "Get System Cash",
                              style: TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.blue,
                                  decorationThickness: 2.0,
                                  decoration: ui.TextDecoration.underline),
                            ),
                          ),
                        ),
                      ],
                    ),
                    10.heightBox,

                    // Shorts Text Field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        subHeadingText("Short:").pOnly(right: 25.0),
                        Container(
                          height: 30,
                          width: 200,
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            controller: _controllerShort,
                            readOnly: true,
                            style: GoogleFonts.poppins(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                            textDirection: ui.TextDirection.rtl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.deepPurple.shade300,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 10.0),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.deepPurple),
                                    borderRadius: BorderRadius.zero),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.deepPurple),
                                    borderRadius: BorderRadius.zero)),
                          ),
                        ),
                      ],
                    ),

                    15.heightBox,

                    // For Two Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SEFormButton(
                              // width: MediaQuery.of(context).size.width * 0.05,
                              height: 40,
                              onPressed: createDailyCashEntry,
                              buttonText: 'Save [F4]',
                            )
                          ],
                        ),
                        10.widthBox,
                        Column(
                          children: [
                            SEFormButton(
                              // width: MediaQuery.of(context).size.width * 0.05,
                              height: 40,
                              onPressed: () {},
                              buttonText: 'Cancel',
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// For subHeading
Widget subHeadingText(String text) {
  return Text(
    text,
    style: GoogleFonts.poppins(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.deepPurple),
  );
}

// For Date Picker
class DatePicker extends StatefulWidget {
  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final TextEditingController _dateController1 = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 35,
            width: 30,
            child: TextField(
              controller: _dateController1,
              onTap: () {
                _selectDate(_dateController1);
              },
              onChanged: (value) {
                setState(() {
                  _dateController1.text = value;
                });
              },
              decoration: const InputDecoration(
                hintText: "Date",
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              readOnly: true,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1935),
      lastDate: DateTime(2035),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }
}

// For TextField
class customFormField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  const customFormField({
    Key? key,
    required this.text,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: TextFormField(
        style: GoogleFonts.poppins(fontSize: 15.0, fontWeight: FontWeight.w500),
        controller: controller,
        decoration: InputDecoration(
            hintText: text,
            hintStyle: GoogleFonts.poppins(
                fontSize: 15.0, fontWeight: FontWeight.w500),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(2)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(2))),
      ),
    );
  }
}

// For Button
Widget buildCustomButton({
  required String text,
  required BuildContext context,
}) {
  double screenWidth = MediaQuery.of(context).size.width;
  double fontSize = screenWidth > 600 ? 18.0 : 14.0;

  return Container(
    alignment: Alignment.center,
    height: 40,
    decoration: BoxDecoration(
      border: Border.all(width: 1.5, color: Colors.yellow.shade500),
      color: const Color.fromRGBO(255, 250, 205, 1),
    ),
    // width: 180,
    child: Text(
      text,
      style: GoogleFonts.poppins(color: Colors.black, fontSize: fontSize),
    ),
  );
}

// For Currency Row Stateless
class CurrencyRow extends StatelessWidget {
  final String heading;
  final TextEditingController inputController;
  final TextEditingController resultController;
  final double multiplier;
  final Function calculateGrandTotal;

  CurrencyRow({
    Key? key,
    required this.heading,
    required this.inputController,
    required this.resultController,
    required this.multiplier,
    required this.calculateGrandTotal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          SizedBox(
            width: 52,
            height: 25,
            child: subHeadingText(heading).pOnly(right: 5.0),
          ),
          SizedBox(
            width: 65,
            height: 30,
            child: TextFormField(
              cursorColor: Colors.black,
              textDirection: ui.TextDirection.rtl,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
              controller: inputController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(
                  fontSize: 15.5, fontWeight: FontWeight.w500),
              onChanged: (value) {
                double input = double.tryParse(value) ?? 0.0;
                resultController.text = (input * multiplier).toStringAsFixed(2);
                calculateGrandTotal();
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 10.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 30,
              child: TextFormField(
                readOnly: true,
                cursorColor: Colors.black,
                textDirection: ui.TextDirection.rtl,
                controller: resultController,
                style: GoogleFonts.poppins(
                    fontSize: 15.5, fontWeight: FontWeight.w500),
                onChanged: (_) {
                  calculateGrandTotal();
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 10.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
