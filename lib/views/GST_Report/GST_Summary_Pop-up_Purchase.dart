import 'package:billingsphere/data/models/ledger/ledger_model.dart';
import 'package:billingsphere/data/repository/ledger_repository.dart';
import 'package:billingsphere/views/GST_Report/GST_Summary.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GSTSummaryPopUpPurchase extends StatefulWidget {
  final List<PurchaseEntryWithEntries> purchaseEntriesWithEntries;

  const GSTSummaryPopUpPurchase(
      {super.key, required this.purchaseEntriesWithEntries});

  @override
  State<GSTSummaryPopUpPurchase> createState() => _ChequeReturnEntryState();
}

class _ChequeReturnEntryState extends State<GSTSummaryPopUpPurchase> {
  double totalAmount = 0;
  double totalSGST = 0;
  double totalCGST = 0;
  double totalNetAmount = 0;
  List<Ledger> selectedLedger = [];
  LedgerService ledgerRepo = LedgerService();

  @override
  void initState() {
    super.initState();
    fetchLedger();
    calculateTotalNetAmount();
  }

  Future<void> fetchLedger() async {
    try {
      final List<Ledger> ledger = await ledgerRepo.fetchLedgers();

      setState(() {
        selectedLedger = ledger;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  String getLedgerName(String ledgername) {
    for (var ledger in selectedLedger) {
      if (ledger.id == ledgername) {
        return ledger.name.toString();
      }
    }
    return '';
  }

  String getLedgerGST(String ledgergst) {
    for (var ledger in selectedLedger) {
      if (ledger.id == ledgergst) {
        return ledger.gst.toString();
      }
    }
    return '';
  }

  void calculateTotalNetAmount() {
    for (var entryWithEntries in widget.purchaseEntriesWithEntries) {
      for (var entry in entryWithEntries.entriesP) {
        totalAmount += entry.amount;
        totalSGST += entry.sgst;
        totalCGST += entry.cgst;
        totalNetAmount += entry.netAmount;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                height: 40,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 33, 65, 243),
                ),
                child: Text(
                  "GST Transactions",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Table(
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(2),
                            3: FlexColumnWidth(4),
                            4: FlexColumnWidth(4),
                            5: FlexColumnWidth(2),
                            6: FlexColumnWidth(2),
                            7: FlexColumnWidth(2),
                            8: FlexColumnWidth(2),
                            9: FlexColumnWidth(2),
                            10: FlexColumnWidth(2),
                            11: FlexColumnWidth(2),
                          },
                          border: TableBorder.all(color: Colors.black),
                          children: [
                            TableRow(
                              children: [
                                _buildTableCell2("Date"),
                                _buildTableCell2("Place"),
                                _buildTableCell2("No"),
                                _buildTableCell2("Particulars"),
                                _buildTableCell2("GSTIN"),
                                _buildTableCell2("TxblAmt."),
                                _buildTableCell2("SGST"),
                                _buildTableCell2("CGST"),
                                _buildTableCell2("IGST"),
                                _buildTableCell2("Cess"),
                                _buildTableCell2("Net.Amt"),
                              ],
                            ),
                          ],
                        ),
                        SingleChildScrollView(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4621,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  widget.purchaseEntriesWithEntries.length,
                              itemBuilder: (context, index) {
                                final pEntryWithEntries =
                                    widget.purchaseEntriesWithEntries[index];
                                String ledgerName = getLedgerName(
                                    pEntryWithEntries.purchaseEntry.ledger);
                                String ledgerGst = getLedgerGST(
                                    pEntryWithEntries.purchaseEntry.ledger);
                                return InkWell(
                                  onDoubleTap: () {
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (context) => SalesEditScreen(
                                    //       salesEntryId: salesEntryWithEntries
                                    //           .salesEntry.id,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  child: Table(
                                    columnWidths: const {
                                      0: FlexColumnWidth(2),
                                      1: FlexColumnWidth(2),
                                      2: FlexColumnWidth(2),
                                      3: FlexColumnWidth(4),
                                      4: FlexColumnWidth(4),
                                      5: FlexColumnWidth(2),
                                      6: FlexColumnWidth(2),
                                      7: FlexColumnWidth(2),
                                      8: FlexColumnWidth(2),
                                      9: FlexColumnWidth(2),
                                      10: FlexColumnWidth(2),
                                      11: FlexColumnWidth(2),
                                    },
                                    border:
                                        TableBorder.all(color: Colors.black),
                                    children: List<TableRow>.from(
                                      pEntryWithEntries.entriesP.map(
                                        (entry) {
                                          return TableRow(
                                            children: [
                                              _buildTableCell(pEntryWithEntries
                                                  .purchaseEntry.date),
                                              _buildTableCell(pEntryWithEntries
                                                  .purchaseEntry.place),
                                              _buildTableCell(pEntryWithEntries
                                                  .purchaseEntry.no
                                                  .toString()),
                                              _buildTableCell(ledgerName),
                                              _buildTableCell(ledgerGst),
                                              _buildTableCell(entry.amount
                                                  .toStringAsFixed(2)),
                                              _buildTableCell(entry.sgst
                                                  .toStringAsFixed(2)),
                                              _buildTableCell(entry.cgst
                                                  .toStringAsFixed(2)),
                                              _buildTableCell('0'),
                                              _buildTableCell('0'),
                                              _buildTableCell(entry.netAmount
                                                  .toStringAsFixed(2)),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(4),
                    4: FlexColumnWidth(4),
                    5: FlexColumnWidth(2),
                    6: FlexColumnWidth(2),
                    7: FlexColumnWidth(2),
                    8: FlexColumnWidth(2),
                    9: FlexColumnWidth(2),
                    10: FlexColumnWidth(2),
                    11: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      children: [
                        _buildTableCell2(""),
                        _buildTableCell2("Total"),
                        _buildTableCell2(""),
                        _buildTableCell2(""),
                        _buildTableCell2(""),
                        _buildTableCell2(totalAmount.toStringAsFixed(2)),
                        _buildTableCell2(totalSGST.toStringAsFixed(2)),
                        _buildTableCell2(totalCGST.toStringAsFixed(2)),
                        _buildTableCell2("0.00"),
                        _buildTableCell2("0.00"),
                        _buildTableCell2(totalNetAmount.toStringAsFixed(2)),
                      ],
                    ),
                  ],
                ),
              ),
              //Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 45,
                    child: Row(
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.yellow[100]),
                            foregroundColor:
                                const WidgetStatePropertyAll(Colors.black),
                            shape: const WidgetStatePropertyAll(
                              BeveledRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.zero),
                              ),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Save",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.yellow[100]),
                            foregroundColor:
                                const WidgetStatePropertyAll(Colors.black),
                            shape: const WidgetStatePropertyAll(
                              BeveledRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.zero),
                              ),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Cancel",
                            style: TextStyle(fontWeight: FontWeight.bold),
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
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTableCell2(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: const Color.fromARGB(255, 30, 0, 81),
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
