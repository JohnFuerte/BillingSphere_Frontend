import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NInewTable extends StatelessWidget {
  const NInewTable({
    super.key,
    required this.dealerController,
    required this.subDealerController,
    required this.retailController,
    required this.mrpController,
    required this.dateController,
    required this.currentPriceController,
  });

  final TextEditingController dealerController;
  final TextEditingController subDealerController;
  final TextEditingController retailController;
  final TextEditingController mrpController;
  final TextEditingController dateController;
  final TextEditingController currentPriceController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Table(
              border: TableBorder.all(color: Colors.black),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          'Date',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          'Dealer',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          'Sub Dealer',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          'Retail',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          'MRP',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          'Current Price',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    // Repeat the pattern for other cells
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            children: [
              SizedBox(
                height: 78,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Table(
                    border: TableBorder.all(color: Colors.black),
                    // border: const TableBorder(

                    //     verticalInside: BorderSide(color: Colors.black),
                    //     horizontalInside: BorderSide(color: Colors.black),
                    //     ),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: TextFormField(
                              controller: dateController,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold),
                              onSaved: (newValue) {
                                dateController.text = newValue!;
                              },
                              textAlign: TextAlign.center,
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: TextFormField(
                              controller: dealerController,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold),
                              onSaved: (newValue) {
                                dealerController.text = newValue!;
                              },
                              textAlign: TextAlign.center,
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: TextFormField(
                              controller: subDealerController,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold),
                              onSaved: (newValue) {
                                subDealerController.text = newValue!;
                              },
                              textAlign: TextAlign.center,
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: TextFormField(
                              controller: retailController,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold),
                              onSaved: (newValue) {
                                retailController.text = newValue!;
                              },
                              textAlign: TextAlign.center,
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: TextFormField(
                              controller: mrpController,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold),
                              onSaved: (newValue) {
                                mrpController.text = newValue!;
                              },
                              textAlign: TextAlign.center,
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: TextFormField(
                              controller: currentPriceController,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold),
                              onSaved: (newValue) {
                                currentPriceController.text = newValue!;
                              },
                              textAlign: TextAlign.center,
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
      ],
    );
  }
}
