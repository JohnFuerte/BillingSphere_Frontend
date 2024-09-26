// import 'dart:io';
// import 'dart:typed_data';

// import 'package:billingsphere/data/models/item/item_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../data/models/hsn/hsn_model.dart';
// import '../../data/models/ledger/ledger_model.dart';
// import '../../data/models/newCompany/new_company_model.dart';
// import '../../data/models/salesEntries/sales_entrires_model.dart';
// import '../../data/repository/hsn_repository.dart';
// import '../../data/repository/item_repository.dart';
// import '../../data/repository/ledger_repository.dart';
// import '../../data/repository/new_company_repository.dart';
// import '../../data/repository/sales_enteries_repository.dart';

// class PrintBigReceipt extends StatefulWidget {
//   const PrintBigReceipt(this.title, {super.key, required this.sales});
//   final String sales;

//   final String title;

//   @override
//   State<PrintBigReceipt> createState() => _PrintBigReceiptState();
// }

// class _PrintBigReceiptState extends State<PrintBigReceipt> {
//   LedgerService ledgerService = LedgerService();
//   SalesEntryService salesService = SalesEntryService();
//   ItemsService itemsService = ItemsService();
//   HSNCodeService hsnCodeService = HSNCodeService();
//   SalesEntry? _SalesEntry;
//   String? selectedId;
//   bool isLoading = false;
//   List<NewCompany> selectedComapny = [];
//   NewCompanyRepository newCompanyRepo = NewCompanyRepository();

//   List<Item> fectedItems = [];
//   List<HSNCode> fectedHsn = [];
//   List<Ledger> fectedLedgers = [];

//   List<String>? companyCode;
//   Future<List<String>?> getCompanyCode() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getStringList('companies');
//   }

//   Future<void> setCompanyCode() async {
//     List<String>? code = await getCompanyCode();
//     setState(() {
//       companyCode = code;
//     });
//   }

//   Future<void> fetchSalesById() async {
//     final sales = await salesService.fetchSalesById(widget.sales);
//     print(widget.sales);

//     setState(() {
//       _SalesEntry = sales;
//     });
//   }

//   Future<void> fetchItems() async {
//     try {
//       final List<Item> items = await itemsService.fetchItems();
//       setState(() {
//         fectedItems = items;
//       });
//     } catch (error) {
//       print('Failed to fetch Item name: $error');
//     }
//   }

//   Future<void> fetchHsn() async {
//     try {
//       final List<HSNCode> hsn = await hsnCodeService.fetchItemHSN();
//       setState(() {
//         fectedHsn = hsn;
//       });
//     } catch (error) {
//       print('Failed to fetch Hsn Code: $error');
//     }
//   }

//   Future<void> fetchLedger() async {
//     try {
//       final List<Ledger> ledgers = await ledgerService.fetchLedgers();
//       setState(() {
//         fectedLedgers = ledgers;
//       });
//     } catch (error) {
//       print('Failed to fetch ledger name: $error');
//     }
//   }

//   List<Uint8List> _selectedImages = [];
//   List<Uint8List> _selectedImages2 = [];
//   List<File> files = [];

//   Future<void> fetchNewCompany() async {
//     try {
//       final newcom = await newCompanyRepo.getAllCompanies();

//       final filteredCompany = newcom
//           .where((company) =>
//               company.stores!.any((store) => store.code == companyCode!.first))
//           .toList();
//       setState(() {
//         selectedComapny = filteredCompany;
//         _selectedImages =
//             filteredCompany.first.logo1!.map((e) => e.data).toList();
//         _selectedImages2 =
//             filteredCompany.first.logo2!.map((e) => e.data).toList();
//       });
//       // print(_selectedImages);
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: $error'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   Future<void> _initializeData() async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       await Future.wait([
//         setCompanyCode(),
//         fetchLedger(),
//         fetchItems(),
//         fetchHsn(),
//         fetchNewCompany(),
//         fetchSalesById(),
//       ]);
//     } catch (e) {
//       print(e);
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: isLoading
//           ? const Scaffold(
//               body: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             )
//           : Scaffold(
//               appBar: AppBar(
//                 leading: IconButton(
//                   icon: const Icon(Icons.arrow_back),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 title: Text(widget.title),
//                 centerTitle: true,
//               ),
//               body: PdfPreview(
//                 build: (format) => _generatePdf(format, widget.title),
//               ),
//             ),
//       debugShowCheckedModeBanner:
//           false, // Set to false to hide the debug banner
//     );
//   }

//   Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
//     final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
//     // final font = await PdfGoogleFonts.nunitoExtraLight();
//     int totalItems = _SalesEntry!.entries.length;
//     int totalQuantity =
//         _SalesEntry!.entries.map((e) => e.qty).reduce((a, b) => a + b);
//     double totalValue = 0.0;
//     double totalAmount = 0.0;
//     double totalsgst = 0.0;
//     double totalcgst = 0.0;
//     double totalNetAmount = 0.0;
//     for (var entry in _SalesEntry!.entries) {
//       totalValue += entry.qty * entry.rate;
//       totalAmount += entry.amount;
//       totalNetAmount += entry.netAmount;
//       totalsgst += entry.sgst;
//       totalcgst += entry.cgst;
//     }
//     int counter = 1; // Initialize a counter variable outside the map function

//     // final image = pw.MemoryImage(_selectedImages[0]);

//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (context) {
//           return pw.Column(
//             children: [
//               pw.Container(
//                 width: format.availableWidth,
//                 decoration: pw.BoxDecoration(
//                     color: PdfColors.white,
//                     border: pw.Border.all(color: PdfColors.black)),
//                 child: pw.Row(
//                   children: [
//                     pw.SizedBox(width: 2),
//                     pw.Container(
//                       width: 50,
//                       child: _selectedImages.isNotEmpty
//                           ? pw.Image(pw.MemoryImage(_selectedImages[0]))
//                           : pw.SizedBox(width: 50),
//                     ),
//                     pw.Container(
//                       width: 365,
//                       child: pw.Center(
//                         child: pw.Column(
//                           children: [
//                             pw.Text(
//                               selectedComapny.first.companyName!,
//                               style: pw.TextStyle(
//                                   fontSize: 24, fontWeight: pw.FontWeight.bold),
//                               textAlign: pw.TextAlign.right,
//                             ),
//                             pw.Text(
//                               '"${selectedComapny.first.tagline}"',
//                               style: pw.TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: pw.FontWeight.normal),
//                             ),
//                             pw.SizedBox(height: 5),
//                             pw.Text(
//                               selectedComapny.first.stores!.first.address,
//                               maxLines: 3,
//                               textAlign: pw.TextAlign.center,
//                               softWrap: true,
//                               style: const pw.TextStyle(fontSize: 12),
//                             ),
//                             pw.SizedBox(height: 2),
//                           ],
//                         ),
//                       ),
//                     ),
//                     pw.Container(
//                       width: 50,
//                       child: _selectedImages.isNotEmpty
//                           ? pw.Image(pw.MemoryImage(_selectedImages[0]))
//                           : pw.SizedBox(width: 50),
//                     ),
//                     pw.SizedBox(width: 2),
//                   ],
//                 ),
//               ),
             
//               pw.Container(
//                 width: format.availableWidth,
//                 decoration: pw.BoxDecoration(
//                   color: PdfColors.white,
//                   border: pw.Border.all(color: PdfColors.black),
//                 ),
//                 child: pw.Row(
//                   children: [
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.only(left: 2.0),
//                       child: pw.Text(
//                         'GSTIN : ${selectedComapny.first.gstin}',
//                         style: pw.TextStyle(
//                             fontSize: 14, fontWeight: pw.FontWeight.bold),
//                       ),
//                     ),
//                     pw.Spacer(),
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.only(right: 2.0),
//                       child: pw.Text(
//                         'PAN : ${selectedComapny.first.pan}',
//                         style: pw.TextStyle(
//                             fontSize: 14, fontWeight: pw.FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               pw.Container(
//                 width: format.availableWidth,
//                 decoration: pw.BoxDecoration(
//                   color: PdfColors.white,
//                   border: pw.Border.all(color: PdfColors.black),
//                 ),
//                 child: pw.Row(
//                   children: [
//                     pw.Expanded(
//                       child: pw.Container(
//                         decoration: const pw.BoxDecoration(
//                           border: pw.Border(
//                             right: pw.BorderSide(),
//                           ),
//                         ),
//                         child: pw.Text(
//                           '${_SalesEntry!.type} MEMO',
//                           style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                           textAlign: pw.TextAlign.center,
//                         ),
//                       ),
//                     ),
//                     pw.Expanded(
//                       child: pw.Container(
//                         child: pw.Text(
//                           'TAX INVOICE',
//                           style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                           textAlign: pw.TextAlign.center,
//                         ),
//                       ),
//                     ),
//                     pw.Expanded(
//                       child: pw.Container(
//                         decoration: const pw.BoxDecoration(
//                           border: pw.Border(
//                             left: pw.BorderSide(),
//                           ),
//                         ),
//                         child: pw.Text(
//                           'ORIGINAL',
//                           style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                           textAlign: pw.TextAlign.center,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               pw.Container(
//                 width: format.availableWidth,
//                 decoration: pw.BoxDecoration(
//                   color: PdfColors.white,
//                   border: pw.Border.all(color: PdfColors.black),
//                 ),
//                 child: pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.start,
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Expanded(
//                       child: pw.Container(
//                         height: 100,
//                         decoration: const pw.BoxDecoration(
//                           border: pw.Border(
//                             right: pw.BorderSide(),
//                           ),
//                         ),
//                         child: pw.Padding(
//                           padding: const pw.EdgeInsets.only(left: 2.0),
//                           child: pw.Column(
//                             mainAxisAlignment: pw.MainAxisAlignment.start,
//                             crossAxisAlignment: pw.CrossAxisAlignment.start,
//                             children: [
//                               pw.Text(
//                                 'To, ${fectedLedgers.firstWhere((ledger) => ledger.id == _SalesEntry!.party).name} ',
//                                 textAlign: pw.TextAlign.start,
//                                 style: pw.TextStyle(
//                                     fontWeight: pw.FontWeight.bold),
//                               ),
//                               pw.Text(
//                                   fectedLedgers
//                                       .firstWhere((ledger) =>
//                                           ledger.id == _SalesEntry!.party)
//                                       .address,
//                                   textAlign: pw.TextAlign.start),
//                               pw.Text(
//                                   'Mob : ${fectedLedgers.firstWhere((ledger) => ledger.id == _SalesEntry!.party).mobile}',
//                                   textAlign: pw.TextAlign.start),
//                               pw.Text(
//                                   'GSTIN : ${fectedLedgers.firstWhere((ledger) => ledger.id == _SalesEntry!.party).gst}',
//                                   textAlign: pw.TextAlign.start),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     pw.Expanded(
//                       child: pw.Container(
//                         decoration: const pw.BoxDecoration(
//                           border: pw.Border(
//                             bottom: pw.BorderSide(),
//                           ),
//                         ),
//                         child: pw.Padding(
//                           padding: const pw.EdgeInsets.all(2.0),
//                           child: pw.Row(
//                             mainAxisAlignment: pw.MainAxisAlignment.start,
//                             crossAxisAlignment: pw.CrossAxisAlignment.start,
//                             children: [
//                               pw.Text(
//                                 'Invoice No    :    ${_SalesEntry!.dcNo}',
//                                 textAlign: pw.TextAlign.start,
//                                 style: const pw.TextStyle(fontSize: 10),
//                               ),
//                               pw.Spacer(),
//                               pw.Text(
//                                 'Date   : ${_SalesEntry!.date}',
//                                 style: const pw.TextStyle(fontSize: 10),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               pw.Container(
//                 width: format.availableWidth,
//                 decoration: pw.BoxDecoration(
//                   color: PdfColors.white,
//                   border: pw.Border.all(color: PdfColors.black),
//                 ),
//                 child: pw.Expanded(
//                   child: pw.Row(
//                     children: [
//                       pw.Container(
//                         width: 20,
//                         decoration: const pw.BoxDecoration(
//                           border: pw.Border(
//                             right: pw.BorderSide(),
//                           ),
//                         ),
//                         child: pw.Text(
//                           'Sr',
//                           textAlign: pw.TextAlign.center,
//                           style: pw.TextStyle(
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       pw.Container(
//                         width: 180,
//                         decoration: const pw.BoxDecoration(
//                           border: pw.Border(
//                             right: pw.BorderSide(),
//                           ),
//                         ),
//                         child: pw.Text(
//                           'Particulars',
//                           textAlign: pw.TextAlign.center,
//                           style: pw.TextStyle(
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       pw.Container(
//                         width: 50,
//                         decoration: const pw.BoxDecoration(
//                           border: pw.Border(
//                             right: pw.BorderSide(),
//                           ),
//                         ),
//                         child: pw.Text(
//                           'HSN',
//                           textAlign: pw.TextAlign.center,
//                           style: pw.TextStyle(
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       pw.Container(
//                         width: 50,
//                         decoration: const pw.BoxDecoration(
//                           border: pw.Border(
//                             right: pw.BorderSide(),
//                           ),
//                         ),
//                         child: pw.Text(
//                           'Qty',
//                           textAlign: pw.TextAlign.center,
//                           style: pw.TextStyle(
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       pw.Container(
//                         width: 50,
//                         decoration: const pw.BoxDecoration(
//                           border: pw.Border(
//                             right: pw.BorderSide(),
//                           ),
//                         ),
//                         child: pw.Text(
//                           'Rate',
//                           textAlign: pw.TextAlign.center,
//                           style: pw.TextStyle(
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       pw.Container(
//                         width: 50,
//                         decoration: const pw.BoxDecoration(
//                           border: pw.Border(
//                             right: pw.BorderSide(),
//                           ),
//                         ),
//                         child: pw.Text(
//                           'Dis%',
//                           textAlign: pw.TextAlign.center,
//                           style: pw.TextStyle(
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       pw.Container(
//                         width: 68,
//                         decoration: const pw.BoxDecoration(
//                           border: pw.Border(
//                             right: pw.BorderSide(),
//                           ),
//                         ),
//                         child: pw.Text(
//                           'Amount',
//                           textAlign: pw.TextAlign.center,
//                           style: pw.TextStyle(
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               pw.Container(
//                 // height: 250,
//                 width: format.availableWidth,
//                 decoration: pw.BoxDecoration(
//                   color: PdfColors.white,
//                   border: pw.Border.all(color: PdfColors.black),
//                 ),
//                 child: pw.ListView(
//                   children: _SalesEntry!.entries.map((sale) {
//                     // Fetch the item name (assuming this is already done before building the PDF)
//                     Item? item = fectedItems.firstWhere(
//                       (item) => item.id == sale.itemName,
//                     );
//                     HSNCode? hsnCode = fectedHsn.firstWhere(
//                       (hsn) => hsn.id == item?.hsnCode,
//                     );

//                     return pw.Table(
//                       border: pw.TableBorder.all(
//                           // inside: const pw.BorderSide(
//                           //   color: PdfColors.black,
//                           //   width: 1,
//                           // ),
//                           ),
//                       children: [
//                         pw.TableRow(
//                           children: [
//                             pw.SizedBox(
//                               width: 20,
//                               child: pw.Padding(
//                                 padding: const pw.EdgeInsets.all(2.0),
//                                 child: pw.Text(
//                                   (counter++).toString(),
//                                   textAlign: pw.TextAlign.center,
//                                   style: pw.TextStyle(
//                                       fontWeight: pw.FontWeight.bold,
//                                       fontSize: 8),
//                                 ),
//                               ),
//                             ),
//                             pw.SizedBox(
//                               width: 180,
//                               child: pw.Padding(
//                                 padding: const pw.EdgeInsets.all(2.0),
//                                 child: pw.Text(
//                                   item != null
//                                       ? item.itemName
//                                       : 'Item not found',
//                                   style: pw.TextStyle(
//                                       fontWeight: pw.FontWeight.bold,
//                                       fontSize: 8),
//                                 ),
//                               ),
//                             ),
//                             pw.SizedBox(
//                               width: 50,
//                               child: pw.Padding(
//                                 padding: const pw.EdgeInsets.all(2.0),
//                                 child: pw.Text(
//                                   hsnCode?.hsn ?? 'Hsn not found',
//                                   textAlign: pw.TextAlign.center,
//                                   style: pw.TextStyle(
//                                       fontWeight: pw.FontWeight.bold,
//                                       fontSize: 8),
//                                 ),
//                               ),
//                             ),
//                             pw.SizedBox(
//                               width: 50,
//                               child: pw.Padding(
//                                 padding: const pw.EdgeInsets.all(2.0),
//                                 child: pw.Text(
//                                   '${sale.qty}',
//                                   textAlign: pw.TextAlign.center,
//                                   style: pw.TextStyle(
//                                       fontWeight: pw.FontWeight.bold,
//                                       fontSize: 8),
//                                 ),
//                               ),
//                             ),
//                             pw.SizedBox(
//                               width: 50,
//                               child: pw.Padding(
//                                 padding: const pw.EdgeInsets.all(2.0),
//                                 child: pw.Text(
//                                   sale.rate.toStringAsFixed(2),
//                                   textAlign: pw.TextAlign.center,
//                                   style: pw.TextStyle(
//                                       fontWeight: pw.FontWeight.bold,
//                                       fontSize: 8),
//                                 ),
//                               ),
//                             ),
//                             pw.SizedBox(
//                               width: 50,
//                               child: pw.Padding(
//                                 padding: const pw.EdgeInsets.all(2.0),
//                                 child: pw.Text(
//                                   '0.00',
//                                   textAlign: pw.TextAlign.center,
//                                   style: pw.TextStyle(
//                                       fontWeight: pw.FontWeight.bold,
//                                       fontSize: 8),
//                                 ),
//                               ),
//                             ),
//                             pw.SizedBox(
//                               width: 68,
//                               child: pw.Padding(
//                                 padding: const pw.EdgeInsets.all(2.0),
//                                 child: pw.Text(
//                                   (sale.qty * sale.rate).toStringAsFixed(
//                                       2), // Calculate qty * rate
//                                   textAlign: pw.TextAlign.center,
//                                   style: pw.TextStyle(
//                                       fontWeight: pw.FontWeight.bold,
//                                       fontSize: 8),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//               ),
//               pw.Container(
//                 width: format.availableWidth,
//                 decoration: pw.BoxDecoration(
//                   color: PdfColors.white,
//                   border: pw.Border.all(color: PdfColors.black),
//                 ),
//                 child: pw.Column(
//                   children: [
//                     pw.Row(
//                       children: [
//                         pw.Container(
//                           width: 150,
//                           padding: const pw.EdgeInsets.all(2.0),
//                           child: pw.Text('ADVANCE PAYMENT : ',
//                               style: pw.TextStyle(
//                                   fontSize: 8, fontWeight: pw.FontWeight.bold)),
//                         ),
//                         pw.Text(
//                           '${_SalesEntry!.moredetails.first.advpayment} ',
//                           textAlign: pw.TextAlign.start,
//                           style: pw.TextStyle(
//                               fontWeight: pw.FontWeight.bold, fontSize: 8),
//                         ),
//                       ],
//                     ),
//                     pw.Row(
//                       children: [
//                         pw.Container(
//                           width: 150,
//                           padding: const pw.EdgeInsets.all(2.0),
//                           child: pw.Text('ADVANCE PAYMENT DATE : ',
//                               style: pw.TextStyle(
//                                   fontSize: 8, fontWeight: pw.FontWeight.bold)),
//                         ),
//                         pw.Text(
//                           '${_SalesEntry!.moredetails.first.advpaymentdate} ',
//                           textAlign: pw.TextAlign.start,
//                           style: pw.TextStyle(
//                               fontWeight: pw.FontWeight.bold, fontSize: 8),
//                         ),
//                       ],
//                     ),
//                     pw.Row(
//                       children: [
//                         pw.Container(
//                           width: 150,
//                           padding: const pw.EdgeInsets.all(2.0),
//                           child: pw.Text('INSTALLMENT : ',
//                               style: pw.TextStyle(
//                                   fontSize: 8, fontWeight: pw.FontWeight.bold)),
//                         ),
//                         pw.Text(
//                           '${_SalesEntry!.moredetails.first.installment} ',
//                           textAlign: pw.TextAlign.start,
//                           style: pw.TextStyle(
//                               fontWeight: pw.FontWeight.bold, fontSize: 8),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               pw.Container(
//                 width: format.availableWidth,
//                 decoration: pw.BoxDecoration(
//                   color: PdfColors.white,
//                   border: pw.Border.all(color: PdfColors.black),
//                 ),
//                 child: pw.Container(
//                   width: 150,
//                   padding: const pw.EdgeInsets.all(2.0),
//                   decoration: const pw.BoxDecoration(
//                       color: PdfColor.fromInt(0xFD2D2D2)),
//                   child: pw.Text(
//                       '  TOTAL DEBIT AMOUNT (WITH INTEREST) : ${_SalesEntry!.moredetails.first.toteldebitamount}',
//                       style: pw.TextStyle(
//                           fontSize: 8,
//                           fontWeight: pw.FontWeight.bold,
//                           color: const PdfColor.fromInt(0xFF0000))),
//                 ),
//               ),
//               pw.Container(
//                 width: format.availableWidth,
//                 decoration: pw.BoxDecoration(
//                   color: PdfColors.white,
//                   border: pw.Border.all(color: PdfColors.black),
//                 ),
//                 child: pw.Row(
//                   children: [
//                     pw.Expanded(
//                       child: pw.Container(
//                         child: pw.Text(
//                           'Total',
//                           style: pw.TextStyle(
//                               fontWeight: pw.FontWeight.bold, fontSize: 10),
//                           textAlign: pw.TextAlign.center,
//                         ),
//                       ),
//                     ),
//                     pw.Expanded(
//                       child: pw.Container(
//                         child: pw.Padding(
//                           padding: const pw.EdgeInsets.all(2.0),
//                           child: pw.Text(
//                             totalValue.toStringAsFixed(2),
//                             style: pw.TextStyle(
//                               fontWeight: pw.FontWeight.bold,
//                               fontSize: 10,
//                               decoration: pw.TextDecoration.underline,
//                             ),
//                             textAlign: pw.TextAlign.right,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               pw.Container(
//                 width: format.availableWidth,
//                 decoration: pw.BoxDecoration(
//                   color: PdfColors.white,
//                   border: pw.Border.all(color: PdfColors.black),
//                 ),
//                 child: pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.start,
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Expanded(
//                       child: pw.Container(
//                         decoration: const pw.BoxDecoration(
//                           border: pw.Border(
//                             right: pw.BorderSide(),
//                           ),
//                         ),
//                         child: pw.Column(
//                           children: [
//                             pw.Container(
//                               child: pw.Text(
//                                 'Bank Details',
//                                 style: pw.TextStyle(
//                                     fontWeight: pw.FontWeight.bold,
//                                     fontSize: 10),
//                                 textAlign: pw.TextAlign.center,
//                               ),
//                             ),
//                             pw.Row(
//                               children: [
//                                 pw.Container(
//                                   width: 50,
//                                   decoration: pw.BoxDecoration(
//                                     border: pw.Border.all(),
//                                   ),
//                                   child: pw.Padding(
//                                     padding: const pw.EdgeInsets.all(2.0),
//                                     child: pw.Text(
//                                       'Bank',
//                                       style: pw.TextStyle(
//                                           fontWeight: pw.FontWeight.bold,
//                                           fontSize: 8),
//                                     ),
//                                   ),
//                                 ),
//                                 pw.Container(
//                                   width: 106,
//                                   height: 13,
//                                   decoration: const pw.BoxDecoration(
//                                     border: pw.Border(
//                                       left: pw.BorderSide(),
//                                       top: pw.BorderSide(),
//                                       bottom: pw.BorderSide(),
//                                     ),
//                                   ),
//                                   child: pw.Padding(
//                                     padding: const pw.EdgeInsets.all(2.0),
//                                     child: pw.Text(
//                                       fectedLedgers
//                                           .firstWhere((ledger) =>
//                                               ledger.id == _SalesEntry!.party)
//                                           .bankName,
//                                       style: const pw.TextStyle(fontSize: 8),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             pw.Row(
//                               children: [
//                                 pw.Container(
//                                   width: 50,
//                                   decoration: pw.BoxDecoration(
//                                     border: pw.Border.all(),
//                                   ),
//                                   child: pw.Padding(
//                                     padding: const pw.EdgeInsets.all(2.0),
//                                     child: pw.Text(
//                                       'Branch',
//                                       style: pw.TextStyle(
//                                           fontWeight: pw.FontWeight.bold,
//                                           fontSize: 8),
//                                     ),
//                                   ),
//                                 ),
//                                 pw.Container(
//                                   width: 106,
//                                   height: 13,
//                                   decoration: const pw.BoxDecoration(
//                                     border: pw.Border(
//                                       left: pw.BorderSide(),
//                                       top: pw.BorderSide(),
//                                       bottom: pw.BorderSide(),
//                                     ),
//                                   ),
//                                   child: pw.Padding(
//                                     padding: const pw.EdgeInsets.all(2.0),
//                                     child: pw.Text(
//                                       fectedLedgers
//                                           .firstWhere((ledger) =>
//                                               ledger.id == _SalesEntry!.party)
//                                           .branchName,
//                                       style: const pw.TextStyle(fontSize: 8),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             pw.Row(
//                               children: [
//                                 pw.Container(
//                                   width: 50,
//                                   decoration: pw.BoxDecoration(
//                                     border: pw.Border.all(),
//                                   ),
//                                   child: pw.Padding(
//                                     padding: const pw.EdgeInsets.all(2.0),
//                                     child: pw.Text(
//                                       'A/c No',
//                                       style: pw.TextStyle(
//                                           fontWeight: pw.FontWeight.bold,
//                                           fontSize: 8),
//                                     ),
//                                   ),
//                                 ),
//                                 pw.Container(
//                                   width: 106,
//                                   height: 13,
//                                   decoration: const pw.BoxDecoration(
//                                     border: pw.Border(
//                                       left: pw.BorderSide(),
//                                       top: pw.BorderSide(),
//                                       bottom: pw.BorderSide(),
//                                     ),
//                                   ),
//                                   child: pw.Padding(
//                                     padding: const pw.EdgeInsets.all(2.0),
//                                     child: pw.Text(
//                                       fectedLedgers
//                                           .firstWhere((ledger) =>
//                                               ledger.id == _SalesEntry!.party)
//                                           .accNo,
//                                       style: const pw.TextStyle(fontSize: 8),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             pw.Row(
//                               children: [
//                                 pw.Container(
//                                   width: 50,
//                                   decoration: pw.BoxDecoration(
//                                     border: pw.Border.all(),
//                                   ),
//                                   child: pw.Padding(
//                                     padding: const pw.EdgeInsets.all(2.0),
//                                     child: pw.Text(
//                                       'IFSC',
//                                       style: pw.TextStyle(
//                                           fontWeight: pw.FontWeight.bold,
//                                           fontSize: 8),
//                                     ),
//                                   ),
//                                 ),
//                                 pw.Container(
//                                   width: 106,
//                                   height: 13,
//                                   decoration: const pw.BoxDecoration(
//                                     border: pw.Border(
//                                       left: pw.BorderSide(),
//                                       top: pw.BorderSide(),
//                                       bottom: pw.BorderSide(),
//                                     ),
//                                   ),
//                                   child: pw.Padding(
//                                     padding: const pw.EdgeInsets.all(2.0),
//                                     child: pw.Text(
//                                       fectedLedgers
//                                           .firstWhere((ledger) =>
//                                               ledger.id == _SalesEntry!.party)
//                                           .ifsc,
//                                       style: const pw.TextStyle(fontSize: 8),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     pw.Expanded(
//                       child: pw.Row(
//                         mainAxisAlignment: pw.MainAxisAlignment.center,
//                         crossAxisAlignment: pw.CrossAxisAlignment.center,
//                         children: [
//                           pw.Container(
//                             child: pw.Column(
//                               children: [
//                                 pw.Padding(
//                                   padding: const pw.EdgeInsets.all(2.0),
//                                   child: pw.Text(
//                                     'Out-standing Balance',
//                                     style: pw.TextStyle(
//                                       fontWeight: pw.FontWeight.bold,
//                                       fontSize: 8,
//                                     ),
//                                     textAlign: pw.TextAlign.center,
//                                   ),
//                                 ),
//                                 pw.Container(
//                                   decoration: pw.BoxDecoration(
//                                     border: pw.Border.all(),
//                                     borderRadius: pw.BorderRadius.circular(5),
//                                   ),
//                                   child: pw.Padding(
//                                     padding: const pw.EdgeInsets.all(2.0),
//                                     child: pw.Text(
//                                       fectedLedgers
//                                           .firstWhere((ledger) =>
//                                               ledger.id == _SalesEntry!.party)
//                                           .openingBalance
//                                           .toStringAsFixed(2),
//                                       style: pw.TextStyle(
//                                         fontWeight: pw.FontWeight.bold,
//                                         fontSize: 8,
//                                       ),
//                                       textAlign: pw.TextAlign.center,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     pw.Expanded(
//                       child: pw.Container(
//                         decoration: const pw.BoxDecoration(
//                           border: pw.Border(
//                             left: pw.BorderSide(),
//                             bottom: pw.BorderSide(),
//                           ),
//                         ),
//                         child: pw.Column(
//                           children: [
//                             pw.Row(
//                               children: [
//                                 pw.Padding(
//                                   padding: const pw.EdgeInsets.all(2.0),
//                                   child: pw.Text(
//                                     'Taxable Amount',
//                                     style: const pw.TextStyle(fontSize: 6),
//                                   ),
//                                 ),
//                                 pw.Spacer(),
//                                 pw.Padding(
//                                   padding: const pw.EdgeInsets.all(2.0),
//                                   child: pw.Text(
//                                     totalValue.toStringAsFixed(2),
//                                     style: const pw.TextStyle(fontSize: 6),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             pw.Row(
//                               children: [
//                                 pw.Padding(
//                                   padding: const pw.EdgeInsets.all(2.0),
//                                   child: pw.Text(
//                                     'SGST',
//                                     style: const pw.TextStyle(fontSize: 6),
//                                   ),
//                                 ),
//                                 pw.Spacer(),
//                                 pw.Padding(
//                                   padding: const pw.EdgeInsets.all(2.0),
//                                   child: pw.Text(
//                                     totalsgst.toStringAsFixed(2),
//                                     style: const pw.TextStyle(fontSize: 6),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             pw.Row(
//                               children: [
//                                 pw.Padding(
//                                   padding: const pw.EdgeInsets.all(2.0),
//                                   child: pw.Text(
//                                     'CGST',
//                                     style: const pw.TextStyle(fontSize: 6),
//                                   ),
//                                 ),
//                                 pw.Spacer(),
//                                 pw.Padding(
//                                   padding: const pw.EdgeInsets.all(2.0),
//                                   child: pw.Text(
//                                     totalcgst.toStringAsFixed(2),
//                                     style: const pw.TextStyle(fontSize: 6),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             pw.Row(
//                               children: [
//                                 pw.Padding(
//                                   padding: const pw.EdgeInsets.all(2.0),
//                                   child: pw.Text(
//                                     'Bill Amount',
//                                     style: pw.TextStyle(
//                                         fontSize: 8,
//                                         fontWeight: pw.FontWeight.bold),
//                                   ),
//                                 ),
//                                 pw.Spacer(),
//                                 pw.Padding(
//                                   padding: const pw.EdgeInsets.all(2.0),
//                                   child: pw.Text(
//                                     totalNetAmount.toStringAsFixed(2),
//                                     style: pw.TextStyle(
//                                         fontSize: 8,
//                                         fontWeight: pw.FontWeight.bold),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               //Tax AMount

//               pw.Container(
//                 width: format.availableWidth,
//                 decoration: pw.BoxDecoration(
//                   color: PdfColors.white,
//                   border: pw.Border.all(color: PdfColors.black),
//                 ),
//                 child: pw.Expanded(
//                   child: pw.Row(
//                     children: [
//                       pw.Container(
//                         width: 93.4,
//                         decoration: const pw.BoxDecoration(
//                           border: pw.Border(
//                             right: pw.BorderSide(),
//                           ),
//                         ),
//                         child: pw.Padding(
//                           padding: const pw.EdgeInsets.all(2.0),
//                           child: pw.Text(
//                             'Tax Category',
//                             textAlign: pw.TextAlign.center,
//                             style: pw.TextStyle(
//                               fontWeight: pw.FontWeight.bold,
//                               fontSize: 6,
//                             ),
//                           ),
//                         ),
//                       ),
//                       pw.Container(
//                         width: 93.6,
//                         decoration: const pw.BoxDecoration(
//                           border: pw.Border(
//                             right: pw.BorderSide(),
//                           ),
//                         ),
//                         child: pw.Padding(
//                           padding: const pw.EdgeInsets.all(2.0),
//                           child: pw.Text(
//                             'Taxable Amount',
//                             textAlign: pw.TextAlign.center,
//                             style: pw.TextStyle(
//                               fontWeight: pw.FontWeight.bold,
//                               fontSize: 6,
//                             ),
//                           ),
//                         ),
//                       ),
//                       pw.Container(
//                         width: 93.6,
//                         decoration: const pw.BoxDecoration(
//                           border: pw.Border(
//                             right: pw.BorderSide(),
//                           ),
//                         ),
//                         child: pw.Padding(
//                           padding: const pw.EdgeInsets.all(2.0),
//                           child: pw.Text(
//                             'SGST',
//                             textAlign: pw.TextAlign.center,
//                             style: pw.TextStyle(
//                               fontWeight: pw.FontWeight.bold,
//                               fontSize: 6,
//                             ),
//                           ),
//                         ),
//                       ),
//                       pw.Container(
//                         width: 93.6,
//                         decoration: const pw.BoxDecoration(
//                           border: pw.Border(
//                             right: pw.BorderSide(),
//                           ),
//                         ),
//                         child: pw.Padding(
//                           padding: const pw.EdgeInsets.all(2.0),
//                           child: pw.Text(
//                             'CGST',
//                             textAlign: pw.TextAlign.center,
//                             style: pw.TextStyle(
//                               fontWeight: pw.FontWeight.bold,
//                               fontSize: 6,
//                             ),
//                           ),
//                         ),
//                       ),
//                       pw.Container(
//                         width: 93.6,
//                         decoration: const pw.BoxDecoration(
//                           border: pw.Border(
//                             right: pw.BorderSide(),
//                           ),
//                         ),
//                         child: pw.Padding(
//                           padding: const pw.EdgeInsets.all(2.0),
//                           child: pw.Text(
//                             'IGST',
//                             textAlign: pw.TextAlign.center,
//                             style: pw.TextStyle(
//                               fontWeight: pw.FontWeight.bold,
//                               fontSize: 6,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               pw.Container(
//                 width: format.availableWidth,
//                 decoration: pw.BoxDecoration(
//                   color: PdfColors.white,
//                   border: pw.Border.all(color: PdfColors.black),
//                 ),
//                 child: pw.ListView(
//                   children: _SalesEntry!.entries.map((sale) {
//                     return pw.Table(
//                       border: pw.TableBorder.all(),
//                       children: [
//                         pw.TableRow(
//                           children: [
//                             pw.SizedBox(
//                               width: 92,
//                               child: pw.Padding(
//                                 padding: const pw.EdgeInsets.all(2.0),
//                                 child: pw.Text(
//                                   '${sale.tax}% GST',
//                                   textAlign: pw.TextAlign.center,
//                                   style: pw.TextStyle(
//                                       fontWeight: pw.FontWeight.bold,
//                                       fontSize: 6),
//                                 ),
//                               ),
//                             ),
//                             pw.SizedBox(
//                               width: 92,
//                               child: pw.Padding(
//                                 padding: const pw.EdgeInsets.all(2.0),
//                                 child: pw.Text(
//                                   (sale.qty * sale.rate).toStringAsFixed(2),
//                                   style: pw.TextStyle(
//                                       fontWeight: pw.FontWeight.bold,
//                                       fontSize: 6),
//                                 ),
//                               ),
//                             ),
//                             pw.SizedBox(
//                               width: 92,
//                               child: pw.Padding(
//                                 padding: const pw.EdgeInsets.all(2.0),
//                                 child: pw.Text(
//                                   sale.sgst.toStringAsFixed(2),
//                                   textAlign: pw.TextAlign.center,
//                                   style: pw.TextStyle(
//                                       fontWeight: pw.FontWeight.bold,
//                                       fontSize: 6),
//                                 ),
//                               ),
//                             ),
//                             pw.SizedBox(
//                               width: 92,
//                               child: pw.Padding(
//                                 padding: const pw.EdgeInsets.all(2.0),
//                                 child: pw.Text(
//                                   sale.cgst.toStringAsFixed(2),
//                                   textAlign: pw.TextAlign.center,
//                                   style: pw.TextStyle(
//                                       fontWeight: pw.FontWeight.bold,
//                                       fontSize: 6),
//                                 ),
//                               ),
//                             ),
//                             pw.SizedBox(
//                               width: 92,
//                               child: pw.Padding(
//                                 padding: const pw.EdgeInsets.all(2.0),
//                                 child: pw.Text(
//                                   '0.00',
//                                   textAlign: pw.TextAlign.center,
//                                   style: pw.TextStyle(
//                                       fontWeight: pw.FontWeight.bold,
//                                       fontSize: 6),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//               ),

//               //Term's and Conditions
//               pw.Container(
//                 width: format.availableWidth,
//                 decoration: pw.BoxDecoration(
//                   color: PdfColors.white,
//                   border: pw.Border.all(),
//                 ),
//                 height: 100,
//                 child: pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.start,
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Container(
//                       width: 300,
//                       decoration: pw.BoxDecoration(
//                         color: PdfColors.white,
//                         border: pw.Border.all(),
//                       ),
//                       child: pw.Column(
//                         mainAxisAlignment: pw.MainAxisAlignment.start,
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           pw.Padding(
//                             padding: const pw.EdgeInsets.all(2.0),
//                             child: pw.Text(
//                               'Terms And Condition :',
//                               style: pw.TextStyle(
//                                 fontSize: 6,
//                                 fontWeight: pw.FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           pw.Padding(
//                             padding: const pw.EdgeInsets.all(2.0),
//                             child: pw.Text(
//                               '- Goods once sold wifi not be taken back or exchanged.',
//                               style: const pw.TextStyle(
//                                 fontSize: 6,
//                               ),
//                             ),
//                           ),
//                           pw.Padding(
//                             padding: const pw.EdgeInsets.all(2.0),
//                             child: pw.Text(
//                               '- Goods once sold wifi not be taken back or exchanged.',
//                               style: const pw.TextStyle(
//                                 fontSize: 6,
//                               ),
//                             ),
//                           ),
//                           pw.Padding(
//                             padding: const pw.EdgeInsets.all(2.0),
//                             child: pw.Text(
//                               '- Goods once sold wifi not be taken back or exchanged.',
//                               style: const pw.TextStyle(
//                                 fontSize: 6,
//                               ),
//                             ),
//                           ),
//                           pw.Padding(
//                             padding: const pw.EdgeInsets.all(2.0),
//                             child: pw.Text(
//                               '- Goods once sold wifi not be taken back or exchanged.',
//                               style: const pw.TextStyle(
//                                 fontSize: 6,
//                               ),
//                             ),
//                           ),
//                           pw.Padding(
//                             padding: const pw.EdgeInsets.all(2.0),
//                             child: pw.Text(
//                               '- Goods once sold wifi not be taken back or exchanged.',
//                               style: const pw.TextStyle(
//                                 fontSize: 6,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     pw.Container(
//                       width: 200,
//                       child: pw.Column(
//                         mainAxisAlignment: pw.MainAxisAlignment.start,
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           pw.Container(
//                             width: 167,
//                             height: 50,
//                             decoration: const pw.BoxDecoration(
//                               border: pw.Border(
//                                 bottom: pw.BorderSide(),
//                               ),
//                             ),
//                             child: pw.Column(
//                               mainAxisAlignment: pw.MainAxisAlignment.end,
//                               children: [
//                                 pw.Container(
//                                   width: 50,
//                                   child: _selectedImages2.isNotEmpty
//                                       ? pw.Image(
//                                           pw.MemoryImage(_selectedImages2[0]))
//                                       : pw.SizedBox(width: 50),
//                                 ),
//                                 pw.SizedBox(height: 5),
//                                 pw.Text(
//                                   'For, ${selectedComapny.first.companyName}',
//                                   style: pw.TextStyle(
//                                     fontSize: 6,
//                                     fontWeight: pw.FontWeight.bold,
//                                   ),
//                                   textAlign: pw.TextAlign.center,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           pw.Container(
//                             width: 167,
//                             height: 50,
//                             child: pw.Column(
//                               mainAxisAlignment: pw.MainAxisAlignment.end,
//                               children: [
//                                 pw.Text(
//                                   'Customer Signature',
//                                   style: pw.TextStyle(
//                                     fontSize: 6,
//                                     fontWeight: pw.FontWeight.bold,
//                                   ),
//                                   textAlign: pw.TextAlign.center,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );

//     return pdf.save();
//   }
// }
