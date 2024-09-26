import 'package:billingsphere/data/repository/purchase_repository.dart';
import 'package:billingsphere/views/GST_Report/GST_custom_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/models/purchase/purchase_model.dart';
import '../../data/models/salesEntries/sales_entrires_model.dart';
import '../../data/repository/sales_enteries_repository.dart';
import '../sumit_screen/voucher _entry.dart/voucher_list_widget.dart';
import 'GST_Summary_Pop-up_Purchase.dart';
import 'GST_Summary_Pop-up_Sale.dart';
import 'GST_Summary_Print.dart';

class GSTSummary extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;

  const GSTSummary({super.key, this.startDate, this.endDate});

  @override
  State<GSTSummary> createState() => _GSTSummaryState();
}

class SalesEntryWithEntries {
  final SalesEntry salesEntry;
  final List<Entry> entries;

  SalesEntryWithEntries({required this.salesEntry, required this.entries});
}

class GroupedEntrySales {
  final String taxRate;
  double totalNetAmount;
  double totalSgst;
  double totalCgst;
  final List<SalesEntryWithEntries> salesEntriesWithEntries;

  GroupedEntrySales({
    required this.taxRate,
    this.totalNetAmount = 0,
    this.totalSgst = 0,
    this.totalCgst = 0,
  }) : salesEntriesWithEntries = [];
}

List<GroupedEntrySales> groupSalesByTax(List<SalesEntry> sales) {
  Map<String, GroupedEntrySales> groupedData = {};

  for (var sale in sales) {
    for (var entry in sale.entries) {
      if (!groupedData.containsKey(entry.tax)) {
        groupedData[entry.tax] = GroupedEntrySales(taxRate: entry.tax);
      }
      groupedData[entry.tax]!.totalNetAmount += entry.netAmount;
      groupedData[entry.tax]!.totalSgst += entry.sgst;
      groupedData[entry.tax]!.totalCgst += entry.cgst;
      groupedData[entry.tax]!
          .salesEntriesWithEntries
          .add(SalesEntryWithEntries(salesEntry: sale, entries: [entry]));
    }
  }

  return groupedData.values.toList();
}

class PurchaseEntryWithEntries {
  final Purchase purchaseEntry;
  final List<PurchaseEntry> entriesP;

  PurchaseEntryWithEntries(
      {required this.purchaseEntry, required this.entriesP});
}

class GroupedEntryPurchase {
  final String taxRate;
  double totalNetAmount;
  double totalSgst;
  double totalCgst;
  final List<PurchaseEntryWithEntries> purchaseEntryWithEntries;

  GroupedEntryPurchase({
    required this.taxRate,
    this.totalNetAmount = 0,
    this.totalSgst = 0,
    this.totalCgst = 0,
  }) : purchaseEntryWithEntries = [];
}

List<GroupedEntryPurchase> groupPurchaseByTax(List<Purchase> purchases) {
  Map<String, GroupedEntryPurchase> groupedData = {};

  for (var purchase in purchases) {
    for (var entry in purchase.entries) {
      if (!groupedData.containsKey(entry.tax)) {
        groupedData[entry.tax] = GroupedEntryPurchase(taxRate: entry.tax);
      }
      groupedData[entry.tax]!.totalNetAmount += entry.netAmount;
      groupedData[entry.tax]!.totalSgst += entry.sgst;
      groupedData[entry.tax]!.totalCgst += entry.cgst;
      groupedData[entry.tax]!.purchaseEntryWithEntries.add(
          PurchaseEntryWithEntries(purchaseEntry: purchase, entriesP: [entry]));
    }
  }

  return groupedData.values.toList();
}

class _GSTSummaryState extends State<GSTSummary> {
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  List<SalesEntry> allSales = [];
  List<SalesEntry> filteredSales = [];
  List<Purchase> allPurchase = [];
  List<Purchase> filteredPurchase = [];
  double totalNetAmountS = 0;
  double totalSgstS = 0;
  double totalCgstS = 0;
  double totalGstS = 0;

  double totalNetAmountP = 0;
  double totalSgstP = 0;
  double totalCgstP = 0;
  double totalGstP = 0;

  double totalCgst = 0;
  double totalSgst = 0;
  double totalGst = 0;
  double finalTax = 0;

  SalesEntryService salesService = SalesEntryService();
  PurchaseServices purchaseService = PurchaseServices();
  @override
  void initState() {
    super.initState();
    fetchPurchase();
    fetchSales();
  }

  Future<void> fetchSales() async {
    try {
      final List<SalesEntry> sales = await salesService.fetchSalesEntries();

      setState(() {
        allSales = sales;
        filterSales();
      });
    } catch (error) {
      print('Error $error');
    }
  }

  void filterSales() {
    setState(() {
      filteredSales = allSales.where((sale) {
        DateTime saleDate = dateFormat.parse(sale.date);
        if (widget.startDate != null && saleDate.isBefore(widget.startDate!)) {
          return false;
        }
        if (widget.endDate != null && saleDate.isAfter(widget.endDate!)) {
          return false;
        }
        return true;
      }).toList();
      calculateTotalSales();
      calculateTotals();
    });
  }

  void calculateTotalSales() {
    totalNetAmountS = filteredSales.fold(
        0,
        (sum, sale) =>
            sum +
            sale.entries.fold(0, (subSum, entry) => subSum + entry.netAmount));
    totalSgstS = filteredSales.fold(
        0,
        (sum, sale) =>
            sum + sale.entries.fold(0, (subSum, entry) => subSum + entry.sgst));
    totalCgstS = filteredSales.fold(
        0,
        (sum, sale) =>
            sum + sale.entries.fold(0, (subSum, entry) => subSum + entry.cgst));

    totalGstS = totalCgstS + totalSgstS;
  }

  Future<void> fetchPurchase() async {
    try {
      final List<Purchase> purchase =
          await purchaseService.fetchPurchaseEntries();

      setState(() {
        allPurchase = purchase;
        filterPurchase();
      });
    } catch (error) {
      print('Error $error');
    }
  }

  void filterPurchase() {
    setState(() {
      filteredPurchase = allPurchase.where((purchase) {
        DateTime purchaseDate = dateFormat.parse(purchase.date);
        if (widget.startDate != null &&
            purchaseDate.isBefore(widget.startDate!)) {
          return false;
        }
        if (widget.endDate != null && purchaseDate.isAfter(widget.endDate!)) {
          return false;
        }
        return true;
      }).toList();
      calculateTotalsPurchase();
    });
  }

  void calculateTotalsPurchase() {
    totalNetAmountP = filteredPurchase.fold(
        0,
        (sum, purchase) =>
            sum +
            purchase.entries
                .fold(0, (subSum, entry) => subSum + entry.netAmount));
    totalSgstP = filteredPurchase.fold(
        0,
        (sum, purchase) =>
            sum +
            purchase.entries.fold(0, (subSum, entry) => subSum + entry.sgst));
    totalCgstP = filteredPurchase.fold(
        0,
        (sum, purchase) =>
            sum +
            purchase.entries.fold(0, (subSum, entry) => subSum + entry.cgst));
    totalGstP = totalCgstP + totalCgstP;
  }

  void calculateTotals() {
    totalCgst = totalCgstP - totalCgstS;
    totalSgst = totalSgstP - totalSgstS;
    totalGst = totalGstP - totalGstS;
    finalTax = totalCgst + totalSgst;
  }

  @override
  void didUpdateWidget(GSTSummary oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-filter sales if date range changes
    if (oldWidget.startDate != widget.startDate ||
        oldWidget.endDate != widget.endDate) {
      filterSales();
    }
  }

  List<SalesEntry> getSalesEntriesForTaxRate(
      List<SalesEntry> sales, String taxRate) {
    return sales
        .where((sale) => sale.entries.any((entry) => entry.tax == taxRate))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = const Color.fromARGB(255, 33, 65, 243);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GST Reports',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: textColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.07,
                        child: const Text(
                          'GST Summary',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.17,
                        child: Text(
                          'Date From ${widget.startDate != null ? dateFormat.format(widget.startDate!) : 'Not selected'} to ${widget.endDate != null ? dateFormat.format(widget.endDate!) : 'Not selected'}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 700,
                    decoration: BoxDecoration(border: Border.all()),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //Header
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Particulars",
                                  "Sales/Purchase",
                                  "CGST/IGST",
                                  "SGST",
                                  "Cess",
                                  "Return",
                                  "CGST/IGST",
                                  "SGST",
                                  "Cess",
                                  "Nett",
                                  "CGST/IGST",
                                  "SGST",
                                  "Cess"
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right
                                ],
                                colors: [
                                  Colors.deepPurple,
                                  Colors.deepPurple,
                                  Colors.deepPurple,
                                  Colors.deepPurple,
                                  Colors.deepPurple,
                                  Colors.deepPurple,
                                  Colors.deepPurple,
                                  Colors.deepPurple,
                                  Colors.deepPurple,
                                  Colors.deepPurple,
                                  Colors.deepPurple,
                                  Colors.deepPurple,
                                  Colors.deepPurple
                                ],
                                fontWeights: [
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800
                                ],
                              ),
                            ],
                          ),
                          //Input GST Local
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Input GST (Local)",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700
                                ],
                              ),
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                groupPurchaseByTax(filteredPurchase).length,
                            itemBuilder: (context, index) {
                              final entry =
                                  groupPurchaseByTax(filteredPurchase)[index];
                              final purchaseEntryWithEntries =
                                  entry.purchaseEntryWithEntries;
                              return InkWell(
                                onDoubleTap: () {
                                  openDialogPurchase(
                                      context, purchaseEntryWithEntries);
                                },
                                child: CustomTable(
                                  rows: [
                                    CustomTableRow(
                                      cellTexts: [
                                        "${entry.taxRate}% GST",
                                        ((entry.totalNetAmount)
                                            .toStringAsFixed(2)),
                                        ((entry.totalSgst).toStringAsFixed(2)),
                                        ((entry.totalCgst).toStringAsFixed(2)),
                                        "0",
                                        "0",
                                        "0",
                                        "0",
                                        "0",
                                        ((entry.totalNetAmount)
                                            .toStringAsFixed(2)),
                                        ((entry.totalSgst).toStringAsFixed(2)),
                                        ((entry.totalCgst).toStringAsFixed(2)),
                                        "0"
                                      ],
                                      alignments: [
                                        TextAlign.left,
                                        TextAlign.right,
                                        TextAlign.right,
                                        TextAlign.right,
                                        TextAlign.right,
                                        TextAlign.right,
                                        TextAlign.right,
                                        TextAlign.right,
                                        TextAlign.right,
                                        TextAlign.right,
                                        TextAlign.right,
                                        TextAlign.right,
                                        TextAlign.right
                                      ],
                                      colors: [
                                        Colors.black,
                                        Colors.black,
                                        Colors.black,
                                        Colors.black,
                                        Colors.black,
                                        Colors.black,
                                        Colors.black,
                                        Colors.black,
                                        Colors.black,
                                        Colors.black,
                                        Colors.black,
                                        Colors.black,
                                        Colors.black
                                      ],
                                      fontWeights: [
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ), // -----

                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "",
                                  "--------",
                                  "--------",
                                  "--------",
                                  "",
                                  "--------",
                                  "--------",
                                  "--------",
                                  "",
                                  "--------",
                                  "--------",
                                  "--------",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.center,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700
                                ],
                              ),
                            ],
                          ), //Blank Row
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal
                                ],
                              ),
                            ],
                          ), //Total Taxable
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Total Taxable",
                                  (totalNetAmountP.toStringAsFixed(2)),
                                  (totalSgstP.toStringAsFixed(2)),
                                  (totalCgstP.toStringAsFixed(2)),
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  (totalNetAmountP.toStringAsFixed(2)),
                                  (totalSgstP.toStringAsFixed(2)),
                                  (totalCgstP.toStringAsFixed(2)),
                                  "0"
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right
                                ],
                                colors: [
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor
                                ],
                                fontWeights: [
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700
                                ],
                              ),
                            ],
                          ), //Total Non Taxable
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Total Non Taxable",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0"
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right
                                ],
                                colors: [
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor
                                ],
                                fontWeights: [
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700
                                ],
                              ),
                            ],
                          ), //Total
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Total",
                                  (totalNetAmountP.toStringAsFixed(2)),
                                  (totalCgstP.toStringAsFixed(2)),
                                  (totalSgstP.toStringAsFixed(2)),
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  (totalNetAmountP.toStringAsFixed(2)),
                                  (totalCgstP.toStringAsFixed(2)),
                                  (totalSgstP.toStringAsFixed(2)),
                                  "0"
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right
                                ],
                                colors: [
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor
                                ],
                                fontWeights: [
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700
                                ],
                              ),
                            ],
                          ), // -----
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "",
                                  "--------",
                                  "--------",
                                  "--------",
                                  "",
                                  "--------",
                                  "--------",
                                  "--------",
                                  "",
                                  "--------",
                                  "--------",
                                  "--------",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.center,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700
                                ],
                              ),
                            ],
                          ), //Blank Row
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal
                                ],
                              ),
                            ],
                          ), //Output GST Local
                          //Output GST Local
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Output GST (Local)",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700
                                ],
                              ),
                            ],
                          ), // Sales Entry
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: groupSalesByTax(filteredSales).length,
                            itemBuilder: (context, index) {
                              final entry =
                                  groupSalesByTax(filteredSales)[index];
                              final salesEntriesWithEntries =
                                  entry.salesEntriesWithEntries;
                              return InkWell(
                                onDoubleTap: () {
                                  openDialogSales(
                                      context, salesEntriesWithEntries);
                                },
                                child: CustomTable(
                                  rows: [
                                    CustomTableRow(
                                      cellTexts: [
                                        "${entry.taxRate}% GST",
                                        ((entry.totalNetAmount)
                                            .toStringAsFixed(2)),
                                        ((entry.totalSgst).toStringAsFixed(2)),
                                        ((entry.totalCgst).toStringAsFixed(2)),
                                        "0",
                                        "0",
                                        "0",
                                        "0",
                                        "0",
                                        ((entry.totalNetAmount)
                                            .toStringAsFixed(2)),
                                        ((entry.totalSgst).toStringAsFixed(2)),
                                        ((entry.totalCgst).toStringAsFixed(2)),
                                        "0"
                                      ],
                                      alignments: [
                                        TextAlign.left,
                                        TextAlign.right,
                                        TextAlign.right,
                                        TextAlign.right,
                                        TextAlign.right,
                                        TextAlign.right,
                                        TextAlign.right,
                                        TextAlign.right,
                                        TextAlign.right,
                                        TextAlign.right,
                                        TextAlign.right,
                                        TextAlign.right,
                                        TextAlign.right
                                      ],
                                      colors: [
                                        Colors.black,
                                        Colors.black,
                                        Colors.black,
                                        Colors.black,
                                        Colors.black,
                                        Colors.black,
                                        Colors.black,
                                        Colors.black,
                                        Colors.black,
                                        Colors.black,
                                        Colors.black,
                                        Colors.black,
                                        Colors.black
                                      ],
                                      fontWeights: [
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal,
                                        FontWeight.normal
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ), // -----
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "",
                                  "--------",
                                  "--------",
                                  "--------",
                                  "",
                                  "--------",
                                  "--------",
                                  "--------",
                                  "",
                                  "--------",
                                  "--------",
                                  "--------",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.center,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700
                                ],
                              ),
                            ],
                          ), //Blank Row
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal
                                ],
                              ),
                            ],
                          ), //Total Taxable
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Total Taxable",
                                  (totalNetAmountS.toStringAsFixed(2)),
                                  (totalSgstS.toStringAsFixed(2)),
                                  (totalCgstS.toStringAsFixed(2)),
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  (totalNetAmountS.toStringAsFixed(2)),
                                  (totalSgstS.toStringAsFixed(2)),
                                  (totalCgstS.toStringAsFixed(2)),
                                  "0"
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right
                                ],
                                colors: [
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor
                                ],
                                fontWeights: [
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700
                                ],
                              ),
                            ],
                          ), //Total Non Taxable
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Total Non Taxable",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0"
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right
                                ],
                                colors: [
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor
                                ],
                                fontWeights: [
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700
                                ],
                              ),
                            ],
                          ), //Total
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Total",
                                  (totalNetAmountS.toStringAsFixed(2)),
                                  (totalSgstS.toStringAsFixed(2)),
                                  (totalCgstS.toStringAsFixed(2)),
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  (totalNetAmountS.toStringAsFixed(2)),
                                  (totalSgstS.toStringAsFixed(2)),
                                  (totalCgstS.toStringAsFixed(2)),
                                  "0"
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right
                                ],
                                colors: [
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor,
                                  textColor
                                ],
                                fontWeights: [
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700
                                ],
                              ),
                            ],
                          ), // -----
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "",
                                  "--------",
                                  "--------",
                                  "--------",
                                  "",
                                  "--------",
                                  "--------",
                                  "--------",
                                  "",
                                  "--------",
                                  "--------",
                                  "--------",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.center,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700
                                ],
                              ),
                            ],
                          ), //Blank Row
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal
                                ],
                              ),
                            ],
                          ), //Tax Calculation
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Tax Calculation",
                                  "CGST",
                                  "SGST",
                                  "IGST",
                                  "Cess",
                                  "Total",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700
                                ],
                              ),
                            ],
                          ),
                          // -----
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "",
                                  "--------",
                                  "--------",
                                  "--------",
                                  "--------",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.center,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700
                                ],
                              ),
                            ],
                          ),
                          //Opening Balance
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Opening Balance",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800
                                ],
                              ),
                            ],
                          ),
                          //Input Tax
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Input Tax",
                                  (totalCgstP.toStringAsFixed(2)),
                                  (totalSgstP.toStringAsFixed(2)),
                                  "0",
                                  "0",
                                  (totalGstP.toStringAsFixed(2)),
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal
                                ],
                              ),
                            ],
                          ),
                          //Output Tax
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Output Tax",
                                  (totalCgstS.toStringAsFixed(2)),
                                  (totalSgstS.toStringAsFixed(2)),
                                  "0",
                                  "0",
                                  (totalGstS.toStringAsFixed(2)),
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal
                                ],
                              ),
                            ],
                          ),
                          //Cross Adjusment
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Cross Adjument",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "0",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal
                                ],
                              ),
                            ],
                          ),
                          //Tax Payable
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Tax Payable",
                                  (totalCgst.toStringAsFixed(2)),
                                  (totalSgst.toStringAsFixed(2)),
                                  "0",
                                  "0",
                                  (totalGst.toStringAsFixed(2)),
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal
                                ],
                              ),
                            ],
                          ),
                          //ref.
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "",
                                  "Ref.",
                                  "Ref.",
                                  "Ref.",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal
                                ],
                              ),
                            ],
                          ),
                          //Blank Row
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal
                                ],
                              ),
                            ],
                          ),
                          //Blank Row
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal
                                ],
                              ),
                            ],
                          ),
                          //Final Tax Calculation
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Final Tax Calculation",
                                  "Tax Payable",
                                  "Payment",
                                  "Tax Payable",
                                  "",
                                  "Ledger Bal",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700
                                ],
                              ),
                            ],
                          ),
                          // -----
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "",
                                  "--------",
                                  "--------",
                                  "--------",
                                  "",
                                  "--------",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.center,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700
                                ],
                              ),
                            ],
                          ),
                          //Cgst
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "CGST",
                                  totalCgst.toStringAsFixed(2),
                                  "0.00",
                                  totalCgst.toStringAsFixed(2),
                                  "",
                                  totalCgst.toStringAsFixed(2),
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800
                                ],
                              ),
                            ],
                          ),
                          //Sgst
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "SGST",
                                  totalSgst.toStringAsFixed(2),
                                  "0.00",
                                  totalSgst.toStringAsFixed(2),
                                  "",
                                  totalSgst.toStringAsFixed(2),
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800
                                ],
                              ),
                            ],
                          ),
                          //IGST
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "IGST",
                                  "0.00",
                                  "0.00",
                                  "0.00",
                                  "",
                                  "0.00",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800
                                ],
                              ),
                            ],
                          ),
                          //Cess
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Cess",
                                  "0.00",
                                  "0.00",
                                  "0.00",
                                  "",
                                  "0.00",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800,
                                  FontWeight.w800
                                ],
                              ),
                            ],
                          ),
                          //Total
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Total",
                                  finalTax.toStringAsFixed(2),
                                  "0.00",
                                  finalTax.toStringAsFixed(2),
                                  "",
                                  finalTax.toStringAsFixed(2),
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700
                                ],
                              ),
                            ],
                          ),
                          //Blank Row
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal
                                ],
                              ),
                            ],
                          ),
                          //Compo/zero rate
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Compo/Zero Rate",
                                  "Inter",
                                  "Intra",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700
                                ],
                              ),
                            ],
                          ),
                          //purchase
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Purchase",
                                  "0",
                                  "0",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal
                                ],
                              ),
                            ],
                          ),
                          //Blank Row
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal,
                                  FontWeight.normal
                                ],
                              ),
                            ],
                          ),
                          //Net. Purchase
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Net. Purchase",
                                  totalNetAmountP.toStringAsFixed(2),
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700
                                ],
                              ),
                            ],
                          ),
                          //Net. Sales
                          CustomTable(
                            rows: [
                              CustomTableRow(
                                cellTexts: [
                                  "Net. Sales",
                                  totalNetAmountS.toStringAsFixed(2),
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  "",
                                  ""
                                ],
                                alignments: [
                                  TextAlign.left,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.right,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center,
                                  TextAlign.center
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black,
                                  Colors.black
                                ],
                                fontWeights: [
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700,
                                  FontWeight.w700
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      color: Colors.amber[100],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {},
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.025,
                              child: const Text(
                                'GST3B',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 8, 255),
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Color.fromARGB(255, 0, 8, 255),
                                  decorationThickness: 2,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {},
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                              child: const Text(
                                'Sales Regi.',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 8, 255),
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Color.fromARGB(255, 0, 8, 255),
                                  decorationThickness: 2,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {},
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                              child: const Text(
                                'Purch Regi.',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 8, 255),
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Color.fromARGB(255, 0, 8, 255),
                                  decorationThickness: 2,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {},
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.035,
                              child: const Text(
                                'HSNwise',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 8, 255),
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Color.fromARGB(255, 0, 8, 255),
                                  decorationThickness: 2,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {},
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.045,
                              child: const Text(
                                'GSTR1 Json',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 8, 255),
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Color.fromARGB(255, 0, 8, 255),
                                  decorationThickness: 2,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {},
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                              child: const Text(
                                'GSTR1 IFF',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 8, 255),
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Color.fromARGB(255, 0, 8, 255),
                                  decorationThickness: 2,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {},
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.045,
                              child: const Text(
                                'GSTR1 Excel',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 8, 255),
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Color.fromARGB(255, 0, 8, 255),
                                  decorationThickness: 2,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {},
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.055,
                              child: const Text(
                                'Sales/Ret Regi.',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 8, 255),
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Color.fromARGB(255, 0, 8, 255),
                                  decorationThickness: 2,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {},
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.055,
                              child: const Text(
                                'Purch/Ret Regi.',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 8, 255),
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Color.fromARGB(255, 0, 8, 255),
                                  decorationThickness: 2,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {},
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: const Text(
                                'Sales Comb. Regi.',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 8, 255),
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Color.fromARGB(255, 0, 8, 255),
                                  decorationThickness: 2,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {},
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: const Text(
                                'Purch Comb. Regi.',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 8, 255),
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Color.fromARGB(255, 0, 8, 255),
                                  decorationThickness: 2,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 0.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                height: 900,
                child: Shortcuts(
                  shortcuts: {
                    LogicalKeySet(LogicalKeyboardKey.f3):
                        const ActivateIntent(),
                    LogicalKeySet(LogicalKeyboardKey.f4):
                        const ActivateIntent(),
                  },
                  child: Focus(
                    autofocus: true,
                    onKey: (node, event) {
                      // ignore: deprecated_member_use
                      if (event is RawKeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.keyP) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => GSTSummaryPrint(
                              '',
                              startDate: widget.startDate,
                              endDate: widget.endDate,
                              groupedPurchases:
                                  groupPurchaseByTax(filteredPurchase),
                              groupedSales: groupSalesByTax(filteredSales),
                              totalNetAmountS: totalNetAmountS,
                              totalSgstS: totalSgstS,
                              totalCgstS: totalCgstS,
                              totalGstS: totalGstS,
                              totalNetAmountP: totalNetAmountP,
                              totalSgstP: totalSgstP,
                              totalCgstP: totalCgstP,
                              totalGstP: totalGstP,
                              totalCgst: totalCgst,
                              totalSgst: totalSgst,
                              totalGst: totalGst,
                              finalTax: finalTax,
                            ),
                          ),
                        );

                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.099,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CustomList(
                                Skey: "F2", name: "Report", onTap: () {}),
                            CustomList(
                                Skey: "P",
                                name: "Print",
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => GSTSummaryPrint(
                                        '',
                                        startDate: widget.startDate,
                                        endDate: widget.endDate,
                                        groupedPurchases: groupPurchaseByTax(
                                            filteredPurchase),
                                        groupedSales:
                                            groupSalesByTax(filteredSales),
                                        totalNetAmountS: totalNetAmountS,
                                        totalSgstS: totalSgstS,
                                        totalCgstS: totalCgstS,
                                        totalGstS: totalGstS,
                                        totalNetAmountP: totalNetAmountP,
                                        totalSgstP: totalSgstP,
                                        totalCgstP: totalCgstP,
                                        totalGstP: totalGstP,
                                        totalCgst: totalCgst,
                                        totalSgst: totalSgst,
                                        totalGst: totalGst,
                                        finalTax: finalTax,
                                      ),
                                    ),
                                  );
                                }),
                            CustomList(
                                Skey: "V", name: "AdvView", onTap: () {}),
                            CustomList(Skey: "", name: "", onTap: () {}),
                            CustomList(
                                Skey: "X", name: "Export-Excel", onTap: () {}),
                            CustomList(Skey: "", name: "", onTap: () {}),
                            CustomList(Skey: "", name: "", onTap: () {}),
                            CustomList(
                                Skey: "I", name: "Edit Item", onTap: () {}),
                            CustomList(Skey: "", name: "", onTap: () {}),
                            CustomList(Skey: "B", name: "3B XLS", onTap: () {}),
                            CustomList(Skey: "", name: "", onTap: () {}),
                            CustomList(Skey: "", name: "", onTap: () {}),
                            CustomList(Skey: "", name: "", onTap: () {}),
                            CustomList(
                                Skey: "G", name: "GSTReq Lett", onTap: () {}),
                            CustomList(Skey: "F3", name: "Find", onTap: () {}),
                            CustomList(
                                Skey: "F3", name: "Find Next", onTap: () {}),
                            CustomList(Skey: "", name: "", onTap: () {}),
                            CustomList(Skey: "", name: "", onTap: () {}),
                            CustomList(Skey: "", name: "", onTap: () {}),
                            CustomList(Skey: "", name: "", onTap: () {}),
                            CustomList(Skey: "", name: "", onTap: () {}),
                            CustomList(Skey: "", name: "", onTap: () {}),
                            CustomList(Skey: "", name: "", onTap: () {}),
                            CustomList(Skey: "", name: "", onTap: () {}),
                            CustomList(Skey: "", name: "", onTap: () {}),
                            CustomList(Skey: "", name: "", onTap: () {}),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openDialogSales(BuildContext context,
      List<SalesEntryWithEntries> salesEntriesWithEntries) {
    showDialog(
      context: context,
      builder: (context) {
        return GSTSummaryPopUpSales(
            salesEntriesWithEntries: salesEntriesWithEntries);
      },
    );
  }

  void openDialogPurchase(BuildContext context,
      List<PurchaseEntryWithEntries> purchaseEntriesWithEntries) {
    showDialog(
      context: context,
      builder: (context) {
        return GSTSummaryPopUpPurchase(
            purchaseEntriesWithEntries: purchaseEntriesWithEntries);
      },
    );
  }
}
