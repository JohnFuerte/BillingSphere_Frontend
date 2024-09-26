import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/ledger/ledger_model.dart';
import '../data/models/purchase/purchase_model.dart';
import '../data/repository/purchase_repository.dart';
import 'PA_D_Payment_Popup.dart';
import '../views/RA_widgets/RA_D_table_text.dart';
import '../views/RA_widgets/RA_D_table_text_2.dart';
import '../views/SL_widgets/SL_D_side_buttons.dart';

class MyTable2 extends StatefulWidget {
  const MyTable2({
    super.key,
    required this.ledgerName,
    required this.ledgerLocation,
    required this.ledgerMobile,
    required this.id,
    required this.updateTotalAmount,
    required this.updateDueAmount,
    required this.paidAmount,
    this.startDateL,
    this.endDateL,
    required this.payableType,
    this.myLedgers,
    this.startDateLG,
    this.endDateLG,
  });

  final String ledgerName;
  final String ledgerLocation;
  final String? ledgerMobile;
  final String? id;
  final void Function(double) updateTotalAmount;
  final void Function(double) updateDueAmount;
  final double paidAmount;
  final DateTime? startDateL;
  final DateTime? endDateL;
  final DateTime? startDateLG;
  final DateTime? endDateLG;
  final int payableType;
  final List<Ledger>? myLedgers;

  @override
  State<MyTable2> createState() => _MyTableState();
}

class _MyTableState extends State<MyTable2> {
  late List<bool> _isCheckedList;
  late List<double> _dueAmountList;
  bool isLoading = false;
  double totalAmount = 0;
  double dueAmount = 0;
  List<Purchase> filteredSalesEntry = [];
  List<Purchase> filteredPurchase = [];

  Map<String, dynamic> data = {};

  String? user_id;
  Future<String?> getUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> setId() async {
    String? id = await getUID();
    setState(() {
      user_id = id;
    });
  }

  List<Purchase> purchase = [];

  PurchaseServices purchaseServices = PurchaseServices();

  Future<void> getPurchase() async {
    setState(() {
      isLoading = true;
    });

    final purchases = await purchaseServices.getPurchase();

    if (widget.id != null) {
      List<Purchase> filteredPurchase = [];

      if (widget.payableType == 0) {
        filteredPurchase = purchases.where((purchase) {
          if ((widget.startDateLG == null || widget.endDateLG == null) &&
              purchase.ledger == widget.id &&
              purchase.type == 'Debit' &&
              purchase.dueAmount != '0') {
            return true;
          } else if (widget.startDateLG != null &&
              widget.endDateLG != null &&
              purchase.ledger == widget.id &&
              purchase.type == 'Debit' &&
              purchase.dueAmount != '0') {
            final entryDate = DateFormat('dd/MM/yyyy').parse(purchase.date);
            return entryDate.isAfter(widget.startDateLG!) &&
                entryDate.isBefore(widget.endDateLG!);
          }
          return false;
        }).toList();
      } else {
        filteredPurchase = purchases.where((purchaseentry) {
          if ((widget.startDateL == null || widget.endDateL == null) &&
              purchaseentry.ledger == widget.id &&
              purchaseentry.type == 'Debit' &&
              purchaseentry.dueAmount != '0') {
            return true;
          } else if (widget.startDateL != null &&
              widget.endDateL != null &&
              purchaseentry.ledger == widget.id &&
              purchaseentry.type == 'Debit' &&
              purchaseentry.dueAmount != '0') {
            final entryDate =
                DateFormat('dd/MM/yyyy').parse(purchaseentry.date);
            return entryDate.isAfter(widget.startDateL!) &&
                entryDate.isBefore(widget.endDateL!);
          }
          return false;
        }).toList();
      }

      setState(() {
        purchase = filteredPurchase;
        _isCheckedList = List.generate(purchase.length, (index) => false);
        _dueAmountList = List.generate(purchase.length, (index) => 0);
        isLoading = false;
      });
    } else {
      setState(() {
        purchase = purchases;
        _isCheckedList = List.generate(purchase.length, (index) => false);
        _dueAmountList = List.generate(purchase.length, (index) => 0);
        isLoading = false;
      });
    }

    for (var i = 0; i < purchase.length; i++) {
      setState(() {
        totalAmount += double.parse(purchase[i].totalamount ?? '0');
        dueAmount += double.parse(purchase[i].dueAmount ?? '0');
      });
    }

    widget.updateTotalAmount(totalAmount);
    widget.updateDueAmount(dueAmount);

    print('Purchase: $purchase');
    print('Filtered Purchase: $filteredPurchase');
  }

  @override
  void didUpdateWidget(covariant MyTable2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if paidAmount has changed
    if (widget.paidAmount != oldWidget.paidAmount) {
      // Call your function here
      onPaidAmountChanged();
    }
  }

  void onPaidAmountChanged() {
    double remainingAmount = widget.paidAmount;
    for (var i = 0; i < purchase.length; i++) {
      if (remainingAmount > double.parse(purchase[i].dueAmount!)) {
        setState(() {
          remainingAmount -= double.parse(purchase[i].dueAmount!);
          _dueAmountList[i] = double.parse(purchase[i].dueAmount!);
          _isCheckedList[i] = true;

          data[purchase[i].id] = {
            'id': purchase[i].id,
            'billNumber': purchase[i].billNumber,
            'ledger': purchase[i].ledger,
            'date': purchase[i].date2,
            'invoiceGST': purchase[i].no.toString(),
            'dueAmount': _dueAmountList[i].toString(),
            'totalAmount':
                double.parse(purchase[i].totalamount).toStringAsFixed(2),
            'paidAmount': widget.paidAmount,
            'adjustmentAmount': _dueAmountList[i].toStringAsFixed(2),
            'pendingAmount':
                (double.parse(purchase[i].dueAmount!) - _dueAmountList[i])
                    .toString(),
          };
          // sales[i].dueAmount = '0';
        });
      } else if (remainingAmount != 0.00) {
        setState(() {
          _dueAmountList[i] =
              (double.parse(purchase[i].dueAmount!) - remainingAmount);
          // sales[i].dueAmount =
          //     (double.parse(sales[i].dueAmount) - remainingAmount).toString();

          _dueAmountList[i] = remainingAmount;
          _isCheckedList[i] = true;

          remainingAmount = 0;

          data[purchase[i].id] = {
            'id': purchase[i].id,
            'billNumber': purchase[i].billNumber,
            'ledger': purchase[i].ledger,
            'date': purchase[i].date2,
            'invoiceGST': purchase[i].no.toString(),
            'dueAmount': _dueAmountList[i].toString(),
            'totalAmount':
                double.parse(purchase[i].totalamount).toStringAsFixed(2),
            'paidAmount': widget.paidAmount,
            'adjustmentAmount': _dueAmountList[i].toStringAsFixed(2),
            'pendingAmount':
                (double.parse(purchase[i].dueAmount!) - _dueAmountList[i])
                    .toString(),
          };
        });
      }
    }
  }

  void _initializeData() async {
    await setId();
    await getPurchase();
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Text('')
        : purchase.isEmpty
            ? Center(
                child: Text('No pending bills for ${widget.ledgerName}'),
              )
            : Column(
                children: [
                  // First row
                  Container(
                    color: Colors.grey[200],
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white)),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.ledgerName} | ${widget.ledgerLocation} | M:${widget.ledgerMobile}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        MyTableText1(
                            text: purchase.isNotEmpty
                                ? purchase.map((e) => e.dueAmount!).reduce(
                                    (value, element) => (double.parse(value) +
                                            double.parse(element))
                                        .toStringAsFixed(2))
                                : '0.00'),
                        // Default value if sales is empty
                        MyTableText1(
                            text: purchase.isNotEmpty
                                ? purchase.map((e) => e.totalamount).reduce(
                                    (value, element) => (double.parse(value) +
                                            double.parse(element))
                                        .toStringAsFixed(2))
                                : '0.00'),
                        const MyTableText1(text: ''),
                        const MyTableText1(text: ''),
                        const MyTableText1(text: ''),
                        const MyTableText1(text: '0'),
                      ],
                    ),
                  ),
                  // Second row
                  for (var i = 0; i < purchase.length; i++)
                    Container(
                      color: Colors.grey[200],
                      child: Row(
                        children: [
                          MyTableText2(
                            text: purchase[i].date,
                            textAlign: TextAlign.center,
                          ),
                          const MyTableText2(
                            text: 'Invoice GST',
                            textAlign: TextAlign.start,
                          ),
                          MyTableText2(
                            text: purchase[i].no.toString(),
                            textAlign: TextAlign.center,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white)),
                              padding: const EdgeInsets.all(2.0),
                              child: Transform.scale(
                                scale: 0.8, // Adjust the scale factor as needed
                                child: Checkbox(
                                  value: _isCheckedList[i],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isCheckedList[i] = value ?? false;
                                    });

                                    if (value == true) {
                                      // Checkbox is checked, add data to the map

                                      _dueAmountList[i] =
                                          double.parse(purchase[i].dueAmount!);

                                      data[purchase[i].id] = {
                                        'id': purchase[i].id,
                                        'billNumber': purchase[i].billNumber,
                                        'ledger': purchase[i].ledger,
                                        'date': purchase[i].date2,
                                        'invoiceGST': purchase[i].no.toString(),
                                        'dueAmount':
                                            _dueAmountList[i].toString(),
                                        'totalAmount': double.parse(
                                                purchase[i].totalamount)
                                            .toStringAsFixed(2),
                                        'paidAmount': widget.paidAmount,
                                        'adjustmentAmount': _dueAmountList[i]
                                            .toStringAsFixed(2),
                                        'pendingAmount': (double.parse(
                                                    purchase[i].dueAmount!) -
                                                _dueAmountList[i])
                                            .toString(),
                                      };
                                    } else {
                                      data.remove(purchase[i].id);
                                      _dueAmountList[i] = 0.00;
                                    }
                                  },
                                  activeColor:
                                      const Color.fromARGB(255, 33, 44, 243),
                                ),
                              ),
                            ),
                          ),
                          MyTableText2(
                            text: _dueAmountList[i].toStringAsFixed(2),
                            textAlign: TextAlign.end,
                          ),
                          MyTableText2(
                            text: double.parse(purchase[i].dueAmount!)
                                .toStringAsFixed(2),
                            textAlign: TextAlign.end,
                          ),
                          MyTableText2(
                            text: double.parse(purchase[i].totalamount)
                                .toStringAsFixed(2),
                            textAlign: TextAlign.end,
                          ),
                          MyTableText2(
                            text: purchase[i].type,
                            textAlign: TextAlign.center,
                          ),
                          MyTableText2(
                            text: purchase[i].date2,
                            textAlign: TextAlign.center,
                          ),
                          MyTableText2(
                            text: daysBetween(
                                    parseDate(purchase[i].date), DateTime.now())
                                .toString(),
                            textAlign: TextAlign.center,
                          ),
                          MyTableText2(
                            text: double.parse(purchase[i].dueAmount!)
                                .toStringAsFixed(2),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 10),
                  data.isEmpty
                      ? const Text('')
                      : SLDSideBUtton(
                          onTapped: () {
                            openDialog1(context);
                          },
                          text: 'Make Receipt',
                        ),
                ],
              );
  }

  DateTime parseDate(String dateStr) {
    return DateFormat('dd/MM/yyyy').parse(dateStr);
  }

  int daysBetween(DateTime from, DateTime to) {
    return to.difference(from).inDays;
  }

  void openDialog1(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PaymentPopUpFormPA(
        data: data,
        id: widget.id!,
      ),
    );
  }
}
