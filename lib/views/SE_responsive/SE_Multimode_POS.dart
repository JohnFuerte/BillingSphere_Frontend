import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class PopUp2 extends StatefulWidget {
  final Widget listWidget;
  final double totalAmount;
  final VoidCallback onSaveData;
  final Map<String, dynamic> multimodeDetails;

  PopUp2({
    super.key,
    required this.totalAmount,
    required this.listWidget,
    required this.onSaveData,
    required this.multimodeDetails,
  });

  @override
  State<PopUp2> createState() => _PopUp2State();
}

class _PopUp2State extends State<PopUp2> {
  final TextEditingController _controller = TextEditingController();

  final TextEditingController _controllercash =
      TextEditingController(text: '0');

  final TextEditingController _controllerupi = TextEditingController();

  final TextEditingController _controllercheque = TextEditingController();

  final TextEditingController _controllercardPaymentamount =
      TextEditingController();

  final TextEditingController _controllerpending =
      TextEditingController(text: '0');

  final TextEditingController _controllertotal =
      TextEditingController(text: '0');

  double? defaultValue;

  bool? isCashEditable;
  bool? isUpiEditable;
  bool? isCardEditable;
  bool? isChequeEditable;

  void setEditableValues() {
    isCashEditable = widget.totalAmount != 0.0 ? true : false;
    isUpiEditable = widget.totalAmount != 0.0 ? true : false;
    isCardEditable = widget.totalAmount != 0.0 ? true : false;
    isChequeEditable = widget.totalAmount != 0.0 ? true : false;
  }

  @override
  void initState() {
    _controllertotal.text = widget.totalAmount.toString();
    _controllerpending.text = widget.totalAmount.toString();
    setEditableValues();
    super.initState();
  }

  void saveMultiModeValues() {
    double cashValue = double.tryParse(_controllercash.text) ?? 0.0;
    double debitValue = double.tryParse(_controllerupi.text) ?? 0.0;
    double cardPaymentamountValue =
        double.tryParse(_controllercardPaymentamount.text) ?? 0.0;
    double chequeValue = double.tryParse(_controllercheque.text) ?? 0.0;
    double cashPending = double.tryParse(_controllerpending.text) ?? 0.0;
    double cashFinalAmount = double.tryParse(_controllertotal.text) ?? 0.0;

    widget.multimodeDetails['cash'] = cashValue;
    widget.multimodeDetails['upi'] = debitValue;
    widget.multimodeDetails['cardPayment'] = cardPaymentamountValue;
    widget.multimodeDetails['cheque'] = chequeValue;
    widget.multimodeDetails['pendingAmount'] = cashPending;
    widget.multimodeDetails['finalAmount'] = cashFinalAmount;

    print(widget.multimodeDetails);
  }

  // void grandtotal() {
  //   double grandtotal = 0.0;

  //   grandtotal += double.tryParse(_controllercash.text) ?? 0.0;
  //   grandtotal += double.tryParse(_controllerupi.text) ?? 0.0;
  //   grandtotal -= double.tryParse(_controllercardPaymentamount.text) ?? 0.0;
  //   grandtotal += double.tryParse(_controllercheque.text) ?? 0.0;

  //   _controllertotal.text = grandtotal.toStringAsFixed(2);
  // }

  void voidpending() {
    // Get all payment values
    double cashValue = double.tryParse(_controllercash.text) ?? 0.0;
    double upiValue = double.tryParse(_controllerupi.text) ?? 0.0;
    double cardPaymentamountValue =
        double.tryParse(_controllercardPaymentamount.text) ?? 0.0;
    double chequeValue = double.tryParse(_controllercheque.text) ?? 0.0;

    // Calculate pending amount
    double pendingAmount = widget.totalAmount -
        (cashValue + upiValue + cardPaymentamountValue + chequeValue);

    _controllerpending.text = pendingAmount.toStringAsFixed(2);
    // Clamp the pendinjg amount so that it doesn't go below 0 using clamp method
    _controllerpending.text = double.parse(_controllerpending.text)
        .clamp(0.0, widget.totalAmount)
        .toStringAsFixed(2);

    print("Pending Amount: ${_controllerpending.text}");
  }

  bool isValueLessThanPendingAmount(double value) {
    double pendingAmount = double.tryParse(_controllerpending.text) ?? 0.0;

    return value <= pendingAmount;
  }

  void handleTextFieldAction({
    required TextEditingController pendingController,
    required TextEditingController upiController,
    required TextEditingController cardPaymentController,
    required TextEditingController chequeController,
    required TextEditingController cashController,
    required TextEditingController currentController,
    required VoidCallback voidPendingAction,
    required VoidCallback saveMultiModeValues,
    required double totalAmount,
    required ValueChanged<bool> onUpiEditableChanged,
    required ValueChanged<bool> onCardEditableChanged,
    required ValueChanged<bool> onChequeEditableChanged,
  }) {
    // Delay for 1 sec
    Future.delayed(const Duration(seconds: 2));
    if (double.tryParse(pendingController.text) != null &&
        double.parse(pendingController.text) > 0) {
      voidPendingAction();
      saveMultiModeValues();
    } else {
      // Check all controllers that are empty
      if (upiController.text.isEmpty) {
        onUpiEditableChanged(false);
      }
      if (cardPaymentController.text.isEmpty) {
        onCardEditableChanged(false);
      }
      if (chequeController.text.isEmpty) {
        onChequeEditableChanged(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4169E1),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Multiple Payment Receipt Details',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 246, 246, 246),
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Total Amount To Receive",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      20.widthBox,
                      Expanded(
                        child: TextFormField(
                          cursorColor: Colors.black,
                          readOnly: true,
                          controller: _controller
                            ..text = widget.totalAmount.toString(),
                          textDirection: TextDirection.rtl,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.poppins(
                              fontSize: 15.5, fontWeight: FontWeight.bold),
                          onChanged: (value) {
                            print("Total Amount changed: $value");
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 2.0,
                              horizontal: 10.0,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                        ).h(25),
                      ),
                    ],
                  ).pOnly(right: 30, left: 5).h(60),
                  const Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25,
                        width: 220,
                        child: Text(
                          "Payment Type",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      1.widthBox,
                      Expanded(
                        child: SizedBox(
                          height: 25,
                          width: 200,
                          child: Text(
                            "Amount",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ).pOnly(right: 30),
                      ),
                    ],
                  ).pOnly(left: 5),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CurrencyRow(
                                  heading: "Cash",
                                  isTrue: false,
                                  inputController: _controllercash,
                                  onAmountChanged: (newValue) {
                                    setState(() {
                                      _controllercash.text =
                                          newValue.toString();
                                    });

                                    voidpending();
                                    saveMultiModeValues();
                                  },
                                  isEditable: isCashEditable,
                                )
                              ],
                            ).pOnly(right: 30, top: 2),
                            Row(
                              children: [
                                CurrencyRow(
                                  heading: "UPI",
                                  isTrue: false,
                                  inputController: _controllerupi,
                                  onAmountChanged: (newValue) {
                                    setState(() {
                                      _controllerupi.text = newValue.toString();
                                    });

                                    voidpending();
                                    saveMultiModeValues();
                                  },
                                  isEditable: isUpiEditable,
                                )
                              ],
                            ).pOnly(right: 30, top: 2),
                            Row(
                              children: [
                                CurrencyRow(
                                  heading: "CARD PAYMENT ",
                                  isTrue: false,
                                  inputController: _controllercardPaymentamount,
                                  onAmountChanged: (newValue) {
                                    setState(() {
                                      _controllercardPaymentamount.text =
                                          newValue.toString();
                                    });

                                    voidpending();
                                    saveMultiModeValues();
                                  },
                                  isEditable: isCardEditable,
                                )
                              ],
                            ).pOnly(right: 30, top: 2),
                            Row(
                              children: [
                                CurrencyRow(
                                  heading: "CHEQUE ",
                                  isTrue: false,
                                  inputController: _controllercheque,
                                  onAmountChanged: (newValue) {
                                    setState(() {
                                      _controllercheque.text =
                                          newValue.toString();
                                    });
                                    voidpending();
                                    saveMultiModeValues();
                                  },
                                  isEditable: isChequeEditable,
                                )
                              ],
                            ).pOnly(right: 30, top: 2),
                          ],
                        ),
                      ),
                    ).pOnly(right: 30, left: 5),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),

                      // Pending Amount Text Field
                      Row(
                        children: [
                          SizedBox(
                            height: 25,
                            width: 200,
                            child: Text(
                              "Pending",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          1.widthBox,
                          Expanded(
                            child: SizedBox(
                              width: 65,
                              height: 25,
                              child: TextFormField(
                                readOnly: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                controller: _controllerpending,
                                cursorColor: Colors.black,
                                textDirection: TextDirection.rtl,
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.poppins(
                                    fontSize: 16, fontWeight: FontWeight.bold),
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
                      ).pOnly(right: 30, top: 2),
                      const SizedBox(
                        height: 10,
                      ),

                      // Total Amount Text Field
                      Row(
                        children: [
                          SizedBox(
                            height: 25,
                            width: 200,
                            child: Text(
                              "Total Amount",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          1.widthBox,
                          Expanded(
                            child: SizedBox(
                              width: 65,
                              height: 25,
                              child: TextFormField(
                                readOnly: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                controller: _controllertotal,
                                cursorColor: Colors.black,
                                textDirection: TextDirection.rtl,
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.poppins(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                onChanged: (value) {
                                  print("object..........$value");
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
                      ).pOnly(right: 30, top: 2),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              color: const Color.fromARGB(255, 250, 237, 126),
                            ),
                            child: InkWell(
                              onTap: () {
                                if (_controllerpending.text != defaultValue) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Error!',
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        content: Text(
                                          'Receipt Amount do not match with Bill Amount.',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return;
                                } else {
                                  widget.onSaveData();
                                }
                              },
                              child: Center(
                                child: Text(
                                  "Save[F4]",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          3.widthBox,
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              color: const Color.fromARGB(255, 250, 237, 126),
                            ),
                            height: 30,
                            width: 150,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Center(
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ).pOnly(right: 30),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ).pOnly(left: 5),
                ],
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 246, 246, 246),
            width: 300,
            height: double.infinity,
            padding: const EdgeInsets.only(top: 20, bottom: 50),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                color: Colors.white,
              ),
              padding: EdgeInsets.zero,
              // child: listWidget,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 145,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Text(
                          'Group Sales',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ).p2(),
                      ),
                      Container(
                        width: 145,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Text(
                          'Amount',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                          textAlign: TextAlign.end,
                        ).p2(),
                      ),
                    ],
                  ),
                  widget.listWidget,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CurrencyRow extends StatelessWidget {
  final String heading;
  final bool isTrue;
  final TextEditingController inputController;
  final Function(double) onAmountChanged;
  final bool? isEditable;

  const CurrencyRow({
    super.key,
    required this.heading,
    required this.isTrue,
    required this.inputController,
    required this.onAmountChanged,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            height: 25,
            width: 200,
            decoration:
                isTrue ? null : BoxDecoration(border: Border.all(width: 1)),
            child: Text(heading,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
          ),
          1.widthBox,
          Expanded(
            child: SizedBox(
              width: 65,
              height: 25,
              child: TextFormField(
                readOnly: !isEditable!,
                controller: inputController,
                cursorColor: Colors.black,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.end,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d+\.?\d{0,2}'),
                  ),
                ],
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                onEditingComplete: () {
                  final double newValue =
                      double.tryParse(inputController.text) ?? 0.0;

                  onAmountChanged(newValue);
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
