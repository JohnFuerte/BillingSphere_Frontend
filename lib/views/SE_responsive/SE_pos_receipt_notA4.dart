import 'dart:typed_data';

import 'package:billingsphere/data/models/item/item_model.dart';
import 'package:flutter/material.dart';
import 'package:indian_currency_to_word/indian_currency_to_word.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/hsn/hsn_model.dart';
import '../../data/models/newCompany/new_company_model.dart';
import '../../data/models/salesPos/sales_pos_model.dart';
import '../../data/repository/hsn_repository.dart';
import '../../data/repository/item_repository.dart';
import '../../data/repository/new_company_repository.dart';

class SePosReceiptNota4 extends StatefulWidget {
  final SalesPos sales;
  const SePosReceiptNota4({super.key, required this.sales});

  @override
  State<SePosReceiptNota4> createState() => _SePosReceiptNota4State();
}

class _SePosReceiptNota4State extends State<SePosReceiptNota4> {
  // Variables
  List<Uint8List> _selectedImages = [];
  List<Uint8List> _selectedImages2 = [];
  List<Item> fectedItems = [];
  List<HSNCode> fectedHsn = [];
  final converter = AmountToWords();

  List<String>? companyCode;
  bool isLoading = false;
  SalesPos? _SalesEntry;

  // Data
  List<NewCompany> selectedComapny = [];

  // Repos
  NewCompanyRepository newCompanyRepo = NewCompanyRepository();
  ItemsService itemsService = ItemsService();
  HSNCodeService hsnCodeService = HSNCodeService();

  Future<List<String>?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('companies');
  }

  Future<void> setCompanyCode() async {
    List<String>? code = await getCompanyCode();
    companyCode = code;
  }

  Future<void> _initializeData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Future.wait([
        setCompanyCode(),
        fetchNewCompany(),
        fetchItems(),
        fetchHsn(),
      ]);
    } catch (e) {
      print("Error $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _SalesEntry = widget.sales;
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : PdfPreview(
              allowPrinting: true,
              canChangeOrientation: false,
              canChangePageFormat: false,
              canDebug: false,
              initialPageFormat: PdfPageFormat.roll80,
              enableScrollToPage: true,
              build: (format) => _generatePdf(format, 'SALES POS RECEIPT'),
            ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(
      version: PdfVersion.pdf_1_5,
      compress: true,
      pageMode: PdfPageMode.fullscreen,
    );
    // PDF FORMAT
    const customFormat = PdfPageFormat.roll80;

    final String formattedDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(_SalesEntry!.createdAt!));

    pdf.addPage(
      pw.Page(
        pageFormat: customFormat,
        clip: true,
        margin: const pw.EdgeInsets.all(2),
        orientation: pw.PageOrientation.portrait,
        build: (context) {
          return pw.Container(
            // color: MaterialColor(primary, swatch),
            width: format.width,
            decoration: pw.BoxDecoration(
                color: PdfColors.white,
                border: pw.Border.all(color: PdfColors.black)),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Logo or Image Section
                _selectedImages.isNotEmpty
                    ? pw.Center(
                        child: pw.Image(
                          pw.MemoryImage(_selectedImages[0]),
                          height: 40,
                          width: 40,
                        ),
                      )
                    : pw.SizedBox(width: 50),

                pw.SizedBox(height: 10),

                // Company Information Section
                pw.Center(
                  child: pw.Text(
                    selectedComapny.first.companyName!,
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  selectedComapny
                      .firstWhere((company) => company.stores!.any(
                          (store) => store.code == _SalesEntry!.companyCode))
                      .stores!
                      .firstWhere(
                          (store) => store.code == _SalesEntry!.companyCode)
                      .address,
                  maxLines: 3,
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 7),
                ),
                pw.SizedBox(height: 5),
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'GSTIN: ${selectedComapny.first.gstin}',
                        style: const pw.TextStyle(fontSize: 7),
                      ),
                      pw.Text(
                        'PAN: ${selectedComapny.first.pan}',
                        style: const pw.TextStyle(fontSize: 7),
                      ),
                      pw.Text(
                        'E-mail: ${selectedComapny.firstWhere((company) => company.stores!.any((store) => store.code == _SalesEntry!.companyCode)).stores!.firstWhere((store) => store.code == _SalesEntry!.companyCode).email}',
                        style: const pw.TextStyle(fontSize: 7),
                      ),
                      pw.Text(
                        'Mo.: ${selectedComapny.firstWhere((company) => company.stores!.any((store) => store.code == _SalesEntry!.companyCode)).stores!.firstWhere((store) => store.code == _SalesEntry!.companyCode).phone}',
                        style: const pw.TextStyle(fontSize: 7),
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 10),
                pw.SizedBox(
                  child: pw.Row(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          'BILL NO: ${_SalesEntry!.no.toString()}',
                          style: pw.TextStyle(
                            fontWeight:
                                pw.FontWeight.bold, // Bold text for emphasis
                            fontSize: 7, // Font size for table content
                          ),
                        ),
                      ),
                      pw.Spacer(),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          'BILL Date: $formattedDate',
                          style: pw.TextStyle(
                            fontWeight:
                                pw.FontWeight.bold, // Bold text for emphasis
                            fontSize: 7, // Font size for table content
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                pw.SizedBox(height: 10),

                // Table Header
                pw.Container(
                  child: pw.Row(
                    children: [
                      _buildTableHeaderCell('Item', 90),
                      _buildTableHeaderCell('HSN', 35),
                      _buildTableHeaderCell('Qty', 25),
                      _buildTableHeaderCell('Rate', 35),
                      _buildTableHeaderCell('Total', 35),
                    ],
                  ),
                ),

                pw.ListView(
                  children: _SalesEntry!.entries.map((sale) {
                    Item? item = fectedItems.firstWhere(
                      (item) => item.id == sale.itemName,
                    );

                    HSNCode? hsnCode = fectedHsn.firstWhere(
                      (hsn) => hsn.id == item?.hsnCode,
                    );

                    return pw.Table(
                      border: pw.TableBorder.all(),
                      children: [
                        pw.TableRow(
                          children: [
                            _buildTableCell(
                                item.itemName.isNotEmpty
                                    ? item.itemName
                                    : 'Item not found',
                                90,
                                pw.Alignment.centerLeft),
                            _buildTableCell(
                                hsnCode.hsn, 35, pw.Alignment.center),
                            _buildTableCell(
                                '${sale.qty}', 25, pw.Alignment.center),
                            _buildTableCell(sale.amount.toStringAsFixed(2), 35,
                                pw.Alignment.center),
                            _buildTableCell(sale.netAmount.toStringAsFixed(2),
                                35, pw.Alignment.center),
                          ],
                        ),
                      ],
                    );
                  }).toList(),
                ),
                pw.SizedBox(
                    height:
                        10), // Spacing between the table and the totals section
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Total Amount (in numbers): Rs. ${_SalesEntry!.totalAmount.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(
                        height: 5), // Space between the number and the words
                    pw.Text(
                      'Total Amount (in words): ${converter.convertAmountToWords(_SalesEntry!.totalAmount, ignoreDecimal: false)}',
                      style: pw.TextStyle(
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20), // Adding some space before the text

                pw.Container(
                  width: format.availableWidth,
                  alignment: pw.Alignment.center, // Center the text
                  child: pw.Text(
                    'Thanks for your patronage!',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    return pdf.save();
  }

  pw.Widget _buildTableCell(String text, double width, pw.Alignment alignment) {
    return pw.SizedBox(
      width: width,
      child: pw.Padding(
        padding: const pw.EdgeInsets.all(2.0), // Padding for each cell
        child: pw.Text(
          text,
          maxLines: 2,
          overflow: pw.TextOverflow.clip,
          textAlign: pw.TextAlign.center, // Center-align text within the cell
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold, // Bold text for emphasis
            fontSize: 8, // Font size for table content
          ),
        ),
      ),
    );
  }

  pw.Widget _buildTableHeaderCell(String text, double width) {
    return pw.Container(
      width: width,
      height: 10, // Adjust the height as needed
      alignment: pw.Alignment.center, // Center align the content
      decoration: pw.BoxDecoration(
        border:
            pw.Border.all(color: PdfColors.black), // Ensure borders are tight
      ),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 8.5,
        ),
      ),
    );
  }
  // Future Functions...

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

  Future<void> fetchHsn() async {
    try {
      final List<HSNCode> hsn = await hsnCodeService.fetchItemHSN();
      fectedHsn = hsn;
    } catch (error) {
      print('Failed to fetch Hsn Code: $error');
    }
  }

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
}
