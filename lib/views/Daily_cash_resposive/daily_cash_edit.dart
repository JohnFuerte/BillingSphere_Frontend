import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../data/models/dailyCash/daily_cash_model.dart';
import '../../data/repository/daily_cash_repository.dart';
import '../SE_common/SE_form_buttons.dart';
import 'daily_cash_master.dart';
import 'daily_cash_receipt.dart';

class DailyCashEdit extends StatefulWidget {
  final dailyID;
  const DailyCashEdit({super.key, required this.dailyID});

  @override
  State<DailyCashEdit> createState() => _DailyCashEditState();
}

class _DailyCashEditState extends State<DailyCashEdit> {
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
  DailyCashEntry? _dailyCashEntry;
  var _id;
  Future<void> _fetchDailyCash() async {
    try {
      DailyCashEntry? dailyCashEntry =
          await DailyCashServices().fetchDailyCashById(widget.dailyID);
      print(dailyCashEntry);
      if (dailyCashEntry != null) {
        setState(() {
          _dailyCashEntry = dailyCashEntry;
          _id = _dailyCashEntry!.id;
          _dateController1.text = _dailyCashEntry!.date;
          _description.text = _dailyCashEntry!.description;
          _cashier.text = _dailyCashEntry!.cashier;
          _dateController1.text = _dailyCashEntry!.date;
          if (_dailyCashEntry!.twoThousand != null &&
              _dailyCashEntry!.twoThousand!.isNotEmpty) {
            _controllerInput2000.text =
                _dailyCashEntry!.twoThousand!.first.qty.toString();
            _controllerResult2000.text =
                _dailyCashEntry!.twoThousand!.first.total.toString();
          } else {
            _controllerInput2000.text = '';
            _controllerResult2000.text = '';
          }
          _dailyCashEntry!.twoThousand!.first.total.toString();
          if (_dailyCashEntry!.fiveHundred != null &&
              _dailyCashEntry!.fiveHundred!.isNotEmpty) {
            _controllerInput500.text =
                _dailyCashEntry!.fiveHundred!.first.qty.toString();
            _controllerResult500.text =
                _dailyCashEntry!.fiveHundred!.first.total.toString();
          } else {
            _controllerInput500.text = '';
            _controllerResult500.text = '';
          }

          if (_dailyCashEntry!.twoHundred != null &&
              _dailyCashEntry!.twoHundred!.isNotEmpty) {
            _controllerInput200.text =
                _dailyCashEntry!.twoHundred!.first.qty.toString();
            _controllerResult200.text =
                _dailyCashEntry!.twoHundred!.first.total.toString();
          } else {
            _controllerInput200.text = '';
            _controllerResult200.text = '';
          }

          if (_dailyCashEntry!.oneHundred != null &&
              _dailyCashEntry!.oneHundred!.isNotEmpty) {
            _controllerInput100.text =
                _dailyCashEntry!.oneHundred!.first.qty.toString();
            _controllerResult100.text =
                _dailyCashEntry!.oneHundred!.first.total.toString();
          } else {
            _controllerInput100.text = '';
            _controllerResult100.text = '';
          }

          if (_dailyCashEntry!.fifty != null &&
              _dailyCashEntry!.fifty!.isNotEmpty) {
            _controllerInput50.text =
                _dailyCashEntry!.fifty!.first.qty.toString();
            _controllerResult50.text =
                _dailyCashEntry!.fifty!.first.total.toString();
          } else {
            _controllerInput50.text = '';
            _controllerResult50.text = '';
          }

          if (_dailyCashEntry!.twenty != null &&
              _dailyCashEntry!.twenty!.isNotEmpty) {
            _controllerInput20.text =
                _dailyCashEntry!.twenty!.first.qty.toString();
            _controllerResult20.text =
                _dailyCashEntry!.twenty!.first.total.toString();
          } else {
            _controllerInput20.text = '';
            _controllerResult20.text = '';
          }

          if (_dailyCashEntry!.ten != null &&
              _dailyCashEntry!.ten!.isNotEmpty) {
            _controllerInput10.text =
                _dailyCashEntry!.ten!.first.qty.toString();
            _controllerResult10.text =
                _dailyCashEntry!.ten!.first.total.toString();
          } else {
            _controllerInput10.text = '';
            _controllerResult10.text = '';
          }

          if (_dailyCashEntry!.coins != null &&
              _dailyCashEntry!.coins!.isNotEmpty) {
            _controllerInputCoins.text =
                _dailyCashEntry!.coins!.first.qty.toString();
            _controllerResultCoins.text =
                _dailyCashEntry!.coins!.first.total.toString();
          } else {
            _controllerInputCoins.text = '';
            _controllerResultCoins.text = '';
          }

          _controllerDenom.text = _dailyCashEntry!.actualcash.toString();
          _controllerAsPerBook.text = _dailyCashEntry!.systemcash.toString();
          _controllerShort.text = _dailyCashEntry!.excesscash.toString();
        });
      } else {
        // Handle case where entry is not found
      }
    } catch (e) {
      // Handle error
      print('Error fetching daily cash entry: $e');
    }
  }

  Future<void> updateDailyCashEntry() async {
    try {
      DailyCashEntry updateDailyCashEntry = DailyCashEntry(
        id: _id,
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
        systemcash: double.parse(_controllerAsPerBook.text),
        excesscash: double.parse(_controllerShort.text),
      );
      DailyCashServices dailyCashServices = DailyCashServices();
      await dailyCashServices.updateDailyCashEntry(
          updateDailyCashEntry, context);
      Fluttertoast.showToast(
        msg: "Daily cash entry updated successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const DailyCashMaster(),
        ),
      );
    } catch (e) {
      print('Error updating daily cash entry: $e');
      Fluttertoast.showToast(
        msg: "Failed to update daily cash entry",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDailyCash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: Text(
            'EDIT Daily Cash Record',
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
                height: 600,
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
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => DailyCashReceipt(
                                      dailyCashID: widget.dailyID,
                                      title: 'Print Daily Cash Receipt',
                                    ),
                                  ),
                                );
                              },
                              buttonText: 'Print',
                            )
                          ],
                        ),
                        20.widthBox,
                        Column(
                          children: [
                            SEFormButton(
                              // width: MediaQuery.of(context).size.width * 0.05,
                              height: 40,
                              onPressed: updateDailyCashEntry,
                              buttonText: 'Update [F4]',
                            )
                          ],
                        ),
                        10.widthBox,
                        Column(
                          children: [
                            SEFormButton(
                              // width: MediaQuery.of(context).size.width * 0.05,
                              height: 40,
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DailyCashMaster(),
                                  ),
                                );
                              },
                              buttonText: 'Cancel',
                            )
                          ],
                        ),
                        10.widthBox,
                        Column(
                          children: [
                            SEFormButton(
                              // width: MediaQuery.of(context).size.width * 0.05,
                              height: 40,
                              onPressed: () {
                                showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: const Text('Delete'),
                                      content: const Text(
                                          'Are you sure you want to delete this entry?'),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: const Text('Yes'),
                                          onPressed: () {
                                            DailyCashServices
                                                dailyCashServices =
                                                DailyCashServices();

                                            dailyCashServices
                                                .deleteDailyCash(
                                                    widget.dailyID, context)
                                                .then((value) => {
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const DailyCashMaster(),
                                                        ),
                                                      )
                                                    });
                                          },
                                        ),
                                        CupertinoDialogAction(
                                          child: const Text('No',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              buttonText: 'Delete',
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
