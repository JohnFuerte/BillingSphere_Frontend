import 'package:flutter/material.dart';
import 'package:billingsphere/data/models/salesEntries/sales_entrires_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/ledger/ledger_model.dart';
import '../../data/repository/sales_enteries_repository.dart';
import '../SL_widgets/SL_D_side_buttons.dart';
import 'RA_D_Receipt_Popup.dart';
import 'RA_D_table_text.dart';
import 'RA_D_table_text_2.dart';

class MyTable extends StatefulWidget {
  const MyTable({
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
    this.startDateLG,
    this.endDateLG,
    required this.payableType,
    this.myLedgers,
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
  State<MyTable> createState() => _MyTableState();
}

class _MyTableState extends State<MyTable> {
  late List<bool> _isCheckedList;
  late List<double> _dueAmountList;
  bool isLoading = false;
  double totalAmount = 0;
  double dueAmount = 0;
  List<SalesEntry> filteredSalesEntry = [];
  List<SalesEntry> filteredSales = [];

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

  List<SalesEntry> sales = [];

  SalesEntryService salesServices = SalesEntryService();

  Future<void> getSales() async {
    setState(() {
      isLoading = true;
    });

    final sale = await salesServices.getSales();

    if (widget.id != null) {
      List<SalesEntry> filteredSales = [];

      if (widget.payableType == 0) {
        filteredSales = sale.where((sale) {
          if ((widget.startDateLG == null || widget.endDateLG == null) &&
                  sale.party == widget.id &&
                  sale.type == 'DEBIT' ||
              sale.type == 'MULTI MODE' && sale.dueAmount != '0') {
            return true;
          } else if (widget.startDateLG != null &&
              widget.endDateLG != null &&
              sale.party == widget.id &&
              sale.type == 'DEBIT' &&
              sale.dueAmount != '0') {
            final entryDate = DateFormat('dd/MM/yyyy').parse(sale.date);
            return entryDate.isAfter(widget.startDateLG!) &&
                entryDate.isBefore(widget.endDateLG!);
          }
          return false;
        }).toList();
      } else {
        filteredSales = sale.where((salesentry) {
          if ((widget.startDateL == null || widget.endDateL == null) &&
                  salesentry.party == widget.id &&
                  salesentry.type == 'DEBIT' ||
              salesentry.type == 'MULTI MODE' && salesentry.dueAmount != '0') {
            return true;
          } else if (widget.startDateL != null &&
              widget.endDateL != null &&
              salesentry.party == widget.id &&
              salesentry.type == 'DEBIT' &&
              salesentry.dueAmount != '0') {
            final entryDate = DateFormat('dd/MM/yyyy').parse(salesentry.date);
            return entryDate.isAfter(widget.startDateL!) &&
                entryDate.isBefore(widget.endDateL!);
          }
          return false;
        }).toList();
      }

      setState(() {
        sales = filteredSales;
        _isCheckedList = List.generate(sales.length, (index) => false);
        _dueAmountList = List.generate(sales.length, (index) => 0);
        isLoading = false;
      });
    } else {
      setState(() {
        sales = sale;
        _isCheckedList = List.generate(sales.length, (index) => false);
        _dueAmountList = List.generate(sales.length, (index) => 0);
        isLoading = false;
      });
    }

    for (var i = 0; i < sales.length; i++) {
      setState(() {
        totalAmount += double.parse(sales[i].totalamount ?? '0');
        dueAmount += double.parse(sales[i].dueAmount ?? '0');
      });
    }

    widget.updateTotalAmount(totalAmount);
    widget.updateDueAmount(dueAmount);

    print('Purchase: $sales');
    print('Filtered Purchase: $filteredSales');
  }

  @override
  void didUpdateWidget(covariant MyTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if paidAmount has changed
    if (widget.paidAmount != oldWidget.paidAmount) {
      // Call your function here
      onPaidAmountChanged();
    }
  }

  void onPaidAmountChanged() {
    double remainingAmount = widget.paidAmount;
    for (var i = 0; i < sales.length; i++) {
      if (remainingAmount > double.parse(sales[i].dueAmount)) {
        setState(() {
          remainingAmount -= double.parse(sales[i].dueAmount);
          _dueAmountList[i] = double.parse(sales[i].dueAmount);
          _isCheckedList[i] = true;

          data[sales[i].id] = {
            'id': sales[i].id,
            'billNumber': sales[i].dcNo,
            'ledger': sales[i].party,
            'date': sales[i].date2,
            'invoiceGST': sales[i].no.toString(),
            'dueAmount': _dueAmountList[i].toString(),
            'totalAmount':
                double.parse(sales[i].totalamount).toStringAsFixed(2),
            'paidAmount': widget.paidAmount,
            'adjustmentAmount': _dueAmountList[i].toStringAsFixed(2),
            'pendingAmount':
                (double.parse(sales[i].dueAmount) - _dueAmountList[i])
                    .toString(),
          };
          // sales[i].dueAmount = '0';
        });
      } else if (remainingAmount != 0.00) {
        setState(() {
          _dueAmountList[i] =
              (double.parse(sales[i].dueAmount) - remainingAmount);
          // sales[i].dueAmount =
          //     (double.parse(sales[i].dueAmount) - remainingAmount).toString();

          _dueAmountList[i] = remainingAmount;
          _isCheckedList[i] = true;

          remainingAmount = 0;

          data[sales[i].id] = {
            'id': sales[i].id,
            'billNumber': sales[i].dcNo,
            'ledger': sales[i].party,
            'date': sales[i].date2,
            'invoiceGST': sales[i].no.toString(),
            'dueAmount': _dueAmountList[i].toString(),
            'totalAmount':
                double.parse(sales[i].totalamount).toStringAsFixed(2),
            'paidAmount': widget.paidAmount,
            'adjustmentAmount': _dueAmountList[i].toStringAsFixed(2),
            'pendingAmount':
                (double.parse(sales[i].dueAmount) - _dueAmountList[i])
                    .toString(),
          };
        });
      }
    }
  }

  void _initializeData() async {
    await setId();
    await getSales();
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
        : sales.isEmpty
            ? Center(
                child: Text('No pending bills for ${widget.ledgerName}'),
              )
            : Column(
                children: [
                  // First row
                  Container(
                    color: Colors.grey[300],
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        MyTableText1(
                            text: sales.map((e) => e.dueAmount!).reduce((value,
                                    element) =>
                                (double.parse(value) + double.parse(element))
                                    .toStringAsFixed(2))),
                        MyTableText1(
                            text: sales.map((e) => e.totalamount).reduce((value,
                                    element) =>
                                (double.parse(value) + double.parse(element))
                                    .toStringAsFixed(2))),
                        const MyTableText1(text: ''),
                        const MyTableText1(text: ''),
                        const MyTableText1(text: ''),
                        const MyTableText1(text: '0'),
                      ],
                    ),
                  ),
                  // Second row
                  for (var i = 0; i < sales.length; i++)
                    Container(
                      color: Colors.grey[300],
                      child: Row(
                        children: [
                          MyTableText2(
                            text: sales[i].date,
                            textAlign: TextAlign.center,
                          ),
                          const MyTableText2(
                            text: 'Invoice GST',
                            textAlign: TextAlign.start,
                          ),
                          MyTableText2(
                            text: sales[i].no.toString(),
                            textAlign: TextAlign.center,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white)),
                              padding: const EdgeInsets.all(2.0),
                              child: Transform.scale(
                                scale: 0.5, // Adjust the scale factor as needed
                                child: Checkbox(
                                  value: _isCheckedList[i],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isCheckedList[i] = value ?? false;
                                    });
                                    if (value == true) {
                                      // Checkbox is checked, add data to the map

                                      _dueAmountList[i] =
                                          double.parse(sales[i].dueAmount!);

                                      data[sales[i].id] = {
                                        'id': sales[i].id,
                                        'billNumber': sales[i].dcNo,
                                        'ledger': sales[i].party,
                                        'date': sales[i].date2,
                                        'invoiceGST': sales[i].no.toString(),
                                        'dueAmount':
                                            _dueAmountList[i].toString(),
                                        'totalAmount':
                                            double.parse(sales[i].totalamount)
                                                .toStringAsFixed(2),
                                        'paidAmount': widget.paidAmount,
                                        'adjustmentAmount': _dueAmountList[i]
                                            .toStringAsFixed(2),
                                        'pendingAmount':
                                            (double.parse(sales[i].dueAmount!) -
                                                    _dueAmountList[i])
                                                .toString(),
                                      };
                                    } else {
                                      data.remove(sales[i].id);
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
                            text: double.parse(sales[i].dueAmount!)
                                .toStringAsFixed(2),
                            textAlign: TextAlign.end,
                          ),
                          MyTableText2(
                            text: double.parse(sales[i].totalamount)
                                .toStringAsFixed(2),
                            textAlign: TextAlign.end,
                          ),
                          MyTableText2(
                            text: sales[i].type,
                            textAlign: TextAlign.center,
                          ),
                          MyTableText2(
                            text: sales[i].date2,
                            textAlign: TextAlign.center,
                          ),
                          MyTableText2(
                            text: daysBetween(
                                    parseDate(sales[i].date), DateTime.now())
                                .toString(),
                            textAlign: TextAlign.center,
                          ),
                          MyTableText2(
                            text: double.parse(sales[i].dueAmount!)
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
      builder: (context) => ReceiptPopUpFormRA(
        data: data,
        id: widget.id!,
      ),
    );
  }
}
