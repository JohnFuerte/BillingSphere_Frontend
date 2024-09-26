import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/dailyCash/daily_cash_model.dart';
import '../../data/models/newCompany/new_company_model.dart';
import '../../data/repository/daily_cash_repository.dart';
import '../../data/repository/new_company_repository.dart';

class DailyCashReceipt extends StatefulWidget {
  const DailyCashReceipt(
      {super.key, required this.dailyCashID, required this.title});
  final String dailyCashID;

  final String title;

  @override
  State<DailyCashReceipt> createState() => _DailyCashReceiptState();
}

class _DailyCashReceiptState extends State<DailyCashReceipt> {
  bool isLoading = false;
  List<NewCompany> selectedComapny = [];
  NewCompanyRepository newCompanyRepo = NewCompanyRepository();

  List<String>? companyCode;
  Future<List<String>?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('companies');
  }

  Future<void> setCompanyCode() async {
    List<String>? code = await getCompanyCode();
    setState(() {
      companyCode = code;
    });
  }

  Future<void> fetchNewCompany() async {
    try {
      final newcom = await newCompanyRepo.getAllCompanies();

      final filteredCompany = newcom
          .where((company) =>
              company.stores!.any((store) => store.code == companyCode!.first))
          .toList();

      setState(() {
        selectedComapny = filteredCompany;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  DailyCashEntry? _dailyCashEntry;
  DailyCashServices dailyCashService = DailyCashServices();

  Future<void> fetchdailyCashById() async {
    final dailycash =
        await dailyCashService.fetchDailyCashById(widget.dailyCashID);
    setState(() {
      _dailyCashEntry = dailycash;
    });
  }

  Future<void> _initializeData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await setCompanyCode();
      await fetchNewCompany();
      await fetchdailyCashById();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

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

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll57,
        build: (context) {
          return pw.Column(
            children: [
              pw.Container(
                width: format.availableWidth,
                decoration: const pw.BoxDecoration(
                  color: PdfColors.white,
                ),
                padding: const pw.EdgeInsets.all(10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '$formattedDate  $formattedTime',
                      style: const pw.TextStyle(fontSize: 5),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Center(
                      child: pw.Column(
                        children: [
                          pw.Text(
                            selectedComapny.first.companyName!,
                            style: pw.TextStyle(
                                fontSize: 8, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            selectedComapny.first.stores!.first.address,
                            style: const pw.TextStyle(fontSize: 6),
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.SizedBox(height: 5),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(2),
                            decoration: const pw.BoxDecoration(
                                border: pw.Border(
                                    top: pw.BorderSide(),
                                    bottom: pw.BorderSide())),
                            child: pw.Text(
                              'Cash Denomination Dated ${_dailyCashEntry!.date}',
                              style: pw.TextStyle(
                                  fontSize: 6, fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.SizedBox(height: 3),
                          if (_dailyCashEntry?.description.isNotEmpty ?? false)
                            pw.Text(
                              'Description : ${_dailyCashEntry!.description}',
                              style: pw.TextStyle(
                                  fontSize: 6, fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.center,
                            ),
                          pw.SizedBox(height: 3),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(2),
                            decoration:
                                pw.BoxDecoration(border: pw.Border.all()),
                            child: pw.Row(
                              children: [
                                pw.SizedBox(
                                  width: 45,
                                  child: pw.Text(
                                    'Currency',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 6),
                                  ),
                                ),
                                pw.SizedBox(
                                  // width: 60,
                                  child: pw.Text(
                                    'Count',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 6),
                                  ),
                                ),
                                pw.Spacer(),
                                pw.SizedBox(
                                  // width: 60,
                                  child: pw.Text(
                                    'Value',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(2),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(),
                            ),
                            child: pw.Column(
                              children: [
                                if (_dailyCashEntry?.twoThousand?.isNotEmpty ??
                                    false)
                                  pw.Row(
                                    children: [
                                      pw.SizedBox(
                                        width: 45,
                                        child: pw.Text(
                                          '2000',
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                      pw.SizedBox(
                                        // width: 60,
                                        child: pw.Text(
                                          _dailyCashEntry!
                                              .twoThousand!.first.qty!
                                              .toStringAsFixed(2),
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                      pw.Spacer(),
                                      pw.SizedBox(
                                        // width: 60,
                                        child: pw.Text(
                                          _dailyCashEntry!
                                              .twoThousand!.first.total!
                                              .toStringAsFixed(2),
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (_dailyCashEntry?.fiveHundred?.isNotEmpty ??
                                    false)
                                  pw.Row(
                                    children: [
                                      pw.SizedBox(
                                        width: 45,
                                        child: pw.Text(
                                          '500',
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                      pw.SizedBox(
                                        // width: 60,
                                        child: pw.Text(
                                          _dailyCashEntry!
                                              .fiveHundred!.first.qty!
                                              .toStringAsFixed(2),
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                      pw.Spacer(),
                                      pw.SizedBox(
                                        // width: 60,
                                        child: pw.Text(
                                          _dailyCashEntry!
                                              .fiveHundred!.first.total!
                                              .toStringAsFixed(2),
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (_dailyCashEntry?.twoHundred?.isNotEmpty ??
                                    false)
                                  pw.Row(
                                    children: [
                                      pw.SizedBox(
                                        width: 45,
                                        child: pw.Text(
                                          '200',
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                      pw.SizedBox(
                                        // width: 60,
                                        child: pw.Text(
                                          _dailyCashEntry!
                                              .twoHundred!.first.qty!
                                              .toStringAsFixed(2),
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                      pw.Spacer(),
                                      pw.SizedBox(
                                        // width: 60,
                                        child: pw.Text(
                                          _dailyCashEntry!
                                              .twoHundred!.first.total!
                                              .toStringAsFixed(2),
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (_dailyCashEntry?.oneHundred?.isNotEmpty ??
                                    false)
                                  pw.Row(
                                    children: [
                                      pw.SizedBox(
                                        width: 45,
                                        child: pw.Text(
                                          '100',
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                      pw.SizedBox(
                                        // width: 60,
                                        child: pw.Text(
                                          _dailyCashEntry!
                                              .oneHundred!.first.qty!
                                              .toStringAsFixed(2),
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                      pw.Spacer(),
                                      pw.SizedBox(
                                        // width: 60,
                                        child: pw.Text(
                                          _dailyCashEntry!
                                              .oneHundred!.first.total!
                                              .toStringAsFixed(2),
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (_dailyCashEntry?.fifty?.isNotEmpty ?? false)
                                  pw.Row(
                                    children: [
                                      pw.SizedBox(
                                        width: 45,
                                        child: pw.Text(
                                          '50',
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                      pw.SizedBox(
                                        // width: 60,
                                        child: pw.Text(
                                          _dailyCashEntry!.fifty!.first.qty!
                                              .toStringAsFixed(2),
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                      pw.Spacer(),
                                      pw.SizedBox(
                                        // width: 60,
                                        child: pw.Text(
                                          _dailyCashEntry!.fifty!.first.total!
                                              .toStringAsFixed(2),
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (_dailyCashEntry?.twenty?.isNotEmpty ??
                                    false)
                                  pw.Row(
                                    children: [
                                      pw.SizedBox(
                                        width: 45,
                                        child: pw.Text(
                                          '20',
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                      pw.SizedBox(
                                        // width: 60,
                                        child: pw.Text(
                                          _dailyCashEntry!.twenty!.first.qty!
                                              .toStringAsFixed(2),
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                      pw.Spacer(),
                                      pw.SizedBox(
                                        // width: 60,
                                        child: pw.Text(
                                          _dailyCashEntry!.twenty!.first.total!
                                              .toStringAsFixed(2),
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (_dailyCashEntry?.ten?.isNotEmpty ?? false)
                                  pw.Row(
                                    children: [
                                      pw.SizedBox(
                                        width: 45,
                                        child: pw.Text(
                                          '10',
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                      pw.SizedBox(
                                        // width: 60,
                                        child: pw.Text(
                                          _dailyCashEntry!.ten!.first.qty!
                                              .toStringAsFixed(2),
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                      pw.Spacer(),
                                      pw.SizedBox(
                                        // width: 60,
                                        child: pw.Text(
                                          _dailyCashEntry!.ten!.first.total!
                                              .toStringAsFixed(2),
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (_dailyCashEntry?.coins?.isNotEmpty ?? false)
                                  pw.Row(
                                    children: [
                                      pw.SizedBox(
                                        width: 45,
                                        child: pw.Text(
                                          'coins',
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                      pw.SizedBox(
                                        // width: 60,
                                        child: pw.Text(
                                          _dailyCashEntry!.coins!.first.qty!
                                              .toStringAsFixed(2),
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                      pw.Spacer(),
                                      pw.SizedBox(
                                        // width: 60,
                                        child: pw.Text(
                                          _dailyCashEntry!.coins!.first.total!
                                              .toStringAsFixed(2),
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(2),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(),
                            ),
                            child: pw.Column(
                              children: [
                                pw.Row(
                                  children: [
                                    pw.SizedBox(
                                      width: 80,
                                      child: pw.Text(
                                        'Cash As per Denomination :',
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 5,
                                        ),
                                        textAlign: pw.TextAlign.end,
                                      ),
                                    ),
                                    pw.Spacer(),
                                    pw.SizedBox(
                                      child: pw.Text(
                                        _dailyCashEntry!.actualcash
                                            .toStringAsFixed(2),
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 6,
                                        ),
                                        textAlign: pw.TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                                pw.Row(
                                  children: [
                                    pw.SizedBox(
                                      width: 80,
                                      child: pw.Text(
                                        'Cash As per Books/System :',
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 5,
                                        ),
                                        textAlign: pw.TextAlign.end,
                                      ),
                                    ),
                                    pw.Spacer(),
                                    pw.SizedBox(
                                      // width: 20,
                                      child: pw.Text(
                                        _dailyCashEntry?.systemcash
                                                ?.toStringAsFixed(2) ??
                                            '0.00',
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 6,
                                        ),
                                        textAlign: pw.TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                                pw.Row(
                                  children: [
                                    pw.SizedBox(
                                      width: 80,
                                      child: pw.Text(
                                        'Short :',
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 5,
                                        ),
                                        textAlign: pw.TextAlign.end,
                                      ),
                                    ),
                                    pw.Spacer(),
                                    pw.SizedBox(
                                      // width: 20,
                                      child: pw.Text(
                                        _dailyCashEntry!.excesscash
                                            .toStringAsFixed(2),
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 6,
                                        ),
                                        textAlign: pw.TextAlign.end,
                                      ),
                                    ),
                                  ],
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
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
