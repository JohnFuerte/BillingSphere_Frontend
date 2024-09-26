import 'dart:io';
import 'dart:typed_data';

import 'package:billingsphere/data/models/item/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/hsn/hsn_model.dart';
import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/newCompany/new_company_model.dart';
import '../../data/models/salesEntries/sales_entrires_model.dart';
import '../../data/repository/hsn_repository.dart';
import '../../data/repository/item_repository.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/new_company_repository.dart';
import '../../data/repository/sales_enteries_repository.dart';

class PrintBigReceiptthree extends StatefulWidget {
  const PrintBigReceiptthree(this.title, {super.key, required this.sales});
  final String sales;

  final String title;

  @override
  State<PrintBigReceiptthree> createState() => _PrintBigReceiptthreeState();
}

class _PrintBigReceiptthreeState extends State<PrintBigReceiptthree> {
  LedgerService ledgerService = LedgerService();
  SalesEntryService salesService = SalesEntryService();
  ItemsService itemsService = ItemsService();
  HSNCodeService hsnCodeService = HSNCodeService();
  SalesEntry? _SalesEntry;
  String? selectedId;
  bool isLoading = false;
  List<NewCompany> selectedComapny = [];
  NewCompanyRepository newCompanyRepo = NewCompanyRepository();

  List<Item> fectedItems = [];
  List<HSNCode> fectedHsn = [];
  List<Ledger> fectedLedgers = [];

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

  Future<void> fetchSalesById() async {
    final sales = await salesService.fetchSalesById(widget.sales);
    setState(() {
      _SalesEntry = sales;
    });
  }

  Future<void> fetchItems() async {
    try {
      final List<Item> items = await itemsService.fetchItems();
      setState(() {
        fectedItems = items;
      });
    } catch (error) {
      print('Failed to fetch Item name: $error');
    }
  }

  Future<void> fetchHsn() async {
    try {
      final List<HSNCode> hsn = await hsnCodeService.fetchItemHSN();
      setState(() {
        fectedHsn = hsn;
      });
    } catch (error) {
      print('Failed to fetch Hsn Code: $error');
    }
  }

  Future<void> fetchLedger() async {
    try {
      final List<Ledger> ledgers = await ledgerService.fetchLedgers();
      setState(() {
        fectedLedgers = ledgers;
      });
    } catch (error) {
      print('Failed to fetch ledger name: $error');
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
      setState(() {
        selectedComapny = filteredCompany;
        _selectedImages =
            filteredCompany.first.logo1!.map((e) => e.data).toList();
        _selectedImages2 =
            filteredCompany.first.logo2!.map((e) => e.data).toList();
      });
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
        fetchLedger(),
        fetchItems(),
        fetchHsn(),
        fetchNewCompany(),
        fetchSalesById(),
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
    // final font = await PdfGoogleFonts.nunitoExtraLight();
    int totalItems = _SalesEntry!.entries.length;
    int totalQuantity =
        _SalesEntry!.entries.map((e) => e.qty).reduce((a, b) => a + b);
    double totalValue = 0.0;
    double totalQty = 0.0;
    double totalAmount = 0.0;
    double totalsgst = 0.0;
    double totalcgst = 0.0;
    double totalNetAmount = 0.0;
    for (var entry in _SalesEntry!.entries) {
      totalValue += entry.qty * entry.rate;
      totalQty += entry.qty;
      totalAmount += entry.amount;
      totalNetAmount += entry.netAmount;
      totalsgst += entry.sgst;
      totalcgst += entry.cgst;
    }
    int counter = 1; // Initialize a counter variable outside the map function

    // final image = pw.MemoryImage(_selectedImages[0]);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            children: [
              pw.Container(
                width: format.availableWidth,
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
                          width: 200,
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
                                  selectedComapny.first.stores!.first.address,
                                  maxLines: 3,
                                  textAlign: pw.TextAlign.center,
                                  softWrap: true,
                                  style: const pw.TextStyle(fontSize: 8),
                                ),
                                pw.SizedBox(height: 2),

                                pw.Text(
                                  'E-mail: ${selectedComapny.first.stores!.first.email}, Mo. ${selectedComapny.first.stores!.first.phone}',
                                  style: pw.TextStyle(
                                      fontSize: 8,
                                      fontWeight: pw.FontWeight.normal),
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
                      width: format.availableWidth,
                      child: pw.Row(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              'GSTIN : ${selectedComapny.first.gstin}',
                              style: pw.TextStyle(
                                  fontSize: 8,
                                  fontWeight: pw.FontWeight.normal),
                            ),
                          ),
                          pw.Spacer(),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              'State : ${selectedComapny.first.stores!.first.state}',
                              style: pw.TextStyle(
                                  fontSize: 8,
                                  fontWeight: pw.FontWeight.normal),
                            ),
                          ),
                          pw.Spacer(),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              'PAN : ${selectedComapny.first.pan}',
                              style: pw.TextStyle(
                                  fontSize: 8,
                                  fontWeight: pw.FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              pw.Container(
                width: format.availableWidth,
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
                width: format.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: pw.Container(
                        height: 100,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 2.0),
                          child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Row(
                                children: [
                                  pw.Container(
                                    width: 30,
                                    padding: const pw.EdgeInsets.all(2.0),
                                    child: pw.Text('M/s. ',
                                        style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.bold)),
                                  ),
                                  pw.Text(
                                    '${fectedLedgers.firstWhere((ledger) => ledger.id == _SalesEntry!.party).name} ',
                                    textAlign: pw.TextAlign.start,
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 8),
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 5),
                              pw.Row(
                                children: [
                                  pw.Container(
                                    width: 30,
                                    padding: const pw.EdgeInsets.all(2.0),
                                    child: pw.Text('',
                                        style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.bold)),
                                  ),
                                  pw.SizedBox(
                                    width: 150,
                                    child: pw.Text(
                                      fectedLedgers
                                          .firstWhere((ledger) =>
                                              ledger.id == _SalesEntry!.party)
                                          .address,
                                      maxLines: 3,
                                      textAlign: pw.TextAlign.start,
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.normal,
                                          fontSize: 8),
                                    ),
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 15),
                              pw.Row(
                                children: [
                                  pw.Container(
                                    width: 30,
                                    padding: const pw.EdgeInsets.all(2.0),
                                    child: pw.Text('',
                                        style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.bold)),
                                  ),
                                  pw.SizedBox(
                                    width: 150,
                                    child: pw.Text(
                                      'Mob : ${fectedLedgers.firstWhere((ledger) => ledger.id == _SalesEntry!.party).mobile}',
                                      maxLines: 3,
                                      textAlign: pw.TextAlign.start,
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.normal,
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
                                    padding: const pw.EdgeInsets.all(2.0),
                                    child: pw.Text('',
                                        style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.bold)),
                                  ),
                                  pw.SizedBox(
                                    width: 150,
                                    child: pw.Text(
                                      'GSTIN : ${fectedLedgers.firstWhere((ledger) => ledger.id == _SalesEntry!.party).gst}',
                                      maxLines: 3,
                                      textAlign: pw.TextAlign.start,
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.normal,
                                          fontSize: 8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(2.0),
                          child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Row(
                                children: [
                                  pw.Container(
                                    width: 60,
                                    child: pw.Text(
                                      'Invoice No.   :   ',
                                      textAlign: pw.TextAlign.start,
                                      style: pw.TextStyle(
                                          fontSize: 8,
                                          fontWeight: pw.FontWeight.bold),
                                    ),
                                  ),
                                  pw.Container(
                                    width: 55,
                                    child: pw.Text(
                                      _SalesEntry!.dcNo,
                                      style: const pw.TextStyle(fontSize: 8),
                                    ),
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 5),
                              pw.Row(
                                children: [
                                  pw.Container(
                                    width: 60,
                                    child: pw.Text(
                                      'Invoice Date   :   ',
                                      textAlign: pw.TextAlign.start,
                                      style: const pw.TextStyle(
                                        fontSize: 8,
                                      ),
                                    ),
                                  ),
                                  pw.Container(
                                    width: 55,
                                    child: pw.Text(
                                      _SalesEntry!.date,
                                      style: const pw.TextStyle(fontSize: 8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              pw.Container(
                width: format.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Expanded(
                  child: pw.Row(
                    children: [
                      pw.Container(
                        width: 20,
                        height: 20,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Sr. No.',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 150,
                        height: 20,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            'Description',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 35,
                        height: 20,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            'HSN',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 35,
                        height: 20,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            'QTY',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 23,
                        height: 20,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            'Unit',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 35,
                        height: 20,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            'Rate',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 35,
                        height: 20,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            'Basic Price',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 50,
                        height: 20,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            'Assessable Value',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 35,
                        height: 20,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            'GST%',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 50,
                        height: 20,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            'Amount',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              pw.Container(
                // height: 250,
                width: format.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.ListView(
                  children: _SalesEntry!.entries.map((sale) {
                    // Fetch the item name (assuming this is already done before building the PDF)
                    Item? item = fectedItems.firstWhere(
                      (item) => item.id == sale.itemName,
                    );
                    HSNCode? hsnCode = fectedHsn.firstWhere(
                      (hsn) => hsn.id == item?.hsnCode,
                    );

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
                              width: 20,
                              height: 20,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  (counter++).toString(),
                                  textAlign: pw.TextAlign.center,
                                  style: const pw.TextStyle(fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 150,
                              height: 20,
                              child: pw.Center(
                                // padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  item != null
                                      ? item.itemName
                                      : 'Item not found',
                                  style: const pw.TextStyle(fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 35,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  hsnCode?.hsn ?? 'Hsn not found',
                                  textAlign: pw.TextAlign.center,
                                  style: const pw.TextStyle(fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 35,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  '${sale.qty}',
                                  textAlign: pw.TextAlign.center,
                                  style: const pw.TextStyle(fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 23,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  '${sale.unit}',
                                  textAlign: pw.TextAlign.center,
                                  style: const pw.TextStyle(fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 35,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  sale.netAmount.toStringAsFixed(2),
                                  textAlign: pw.TextAlign.center,
                                  style: const pw.TextStyle(fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 35,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  (sale.qty * sale.rate).toStringAsFixed(2),
                                  textAlign: pw.TextAlign.center,
                                  style: const pw.TextStyle(fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 50,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  (sale.qty * sale.rate).toStringAsFixed(
                                      2), // Calculate qty * rate
                                  textAlign: pw.TextAlign.center,
                                  style: const pw.TextStyle(fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 35,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  sale.tax,
                                  textAlign: pw.TextAlign.center,
                                  style: const pw.TextStyle(fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 50,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  sale.amount.toStringAsFixed(2),
                                  textAlign: pw.TextAlign.center,
                                  style: const pw.TextStyle(fontSize: 8),
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
              //total
              pw.Container(
                width: format.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Expanded(
                  child: pw.Row(
                    children: [
                      pw.Container(
                        width: 20,
                        height: 15,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          '',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 150,
                        height: 15,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        padding: const pw.EdgeInsets.all(2.0),
                        child: pw.Text(
                          'Total',
                          textAlign: pw.TextAlign.start,
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 35,
                        height: 15,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            '',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 35,
                        height: 15,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        padding: const pw.EdgeInsets.all(2.0),
                        child: pw.Text(
                          totalQty.toStringAsFixed(2),
                          textAlign: pw.TextAlign.end,
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 23,
                        height: 15,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            '',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 35,
                        height: 15,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            '',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 35,
                        height: 15,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            '',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 50,
                        height: 15,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            '',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 35,
                        height: 15,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            '',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 50,
                        height: 15,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            '',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              pw.Container(
                width: format.availableWidth,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: pw.Container(
                        height: 200,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Container(
                          width: 300,
                          decoration: pw.BoxDecoration(
                            color: PdfColors.white,
                            border: pw.Border.all(color: PdfColors.black),
                          ),
                          child: pw.Column(
                            children: [
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Container(
                                    width: 40,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.all(2.0),
                                      child: pw.Text(
                                        'GST %',
                                        textAlign: pw.TextAlign.center,
                                        style: pw.TextStyle(
                                          color: PdfColors.grey,
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 6,
                                        ),
                                      ),
                                    ),
                                  ),
                                  pw.Container(
                                    width: 45,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.all(2.0),
                                      child: pw.Text(
                                        'Taxable',
                                        textAlign: pw.TextAlign.end,
                                        style: pw.TextStyle(
                                          color: PdfColors.grey,
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 6,
                                        ),
                                      ),
                                    ),
                                  ),
                                  pw.Container(
                                    width: 45,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.all(2.0),
                                      child: pw.Text(
                                        'IGST',
                                        textAlign: pw.TextAlign.end,
                                        style: pw.TextStyle(
                                          color: PdfColors.grey,
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 6,
                                        ),
                                      ),
                                    ),
                                  ),
                                  pw.Container(
                                    width: 45,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.all(2.0),
                                      child: pw.Text(
                                        'CGST',
                                        textAlign: pw.TextAlign.end,
                                        style: pw.TextStyle(
                                          color: PdfColors.grey,
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 6,
                                        ),
                                      ),
                                    ),
                                  ),
                                  pw.Container(
                                    width: 45,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.all(2.0),
                                      child: pw.Text(
                                        'SGST',
                                        textAlign: pw.TextAlign.end,
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          color: PdfColors.grey,
                                          fontSize: 6,
                                        ),
                                      ),
                                    ),
                                  ),
                                  pw.Container(
                                    width: 45,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.all(2.0),
                                      child: pw.Text(
                                        'Total',
                                        textAlign: pw.TextAlign.end,
                                        style: pw.TextStyle(
                                          color: PdfColors.grey,
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 6,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  pw.ListView(
                                    children: _SalesEntry!.entries.map((sale) {
                                      return pw.Table(
                                        border: pw.TableBorder.all(),
                                        children: [
                                          pw.TableRow(
                                            children: [
                                              pw.SizedBox(
                                                width: 40,
                                                child: pw.Padding(
                                                  padding:
                                                      const pw.EdgeInsets.all(
                                                          2.0),
                                                  child: pw.Text(
                                                    sale.tax,
                                                    textAlign:
                                                        pw.TextAlign.center,
                                                    style: const pw.TextStyle(
                                                        fontSize: 6),
                                                  ),
                                                ),
                                              ),
                                              pw.SizedBox(
                                                width: 45,
                                                child: pw.Padding(
                                                  padding:
                                                      const pw.EdgeInsets.all(
                                                          2.0),
                                                  child: pw.Text(
                                                    (sale.qty * sale.rate)
                                                        .toStringAsFixed(2),
                                                    textAlign: pw.TextAlign.end,
                                                    style: const pw.TextStyle(
                                                        fontSize: 6),
                                                  ),
                                                ),
                                              ),
                                              pw.SizedBox(
                                                width: 45,
                                                child: pw.Padding(
                                                  padding:
                                                      const pw.EdgeInsets.all(
                                                          2.0),
                                                  child: pw.Text(
                                                    '0.00',
                                                    textAlign: pw.TextAlign.end,
                                                    style: const pw.TextStyle(
                                                        fontSize: 6),
                                                  ),
                                                ),
                                              ),
                                              pw.SizedBox(
                                                width: 45,
                                                child: pw.Padding(
                                                  padding:
                                                      const pw.EdgeInsets.all(
                                                          2.0),
                                                  child: pw.Text(
                                                    sale.cgst
                                                        .toStringAsFixed(2),
                                                    textAlign: pw.TextAlign.end,
                                                    style: const pw.TextStyle(
                                                        fontSize: 6),
                                                  ),
                                                ),
                                              ),
                                              pw.SizedBox(
                                                width: 45,
                                                child: pw.Padding(
                                                  padding:
                                                      const pw.EdgeInsets.all(
                                                          2.0),
                                                  child: pw.Text(
                                                    sale.sgst
                                                        .toStringAsFixed(2),
                                                    textAlign: pw.TextAlign.end,
                                                    style: const pw.TextStyle(
                                                        fontSize: 6),
                                                  ),
                                                ),
                                              ),
                                              pw.SizedBox(
                                                width: 45,
                                                child: pw.Padding(
                                                  padding:
                                                      const pw.EdgeInsets.all(
                                                          2.0),
                                                  child: pw.Text(
                                                    sale.netAmount
                                                        .toStringAsFixed(2),
                                                    textAlign: pw.TextAlign.end,
                                                    style: const pw.TextStyle(
                                                        fontSize: 6),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Container(
                                    width: 40,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.all(2.0),
                                      child: pw.Text(
                                        'Total',
                                        textAlign: pw.TextAlign.center,
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 6,
                                        ),
                                      ),
                                    ),
                                  ),
                                  pw.Container(
                                    width: 45,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.all(2.0),
                                      child: pw.Text(
                                        totalAmount.toStringAsFixed(2),
                                        textAlign: pw.TextAlign.end,
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 6,
                                        ),
                                      ),
                                    ),
                                  ),
                                  pw.Container(
                                    width: 45,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.all(2.0),
                                      child: pw.Text(
                                        '0.00',
                                        textAlign: pw.TextAlign.end,
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 6,
                                        ),
                                      ),
                                    ),
                                  ),
                                  pw.Container(
                                    width: 45,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.all(2.0),
                                      child: pw.Text(
                                        totalcgst.toStringAsFixed(2),
                                        textAlign: pw.TextAlign.end,
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 6,
                                        ),
                                      ),
                                    ),
                                  ),
                                  pw.Container(
                                    width: 45,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.all(2.0),
                                      child: pw.Text(
                                        totalsgst.toStringAsFixed(2),
                                        textAlign: pw.TextAlign.end,
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 6,
                                        ),
                                      ),
                                    ),
                                  ),
                                  pw.Container(
                                    width: 45,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.all(2.0),
                                      child: pw.Text(
                                        totalNetAmount.toStringAsFixed(2),
                                        textAlign: pw.TextAlign.end,
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
                          ),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        height: 200,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Column(
                          children: [
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: 58.5,
                                  height: 20,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(),
                                  ),
                                ),
                                pw.Container(
                                  width: 58.5,
                                  height: 20,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(),
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

              //BANK
              pw.Container(
                width: format.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Container(
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
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 10),
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
                                          fontSize: 8),
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  width: 106,
                                  height: 13,
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
                                      fectedLedgers
                                          .firstWhere((ledger) =>
                                              ledger.id == _SalesEntry!.party)
                                          .bankName,
                                      style: const pw.TextStyle(fontSize: 8),
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
                                          fontSize: 8),
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  width: 106,
                                  height: 13,
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
                                      fectedLedgers
                                          .firstWhere((ledger) =>
                                              ledger.id == _SalesEntry!.party)
                                          .branchName,
                                      style: const pw.TextStyle(fontSize: 8),
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
                                          fontSize: 8),
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  width: 106,
                                  height: 13,
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
                                      fectedLedgers
                                          .firstWhere((ledger) =>
                                              ledger.id == _SalesEntry!.party)
                                          .accNo,
                                      style: const pw.TextStyle(fontSize: 8),
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
                                          fontSize: 8),
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  width: 106,
                                  height: 13,
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
                                      fectedLedgers
                                          .firstWhere((ledger) =>
                                              ledger.id == _SalesEntry!.party)
                                          .ifsc,
                                      style: const pw.TextStyle(fontSize: 8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Container(
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
                                      fectedLedgers
                                          .firstWhere((ledger) =>
                                              ledger.id == _SalesEntry!.party)
                                          .openingBalance
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
                    pw.Expanded(
                      child: pw.Container(
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            left: pw.BorderSide(),
                            bottom: pw.BorderSide(),
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
                                    style: const pw.TextStyle(fontSize: 6),
                                  ),
                                ),
                                pw.Spacer(),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    totalValue.toStringAsFixed(2),
                                    style: const pw.TextStyle(fontSize: 6),
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
                                    style: const pw.TextStyle(fontSize: 6),
                                  ),
                                ),
                                pw.Spacer(),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    totalsgst.toStringAsFixed(2),
                                    style: const pw.TextStyle(fontSize: 6),
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
                                    style: const pw.TextStyle(fontSize: 6),
                                  ),
                                ),
                                pw.Spacer(),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    totalcgst.toStringAsFixed(2),
                                    style: const pw.TextStyle(fontSize: 6),
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
                                        fontSize: 8,
                                        fontWeight: pw.FontWeight.bold),
                                  ),
                                ),
                                pw.Spacer(),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    totalNetAmount.toStringAsFixed(2),
                                    style: pw.TextStyle(
                                        fontSize: 8,
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
                width: format.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Expanded(
                  child: pw.Row(
                    children: [
                      pw.Container(
                        width: 93.4,
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
                        width: 93.6,
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
                        width: 93.6,
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
                        width: 93.6,
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
                        width: 93.6,
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

              pw.Container(
                width: format.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.ListView(
                  children: _SalesEntry!.entries.map((sale) {
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
                                  '${sale.tax}% GST',
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 6),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 92,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  (sale.qty * sale.rate).toStringAsFixed(2),
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 6),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 92,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  sale.sgst.toStringAsFixed(2),
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 6),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 92,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  sale.cgst.toStringAsFixed(2),
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 6),
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
                                      fontSize: 6),
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

              //Term's and Conditions
              pw.Container(
                width: format.availableWidth,
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
                      width: 300,
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
                                fontSize: 6,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              '- Goods once sold wifi not be taken back or exchanged.',
                              style: const pw.TextStyle(
                                fontSize: 6,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              '- Goods once sold wifi not be taken back or exchanged.',
                              style: const pw.TextStyle(
                                fontSize: 6,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              '- Goods once sold wifi not be taken back or exchanged.',
                              style: const pw.TextStyle(
                                fontSize: 6,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              '- Goods once sold wifi not be taken back or exchanged.',
                              style: const pw.TextStyle(
                                fontSize: 6,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              '- Goods once sold wifi not be taken back or exchanged.',
                              style: const pw.TextStyle(
                                fontSize: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Container(
                      width: 200,
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                            width: 167,
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
                                  width: 50,
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
                            width: 167,
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
