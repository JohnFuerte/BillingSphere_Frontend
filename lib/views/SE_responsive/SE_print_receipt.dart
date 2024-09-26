import 'dart:typed_data';

import 'package:billingsphere/data/models/item/item_model.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/newCompany/new_company_model.dart';
import '../../data/models/salesEntries/sales_entrires_model.dart';
import '../../data/repository/item_repository.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/new_company_repository.dart';
import '../../data/repository/sales_enteries_repository.dart';

class Print extends StatefulWidget {
  const Print(this.title, {super.key, required this.sales});
  final String sales;

  final String title;

  @override
  State<Print> createState() => _PrintState();
}

class _PrintState extends State<Print> {
  LedgerService ledgerService = LedgerService();
  SalesEntryService salesService = SalesEntryService();
  ItemsService itemsService = ItemsService();
  SalesEntry? _SalesEntry;
  String? selectedId;
  bool isLoading = false;

  List<Item> fectedItems = [];

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
      print('Failed to fetch ledger name: $error');
    }
  }

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
      final List<NewCompany> newcom = await newCompanyRepo.getAllCompanies();
      final filteredNewCompany = newcom
          .where((newcompany) => newcompany.companyCode == companyCode!.first)
          .toList();

      setState(() {
        selectedComapny = filteredNewCompany;
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

  // void fetchItemById(String id) async {
  //   final _item = await itemsService.fetchItemById(id);
  //   setState(() {
  //     item = _item;
  //   });
  // }
  Future<void> _initializeData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await setCompanyCode();
      await fetchItems();
      await fetchNewCompany();
      await fetchSalesById();
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
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: PdfPreview(
              build: (format) => _generatePdf(format, widget.title),
            ),
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
    for (var entry in _SalesEntry!.entries) {
      totalValue += entry.qty * entry.rate;
      totalAmount += entry.amount;
      totalsgst += entry.sgst;
      totalcgst += entry.cgst;
    }

    // @override
    // void initState() {
    //   super.initState();
    //   fetchSalesById();
    // }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
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
                    pw.Center(
                      child: pw.Column(
                        children: [
                          pw.Text(
                            selectedComapny.first.companyName!,
                            style: pw.TextStyle(
                                fontSize: 18, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.Divider(),
                          // pw.Text(
                          //   'CIN No : 4354657687980909087',
                          //   style: pw.TextStyle(
                          //       fontSize: 8, fontWeight: pw.FontWeight.normal),
                          // ),
                          // pw.SizedBox(height: 2),
                          pw.Text(
                            'GSTIN : ${selectedComapny.first.gstin}',
                            style: pw.TextStyle(
                                fontSize: 8, fontWeight: pw.FontWeight.normal),
                          ),
                          // pw.SizedBox(height: 2),
                          // pw.Text(
                          //   'FSSAI No : 23456789765432',
                          //   style: pw.TextStyle(
                          //       fontSize: 8, fontWeight: pw.FontWeight.normal),
                          // ),
                        ],
                      ),
                    ),
                    pw.Divider(),
                    pw.Center(
                      child: pw.Column(
                        children: [
                          pw.Text(
                            '',
                            maxLines: 3,
                            softWrap: true,
                            style: const pw.TextStyle(fontSize: 8),
                          ),
                        ],
                      ),
                    ),
                    // pw.Center(
                    //   child: pw.Column(
                    //     children: [
                    //       pw.Text(
                    //         'GULMOHAR BUSINESS PARK',
                    //         style: pw.TextStyle(
                    //             fontSize: 10, fontWeight: pw.FontWeight.normal),
                    //       ),
                    //       pw.SizedBox(height: 5),
                    //       pw.Text(
                    //         '80 ft Rail nagar Main road,',
                    //         style: const pw.TextStyle(fontSize: 8),
                    //       ),
                    //       pw.SizedBox(height: 2),
                    //       pw.Text(
                    //         'Under Bridge, near Rail nagar,',
                    //         style: const pw.TextStyle(fontSize: 8),
                    //       ),
                    //       pw.SizedBox(height: 2),
                    //       pw.Text(
                    //         'Rajkot, Gujarat 360001',
                    //         style: const pw.TextStyle(fontSize: 8),
                    //       ),
                    //       pw.SizedBox(height: 2),
                    //       pw.Text(
                    //         'Phone : +91 9106752843',
                    //         style: const pw.TextStyle(fontSize: 8),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    pw.Divider(),
                    pw.Center(
                      child: pw.Column(
                        children: [
                          pw.Text(
                            'TAX INVOICE',
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Row(
                            children: [
                              pw.Text(
                                'BILL No : ${_SalesEntry!.dcNo}',
                                style: const pw.TextStyle(fontSize: 8),
                              ),
                              pw.Spacer(),
                              pw.Text(
                                'BILL Dt : ${_SalesEntry!.date}',
                                style: const pw.TextStyle(fontSize: 8),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    pw.Divider(),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        // pw.SizedBox(
                        //   width: 20,
                        //   child: pw.Text(
                        //     'HSN',
                        //     style: pw.TextStyle(
                        //         fontWeight: pw.FontWeight.bold, fontSize: 8),
                        //   ),
                        // ),
                        pw.SizedBox(
                          width: 60,
                          child: pw.Text(
                            'Particulars',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8),
                          ),
                        ),
                        pw.SizedBox(
                          width: 20,
                          child: pw.Text(
                            'Qty',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8),
                          ),
                        ),
                        pw.SizedBox(
                          width: 20,
                          child: pw.Text(
                            'Rate',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8),
                          ),
                        ),
                        pw.SizedBox(
                          width: 20,
                          child: pw.Text(
                            'Tax',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8),
                          ),
                        ),
                        pw.SizedBox(
                          width: 20,
                          child: pw.Text(
                            'Val.',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8),
                          ),
                        ),
                      ],
                    ),
                    pw.Divider(),
                    // for (var entry in _SalesEntry!.entries)
                    pw.ListView(
                        children: _SalesEntry!.entries.map((sale) {
                      // Fetch the item name (assuming this is already done before building the PDF)
                      Item? item = fectedItems.firstWhere(
                        (item) => item.id == sale.itemName,
                      );

                      return pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          // pw.SizedBox(
                          //   width: 20,
                          //   child: pw.Text(
                          //     item!.hsnCode,
                          //     style: pw.TextStyle(
                          //         fontWeight: pw.FontWeight.bold, fontSize: 8),
                          //   ),
                          // ),
                          pw.SizedBox(
                            width: 60,
                            child: pw.Text(
                              item != null ? item.itemName : 'Item not found',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 8),
                            ),
                          ),
                          pw.SizedBox(
                            width: 20,
                            child: pw.Text(
                              '${sale.qty}',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 8),
                            ),
                          ),
                          pw.SizedBox(
                            width: 30,
                            child: pw.Text(
                              sale.rate.toStringAsFixed(2),
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 8),
                            ),
                          ),
                          pw.SizedBox(
                            width: 20,
                            child: pw.Text(
                              '${sale.tax}%',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 8),
                            ),
                          ),
                          pw.SizedBox(
                            width: 30,
                            child: pw.Text(
                              sale.netAmount.toStringAsFixed(2),
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 8),
                            ),
                          ),
                        ],
                      );
                    }).toList()),
                    pw.Divider(),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Items: $totalItems',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 12),
                        ),
                        pw.Text(
                          'Qty: $totalQuantity',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 12),
                        ),
                        pw.Text(
                          // '${totalValue.toStringAsFixed(2)}',
                          double.parse(_SalesEntry!.totalamount)
                              .toStringAsFixed(2),
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    pw.Divider(),
                    pw.Text(
                        '---------- GST Breakup Details ------ (Amount INR)',
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Divider(),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.SizedBox(
                          width: 20,
                          child: pw.Text(
                            'GST',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8),
                          ),
                        ),
                        pw.SizedBox(
                          width: 30,
                          child: pw.Text(
                            'Txbl Amt',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8),
                          ),
                        ),
                        pw.SizedBox(
                          width: 30,
                          child: pw.Text(
                            'SGST',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8),
                          ),
                        ),
                        pw.SizedBox(
                          width: 30,
                          child: pw.Text(
                            'CGST',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8),
                          ),
                        ),
                        pw.SizedBox(
                          width: 30,
                          child: pw.Text(
                            'Total Amt.',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8),
                          ),
                        ),
                      ],
                    ),
                    pw.Divider(),
                    for (var entry in _SalesEntry!.entries)
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.SizedBox(
                            width: 20,
                            child: pw.Text(
                              '${entry.tax}%',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 8),
                            ),
                          ),
                          pw.SizedBox(
                            width: 30,
                            child: pw.Text(
                              '${entry.amount}',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 8),
                            ),
                          ),
                          pw.SizedBox(
                            width: 30,
                            child: pw.Text(
                              entry.sgst.toStringAsFixed(2),
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 8),
                            ),
                          ),
                          pw.SizedBox(
                            width: 30,
                            child: pw.Text(
                              entry.cgst.toStringAsFixed(2),
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 8),
                            ),
                          ),
                          pw.SizedBox(
                            width: 30,
                            child: pw.Text(
                              entry.netAmount.toStringAsFixed(2),
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 8),
                            ),
                          ),
                        ],
                      ),
                    pw.Divider(),
                    pw.Row(
                      children: [
                        pw.SizedBox(
                          width: 30,
                          child: pw.Text(
                            'T:',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8),
                          ),
                        ),
                        pw.SizedBox(
                          width: 42,
                          child: pw.Text(
                            totalAmount.toStringAsFixed(2),
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8),
                          ),
                        ),
                        pw.SizedBox(
                          width: 35,
                          child: pw.Text(
                            totalcgst.toStringAsFixed(2),
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8),
                          ),
                        ),
                        pw.SizedBox(
                          width: 35,
                          child: pw.Text(
                            totalsgst.toStringAsFixed(2),
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8),
                          ),
                        ),
                        pw.SizedBox(
                          width: 35,
                          child: pw.Text(
                            double.parse(_SalesEntry!.totalamount)
                                .toStringAsFixed(2),
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 8),
                          ),
                        ),
                      ],
                    ),
                    pw.Divider(),
                    pw.Text('--------- Amount Received From Customer --------',
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Divider(),
                    pw.Text('This is computer generated bill ',
                        style: pw.TextStyle(fontSize: 8)),
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
