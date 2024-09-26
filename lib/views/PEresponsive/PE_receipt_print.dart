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
import '../../data/models/newCompany/new_company_model.dart';
import '../../data/models/purchase/purchase_model.dart';
import '../../data/repository/hsn_repository.dart';
import '../../data/repository/item_repository.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/new_company_repository.dart';
import '../../data/repository/purchase_repository.dart';

class PurchasePrintBigReceipt extends StatefulWidget {
  const PurchasePrintBigReceipt(this.title,
      {super.key, required this.purchaseID});
  final String purchaseID;

  final String title;

  @override
  State<PurchasePrintBigReceipt> createState() =>
      _PurchasePrintBigReceiptState();
}

class _PurchasePrintBigReceiptState extends State<PurchasePrintBigReceipt> {
  LedgerService ledgerService = LedgerService();

  PurchaseServices purchaseService = PurchaseServices();
  ItemsService itemsService = ItemsService();
  HSNCodeService hsnCodeService = HSNCodeService();
  Purchase? _PurchaseEntry;
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

  Future<void> fetchPurchaseById() async {
    final purchase = await purchaseService.fetchPurchaseById(widget.purchaseID);
    setState(() {
      _PurchaseEntry = purchase;
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
      await setCompanyCode();
      await fetchLedger();
      await fetchItems();
      await fetchHsn();
      await fetchNewCompany();
      await fetchPurchaseById();
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
    int totalItems = _PurchaseEntry!.entries.length;
    int totalQuantity =
        _PurchaseEntry!.entries.map((e) => e.qty).reduce((a, b) => a + b);
    double totalValue = 0.0;
    double totalAmount = 0.0;
    double totalsgst = 0.0;
    double totalcgst = 0.0;
    double totalNetAmount = 0.0;
    double totalDiscount = 0.0;
    for (var entry in _PurchaseEntry!.entries) {
      totalValue += entry.qty * entry.rate;
      totalAmount += entry.amount;
      totalNetAmount += entry.netAmount;
      totalsgst += entry.sgst;
      totalcgst += entry.cgst;
      totalDiscount += entry.discount;
    }

    // Calculate roundedValue and roundOff
    int roundedValue = totalNetAmount.truncate(); // Integer part
    double roundOff = totalNetAmount - roundedValue; // Decimal part

    int counter = 1; // Initialize a counter variable outside the map function

    // @override
    // void initState() {
    //   super.initState();
    //   fetchSalesById();
    // }
    final customFormat = PdfPageFormat.a4.copyWith(
      marginLeft: 20,
      marginRight: 20,
      marginTop: 20,
      marginBottom: 20,
    );
    final converter = AmountToWords();

    final upi = selectedComapny
        .firstWhere((company) => company.stores!
            .any((store) => store.code == _PurchaseEntry!.companyCode))
        .stores!
        .firstWhere((store) => store.code == _PurchaseEntry!.companyCode)
        .upi;

    final accountName = selectedComapny
        .firstWhere((company) => company.stores!
            .any((store) => store.code == _PurchaseEntry!.companyCode))
        .stores!
        .firstWhere((store) => store.code == _PurchaseEntry!.companyCode)
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
                          width: 40,
                          child: _selectedImages.isNotEmpty
                              ? pw.Image(pw.MemoryImage(_selectedImages[0]))
                              : pw.SizedBox(width: 50),
                        ),
                        pw.Spacer(),
                        pw.Container(
                          width: 300,
                          child: pw.Center(
                            child: pw.Column(
                              children: [
                                pw.Text(
                                  selectedComapny.first.companyName!,
                                  style: pw.TextStyle(
                                      fontSize: 16,
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
                                              _PurchaseEntry!.companyCode))
                                      .stores!
                                      .firstWhere((store) =>
                                          store.code ==
                                          _PurchaseEntry!.companyCode)
                                      .address,
                                  // selectedComapny.first.stores!.first.address,
                                  maxLines: 3,
                                  textAlign: pw.TextAlign.center,
                                  softWrap: true,
                                  style: const pw.TextStyle(fontSize: 8),
                                ),
                                pw.SizedBox(height: 2),

                                pw.Text(
                                  'E-mail: ${selectedComapny.firstWhere((company) => company.stores!.any((store) => store.code == _PurchaseEntry!.companyCode)).stores!.firstWhere((store) => store.code == _PurchaseEntry!.companyCode).email}, Mo. ${selectedComapny.firstWhere((company) => company.stores!.any((store) => store.code == _PurchaseEntry!.companyCode)).stores!.firstWhere((store) => store.code == _PurchaseEntry!.companyCode).phone}',
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
                          width: 40,
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
                                  fontSize: 8,
                                  fontWeight: pw.FontWeight.normal),
                            ),
                          ),
                          pw.Spacer(),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              'State : ${selectedComapny.firstWhere((company) => company.stores!.any((store) => store.code == _PurchaseEntry!.companyCode)).stores!.firstWhere((store) => store.code == _PurchaseEntry!.companyCode).state}',
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
                          '${_PurchaseEntry!.type} MEMO',
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
                          'PURCHASE INVOICE',
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
                                    child: pw.Text('To, ',
                                        style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.bold)),
                                  ),
                                  pw.Text(
                                    '${fectedLedgers.firstWhere((ledger) => ledger.id == _PurchaseEntry!.ledger).name} ',
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
                                    child: pw.Text(
                                      '',
                                      style: pw.TextStyle(
                                          fontSize: 8,
                                          fontWeight: pw.FontWeight.bold),
                                    ),
                                  ),
                                  pw.SizedBox(
                                    width: 150,
                                    child: pw.Text(
                                      fectedLedgers
                                          .firstWhere((ledger) =>
                                              ledger.id ==
                                              _PurchaseEntry!.ledger)
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
                                      'Mob : ${fectedLedgers.firstWhere((ledger) => ledger.id == _PurchaseEntry!.ledger).mobile}',
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
                                      'GSTIN : ${fectedLedgers.firstWhere((ledger) => ledger.id == _PurchaseEntry!.ledger).gst}',
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
                                      _PurchaseEntry!.billNumber,
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
                                      _PurchaseEntry!.date,
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
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Expanded(
                  child: pw.Row(
                    children: [
                      pw.Container(
                        width: 20.9,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Sr',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 174.5,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Particulars',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 65.2,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'HSN',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 31.3,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Qty',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 53.5,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Rate',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 71,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Amt. incl. Tax',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10),
                        ),
                      ),
                      pw.Container(
                        width: 67,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Disc.',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 71.8,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Net Amount',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.Container(
                height: 310,
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.ListView(
                  children: _PurchaseEntry!.entries.map((purchase) {
                    // Fetch the item name (assuming this is already done before building the PDF)
                    Item? item = fectedItems.firstWhere(
                      (item) => item.id == purchase.itemName,
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
                              width: 167,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  item != null
                                      ? item.itemName
                                      : 'Item not found',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 62.5,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  hsnCode?.hsn ?? 'Hsn not found',
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
                                  '${purchase.qty}',
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 51,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  purchase.rate.toStringAsFixed(2),
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 68,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  ((purchase.qty * purchase.rate) +
                                          purchase.sgst +
                                          purchase.cgst)
                                      .toStringAsFixed(2),
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 64.3,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  purchase.discount.toStringAsFixed(2),
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 68.7,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  purchase.netAmount.toStringAsFixed(
                                      2), // Calculate qty * rate
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
                      width: 415,
                      height: 25,
                      child: pw.Row(
                        children: [
                          pw.Container(
                            width: 70,
                            child: pw.Text(
                              ' Rs. (in words) : ',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 8),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Container(
                            width: 345,
                            child: pw.Text(
                              converter.convertAmountToWords(
                                  roundedValue as double,
                                  ignoreDecimal: false),
                              maxLines: 2,
                              style: const pw.TextStyle(fontSize: 6),
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
                            fontSize: 10,
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
                        'Remarks: ${_PurchaseEntry!.remarks}',
                        style: const pw.TextStyle(
                          fontSize: 8,
                        ),
                      ),
                    ),
                  )
                ],
              )),

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
                      width: 222,
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
                                        fontSize: 8),
                                  ),
                                ),
                              ),
                              pw.Container(
                                width: 171,
                                height: 13.5,
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
                                                _PurchaseEntry!.companyCode))
                                        .stores!
                                        .firstWhere((store) =>
                                            store.code ==
                                            _PurchaseEntry!.companyCode)
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
                                width: 171,
                                height: 13.5,
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
                                                _PurchaseEntry!.companyCode))
                                        .stores!
                                        .firstWhere((store) =>
                                            store.code ==
                                            _PurchaseEntry!.companyCode)
                                        .branch,
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
                                width: 171,
                                height: 13.5,
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
                                                _PurchaseEntry!.companyCode))
                                        .stores!
                                        .firstWhere((store) =>
                                            store.code ==
                                            _PurchaseEntry!.companyCode)
                                        .accountNo,
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
                                width: 171,
                                height: 13.5,
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
                                                _PurchaseEntry!.companyCode))
                                        .stores!
                                        .firstWhere((store) =>
                                            store.code ==
                                            _PurchaseEntry!.companyCode)
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
                    pw.Container(
                      height: 65.5,
                      width: 193,
                      decoration: pw.BoxDecoration(border: pw.Border.all()),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Container(
                            height: 65.5,
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
                            height: 65.5,
                            width: 82.1,
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
                                              ledger.id ==
                                              _PurchaseEntry!.ledger)
                                          .debitBalance
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
                      width: 140,
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
                                    (totalValue - totalDiscount)
                                        .toStringAsFixed(2),
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
                            //         totalDiscount.toStringAsFixed(2),
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
                                    roundedValue.toStringAsFixed(2),
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

              pw.Container(
                height: 70,
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.ListView(
                  children: _PurchaseEntry!.entries
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
                              sale.qty * sale.rate;
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
                                      '$totalTaxableAmount',
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
                                      '$totalSGST',
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
                                      '$totalCGST',
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

              // pw.Container(
              //   width: format.availableWidth,
              //   decoration: pw.BoxDecoration(
              //     color: PdfColors.white,
              //     border: pw.Border.all(color: PdfColors.black),
              //   ),
              //   child: pw.ListView(
              //     children: _PurchaseEntry!.entries.map((sale) {
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
                                fontSize: 6,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          selectedComapny.first.tc1!.isNotEmpty
                              ? pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    '- ${selectedComapny.first.tc1}',
                                    style: const pw.TextStyle(
                                      fontSize: 6,
                                    ),
                                  ),
                                )
                              : pw.SizedBox(),
                          selectedComapny.first.tc2!.isNotEmpty
                              ? pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    '- ${selectedComapny.first.tc2}',
                                    style: const pw.TextStyle(
                                      fontSize: 6,
                                    ),
                                  ),
                                )
                              : pw.SizedBox(),
                          selectedComapny.first.tc3!.isNotEmpty
                              ? pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    '- ${selectedComapny.first.tc3}',
                                    style: const pw.TextStyle(
                                      fontSize: 6,
                                    ),
                                  ),
                                )
                              : pw.SizedBox(),
                          selectedComapny.first.tc4!.isNotEmpty
                              ? pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    '- ${selectedComapny.first.tc4}',
                                    style: const pw.TextStyle(
                                      fontSize: 6,
                                    ),
                                  ),
                                )
                              : pw.SizedBox(),
                          selectedComapny.first.tc5!.isNotEmpty
                              ? pw.Padding(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(
                                    '- ${selectedComapny.first.tc5}',
                                    style: const pw.TextStyle(
                                      fontSize: 6,
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
