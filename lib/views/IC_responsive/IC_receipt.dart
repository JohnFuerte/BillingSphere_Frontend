import 'dart:io';
import 'dart:typed_data';

import 'package:billingsphere/data/models/item/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/deliveryChallan/delivery_challan_model.dart';
import '../../data/models/hsn/hsn_model.dart';
import '../../data/models/inwardChallan/inward_challan_model.dart';
import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/newCompany/new_company_model.dart';
import '../../data/repository/delivery_challan_repository.dart';
import '../../data/repository/hsn_repository.dart';
import '../../data/repository/inward_challan_repository.dart';
import '../../data/repository/item_repository.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/new_company_repository.dart';

class ICReceipt extends StatefulWidget {
  const ICReceipt(this.title, {super.key, required this.inwardChallan});
  final String inwardChallan;

  final String title;

  @override
  State<ICReceipt> createState() => _ICReceiptState();
}

class _ICReceiptState extends State<ICReceipt> {
  LedgerService ledgerService = LedgerService();
  InwardChallanServices inwardService = InwardChallanServices();
  ItemsService itemsService = ItemsService();
  HSNCodeService hsnCodeService = HSNCodeService();
  InwardChallan? _inwardChallan;
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

  Future<void> fetchInwardChallanById() async {
    final inwards =
        await inwardService.fetchInwardChallanById(widget.inwardChallan);
    print('INWARD ${widget.inwardChallan}');
    setState(() {
      _inwardChallan = inwards;
      print('INWARD $inwards');
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

  Future<void> fetchNew() async {
    try {
      final List<NewCompany> newCompanys =
          await newCompanyRepo.getAllCompanies();
      setState(() {
        fectedNewCompany = newCompanys;
      });
    } catch (error) {
      print('Failed to fetch ledger name: $error');
    }
  }

  List<Uint8List> _selectedImages = [];
  List<Uint8List> _selectedImages2 = [];
  List<File> files = [];

  List<NewCompany> fectedNewCompany = [];

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
      await fetchNew();
      await fetchNewCompany();
      await fetchInwardChallanById();
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
    int totalItems = _inwardChallan!.entries.length;
    int totalQuantity =
        _inwardChallan!.entries.map((e) => e.qty).reduce((a, b) => a + b);
    double totalValue = 0.0;
    double totalAmount = 0.0;
    double totalsgst = 0.0;
    double totalcgst = 0.0;
    double totalNetAmount = 0.0;
    for (var entry in _inwardChallan!.entries) {
      totalValue += entry.qty * entry.rate;
      // totalAmount += entry.amount;
      totalNetAmount += entry.netAmount;
      // totalsgst += entry.sgst;
      // totalcgst += entry.cgst;
    }
    int counter = 1; // Initialize a counter variable outside the map function

    // @override
    // void initState() {
    //   super.initState();
    //   fetchSalesById();
    // }

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
                          '',
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
                          'INWARD CHALLAN',
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
                          '',
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
                                    child: pw.Text('Form, ',
                                        style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.bold)),
                                  ),
                                  pw.Text(
                                    '${fectedNewCompany.firstWhere((company) => company.companyCode == _inwardChallan!.type).companyName} - ${fectedNewCompany.firstWhere((company) => company.stores!.any((store) => store.code == _inwardChallan!.companyCode)).stores!.firstWhere((store) => store.code == _inwardChallan!.companyCode).city}',
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
                                      fectedNewCompany
                                          .firstWhere((company) =>
                                              company.stores!.any((store) =>
                                                  store.code ==
                                                  _inwardChallan!.companyCode))
                                          .stores!
                                          .firstWhere((store) =>
                                              store.code ==
                                              _inwardChallan!.companyCode)
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
                                      'Mob : ${fectedNewCompany.firstWhere((company) => company.stores!.any((store) => store.code == _inwardChallan!.companyCode)).stores!.firstWhere((store) => store.code == _inwardChallan!.companyCode).phone}',
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
                                  // pw.SizedBox(
                                  //   width: 150,
                                  //   child: pw.Text(
                                  //     'GSTIN : ${fectedLedgers.firstWhere((ledger) => ledger.id == _DeliveryChallan!.party).gst}',
                                  //     maxLines: 3,
                                  //     textAlign: pw.TextAlign.start,
                                  //     style: pw.TextStyle(
                                  //         fontWeight: pw.FontWeight.normal,
                                  //         fontSize: 8),
                                  //   ),
                                  // ),
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
                                      _inwardChallan!.dcNo,
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
                                      _inwardChallan!.date,
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
                        width: 180,
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
                        width: 50,
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
                        width: 50,
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
                        width: 51,
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
                        width: 50,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Dis%',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
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
                          'Amount',
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
                height: 400,
                width: format.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.ListView(
                  children: _inwardChallan!.entries.map((sale) {
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
                              width: 180,
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
                              width: 50,
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
                              width: 50,
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
                              width: 51,
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
                              width: 50,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  '0.00',
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 8),
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              width: 67,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(2.0),
                                child: pw.Text(
                                  (sale.qty * sale.rate).toStringAsFixed(
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
                width: format.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Container(
                        child: pw.Text(
                          'Total',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(2.0),
                          child: pw.Text(
                            totalValue.toStringAsFixed(2),
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                              decoration: pw.TextDecoration.underline,
                            ),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                          selectedComapny.first.tc4!.isNotEmpty
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
