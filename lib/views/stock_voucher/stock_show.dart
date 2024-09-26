import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/item/item_model.dart';
import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/salesEntries/sales_entrires_model.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/sales_enteries_repository.dart';
import '../DB_widgets/custom_footer.dart';
import '../LG_responsive/LG_HOME.dart';

class StockShow extends StatefulWidget {
  final Item selectedItem;
  final DateTime? startDate;
  final DateTime? endDate;

  const StockShow({
    required this.selectedItem,
    required this.startDate,
    required this.endDate,
  });

  @override
  _StockShowState createState() => _StockShowState();
}

class _StockShowState extends State<StockShow> {
  late SalesEntryService salesService;
  List<SalesEntry> suggestionItems6 = [];

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

  LedgerService ledgerService = LedgerService();

  Future<void> fetchSalesForSelectedItemAndDateRange(
      Item selectedItem, DateTime? startDate, DateTime? endDate) async {
    try {
      final List<SalesEntry> sales = await salesService.fetchSalesEntries();
      final filteredSalesEntry = sales.where((salesentry) {
        if (salesentry.entries
            .any((entry) => entry.itemName == selectedItem.id)) {
          if (startDate != null && endDate != null) {
            final entryDate = DateFormat('M/d/y').parse(salesentry.date);
            return entryDate.isAtSameMomentAs(startDate) ||
                entryDate.isAfter(startDate) && entryDate.isBefore(endDate) ||
                entryDate.isAtSameMomentAs(endDate);
          }
          return true;
        }
        return false;
      }).toList();
      setState(() {
        suggestionItems6 = filteredSalesEntry
            .where((itementry) => itementry.companyCode == companyCode!.first)
            .toList();
        ;
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

  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    setCompanyCode();
    salesService = SalesEntryService();
    fetchSalesForSelectedItemAndDateRange(
        widget.selectedItem, widget.startDate, widget.endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stock Voucher',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 33, 65, 243),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Stock Item: ${widget.selectedItem.itemName}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      fontSize: 18),
                ),
                const Spacer(),
                Text(
                  widget.startDate != null
                      ? dateFormat.format(widget.startDate!)
                      : 'Not selected',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      fontSize: 18),
                ),
                const Text(
                  ' to',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      fontSize: 18),
                ),
                Text(
                  ' ${widget.endDate != null ? dateFormat.format(widget.endDate!) : 'Not selected'}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      fontSize: 18),
                ),
              ],
            ),
            // Row(
            //   children: [
            //     Container(
            //       height: 20,
            //       width: MediaQuery.of(context).size.width * 0.061,
            //       decoration: const BoxDecoration(
            //           border: Border(
            //               bottom: BorderSide(),
            //               top: BorderSide(),
            //               left: BorderSide())),
            //       child: const Text(
            //         'Date',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //     Container(
            //       height: 20,
            //       width: MediaQuery.of(context).size.width * 0.30,
            //       decoration: const BoxDecoration(
            //           border: Border(
            //               bottom: BorderSide(),
            //               top: BorderSide(),
            //               left: BorderSide())),
            //       child: const Text(
            //         'Particular',
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //     Container(
            //       height: 20,
            //       width: MediaQuery.of(context).size.width * 0.061,
            //       decoration: const BoxDecoration(
            //           border: Border(
            //               bottom: BorderSide(),
            //               top: BorderSide(),
            //               left: BorderSide())),
            //       child: const Text(
            //         'Type',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //     Container(
            //       height: 20,
            //       width: MediaQuery.of(context).size.width * 0.061,
            //       decoration: const BoxDecoration(
            //           border: Border(
            //               bottom: BorderSide(),
            //               top: BorderSide(),
            //               left: BorderSide())),
            //       child: const Text(
            //         'No',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //     Container(
            //       height: 20,
            //       width: MediaQuery.of(context).size.width * 0.061,
            //       decoration: const BoxDecoration(
            //           border: Border(
            //               bottom: BorderSide(),
            //               top: BorderSide(),
            //               left: BorderSide())),
            //       child: const Text(
            //         'Qty',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //     Container(
            //       height: 20,
            //       width: MediaQuery.of(context).size.width * 0.061,
            //       decoration: const BoxDecoration(
            //           border: Border(
            //               bottom: BorderSide(),
            //               top: BorderSide(),
            //               left: BorderSide())),
            //       child: const Text(
            //         'In.Qty',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //     Container(
            //       height: 20,
            //       width: MediaQuery.of(context).size.width * 0.061,
            //       decoration: const BoxDecoration(
            //           border: Border(
            //               bottom: BorderSide(),
            //               top: BorderSide(),
            //               left: BorderSide())),
            //       child: const Text(
            //         'Value',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //     Container(
            //       height: 20,
            //       width: MediaQuery.of(context).size.width * 0.061,
            //       decoration: const BoxDecoration(
            //           border: Border(
            //               bottom: BorderSide(),
            //               top: BorderSide(),
            //               left: BorderSide())),
            //       child: const Text(
            //         'Out.Qty',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //     Container(
            //       height: 20,
            //       width: MediaQuery.of(context).size.width * 0.061,
            //       decoration: const BoxDecoration(
            //           border: Border(
            //               bottom: BorderSide(),
            //               top: BorderSide(),
            //               left: BorderSide())),
            //       child: const Text(
            //         'Value',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //     Container(
            //       height: 20,
            //       width: MediaQuery.of(context).size.width * 0.061,
            //       decoration: BoxDecoration(border: Border.all()),
            //       child: const Text(
            //         'CI.Qty',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //   ],
            // ),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: const Color.fromARGB(255, 33, 65, 243),
                                width: 1),
                          ),
                          child: Table(
                            border:
                                TableBorder.all(width: 1, color: Colors.white),
                            columnWidths: const {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(5),
                              2: FlexColumnWidth(1),
                              3: FlexColumnWidth(2),
                              4: FlexColumnWidth(2),
                              5: FlexColumnWidth(2),
                              6: FlexColumnWidth(2),
                              7: FlexColumnWidth(2),
                              8: FlexColumnWidth(2),
                              9: FlexColumnWidth(2),
                            },
                            children: [
                              const TableRow(
                                children: [
                                  TableCell(
                                      child: Text(
                                    "Date",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  )),
                                  TableCell(
                                      child: Text(
                                    "Particular",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  )),
                                  TableCell(
                                      child: Text(
                                    "Type",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  )),
                                  TableCell(
                                      child: Text(
                                    "No",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  )),
                                  TableCell(
                                      child: Text(
                                    "Qty",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  )),
                                  TableCell(
                                      child: Text(
                                    "In.Qty",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  )),
                                  TableCell(
                                      child: Text(
                                    "Value",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  )),
                                  TableCell(
                                      child: Text(
                                    "Out.Qty",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  )),
                                  TableCell(
                                      child: Text(
                                    "Value",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  )),
                                  TableCell(
                                      child: Text(
                                    "CI.Qty",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  )),
                                ],
                              ),
                              for (int i = 0; i < suggestionItems6.length; i++)
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          suggestionItems6[i].date,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FutureBuilder<Ledger?>(
                                          future: ledgerService.fetchLedgerById(
                                              suggestionItems6[i].party),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<Ledger?> snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              // While data is being fetched
                                              return const Text('');
                                            } else if (snapshot.hasError) {
                                              // If an error occurs
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else {
                                              // Data successfully fetched, display it
                                              return SizedBox(
                                                child: Text(
                                                  snapshot.data?.name ??
                                                      '', // Display the ledger name or empty string if data is null
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${suggestionItems6[i].no}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: SizedBox(
                                        height: 35,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListView.builder(
                                            itemCount: suggestionItems6[i]
                                                .entries
                                                .length,
                                            itemBuilder: (context, index) {
                                              final entry = suggestionItems6[i]
                                                  .entries[index];
                                              return Text(
                                                '${entry.qty}',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    const TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    const TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: SizedBox(
                                        height: 35,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListView.builder(
                                            itemCount: suggestionItems6[i]
                                                .entries
                                                .length,
                                            itemBuilder: (context, index) {
                                              final entry = suggestionItems6[i]
                                                  .entries[index];
                                              return Text(
                                                '${entry.amount}',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Row(
                            children: [
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.074,
                                child: const Text(
                                  '',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.19,
                                child: const Text(
                                  'Total',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.06,
                                child: const Text(
                                  '',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                // decoration: BoxDecoration(border: Border.all()),
                                width:
                                    MediaQuery.of(context).size.width * 0.075,
                                child: const Text(
                                  '',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                // decoration: BoxDecoration(border: Border.all()),
                                width:
                                    MediaQuery.of(context).size.width * 0.075,
                                child: const Text(
                                  '',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                // decoration: BoxDecoration(border: Border.all()),
                                width:
                                    MediaQuery.of(context).size.width * 0.075,
                                child: const Text(
                                  '0.00',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.075,
                                child: const Text(
                                  '0.00',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.075,
                                child: const Text(
                                  '0.00',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.075,
                                child: Text(
                                  suggestionItems6
                                      .fold<double>(
                                          0,
                                          (total, entry) =>
                                              total +
                                              entry.entries.fold<double>(
                                                  0,
                                                  (previousValue, element) =>
                                                      previousValue +
                                                      element.amount))
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.075,
                                child: const Text(
                                  '',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.75,
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            List1(
                              name: "Report",
                              onPressed: () {},
                            ),
                            List1(
                              name: "Print",
                              onPressed: () {},
                            ),
                            List1(
                              onPressed: () {
                                print('');
                              },
                            ),
                            List1(name: "", onPressed: () {}),
                            List1(
                              name: "Export Excel",
                              onPressed: () {
                                print('Edit button pressed');
                              },
                            ),
                            List1(
                              name: "",
                              onPressed: () {
                                print('Edit button pressed');
                              },
                            ),
                            List1(
                              onPressed: () {
                                print('Edit button pressed');
                              },
                            ),
                            List1(
                              onPressed: () {
                                print('Edit button pressed');
                              },
                            ),
                            List1(
                              name: "Find",
                              onPressed: () {
                                print('Edit button pressed');
                              },
                            ),
                            List1(
                              name: "Find Next",
                              onPressed: () {
                                print('Edit button pressed');
                              },
                            ),
                            List1(
                              onPressed: () {
                                print('Edit button pressed');
                              },
                            ),
                            List1(
                              name: "",
                              onPressed: () {
                                print('Edit button pressed');
                              },
                            ),
                            List1(
                              name: "",
                              onPressed: () {
                                print('Edit button pressed');
                              },
                            ),
                            List1(
                              name: "",
                              onPressed: () {
                                print('Edit button pressed');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomFooter(),
    );
  }
}

// class List1 extends StatelessWidget {
//   final String? name;
//   final String? Skey;
//   final Function onPressed;
//   const List1({super.key, this.name, this.Skey, required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;

//     return Padding(
//       padding: const EdgeInsets.only(top: 5),
//       child: InkWell(
//         splashColor: Colors.grey[350],
//         onTap: onPressed as void Function()?,
//         child: Container(
//           height: 35,
//           width: w * 0.1,
//           decoration: const BoxDecoration(
//             border: Border(
//               top:
//                   BorderSide(width: 2, color: Color.fromARGB(255, 33, 65, 243)),
//               right:
//                   BorderSide(width: 2, color: Color.fromARGB(255, 33, 65, 243)),
//               left:
//                   BorderSide(width: 2, color: Color.fromARGB(255, 33, 65, 243)),
//               bottom:
//                   BorderSide(width: 2, color: Color.fromARGB(255, 33, 65, 243)),
//             ),
//           ),
//           child: Expanded(
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 5,
//                   ),
//                   child: Expanded(
//                     child: Text(
//                       Skey ?? "",
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                           color: Colors.red,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     name ?? " ",
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                         color: Color.fromARGB(255, 33, 65, 243), fontSize: 15),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
