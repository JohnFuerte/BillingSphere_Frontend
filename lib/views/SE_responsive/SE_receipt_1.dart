// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_web_libraries_in_flutter
import 'package:billingsphere/views/SE_responsive/SE_print_receipt.dart';
import 'package:flutter/material.dart';

import 'package:billingsphere/data/repository/item_repository.dart';
import 'package:billingsphere/data/repository/sales_enteries_repository.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/salesEntries/sales_entrires_model.dart';
import '../../data/repository/hsn_repository.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/sundry_repository.dart';
import 'dart:html' as html;

import 'SE_receipt_2.dart';

class SalesReceipt extends StatefulWidget {
  const SalesReceipt({super.key, required this.sales});

  final String sales;

  @override
  State<SalesReceipt> createState() => SalesReceiptState();
}

class SalesReceiptState extends State<SalesReceipt> {
  LedgerService ledgerService = LedgerService();
  SalesEntryService salesService = SalesEntryService();
  ItemsService itemsService = ItemsService();
  SalesEntry? _SalesEntry;

  void fetchSalesById() async {
    final sales = await salesService.fetchSalesById(widget.sales);
    setState(() {
      _SalesEntry = sales;
    });

    print(_SalesEntry);
  }

  void _openWhatsApp() {
    final baseUrl =
        'https://billingsphere-backend-main.onrender.com/api/sales/download-receipt';
    final text = Uri.encodeComponent(
        'Thank you for Purchasing items from FDSUPERMART worth Rs. ${_SalesEntry!.totalamount} on ${_SalesEntry!.date}, Please download your receipt by clicking on this link: $baseUrl/${widget.sales}');
    final url = 'https://web.whatsapp.com/send?text=$text';
    html.window.open(url, 'whatsapp');
  }

  @override
  void initState() {
    super.initState();
    fetchSalesById();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey,
        centerTitle: true,
      ),
      backgroundColor: Colors.black12,
      body: SingleChildScrollView(
        child: Center(
          child: _SalesEntry != null
              ? Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Print('Print Sales', sales: widget.sales),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                          child: const Text('Print Receipt'),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => PrintBigReceipt(
                            //         'Print Sales',
                            //         sales: widget.sales),
                            //   ),
                            // );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                          child: const Text('Print Receipt'),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: ElevatedButton(
                          onPressed: _openWhatsApp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                          child: const Text('Share on Whatsapp'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        // height: 1200,
                        width: MediaQuery.of(context).size.width * 0.55,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              blurStyle: BlurStyle.outer,
                              spreadRadius: 0,
                              offset: Offset(5, 5),
                            ),
                          ],
                          color: Colors.white,
                        ),

                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width * 0.53,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      'FD SUPER MART',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.52,
                                      decoration:
                                          BoxDecoration(border: Border.all()),
                                      child: const Text(
                                        '80 FT Rail Nagar Main Road, Under Bridge, Near Rail Nagar, Rajkot, Gujarat 360001',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.53,
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(),
                                              right: BorderSide(),
                                            ),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              'Original',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade400,
                                            border: const Border(
                                              bottom: BorderSide(),
                                            ),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              'TAX INVOICE',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(),
                                              left: BorderSide(),
                                            ),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              'DEBIT MEMO',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.33,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text(
                                                    'To,',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.016,
                                                  ),
                                                  SizedBox(
                                                    // Fetch Ledger name
                                                    child:
                                                        FutureBuilder<Ledger?>(
                                                      future: ledgerService
                                                          .fetchLedgerById(
                                                              _SalesEntry!
                                                                  .party),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<Ledger?>
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          // While data is being fetched
                                                          return const Text('');
                                                        } else if (snapshot
                                                            .hasError) {
                                                          // If an error occurs
                                                          return Text(
                                                              'Error: ${snapshot.error}');
                                                        } else {
                                                          // Data successfully fetched, display it
                                                          return SizedBox(
                                                            child: Text(
                                                              snapshot.data!
                                                                  .name, // Display fetched data or 'Unknown' if data is null
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text(
                                                    '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.029,
                                                  ),
                                                  SizedBox(
                                                    // Fetch Ledger name
                                                    child:
                                                        FutureBuilder<Ledger?>(
                                                      future: ledgerService
                                                          .fetchLedgerById(
                                                              _SalesEntry!
                                                                  .party),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<Ledger?>
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          // While data is being fetched
                                                          return const Text('');
                                                        } else if (snapshot
                                                            .hasError) {
                                                          // If an error occurs
                                                          return Text(
                                                              'Error: ${snapshot.error}');
                                                        } else {
                                                          // Data successfully fetched, display it
                                                          return SizedBox(
                                                            child: Text(
                                                              snapshot.data!
                                                                  .city, // Display fetched data or 'Unknown' if data is null
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text(
                                                    '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.029,
                                                  ),
                                                  SizedBox(
                                                    // Fetch Ledger name
                                                    child:
                                                        FutureBuilder<Ledger?>(
                                                      future: ledgerService
                                                          .fetchLedgerById(
                                                              _SalesEntry!
                                                                  .party),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<Ledger?>
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          // While data is being fetched
                                                          return const Text('');
                                                        } else if (snapshot
                                                            .hasError) {
                                                          // If an error occurs
                                                          return Text(
                                                              'Error: ${snapshot.error}');
                                                        } else {
                                                          // Data successfully fetched, display it
                                                          return SizedBox(
                                                            child: Text(
                                                              'GSTIN: ${snapshot.data!.gst}', // Display fetched data or 'Unknown' if data is null
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text(
                                                    '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.029,
                                                  ),
                                                  SizedBox(
                                                    // Fetch Ledger name
                                                    child:
                                                        FutureBuilder<Ledger?>(
                                                      future: ledgerService
                                                          .fetchLedgerById(
                                                              _SalesEntry!
                                                                  .party),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<Ledger?>
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          // While data is being fetched
                                                          return const Text('');
                                                        } else if (snapshot
                                                            .hasError) {
                                                          // If an error occurs
                                                          return Text(
                                                              'Error: ${snapshot.error}');
                                                        } else {
                                                          // Data successfully fetched, display it
                                                          return SizedBox(
                                                            child: Text(
                                                              snapshot.data!
                                                                  .state, // Display fetched data or 'Unknown' if data is null
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.18,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text(
                                                    'No:',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02,
                                                  ),
                                                  Text(
                                                    _SalesEntry!.no.toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text(
                                                    'Date:',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02,
                                                  ),
                                                  Text(
                                                    _SalesEntry!.date
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.start,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Row(
                                                children: [
                                                  const Text(
                                                    'DC NO:',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                    child: Text(
                                                      _SalesEntry!.dcNo,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.53,
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.015,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                      border: Border.all(),
                                    ),
                                    child: const Text(
                                      ' Sr.',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.16,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      color: Colors.grey.shade400,
                                    ),
                                    child: const Text(
                                      '  Product Description',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.051,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      color: Colors.grey.shade400,
                                    ),
                                    child: const Text(
                                      '  HSN',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.0451,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      color: Colors.grey.shade400,
                                    ),
                                    child: const Text(
                                      '  QTY',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.051,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      color: Colors.grey.shade400,
                                    ),
                                    child: const Text(
                                      '  Rate',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  // Container(
                                  //   width: MediaQuery.of(context).size.width * 0.045,
                                  //   decoration: BoxDecoration(
                                  //     border: Border.all(),
                                  //     color: Colors.grey.shade400,
                                  //   ),
                                  //   child: const Text(
                                  //     '  Dis%',
                                  //     overflow: TextOverflow.ellipsis,
                                  //     style: TextStyle(fontWeight: FontWeight.bold),
                                  //   ),
                                  // ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.051,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      color: Colors.grey.shade400,
                                    ),
                                    child: const Text(
                                      '  GST%',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.051,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      color: Colors.grey.shade400,
                                    ),
                                    child: const Text(
                                      '  SGST',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.051,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      color: Colors.grey.shade400,
                                    ),
                                    child: const Text(
                                      '  CGST',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.053,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      color: Colors.grey.shade400,
                                    ),
                                    child: const Text(
                                      '  Amount',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.53,
                              height: 370,
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              child: DataTableExample(
                                sales: _SalesEntry!,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.53,
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.015,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                    ),
                                    child: const Text(
                                      '',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.16,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                    ),
                                    child: const Text(
                                      'Total',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.051,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                    ),
                                    child: const Text(
                                      '  ',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.0451,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                    ),
                                    child: Text(
                                      ('${_SalesEntry!.entries.map((e) => e.qty).fold(0.0, (a, b) => a + b)}'),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.051,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                    ),
                                    child: const Text(
                                      '  ',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  // Container(
                                  //   width: MediaQuery.of(context).size.width * 0.051,
                                  //   decoration: BoxDecoration(
                                  //     border: Border.all(),
                                  //   ),
                                  //   child: const Text(
                                  //     '  ',
                                  //     overflow: TextOverflow.ellipsis,
                                  //     style: TextStyle(fontWeight: FontWeight.bold),
                                  //   ),
                                  // ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.051,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                    ),
                                    child: const Text(
                                      '  ',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.051,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                    ),
                                    child: Text(
                                      ('${_SalesEntry!.entries.map((e) => e.sgst).fold(0.0, (a, b) => a + b)}'),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.051,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                    ),
                                    child: Text(
                                      ('${_SalesEntry!.entries.map((e) => e.cgst).fold(0.0, (a, b) => a + b)}'),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.053,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                    ),
                                    child: Text(
                                      ('${_SalesEntry!.entries.map((e) => e.netAmount).fold(0.0, (a, b) => a + b)}'),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.53,
                              height: 180,
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.242,
                                      height: 150,
                                      decoration:
                                          BoxDecoration(border: Border.all()),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    '  TAX Name',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.08,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Txbl Value',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'SGST ',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'IGST',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.24,
                                            height: 100,
                                            child: DataTableExample2(
                                              sales: _SalesEntry!,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.242,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      top: BorderSide(),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    '   Total',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.075,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      top: BorderSide(),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    ('${_SalesEntry!.entries.map((e) => e.amount).fold(0.0, (a, b) => a + b)}'),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      top: BorderSide(),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    ('${_SalesEntry!.entries.map((e) => e.sgst).fold(0.0, (a, b) => a + b)}'),
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.045,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      top: BorderSide(),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    ('${_SalesEntry!.entries.map((e) => e.cgst).fold(0.0, (a, b) => a + b)}'),
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      height: 150,
                                      decoration:
                                          BoxDecoration(border: Border.all()),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.20,
                                            height: 120,
                                            child: DataTableExample3(
                                              sales: _SalesEntry!,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.20,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      top: BorderSide(),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    '   Total',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.098,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      top: BorderSide(),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    '${_SalesEntry!.entries.map((e) => e.netAmount).fold(0.0, (a, b) => a + b) + _SalesEntry!.sundry.map((e) => e.amount).fold(0.0, (a, b) => a + b)}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
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
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.53,
                              height: 120,
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    // decoration: BoxDecoration(border: Border.all()),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('   Terms & Condition'),
                                        Text(
                                            '  * Goods once sold cannot be accepted back or exchanged.'),
                                        Text(
                                            '  * Please get your Payment Receipt when paying the bills'),
                                        Text(
                                            '  * Please get your Payment Receipt when paying the bills'),
                                        Text(
                                            '  * Please get your Payment Receipt when paying the bills'),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.098,
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text('For, FD SUPER MART  '),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text('Authorised Signatory  '),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : CircularProgressIndicator(), // Show loading indicator while fetching data
        ),
      ),
    );
  }

  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();
    page.graphics.drawString(
        'Hello Print ', PdfStandardFont(PdfFontFamily.helvetica, 30));

    // List<int> bytes = document.save();
    // document.dispose();

    // saveAndLaunchFile(bytes, 'OutPut.pdf');
  }
}

class DataTableExample extends StatelessWidget {
  DataTableExample({
    Key? key,
    required this.sales,
  }) : super(key: key);
  ItemsService itemsService = ItemsService();
  HSNCodeService hsnService = HSNCodeService();
  final SalesEntry sales;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sales.entries.length,
      itemBuilder: (context, index) {
        final sale = sales.entries[index];
        return IntrinsicHeight(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.015,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text('1'),
                ),
                // const VerticalDivider(thickness: 1, width: 1),
                Container(
                  width: MediaQuery.of(context).size.width * 0.148,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: itemsService.fetchItemById(sale.itemName),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                            ''); // or any loading indicator you prefer
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text(snapshot.data!.itemName);
                      }
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.045,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(0.0),
                  child: FutureBuilder(
                    future: itemsService.fetchItemById(sale.itemName),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                            ''); // or any loading indicator you prefer
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return FutureBuilder(
                          future:
                              hsnService.fetchHsnById(snapshot.data!.hsnCode),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text(
                                  ''); // or any loading indicator you prefer
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Text(snapshot.data!.hsn);
                            }
                          },
                        );
                      }
                    },
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.044,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(0.0),
                  child: Text('   ${sale.qty}'),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.045,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(0.0),
                  child: Text('${sale.rate}'),
                ),
                // const VerticalDivider(thickness: 1, width: 1),
                // Container(
                //   width: MediaQuery.of(context).size.width * 0.045,

                //   alignment: Alignment.centerLeft,
                //   padding: const EdgeInsets.all(0.0),
                //   child: const Text('0'),
                // ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.045,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(0.0),
                  child: Text('${sale.tax}%'),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.045,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(0.0),
                  child: Text('${sale.sgst}'),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.045,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(0.0),
                  child: Text('${sale.cgst}'),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.048,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(0.0),
                  child: Text('${sale.netAmount}'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DataTableExample2 extends StatelessWidget {
  const DataTableExample2({super.key, required this.sales});

  final SalesEntry sales;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sales.entries.length,
      itemBuilder: (context, index) {
        final sale = sales.entries[index];
        return IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.06,
                child: Text(
                  sale.tax,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.075,
                child: Text(
                  '${sale.amount}',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.06,
                child: Text(
                  '${sale.sgst}',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.045,
                child: Text(
                  '${sale.cgst}',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DataTableExample3 extends StatelessWidget {
  DataTableExample3({
    Key? key,
    required this.sales,
  }) : super(key: key);
  SundryService sundrdyService = SundryService();

  final SalesEntry sales;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sales.sundry.length,
      itemBuilder: (context, index) {
        final sale = sales.sundry[index];
        return IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text('${sale.sundryName}'),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text('${sale.amount}'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
