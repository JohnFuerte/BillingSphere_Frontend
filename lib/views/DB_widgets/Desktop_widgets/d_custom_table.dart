import 'package:billingsphere/data/models/payment/payment_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../data/models/ledger/ledger_model.dart';
import '../../../data/models/purchase/purchase_model.dart';
import '../../../data/models/salesEntries/sales_entrires_model.dart';

class DTable extends StatefulWidget {
  const DTable({
    super.key,
    required this.suggestionSales,
    required this.suggestionSalesCash,
    required this.suggestionPurchase,
    required this.suggestionPayment,
    required this.suggestionLedger,
    required this.suggestionLedgerCustomer,
  });

  final List<SalesEntry> suggestionSales;
  final List<SalesEntry> suggestionSalesCash;
  final List<Purchase> suggestionPurchase;
  final List<Payment> suggestionPayment;
  final List<Ledger> suggestionLedger;
  final List<Ledger> suggestionLedgerCustomer;

  @override
  State<DTable> createState() => _DTableState();
}

class _DTableState extends State<DTable> {
//fetch sales by date
  double calculateSalesByDate() {
    double totalAmount = 0;
    DateTime today = DateTime.now();
    int todayDay = today.day;
    int todayMonth = today.month;
    int todayYear = today.year;
    // print('Today\'s Date: $todayMonth/$todayDay/$todayYear');
    for (var entry in widget.suggestionSales) {
      // Parse entry date string into its components
      List<String> entryDateComponents = entry.date.split('/');
      int entryDay = int.parse(entryDateComponents[1]); // Adjusted index
      int entryMonth = int.parse(entryDateComponents[0]); // Adjusted index
      int entryYear = int.parse(entryDateComponents[2]);
      // print('Entry Date: $entryMonth/$entryDay/$entryYear');
      if (entryDay == todayDay &&
          entryMonth == todayMonth &&
          entryYear == todayYear) {
        totalAmount += double.parse(entry.totalamount);
      }
    }

    return totalAmount;
  }

  //fetch sales by month
  double calculateSalesByMonth() {
    double totalAmount = 0;
    DateTime today = DateTime.now();
    int currentMonth = today.month;
    int currentYear = today.year;
    for (var entry in widget.suggestionSales) {
      List<String> entryDateComponents = entry.date.split('/');
      int entryMonth = int.parse(entryDateComponents[0]);
      int entryYear = int.parse(entryDateComponents[2]);
      if (entryMonth == currentMonth && entryYear == currentYear) {
        totalAmount += double.parse(entry.totalamount);
      }
    }

    return totalAmount;
  }

  // Fetch sales by total amount
  double calculateSalesTotalAmount() {
    double totalAmount = 0;
    for (var entry in widget.suggestionSales) {
      totalAmount += double.parse(entry.totalamount);
    }
    return totalAmount;
  }

//----------------------------------FETCH SALES CASH START------------------------//
  double calculateSalesCashByDate() {
    double totalAmount = 0;
    DateTime today = DateTime.now();
    int todayDay = today.day;
    int todayMonth = today.month;
    int todayYear = today.year;
    // print('Today\'s Date: $todayMonth/$todayDay/$todayYear');
    for (var entry in widget.suggestionSalesCash) {
      // Parse entry date string into its components
      List<String> entryDateComponents = entry.date.split('/');
      int entryDay = int.parse(entryDateComponents[1]); // Adjusted index
      int entryMonth = int.parse(entryDateComponents[0]); // Adjusted index
      int entryYear = int.parse(entryDateComponents[2]);
      // print('Entry Date: $entryMonth/$entryDay/$entryYear');
      if (entryDay == todayDay &&
          entryMonth == todayMonth &&
          entryYear == todayYear) {
        totalAmount += double.parse(entry.totalamount);
      }
    }

    return totalAmount;
  }

  //fetch sales cash by month
  double calculateSalesCashByMonth() {
    double totalAmount = 0;
    DateTime today = DateTime.now();
    int currentMonth = today.month;
    int currentYear = today.year;
    for (var entry in widget.suggestionSalesCash) {
      List<String> entryDateComponents = entry.date.split('/');
      int entryMonth = int.parse(entryDateComponents[0]);
      int entryYear = int.parse(entryDateComponents[2]);
      if (entryMonth == currentMonth && entryYear == currentYear) {
        totalAmount += double.parse(entry.totalamount);
      }
    }

    return totalAmount;
  }

  // Fetch sales cash by total amount
  double calculateSalesCashTotalAmount() {
    double totalAmount = 0;
    for (var entry in widget.suggestionSalesCash) {
      totalAmount += double.parse(entry.totalamount);
    }
    return totalAmount;
  }

//----------------------------------FETCH SALES CASH END--------------------------//

//----------------------------------FETCH SALES END-------------------------------//

//----------------------------------FETCH PURCHASE START--------------------------//

  double calculatePurchaseByDate() {
    double totalAmount = 0;
    DateTime today = DateTime.now();
    int todayDay = today.day;
    int todayMonth = today.month;
    int todayYear = today.year;
    // print('Today\'s Date: $todayMonth/$todayDay/$todayYear');
    for (var entry in widget.suggestionPurchase) {
      // Parse entry date string into its components
      List<String> entryDateComponents = entry.date.split('/');
      int entryDay = int.parse(entryDateComponents[1]); // Adjusted index
      int entryMonth = int.parse(entryDateComponents[0]); // Adjusted index
      int entryYear = int.parse(entryDateComponents[2]);
      // print('Entry Date: $entryMonth/$entryDay/$entryYear');
      if (entryDay == todayDay &&
          entryMonth == todayMonth &&
          entryYear == todayYear) {
        totalAmount += double.parse(entry.totalamount);
      }
    }

    return totalAmount;
  }

  double calculatePurchaseTotalAmount() {
    double totalAmount = 0;
    for (var entry in widget.suggestionPurchase) {
      totalAmount += double.parse(entry.totalamount);
    }
    return totalAmount;
  }

  double calculatePurchaseByMonth() {
    double totalAmount = 0;
    DateTime today = DateTime.now();
    int currentMonth = today.month;
    int currentYear = today.year;
    for (var entry in widget.suggestionPurchase) {
      List<String> entryDateComponents = entry.date.split('/');
      int entryMonth = int.parse(entryDateComponents[0]);
      int entryYear = int.parse(entryDateComponents[2]);
      if (entryMonth == currentMonth && entryYear == currentYear) {
        totalAmount += double.parse(entry.totalamount);
      }
    }

    return totalAmount;
  }

  //----------------------------------FETCH PURCHASE END-------------------------------//
  //----------------------------------FETCH PAYMENT START------------------------------//

  double calculatePaymentByDate() {
    double totalAmount = 0;
    DateTime today = DateTime.now();
    int todayDay = today.day;
    int todayMonth = today.month;
    int todayYear = today.year;
    // print('Today\'s Date: $todayMonth/$todayDay/$todayYear');
    for (var entry in widget.suggestionPayment) {
      // Parse entry date string into its components
      List<String> entryDateComponents = entry.date.split('/');
      int entryDay = int.parse(entryDateComponents[1]); // Adjusted index
      int entryMonth = int.parse(entryDateComponents[0]); // Adjusted index
      int entryYear = int.parse(entryDateComponents[2]);
      // print('Entry Date: $entryMonth/$entryDay/$entryYear');
      if (entryDay == todayDay &&
          entryMonth == todayMonth &&
          entryYear == todayYear) {
        totalAmount += entry.totalamount;
      }
    }

    return totalAmount;
  }

  double calculatePaymentByMonth() {
    double totalAmount = 0;
    DateTime today = DateTime.now();
    int currentMonth = today.month;
    int currentYear = today.year;
    for (var entry in widget.suggestionPayment) {
      List<String> entryDateComponents = entry.date.split('/');
      int entryMonth = int.parse(entryDateComponents[0]);
      int entryYear = int.parse(entryDateComponents[2]);
      if (entryMonth == currentMonth && entryYear == currentYear) {
        totalAmount += entry.totalamount;
      }
    }

    return totalAmount;
  }

  double calculatePaymentTotalAmount() {
    double totalAmount = 0;
    for (var entry in widget.suggestionPayment) {
      totalAmount += entry.totalamount;
    }
    return totalAmount;
  }

  //----------------------------------FETCH PAYMENT END-------------------------------//
  //----------------------------------FETCH Ledger VENDOR START-----------------------//

  //fetch vendor balance by date
  double calculateVendorByDate() {
    double totalAmount = 0;
    DateTime today = DateTime.now();
    int todayDay = today.day;
    int todayMonth = today.month;
    int todayYear = today.year;
    // print('Today\'s Date: $todayMonth/$todayDay/$todayYear');
    for (var entry in widget.suggestionLedger) {
      // Parse entry date string into its components
      List<String> entryDateComponents = entry.date.split('/');
      int entryDay = int.parse(entryDateComponents[1]); // Adjusted index
      int entryMonth = int.parse(entryDateComponents[0]); // Adjusted index
      int entryYear = int.parse(entryDateComponents[2]);
      // print('Entry Date: $entryMonth/$entryDay/$entryYear');
      if (entryDay == todayDay &&
          entryMonth == todayMonth &&
          entryYear == todayYear) {
        totalAmount += double.parse(entry.openingBalance.toStringAsFixed(2));
      }
    }

    return totalAmount;
  }

  //fetch by month
  double calculateVendorByMonth() {
    double totalAmount = 0;
    DateTime today = DateTime.now();
    int currentMonth = today.month;
    int currentYear = today.year;
    for (var entry in widget.suggestionLedger) {
      List<String> entryDateComponents = entry.date.split('/');
      int entryMonth = int.parse(entryDateComponents[0]);
      int entryYear = int.parse(entryDateComponents[2]);
      if (entryMonth == currentMonth && entryYear == currentYear) {
        totalAmount += double.parse(entry.openingBalance.toStringAsFixed(2));
      }
    }

    return totalAmount;
  }

  // Fetch sales by total amount
  double calculateVendorTotalAmount() {
    double totalAmount = 0;
    for (var entry in widget.suggestionLedger) {
      totalAmount += double.parse(entry.openingBalance.toStringAsFixed(2));
    }
    return totalAmount;
  }

  //----------------------------------FETCH Ledger Customer START-----------------------------//
  //fetch vendor balance by date
  double calculateCustomerByDate() {
    double totalAmount = 0;
    DateTime today = DateTime.now();
    int todayDay = today.day;
    int todayMonth = today.month;
    int todayYear = today.year;
    // print('Today\'s Date: $todayMonth/$todayDay/$todayYear');
    for (var entry in widget.suggestionLedgerCustomer) {
      // Parse entry date string into its components
      List<String> entryDateComponents = entry.date.split('/');
      int entryDay = int.parse(entryDateComponents[1]); // Adjusted index
      int entryMonth = int.parse(entryDateComponents[0]); // Adjusted index
      int entryYear = int.parse(entryDateComponents[2]);
      // print('Entry Date: $entryMonth/$entryDay/$entryYear');
      if (entryDay == todayDay &&
          entryMonth == todayMonth &&
          entryYear == todayYear) {
        totalAmount += double.parse(entry.openingBalance.toStringAsFixed(2));
      }
    }

    return totalAmount;
  }

  //fetch by month
  double calculateCustomerByMonth() {
    double totalAmount = 0;
    DateTime today = DateTime.now();
    int currentMonth = today.month;
    int currentYear = today.year;
    for (var entry in widget.suggestionLedgerCustomer) {
      List<String> entryDateComponents = entry.date.split('/');
      int entryMonth = int.parse(entryDateComponents[0]);
      int entryYear = int.parse(entryDateComponents[2]);
      if (entryMonth == currentMonth && entryYear == currentYear) {
        totalAmount += double.parse(entry.openingBalance.toStringAsFixed(2));
      }
    }

    return totalAmount;
  }

  // Fetch ledger customer by total amount
  double calculateCustomerTotalAmount() {
    double totalAmount = 0;
    for (var entry in widget.suggestionLedgerCustomer) {
      totalAmount += double.parse(entry.openingBalance.toStringAsFixed(2));
    }
    return totalAmount;
  }

  //----------------------------------FETCH Ledger Customer END-------------------------------//
  //----------------------------------FETCH Ledger VENDOR END---------------------------------//

  @override
  void initState() {
    print(widget.suggestionLedger);
    print(widget.suggestionPayment);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          padding: const EdgeInsets.all(0.0),
          child: Container(
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '  DASH BOARD (${DateFormat('MM/dd/yyyy').format(DateTime.now())})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 253, 253, 253),
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1.0),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Refresh',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 250,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Table(
              border: TableBorder.all(
                color: Colors.black,
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: const BoxDecoration(),
                  children: [
                    const TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'Description ',
                          style: TextStyle(
                            color: Color.fromARGB(255, 5, 5, 112),
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          DateFormat('d-MMM').format(DateTime.now()),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 5, 5, 112),
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          DateFormat('MMM-yy').format(DateTime.now()),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 5, 5, 112),
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '24-25 (Lacs)',
                          style: TextStyle(
                            color: Color.fromARGB(255, 5, 5, 112),
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
                // for (String item in items)
                TableRow(
                  children: [
                    const TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'SALES',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          calculateSalesByDate().toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          calculateSalesByMonth().toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          calculateSalesTotalAmount().toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'PURCHASE',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          calculatePurchaseByDate().toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          calculatePurchaseByMonth().toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          calculatePurchaseTotalAmount().toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'RECEIPT',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'PAYMENT',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          calculatePaymentByDate().toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          calculatePaymentByMonth().toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          calculatePaymentTotalAmount().toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'EXPENSE',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),

                TableRow(
                  children: [
                    const TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'CASH BALANCE',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          calculateSalesCashByDate().toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          calculateSalesCashByMonth().toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          calculateSalesCashTotalAmount().toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),

                const TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'STOCK VALUE',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'CUSTOMER BALANCE',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          calculateCustomerByDate().toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          calculateCustomerByMonth().toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          calculateCustomerTotalAmount().toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'VENDOR BALANCE',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          calculateVendorByDate().toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          calculateVendorByMonth().toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          calculateVendorTotalAmount().toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Table Contents
      ],
    );
  }
}

class ShimmerDashboard extends StatelessWidget {
  const ShimmerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          padding: const EdgeInsets.all(0.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              color: Colors.blue,
              height: 40.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: screenWidth * 0.5,
                    color: Colors.grey,
                    alignment: Alignment.center,
                    child: const Text(
                      '  DASH BOARD',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: 100.0,
                    height: 40.0,
                    color: Colors.grey,
                    alignment: Alignment.center,
                    child: const Text(
                      'Refresh',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 250,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Table(
              border: TableBorder.all(
                color: Colors.black,
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: const BoxDecoration(),
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 30.0,
                        color: Colors.grey,
                        alignment: Alignment.center,
                        child: const Text(
                          'Description ',
                          style: TextStyle(
                            color: Color.fromARGB(255, 5, 5, 112),
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 30.0,
                        color: Colors.grey,
                        alignment: Alignment.center,
                        child: const Text(
                          'Date',
                          style: TextStyle(
                            color: Color.fromARGB(255, 5, 5, 112),
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 30.0,
                        color: Colors.grey,
                        alignment: Alignment.center,
                        child: const Text(
                          'Month',
                          style: TextStyle(
                            color: Color.fromARGB(255, 5, 5, 112),
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 30.0,
                        color: Colors.grey,
                        alignment: Alignment.center,
                        child: const Text(
                          'Amount',
                          style: TextStyle(
                            color: Color.fromARGB(255, 5, 5, 112),
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
                // Simulate multiple rows with shimmer
                for (int i = 0; i < 8; i++)
                  TableRow(
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 30.0,
                          color: Colors.grey,
                          alignment: Alignment.center,
                          child: const Text(
                            '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 30.0,
                          color: Colors.grey,
                          alignment: Alignment.center,
                          child: const Text(
                            '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 30.0,
                          color: Colors.grey,
                          alignment: Alignment.center,
                          child: const Text(
                            '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 30.0,
                          color: Colors.grey,
                          alignment: Alignment.center,
                          child: const Text(
                            '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
