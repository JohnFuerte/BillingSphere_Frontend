import 'dart:io';
import 'dart:typed_data';

import 'package:billingsphere/data/models/item/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indian_currency_to_word/indian_currency_to_word.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';

import '../../data/models/hsn/hsn_model.dart';
import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/measurementLimit/measurement_limit_model.dart';
import '../../data/models/newCompany/new_company_model.dart';
import '../../data/models/salesEntries/sales_entrires_model.dart';
import '../../data/repository/hsn_repository.dart';
import '../../data/repository/item_repository.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/measurement_limit_repository.dart';
import '../../data/repository/new_company_repository.dart';
import '../../data/repository/sales_enteries_repository.dart';

class PrintBigReceipt extends StatefulWidget {
  const PrintBigReceipt(
    this.title, {
    super.key,
    required this.sales,
    required this.ledger,
  });
  final SalesEntry sales;
  final Ledger ledger;

  final String title;

  @override
  State<PrintBigReceipt> createState() => _PrintBigReceiptState();
}

class _PrintBigReceiptState extends State<PrintBigReceipt> {
  LedgerService ledgerService = LedgerService();
  SalesEntryService salesService = SalesEntryService();
  ItemsService itemsService = ItemsService();
  MeasurementLimitService measurementLimitService = MeasurementLimitService();
  HSNCodeService hsnCodeService = HSNCodeService();
  SalesEntry? _SalesEntry;
  String? selectedId;
  bool isLoading = false;
  List<NewCompany> selectedComapny = [];
  NewCompanyRepository newCompanyRepo = NewCompanyRepository();

  List<Item> fectedItems = [];
  List<MeasurementLimit> fectedUnit = [];
  List<HSNCode> fectedHsn = [];
  Ledger? fectedLedgers;

  List<String>? companyCode;
  Future<List<String>?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('companies');
  }

  Future<void> setCompanyCode() async {
    List<String>? code = await getCompanyCode();
    companyCode = code;
  }

  // Future<void> fetchSalesById() async {
  //   final sales = await salesService.fetchSalesById(widget.sales);
  //   // print(widget.sales);

  //   setState(() {
  //     _SalesEntry = sales;
  //   });
  // }

  Future<void> fetchItems() async {
    try {
      print('Fetching Items..................');
      final List<Item> items = await itemsService.fetchITEMS();
      fectedItems = items;
      print('Items Fetched..................');
    } catch (error) {
      print('Failed to fetch Item name: $error');
    }
  }

  Future<void> fetchUnit() async {
    try {
      final List<MeasurementLimit> unit =
          await measurementLimitService.fetchMeasurementLimits();
      fectedUnit = unit;
    } catch (error) {
      print('Failed to fetch Item name: $error');
    }
  }

  Future<void> fetchHsn() async {
    try {
      final List<HSNCode> hsn = await hsnCodeService.fetchItemHSN();
      fectedHsn = hsn;
    } catch (error) {
      print('Failed to fetch Hsn Code: $error');
    }
  }

  Future<void> fetchLatestLedger() async {
    try {
      final ledger = await ledgerService.fetchLedgerById(widget.ledger.id);
      fectedLedgers = ledger;
    } catch (error) {
      print('Failed to fetch latest ledger: $error');
    }
  }

  List<Uint8List> _selectedImages = [];
  List<Uint8List> _selectedImages2 = [];
  List<File> files = [];

  Future<void> fetchNewCompany() async {
    try {
      final newcom = await newCompanyRepo.getAllCompanies();

      final filteredCompany = newcom
          .where((company) =>
              company.stores!.any((store) => store.code == companyCode!.first))
          .toList();

      selectedComapny = filteredCompany;
      _selectedImages =
          filteredCompany.first.logo1!.map((e) => e.data).toList();
      _selectedImages2 =
          filteredCompany.first.logo2!.map((e) => e.data).toList();
      // print(_selectedImages);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _initializeData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Future.wait([
        setCompanyCode(),
        fetchLatestLedger(),
        fetchItems(),
        fetchUnit(),
        fetchHsn(),
        fetchNewCompany(),
        // fetchSalesById(),
      ]);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _SalesEntry = widget.sales;
    fectedLedgers = widget.ledger;

    _initializeData();
    super.initState();

    print('Sales Entry: $_SalesEntry');
    print('Ledger: $fectedLedgers');
    print('Item: $fectedItems');
    print("Ledger ${widget.ledger}");
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
                centerTitle: true,
              ),
              body: PdfPreview(
                canChangeOrientation: false,
                canChangePageFormat: false,
                build: (format) => _generatePdf(format, widget.title),
              ),
            ),
      debugShowCheckedModeBanner:
          false, // Set to false to hide the debug banner
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    // final font = await PdfGoogleFonts.nunitoExtraLight();
    int totalItems = _SalesEntry!.entries.length;
    int totalQuantity =
        _SalesEntry!.entries.map((e) => e.qty).reduce((a, b) => a + b);
    double totalValue = 0.0;
    double totalAmount = 0.0;
    double totalsgst = 0.0;
    double totalcgst = 0.0;
    double discount = 0.0;
    double totalNetAmount = 0.0;
    double amount = 0.0;
    for (var entry in _SalesEntry!.entries) {
      totalValue += entry.qty * entry.rate;
      totalAmount += entry.amount;
      totalNetAmount += entry.netAmount;
      totalsgst += entry.sgst;
      totalcgst += entry.cgst;
      discount += entry.discount;
    }
    double taxableAmt = 0.00;
    taxableAmt = totalAmount - discount;
    amount = double.parse(_SalesEntry!.totalamount);
    // Calculate roundedValue and roundOff
    int roundedValue = totalNetAmount.truncate(); // Integer part
    double roundOff = totalNetAmount - roundedValue; // Decimal part
    final converter = AmountToWords();

    int counter = 1; // Initialize a counter variable outside the map function

    // final image = pw.MemoryImage(_selectedImages[0]);
    final customFormat = PdfPageFormat.a4.copyWith(
      marginLeft: 20,
      marginRight: 20,
      marginTop: 20,
      marginBottom: 20,
    );

    final upi = selectedComapny
        .firstWhere((company) => company.stores!
            .any((store) => store.code == _SalesEntry!.companyCode))
        .stores!
        .firstWhere((store) => store.code == _SalesEntry!.companyCode)
        .upi;
    final accountName = selectedComapny
        .firstWhere((company) => company.stores!
            .any((store) => store.code == _SalesEntry!.companyCode))
        .stores!
        .firstWhere((store) => store.code == _SalesEntry!.companyCode)
        .accountName;

    final upiDetailsWithAmount = UPIDetails(
      upiID: upi,
      payeeName: accountName, // Replace with actual payee name if available
      // amount: totalNetAmount, // Use the calculated total net amount
    );
    pdf.addPage(
      pw.Page(
        pageFormat: customFormat,
        build: (context) {
          return pw.Column(
            children: [
              pw.Container(
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    border: pw.Border.all(color: PdfColors.black)),
                child: pw.Column(
                  children: [
                    pw.Row(
                      children: [
                        pw.SizedBox(width: 2),
                        pw.Container(
                          width: 50,
                          child: _selectedImages.isNotEmpty
                              ? pw.Image(pw.MemoryImage(_selectedImages[0]))
                              : pw.SizedBox(width: 50),
                        ),
                        pw.Spacer(),
                        pw.Container(
                          width: 320,
                          child: pw.Center(
                            child: pw.Column(
                              children: [
                                pw.Text(
                                  selectedComapny.first.companyName!,
                                  style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold),
                                  textAlign: pw.TextAlign.right,
                                ),
                                // pw.Text(
                                //   '"${selectedComapny.first.tagline}"',
                                //   style: pw.TextStyle(
                                //       fontSize: 12,
                                //       fontWeight: pw.FontWeight.normal),
                                // ),
                                pw.SizedBox(height: 5),
                                pw.Text(
                                  selectedComapny
                                      .firstWhere((company) => company.stores!
                                          .any((store) =>
                                              store.code ==
                                              _SalesEntry!.companyCode))
                                      .stores!
                                      .firstWhere((store) =>
                                          store.code ==
                                          _SalesEntry!.companyCode)
                                      .address,
                                  maxLines: 3,
                                  textAlign: pw.TextAlign.center,
                                  softWrap: true,
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.SizedBox(height: 2),

                                pw.Text(
                                  'E-mail: ${selectedComapny.firstWhere((company) => company.stores!.any((store) => store.code == _SalesEntry!.companyCode)).stores!.firstWhere((store) => store.code == _SalesEntry!.companyCode).email}, Mo. ${selectedComapny.firstWhere((company) => company.stores!.any((store) => store.code == _SalesEntry!.companyCode)).stores!.firstWhere((store) => store.code == _SalesEntry!.companyCode).phone}',
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.SizedBox(width: 2),
                              ],
                            ),
                          ),
                        ),
                        pw.Spacer(),
                        pw.Container(
                          width: 50,
                          child: _selectedImages.isNotEmpty
                              ? pw.Image(pw.MemoryImage(_selectedImages[0]))
                              : pw.SizedBox(width: 50),
                        ),
                        pw.SizedBox(width: 2),
                      ],
                    ),
                    pw.SizedBox(width: 2),
                    pw.SizedBox(
                      width: customFormat.availableWidth,
                      child: pw.Row(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              'GSTIN : ${selectedComapny.first.gstin}',
                              style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Spacer(),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              'State : ${selectedComapny.firstWhere((company) => company.stores!.any((store) => store.code == _SalesEntry!.companyCode)).stores!.firstWhere((store) => store.code == _SalesEntry!.companyCode).state}',
                              style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Spacer(),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              'PAN : ${selectedComapny.first.pan}',
                              style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              pw.Container(
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(2.0),
                        child: pw.Text(
                          '${_SalesEntry!.type} MEMO',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 10,
                          ),
                          textAlign: pw.TextAlign.start,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(2.0),
                        child: pw.Text(
                          'TAX INVOICE',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 10,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(2.0),
                        child: pw.Text(
                          'ORIGINAL',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 10,
                          ),
                          textAlign: pw.TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              pw.Container(
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 375,
                      height: 105,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(),
                      ),
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 2.0),
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.SizedBox(height: 5),
                            pw.Row(
                              children: [
                                pw.Container(
                                  height: 10,
                                  width: 30,
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text('To, ',
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.SizedBox(
                                  height: 10,
                                  width: 340,
                                  child: pw.Text(
                                    '${fectedLedgers!.name} ',
                                    textAlign: pw.TextAlign.start,
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: 30,
                                  height: 30,
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text('',
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Container(
                                  width: 340,
                                  height: 30,
                                  child: pw.Text(
                                    fectedLedgers!.address,
                                    maxLines: 3,
                                    textAlign: pw.TextAlign.start,
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 8),
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: 30,
                                  height: 10,
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text('',
                                      style: pw.TextStyle(
                                          fontSize: 8,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.SizedBox(
                                  width: 340,
                                  height: 10,
                                  child: pw.Text(
                                    'Mob   : ${fectedLedgers!.mobile}',
                                    maxLines: 3,
                                    textAlign: pw.TextAlign.start,
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 8),
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: 30,
                                  height: 10,
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text('',
                                      style: pw.TextStyle(
                                          fontSize: 8,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.SizedBox(
                                  width: 340,
                                  height: 10,
                                  child: pw.Text(
                                    'Mob-2 : ${fectedLedgers!.sms}',
                                    maxLines: 3,
                                    textAlign: pw.TextAlign.start,
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 8),
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: 30,
                                  height: 10,
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text('',
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.SizedBox(
                                  width: 360,
                                  height: 10,
                                  child: pw.Text(
                                    'GSTIN : ${fectedLedgers!.gst}',
                                    maxLines: 3,
                                    textAlign: pw.TextAlign.start,
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.Container(
                      width: 180,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(2.0),
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: 70,
                                  child: pw.Text(
                                    'Invoice No.   :     ',
                                    textAlign: pw.TextAlign.start,
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.bold),
                                  ),
                                ),
                                pw.Container(
                                  width: 90,
                                  child: pw.Text(_SalesEntry!.dcNo,
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: 80,
                                  child: pw.Text('Invoice Date   :   ',
                                      textAlign: pw.TextAlign.start,
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Container(
                                  width: 80,
                                  child: pw.Text(_SalesEntry!.date,
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              pw.Container(
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Expanded(
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Container(
                        width: 21,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Sr',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 140,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Particulars',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 50,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'HSN',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 30,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Qty',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 30,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Unit',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 52,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Rate',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 52,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Total',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 50,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Dis',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 30,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'GST%',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 50,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Tax. Amt',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 50,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Amount',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              pw.Container(
                height: 214,
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.ListView(
                  children: _SalesEntry!.entries.map((sale) {
                    Item? item = fectedItems.firstWhere(
                      (item) => item.id == sale.itemName,
                    );
                    MeasurementLimit? unit = fectedUnit.firstWhere(
                      (unit) => unit.measurement == sale.unit,
                    );
                    HSNCode? hsnCode = fectedHsn.firstWhere(
                      (hsn) => hsn.id == item?.hsnCode,
                    );
                    // double totalRate = sale.qty * sale.rate;
                    // print(totalRate);
                    return pw.Table(
                      border: pw.TableBorder.all(
                          // inside: const pw.BorderSide(
                          //   color: PdfColors.black,
                          //   width: 1,
                          // ),
                          ),
                      children: [
                        pw.TableRow(
                          children: [
                            pw.SizedBox(
                              width: 21,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  (counter++).toString(),
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 140,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  item != null
                                      ? '${item.itemName} ${sale.additionalInfo!.isNotEmpty ? '(${sale.additionalInfo})' : ''}'
                                      : 'Item not found',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 50,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  hsnCode?.hsn ?? '',
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 30,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  '${sale.qty}',
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 30,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  unit.measurement,
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 52,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  sale.rate.toStringAsFixed(2),
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 52,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  sale.amount.toStringAsFixed(
                                      2), // Calculate qty * rate
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 50,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  sale.originaldiscount.toStringAsFixed(2),
                                  // ((sale.discount / totalRate) * 100)
                                  //     .toStringAsFixed(2),
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 30,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  '${sale.tax}.00',
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 50,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  (sale.sgst * 2).toStringAsFixed(2),
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 50,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  sale.netAmount.toStringAsFixed(2),
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),

              pw.Container(
                height: 25,
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Row(
                  children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(border: pw.Border.all()),
                      width: 397,
                      height: 25,
                      child: pw.Row(
                        children: [
                          pw.Container(
                            width: 80,
                            child: pw.Text(
                              ' Rs. (in words) : ',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 10),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Container(
                            width: 317,
                            child: pw.Text(
                              converter.convertAmountToWords(
                                  roundedValue as double,
                                  ignoreDecimal: false),
                              maxLines: 2,
                              style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Container(
                      width: 140,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(2.0),
                        child: pw.Text(
                          roundedValue.toStringAsFixed(2),
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                            decoration: pw.TextDecoration.underline,
                          ),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Container(
                child: pw.Row(
                  children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(border: pw.Border.all()),
                      width: customFormat.availableWidth,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(2.0),
                        child: pw.Text(
                          'Remarks: ${_SalesEntry!.remark}',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //Multimode
              _SalesEntry!.moredetails.isNotEmpty
                  ? pw.Container(
                      width: customFormat.availableWidth,
                      decoration: pw.BoxDecoration(
                        color: PdfColors.white,
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Column(
                        children: [
                          pw.Row(
                            children: [
                              pw.Container(
                                width: 150,
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text('ADVANCE PAYMENT : ',
                                    style: pw.TextStyle(
                                        fontSize: 8,
                                        fontWeight: pw.FontWeight.bold)),
                              ),
                              pw.Text(
                                '${_SalesEntry!.moredetails.first.advpayment} ',
                                textAlign: pw.TextAlign.start,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 8),
                              ),
                            ],
                          ),
                          pw.Row(
                            children: [
                              pw.Container(
                                width: 150,
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text('ADVANCE PAYMENT DATE : ',
                                    style: pw.TextStyle(
                                        fontSize: 8,
                                        fontWeight: pw.FontWeight.bold)),
                              ),
                              pw.Text(
                                '${_SalesEntry!.moredetails.first.advpaymentdate} ',
                                textAlign: pw.TextAlign.start,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 8),
                              ),
                            ],
                          ),
                          pw.Row(
                            children: [
                              pw.Container(
                                width: 150,
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text('INSTALLMENT : ',
                                    style: pw.TextStyle(
                                        fontSize: 8,
                                        fontWeight: pw.FontWeight.bold)),
                              ),
                              pw.Text(
                                '${_SalesEntry!.moredetails.first.installment} ',
                                textAlign: pw.TextAlign.start,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 8),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : pw.SizedBox(),
              _SalesEntry!.moredetails.isNotEmpty
                  ? pw.Container(
                      width: customFormat.availableWidth - 1,
                      decoration: pw.BoxDecoration(
                        color: PdfColors.white,
                        border: pw.Border.all(color: PdfColors.black, width: 2),
                      ),
                      child: pw.Container(
                        width: 150,
                        padding: const pw.EdgeInsets.all(2.0),
                        decoration: const pw.BoxDecoration(
                            color: PdfColor.fromInt(0xFD2D2D2)),
                        child: pw.Text(
                            '  TOTAL DEBIT AMOUNT (WITH INTEREST) : ${_SalesEntry!.moredetails.first.toteldebitamount}',
                            style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                                color: const PdfColor.fromInt(0xFF0000))),
                      ),
                    )
                  : pw.SizedBox(),

              pw.Container(
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 204,
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(
                          right: pw.BorderSide(),
                        ),
                      ),
                      child: pw.Column(
                        children: [
                          pw.Container(
                            child: pw.Text(
                              'Bank Details',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 10),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Row(
                            children: [
                              pw.Container(
                                width: 50,
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(),
                                ),
                                child: pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    'Bank',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 10),
                                  ),
                                ),
                              ),
                              pw.Container(
                                width: 154,
                                height: 15.8,
                                decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                    left: pw.BorderSide(),
                                    top: pw.BorderSide(),
                                    bottom: pw.BorderSide(),
                                  ),
                                ),
                                child: pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    selectedComapny
                                        .firstWhere((company) => company.stores!
                                            .any((store) =>
                                                store.code ==
                                                _SalesEntry!.companyCode))
                                        .stores!
                                        .firstWhere((store) =>
                                            store.code ==
                                            _SalesEntry!.companyCode)
                                        .bankName,
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.normal),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.Row(
                            children: [
                              pw.Container(
                                width: 50,
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(),
                                ),
                                child: pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    'Branch',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 10),
                                  ),
                                ),
                              ),
                              pw.Container(
                                width: 154,
                                height: 15.8,
                                decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                    left: pw.BorderSide(),
                                    top: pw.BorderSide(),
                                    bottom: pw.BorderSide(),
                                  ),
                                ),
                                child: pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    selectedComapny
                                        .firstWhere((company) => company.stores!
                                            .any((store) =>
                                                store.code ==
                                                _SalesEntry!.companyCode))
                                        .stores!
                                        .firstWhere((store) =>
                                            store.code ==
                                            _SalesEntry!.companyCode)
                                        .branch,
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.normal),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.Row(
                            children: [
                              pw.Container(
                                width: 50,
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(),
                                ),
                                child: pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    'A/c No',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 10),
                                  ),
                                ),
                              ),
                              pw.Container(
                                width: 154,
                                height: 15.8,
                                decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                    left: pw.BorderSide(),
                                    top: pw.BorderSide(),
                                    bottom: pw.BorderSide(),
                                  ),
                                ),
                                child: pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    selectedComapny
                                        .firstWhere((company) => company.stores!
                                            .any((store) =>
                                                store.code ==
                                                _SalesEntry!.companyCode))
                                        .stores!
                                        .firstWhere((store) =>
                                            store.code ==
                                            _SalesEntry!.companyCode)
                                        .accountNo,
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.normal),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.Row(
                            children: [
                              pw.Container(
                                width: 50,
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(),
                                ),
                                child: pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    'IFSC',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 10),
                                  ),
                                ),
                              ),
                              pw.Container(
                                width: 154,
                                height: 15.8,
                                decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                    left: pw.BorderSide(),
                                    top: pw.BorderSide(),
                                    bottom: pw.BorderSide(),
                                  ),
                                ),
                                child: pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    selectedComapny
                                        .firstWhere((company) => company.stores!
                                            .any((store) =>
                                                store.code ==
                                                _SalesEntry!.companyCode))
                                        .stores!
                                        .firstWhere((store) =>
                                            store.code ==
                                            _SalesEntry!.companyCode)
                                        .ifsc,
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.normal),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    pw.Container(
                      height: 76,
                      width: 193,
                      decoration: pw.BoxDecoration(border: pw.Border.all()),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Container(
                            height: 76,
                            width: 110.9,
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(),
                            ),
                            child: pw.Column(
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    upi,
                                    style: pw.TextStyle(
                                      fontSize: 6,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ),
                                pw.Flexible(
                                  child: pw.BarcodeWidget(
                                    barcode: pw.Barcode.qrCode(),
                                    data:
                                        'upi://pay?pa=${upiDetailsWithAmount.upiID}&pn=${upiDetailsWithAmount.payeeName}',
                                    width: 80,
                                    height: 80,
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    'Scan to Pay',
                                    style: pw.TextStyle(
                                      fontSize: 6,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          pw.Container(
                            height: 76,
                            width: 82.1,
                            decoration:
                                pw.BoxDecoration(border: pw.Border.all()),
                            child: pw.Column(
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    'Out-standing Balance',
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 8,
                                    ),
                                    textAlign: pw.TextAlign.center,
                                  ),
                                ),
                                pw.Container(
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(),
                                    borderRadius: pw.BorderRadius.circular(5),
                                  ),
                                  child: pw.Padding(
                                    padding: const pw.EdgeInsets.all(2.0),
                                    child: pw.Text(
                                      fectedLedgers!.debitBalance
                                          .toStringAsFixed(2),
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 8,
                                      ),
                                      textAlign: pw.TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(
                      width: 158,
                      child: pw.Container(
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            left: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Column(
                          children: [
                            pw.Row(
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    'Taxable Amount',
                                    style: pw.TextStyle(
                                        fontSize: 8,
                                        fontWeight: pw.FontWeight.normal),
                                  ),
                                ),
                                pw.Spacer(),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    taxableAmt.toStringAsFixed(2),
                                    style: pw.TextStyle(
                                        fontSize: 8,
                                        fontWeight: pw.FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    'SGST',
                                    style: pw.TextStyle(
                                        fontSize: 8,
                                        fontWeight: pw.FontWeight.normal),
                                  ),
                                ),
                                pw.Spacer(),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    totalsgst.toStringAsFixed(2),
                                    style: pw.TextStyle(
                                        fontSize: 8,
                                        fontWeight: pw.FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    'CGST',
                                    style: pw.TextStyle(
                                        fontSize: 8,
                                        fontWeight: pw.FontWeight.normal),
                                  ),
                                ),
                                pw.Spacer(),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    totalcgst.toStringAsFixed(2),
                                    style: pw.TextStyle(
                                        fontSize: 8,
                                        fontWeight: pw.FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                            // pw.Row(
                            //   children: [
                            //     pw.Padding(
                            //       padding: const pw.EdgeInsets.all(2.0),
                            //       child: pw.Text(
                            //         'Discount',
                            //         style: const pw.TextStyle(fontSize: 6),
                            //       ),
                            //     ),
                            //     pw.Spacer(),
                            //     pw.Padding(
                            //       padding: const pw.EdgeInsets.all(2.0),
                            //       child: pw.Text(
                            //         discount.toStringAsFixed(2),
                            //         style: const pw.TextStyle(fontSize: 6),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            pw.Row(
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    'Round-Off',
                                    style: pw.TextStyle(
                                        fontSize: 8,
                                        fontWeight: pw.FontWeight.normal),
                                  ),
                                ),
                                pw.Spacer(),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    (_SalesEntry!.roundoffDiff)
                                        .toStringAsFixed(2),
                                    style: pw.TextStyle(
                                        fontSize: 8,
                                        fontWeight: pw.FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    'Bill Amount',
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.bold),
                                  ),
                                ),
                                pw.Spacer(),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    amount.toStringAsFixed(2),
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //Tax AMount
              pw.Container(
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Expanded(
                  child: pw.Row(
                    children: [
                      pw.Container(
                        width: 111,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(2.0),
                          child: pw.Text(
                            'Tax Category',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 6,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 111,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(2.0),
                          child: pw.Text(
                            'Taxable Amount',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 6,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 111,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(2.0),
                          child: pw.Text(
                            'SGST',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 6,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 111,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(2.0),
                          child: pw.Text(
                            'CGST',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 6,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 111,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(2.0),
                          child: pw.Text(
                            'IGST',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 6,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // pw.Container(
              //   height: 70,
              //   width: format.availableWidth,
              //   decoration: pw.BoxDecoration(
              //     color: PdfColors.white,
              //     border: pw.Border.all(color: PdfColors.black),
              //   ),
              //   child: pw.ListView(
              //     children: _SalesEntry!.entries.map((sale) {
              //       return pw.Table(
              //         border: pw.TableBorder.all(),
              //         children: [
              //           pw.TableRow(
              //             children: [
              //               pw.SizedBox(
              //                 width: 92,
              //                 child: pw.Padding(
              //                   padding: const pw.EdgeInsets.all(2.0),
              //                   child: pw.Text(
              //                     '${sale.tax}% GST',
              //                     textAlign: pw.TextAlign.center,
              //                     style: pw.TextStyle(
              //                         fontWeight: pw.FontWeight.bold,
              //                         fontSize: 6),
              //                   ),
              //                 ),
              //               ),
              //               pw.SizedBox(
              //                 width: 92,
              //                 child: pw.Padding(
              //                   padding: const pw.EdgeInsets.all(2.0),
              //                   child: pw.Text(
              //                     (sale.qty * sale.rate).toStringAsFixed(2),
              //                     style: pw.TextStyle(
              //                         fontWeight: pw.FontWeight.bold,
              //                         fontSize: 6),
              //                   ),
              //                 ),
              //               ),
              //               pw.SizedBox(
              //                 width: 92,
              //                 child: pw.Padding(
              //                   padding: const pw.EdgeInsets.all(2.0),
              //                   child: pw.Text(
              //                     sale.sgst.toStringAsFixed(2),
              //                     textAlign: pw.TextAlign.center,
              //                     style: pw.TextStyle(
              //                         fontWeight: pw.FontWeight.bold,
              //                         fontSize: 6),
              //                   ),
              //                 ),
              //               ),
              //               pw.SizedBox(
              //                 width: 92,
              //                 child: pw.Padding(
              //                   padding: const pw.EdgeInsets.all(2.0),
              //                   child: pw.Text(
              //                     sale.cgst.toStringAsFixed(2),
              //                     textAlign: pw.TextAlign.center,
              //                     style: pw.TextStyle(
              //                         fontWeight: pw.FontWeight.bold,
              //                         fontSize: 6),
              //                   ),
              //                 ),
              //               ),
              //               pw.SizedBox(
              //                 width: 92,
              //                 child: pw.Padding(
              //                   padding: const pw.EdgeInsets.all(2.0),
              //                   child: pw.Text(
              //                     '0.00',
              //                     textAlign: pw.TextAlign.center,
              //                     style: pw.TextStyle(
              //                         fontWeight: pw.FontWeight.bold,
              //                         fontSize: 6),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ],
              //       );
              //     }).toList(),
              //   ),
              // ),

              pw.Container(
                height: 70,
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.ListView(
                  children: _SalesEntry!.entries
                      .fold<Map<String, Map<String, dynamic>>>(
                        {}, // Initial value is an empty map
                        (map, sale) {
                          final tax = sale.tax; // Tax rate as string
                          final key =
                              'tax_$tax'; // Unique key for each tax rate
                          if (!map.containsKey(key)) {
                            // Initialize entry for this tax rate if not already present
                            map[key] = {
                              'tax': tax,
                              'totalTaxableAmount': 0.0,
                              'totalSGST': 0.0,
                              'totalCGST': 0.0,
                            };
                          }

                          // Add to total taxable amount, SGST, and CGST for this tax rate
                          map[key]!['totalTaxableAmount'] +=
                              sale.amount - sale.discount;
                          map[key]!['totalSGST'] += (sale.sgst);
                          map[key]!['totalCGST'] += (sale.cgst);

                          return map;
                        },
                      )
                      .values
                      .map((taxEntry) {
                        final tax = taxEntry['tax'];
                        final totalTaxableAmount =
                            taxEntry['totalTaxableAmount'];
                        final totalSGST = taxEntry['totalSGST'];
                        final totalCGST = taxEntry['totalCGST'];

                        // Create a row for each tax group
                        return pw.Table(
                          border: pw.TableBorder.all(),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.SizedBox(
                                  width: 92,
                                  child: pw.Padding(
                                    padding: const pw.EdgeInsets.all(2.0),
                                    child: pw.Text(
                                      '$tax% GST',
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 6,
                                      ),
                                    ),
                                  ),
                                ),
                                pw.SizedBox(
                                  width: 92,
                                  child: pw.Padding(
                                    padding: const pw.EdgeInsets.all(2.0),
                                    child: pw.Text(
                                      totalTaxableAmount.toStringAsFixed(2),
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 6,
                                      ),
                                    ),
                                  ),
                                ),
                                pw.SizedBox(
                                  width: 92,
                                  child: pw.Padding(
                                    padding: const pw.EdgeInsets.all(2.0),
                                    child: pw.Text(
                                      totalSGST.toStringAsFixed(2),
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 6,
                                      ),
                                    ),
                                  ),
                                ),
                                pw.SizedBox(
                                  width: 92,
                                  child: pw.Padding(
                                    padding: const pw.EdgeInsets.all(2.0),
                                    child: pw.Text(
                                      totalCGST.toStringAsFixed(2),
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 6,
                                      ),
                                    ),
                                  ),
                                ),
                                pw.SizedBox(
                                  width: 92,
                                  child: pw.Padding(
                                    padding: const pw.EdgeInsets.all(2.0),
                                    child: pw.Text(
                                      '0.00',
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 6,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      })
                      .toList(),
                ),
              ),
              pw.Container(
                child: pw.Row(
                  children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(border: pw.Border.all()),
                      width: customFormat.availableWidth,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(2.0),
                        child: pw.Text(
                          'Remarks: ${fectedLedgers!.remarks} ',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //Term's and Conditions
              pw.Container(
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(),
                ),
                height: 100,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 333,
                      decoration: pw.BoxDecoration(
                        color: PdfColors.white,
                        border: pw.Border.all(),
                      ),
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              'Terms And Condition :',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          selectedComapny.first.tc1!.isNotEmpty
                              ? pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    '- ${selectedComapny.first.tc1}',
                                    style: pw.TextStyle(
                                      fontSize: 8,
                                      fontWeight: pw.FontWeight.normal,
                                    ),
                                  ),
                                )
                              : pw.SizedBox(),
                          selectedComapny.first.tc2!.isNotEmpty
                              ? pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    '- ${selectedComapny.first.tc2}',
                                    style: pw.TextStyle(
                                      fontSize: 8,
                                      fontWeight: pw.FontWeight.normal,
                                    ),
                                  ),
                                )
                              : pw.SizedBox(),
                          selectedComapny.first.tc3!.isNotEmpty
                              ? pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    '- ${selectedComapny.first.tc3}',
                                    style: pw.TextStyle(
                                      fontSize: 8,
                                      fontWeight: pw.FontWeight.normal,
                                    ),
                                  ),
                                )
                              : pw.SizedBox(),
                          selectedComapny.first.tc4!.isNotEmpty
                              ? pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    '- ${selectedComapny.first.tc4}',
                                    style: pw.TextStyle(
                                      fontSize: 8,
                                      fontWeight: pw.FontWeight.normal,
                                    ),
                                  ),
                                )
                              : pw.SizedBox(),
                          selectedComapny.first.tc5!.isNotEmpty
                              ? pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    '- ${selectedComapny.first.tc5}',
                                    style: pw.TextStyle(
                                      fontSize: 8,
                                      fontWeight: pw.FontWeight.normal,
                                    ),
                                  ),
                                )
                              : pw.SizedBox(),
                        ],
                      ),
                    ),
                    pw.Container(
                      width: 222,
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                            width: 222,
                            height: 50,
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                bottom: pw.BorderSide(),
                              ),
                            ),
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.Container(
                                  width: 30,
                                  child: _selectedImages2.isNotEmpty
                                      ? pw.Image(
                                          pw.MemoryImage(_selectedImages2[0]))
                                      : pw.SizedBox(width: 50),
                                ),
                                pw.SizedBox(height: 5),
                                pw.Text(
                                  'For, ${selectedComapny.first.companyName}',
                                  style: pw.TextStyle(
                                    fontSize: 6,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                  textAlign: pw.TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          pw.Container(
                            width: 222,
                            height: 50,
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.Text(
                                  'Customer Signature',
                                  style: pw.TextStyle(
                                    fontSize: 6,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                  textAlign: pw.TextAlign.center,
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
