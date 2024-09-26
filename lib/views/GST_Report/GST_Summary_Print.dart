import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user/user_group_model.dart';
import '../../data/repository/user_group_repository.dart';
import 'GST_Summary.dart';

class GSTSummaryPrint extends StatefulWidget {
  final String title;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<GroupedEntryPurchase> groupedPurchases;
  final List<GroupedEntrySales> groupedSales;
  final double totalNetAmountS;
  final double totalSgstS;
  final double totalCgstS;
  final double totalGstS;
  final double totalNetAmountP;
  final double totalSgstP;
  final double totalCgstP;
  final double totalGstP;
  final double totalCgst;
  final double totalSgst;
  final double totalGst;
  final double finalTax;

  const GSTSummaryPrint(
    this.title, {
    super.key,
    this.startDate,
    this.endDate,
    required this.groupedPurchases,
    required this.groupedSales,
    required this.totalNetAmountS,
    required this.totalSgstS,
    required this.totalCgstS,
    required this.totalGstS,
    required this.totalNetAmountP,
    required this.totalSgstP,
    required this.totalCgstP,
    required this.totalGstP,
    required this.totalCgst,
    required this.totalSgst,
    required this.totalGst,
    required this.finalTax,
  });

  @override
  State<GSTSummaryPrint> createState() => _GSTSummaryPrintState();
}

class _GSTSummaryPrintState extends State<GSTSummaryPrint> {
  late SharedPreferences _prefs;
  late String formattedStartDate;
  late String formattedEndDate;
  late List<GroupedEntryPurchase> groupedPurchases;
  late List<GroupedEntrySales> groupedSales;

  bool isLoading = false;
  String? fullName = '';
  UserGroupServices userGroupServices = UserGroupServices();
  List<UserGroup> userGroupM = [];

  @override
  void initState() {
    super.initState();
    groupedPurchases = widget.groupedPurchases;
    groupedSales = widget.groupedSales;

    initialize();
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    formattedStartDate =
        widget.startDate != null ? dateFormat.format(widget.startDate!) : 'N/A';
    formattedEndDate =
        widget.endDate != null ? dateFormat.format(widget.endDate!) : 'N/A';
  }

  Future<void> fetchUserGroup() async {
    final List<UserGroup> userGroupFetch =
        await userGroupServices.getUserGroups();

    setState(() {
      userGroupM = userGroupFetch;
    });
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> initialize() async {
    setState(() {
      isLoading = true;
    });
    await Future.wait([
      _initPrefs().then((value) => {
            fullName = _prefs.getString('fullName'),
          }),
      fetchUserGroup().then((value) => {}),
    ]);
    setState(() {
      isLoading = false;
    });
  }

  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isLoading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(widget.title),
                centerTitle: true,
              ),
              body: PdfPreview(
                build: (format) => _generatePdf(format, widget.title),
              ),
            ),
      debugShowCheckedModeBanner:
          false, // Set to false to hide the debug banner
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final customFormat = PdfPageFormat.a4.copyWith(
      marginLeft: 20,
      marginRight: 20,
      marginTop: 20,
      marginBottom: 20,
    );
    const columnWidths = {
      0: pw.FlexColumnWidth(4),
      1: pw.FlexColumnWidth(3),
      2: pw.FlexColumnWidth(2),
      3: pw.FlexColumnWidth(2),
      4: pw.FlexColumnWidth(2),
      5: pw.FlexColumnWidth(2),
      6: pw.FlexColumnWidth(2),
      7: pw.FlexColumnWidth(2),
      8: pw.FlexColumnWidth(2),
      9: pw.FlexColumnWidth(2),
      10: pw.FlexColumnWidth(2),
      11: pw.FlexColumnWidth(2),
    };

    pdf.addPage(
      pw.Page(
        pageFormat: customFormat,
        build: (context) {
          return pw.Column(
            children: [
              pw.Container(
                width: customFormat.availableWidth,
                child: pw.Text(
                  '$fullName: $formattedDate $formattedTime',
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.normal,
                  ),
                  textAlign: pw.TextAlign.left,
                ),
              ),
              pw.Container(
                width: customFormat.availableWidth,
                // alignment: pw.Alignment.center,
                child: pw.Text(
                  'General',
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Divider(),
              pw.Container(
                width: customFormat.availableWidth,
                child: pw.Text(
                  'GST Summary Report | $formattedStartDate to $formattedEndDate',
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Table(
                columnWidths: columnWidths,
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      _buildTableCell("Particular",
                          isHeader: true, textAlign: pw.TextAlign.left),
                      _buildTableCell("Sal/Purc Amt",
                          isHeader: true, textAlign: pw.TextAlign.left),
                      _buildTableCell("C/I.GST", isHeader: true),
                      _buildTableCell("SGST", isHeader: true),
                      _buildTableCell("Cess", isHeader: true),
                      _buildTableCell("Ret.Amt",
                          isHeader: true, textAlign: pw.TextAlign.left),
                      _buildTableCell("C/I.GST", isHeader: true),
                      _buildTableCell("SGST", isHeader: true),
                      _buildTableCell("Cess", isHeader: true),
                      _buildTableCell("Net.Amt",
                          isHeader: true, textAlign: pw.TextAlign.left),
                      _buildTableCell("C/I.GST", isHeader: true),
                      _buildTableCell("SGST", isHeader: true),
                      _buildTableCell("Cess", isHeader: true),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("Input GST (Local)",
                          isHeader: true, textAlign: pw.TextAlign.left),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                    ],
                  ),
                  ...groupedPurchases.map((entry) {
                    return pw.TableRow(
                      children: [
                        _buildTableCell("${entry.taxRate}% GST",
                            textAlign: pw.TextAlign.left),
                        _buildTableCell(entry.totalNetAmount.toStringAsFixed(2),
                            textAlign: pw.TextAlign.right),
                        _buildTableCell(entry.totalSgst.toStringAsFixed(2),
                            textAlign: pw.TextAlign.right),
                        _buildTableCell(entry.totalCgst.toStringAsFixed(2),
                            textAlign: pw.TextAlign.right),
                        _buildTableCell("0", textAlign: pw.TextAlign.right),
                        _buildTableCell("0", textAlign: pw.TextAlign.right),
                        _buildTableCell("0", textAlign: pw.TextAlign.right),
                        _buildTableCell("0", textAlign: pw.TextAlign.right),
                        _buildTableCell("0", textAlign: pw.TextAlign.right),
                        _buildTableCell(entry.totalNetAmount.toStringAsFixed(2),
                            textAlign: pw.TextAlign.right),
                        _buildTableCell(entry.totalSgst.toStringAsFixed(2),
                            textAlign: pw.TextAlign.right),
                        _buildTableCell(entry.totalCgst.toStringAsFixed(2),
                            textAlign: pw.TextAlign.right),
                        _buildTableCell(
                          "0",
                        ),
                      ],
                    );
                  }),
                  pw.TableRow(
                    children: [
                      _buildTableCell("Total Taxable",
                          isHeader: true, textAlign: pw.TextAlign.left),
                      _buildTableCell(widget.totalNetAmountP.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalSgstP.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalCgstP.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalNetAmountP.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalSgstP.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalCgstP.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("Total Non Taxable",
                          isHeader: true, textAlign: pw.TextAlign.left),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("Total",
                          isHeader: true, textAlign: pw.TextAlign.left),
                      _buildTableCell(widget.totalNetAmountP.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalSgstP.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalCgstP.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalNetAmountP.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalSgstP.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalCgstP.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("Output GST (Local)",
                          isHeader: true, textAlign: pw.TextAlign.left),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                    ],
                  ),
                  ...groupedSales.map((entry) {
                    return pw.TableRow(
                      children: [
                        _buildTableCell("${entry.taxRate}% GST",
                            textAlign: pw.TextAlign.left),
                        _buildTableCell(entry.totalNetAmount.toStringAsFixed(2),
                            textAlign: pw.TextAlign.right),
                        _buildTableCell(entry.totalSgst.toStringAsFixed(2),
                            textAlign: pw.TextAlign.right),
                        _buildTableCell(entry.totalCgst.toStringAsFixed(2),
                            textAlign: pw.TextAlign.right),
                        _buildTableCell("0", textAlign: pw.TextAlign.right),
                        _buildTableCell("0", textAlign: pw.TextAlign.right),
                        _buildTableCell("0", textAlign: pw.TextAlign.right),
                        _buildTableCell("0", textAlign: pw.TextAlign.right),
                        _buildTableCell("0", textAlign: pw.TextAlign.right),
                        _buildTableCell(entry.totalNetAmount.toStringAsFixed(2),
                            textAlign: pw.TextAlign.right),
                        _buildTableCell(entry.totalSgst.toStringAsFixed(2),
                            textAlign: pw.TextAlign.right),
                        _buildTableCell(entry.totalCgst.toStringAsFixed(2),
                            textAlign: pw.TextAlign.right),
                        _buildTableCell(
                          "0",
                        ),
                      ],
                    );
                  }),
                  pw.TableRow(
                    children: [
                      _buildTableCell("Total Taxable",
                          isHeader: true, textAlign: pw.TextAlign.left),
                      _buildTableCell(widget.totalNetAmountS.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalSgstS.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalCgstS.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalNetAmountS.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalSgstS.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalCgstS.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("Total Non Taxable",
                          isHeader: true, textAlign: pw.TextAlign.left),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0",
                          isHeader: true, textAlign: pw.TextAlign.right),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("Total",
                          isHeader: true, textAlign: pw.TextAlign.left),
                      _buildTableCell(widget.totalNetAmountS.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalSgstS.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalCgstS.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalNetAmountS.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalSgstS.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalCgstS.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("0.00",
                          isHeader: true, textAlign: pw.TextAlign.right),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("Tax Calculation",
                          isHeader: true, textAlign: pw.TextAlign.left),
                      _buildTableCell("CGST",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("SGST",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("IGST",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("Cess",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("Total",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("", isHeader: true),
                      _buildTableCell("", isHeader: true),
                      _buildTableCell("", isHeader: true),
                      _buildTableCell("",
                          isHeader: true, textAlign: pw.TextAlign.left),
                      _buildTableCell("", isHeader: true),
                      _buildTableCell("", isHeader: true),
                      _buildTableCell("", isHeader: true),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("Opening Balance",
                          textAlign: pw.TextAlign.left),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("Input Tax",
                          textAlign: pw.TextAlign.left),
                      _buildTableCell(widget.totalCgstP.toStringAsFixed(2),
                          textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalSgstP.toStringAsFixed(2),
                          textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalGstP.toStringAsFixed(2),
                          textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("Output Tax",
                          textAlign: pw.TextAlign.left),
                      _buildTableCell(widget.totalCgstS.toStringAsFixed(2),
                          textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalSgstS.toStringAsFixed(2),
                          textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalGstS.toStringAsFixed(2),
                          textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("Cross Adjustment",
                          textAlign: pw.TextAlign.left),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("Tax Payable",
                          textAlign: pw.TextAlign.left),
                      _buildTableCell(widget.totalCgst.toStringAsFixed(2),
                          textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalSgst.toStringAsFixed(2),
                          textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalGst.toStringAsFixed(2),
                          textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("", textAlign: pw.TextAlign.left),
                      _buildTableCell("Ref.", textAlign: pw.TextAlign.right),
                      _buildTableCell("Ref.", textAlign: pw.TextAlign.right),
                      _buildTableCell("Ref.", textAlign: pw.TextAlign.right),
                      _buildTableCell("", textAlign: pw.TextAlign.right),
                      _buildTableCell("", textAlign: pw.TextAlign.right),
                      _buildTableCell("", textAlign: pw.TextAlign.right),
                      _buildTableCell("", textAlign: pw.TextAlign.right),
                      _buildTableCell("", textAlign: pw.TextAlign.right),
                      _buildTableCell("", textAlign: pw.TextAlign.right),
                      _buildTableCell("", textAlign: pw.TextAlign.right),
                      _buildTableCell("", textAlign: pw.TextAlign.right),
                      _buildTableCell("", textAlign: pw.TextAlign.right),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("Final Tax Calculation",
                          isHeader: true, textAlign: pw.TextAlign.left),
                      _buildTableCell("Tax Payable",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("Payment",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("Tax Payable",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("Led. Bal",
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell("", isHeader: true),
                      _buildTableCell("", isHeader: true),
                      _buildTableCell("", isHeader: true),
                      _buildTableCell("",
                          isHeader: true, textAlign: pw.TextAlign.left),
                      _buildTableCell("", isHeader: true),
                      _buildTableCell("", isHeader: true),
                      _buildTableCell("", isHeader: true),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("CGST", textAlign: pw.TextAlign.left),
                      _buildTableCell(widget.totalCgst.toStringAsFixed(2),
                          textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalCgst.toStringAsFixed(2),
                          textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalCgst.toStringAsFixed(2),
                          textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("SGST", textAlign: pw.TextAlign.left),
                      _buildTableCell(widget.totalSgst.toStringAsFixed(2),
                          textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalSgst.toStringAsFixed(2),
                          textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.totalSgst.toStringAsFixed(2),
                          textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("IGST", textAlign: pw.TextAlign.left),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("Cess", textAlign: pw.TextAlign.left),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("Total",
                          textAlign: pw.TextAlign.left, isHeader: true),
                      _buildTableCell(widget.finalTax.toStringAsFixed(2),
                          textAlign: pw.TextAlign.right, isHeader: true),
                      _buildTableCell("0",
                          textAlign: pw.TextAlign.right, isHeader: true),
                      _buildTableCell(widget.finalTax.toStringAsFixed(2),
                          textAlign: pw.TextAlign.right, isHeader: true),
                      _buildTableCell("", textAlign: pw.TextAlign.right),
                      _buildTableCell(widget.finalTax.toStringAsFixed(2),
                          textAlign: pw.TextAlign.right, isHeader: true),
                      _buildTableCell("", textAlign: pw.TextAlign.right),
                      _buildTableCell("", textAlign: pw.TextAlign.right),
                      _buildTableCell("", textAlign: pw.TextAlign.right),
                      _buildTableCell("", textAlign: pw.TextAlign.right),
                      _buildTableCell("", textAlign: pw.TextAlign.right),
                      _buildTableCell("", textAlign: pw.TextAlign.right),
                      _buildTableCell("", textAlign: pw.TextAlign.right),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("Compo/Zero Rate",
                          isHeader: true, textAlign: pw.TextAlign.left),
                      _buildTableCell("Inter", textAlign: pw.TextAlign.right),
                      _buildTableCell("Intra", textAlign: pw.TextAlign.right),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("Purchase", textAlign: pw.TextAlign.left),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell("0", textAlign: pw.TextAlign.right),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("Net. Purchase",
                          isHeader: true, textAlign: pw.TextAlign.left),
                      _buildTableCell(widget.totalNetAmountP.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildTableCell("Net. Sales",
                          isHeader: true, textAlign: pw.TextAlign.left),
                      _buildTableCell(widget.totalNetAmountS.toStringAsFixed(2),
                          isHeader: true, textAlign: pw.TextAlign.right),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                      _buildTableCell(""),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildTableCell(String text,
      {pw.TextAlign textAlign = pw.TextAlign.center, bool isHeader = false}) {
    return pw.Container(
      height: 13,
      // alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.all(2),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: textAlign,
      ),
    );
  }
}
