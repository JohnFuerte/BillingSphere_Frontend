import 'dart:math';

import 'package:billingsphere/data/models/purchase/purchase_model.dart';
import 'package:billingsphere/data/repository/item_repository.dart';
import 'package:billingsphere/data/repository/ledger_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../data/models/ledger/ledger_model.dart';

class PEReceiptBody extends StatefulWidget {
  const PEReceiptBody({super.key, required this.data});

  final Purchase data;

  @override
  State<PEReceiptBody> createState() => _PAReceipyBodyState();
}

class _PAReceipyBodyState extends State<PEReceiptBody> {
  int randNum = 0;
  bool isLoading = false;
  Ledger? ledger;
  LedgerService ledgerService = LedgerService();
  ItemsService itemsService = ItemsService();

  void generateThreeDigitNumber() {
    Random random = Random();
    int rand = random.nextInt(900) + 100;

    setState(() {
      randNum = rand;
    });
  }

  Future<void> fetchLedger() async {
    setState(() {
      isLoading = true;
    });
    final response = await ledgerService.fetchLedgerById(widget.data.ledger);
    setState(() {
      ledger = response;
      isLoading = false;
    });
  }

  void _initializeData() async {
    await fetchLedger();
    generateThreeDigitNumber();
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
            body: Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            CupertinoIcons.arrow_left,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45),
                        Text(
                          'PURCHASE RECEIPT',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Text(
                            'FDSUPERMART PVT LTD',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'SHOP NO 553 1ST FLOOR, KALUPUR GATE, KALUPUR, GUJARAT',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                child: Text(
                                  'RECEIPT VOUCHER',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Divider(
                                color: Colors.black,
                                thickness: 2,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Receipt No:         ${randNum.toString()}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Date:               ${DateFormat('yyyy/MM/dd').format(DateTime.now())}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                color: Colors.black,
                                thickness: 1,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Party: ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'M/s. ${ledger!.name}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          ledger!.address,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          'GSTIN: ${ledger!.gst}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          '${ledger!.region}, India',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const Divider(
                                color: Colors.black,
                                thickness: 1,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'We thank you very much for your payment of : ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                    Text(
                                      'Rs. ${widget.data.totalamount}.00',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: ListView(
                                  children: [
                                    DataTable(
                                      columns: [
                                        DataColumn(
                                            label: Text(
                                          'Date',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        )),
                                        DataColumn(
                                            label: Text(
                                          'Item Name',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        )),
                                        DataColumn(
                                            label: Text(
                                          'Quantity',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        )),
                                        DataColumn(
                                            label: Text(
                                          'Amount',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        )),
                                        DataColumn(
                                            label: Text(
                                          'Net Amount',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        )),
                                      ],
                                      rows: widget.data.entries.map((entry) {
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              Text(
                                                DateFormat('yyyy/MM/dd')
                                                    .format(DateTime.now()),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            DataCell(
                                              // Give me future builder example
                                              FutureBuilder(
                                                future:
                                                    itemsService.fetchItemById(
                                                        entry.itemName),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Text(
                                                      snapshot.data!.itemName,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    );
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text(
                                                      'Error',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    );
                                                  }
                                                  return const Text('');
                                                },
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                entry.qty.toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                entry.amount.toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                entry.netAmount.toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
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
              ),
            ),
          );
  }
}
