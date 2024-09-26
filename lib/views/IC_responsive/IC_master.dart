import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/inwardChallan/inward_challan_model.dart';
import '../../data/repository/inward_challan_repository.dart';
import '../../data/repository/ledger_repository.dart';
import 'IC_receipt.dart';

class InwardChallanHome extends StatefulWidget {
  const InwardChallanHome({super.key});

  @override
  State<InwardChallanHome> createState() => _InwardChallanHomeState();
}

class _InwardChallanHomeState extends State<InwardChallanHome> {
  List<InwardChallan> fetchedInward = [];
  LedgerService ledgerService = LedgerService();

  String? selectedId;
  bool isLoading = false;

  InwardChallanServices inwardChallanrepo = InwardChallanServices();
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

  Future<void> fetchAllIC() async {
    setState(() {
      isLoading = true;
    });

    try {
      final List<InwardChallan> ic =
          await inwardChallanrepo.fetchInwardChallan();

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        if (ic.isNotEmpty) {
          fetchedInward = ic;
          selectedId = fetchedInward[0].id;
        } else {
          fetchedInward = ic;
        }
        isLoading = false;
      });

      print(ic);
    } catch (error) {
      print('Failed to fetch Devlivery Challan: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllIC();
    setCompanyCode();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrangeAccent,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'INWARD CHALLAN LIST',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              foregroundColor: Colors.white,
              backgroundColor: Colors.deepOrangeAccent,
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Table(
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(2),
                            3: FlexColumnWidth(2),
                            4: FlexColumnWidth(4),
                            5: FlexColumnWidth(4),
                          },
                          border: TableBorder.all(color: Colors.grey),
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Text(
                                    "Sr",
                                    style: GoogleFonts.poppins(
                                      color: Colors.pinkAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    "Date",
                                    style: GoogleFonts.poppins(
                                      color: Colors.pinkAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    "Bill No",
                                    style: GoogleFonts.poppins(
                                      color: Colors.pinkAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    "Type",
                                    style: GoogleFonts.poppins(
                                      color: Colors.pinkAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    "Particulars",
                                    style: GoogleFonts.poppins(
                                      color: Colors.pinkAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    "Action",
                                    style: GoogleFonts.poppins(
                                      color: Colors.pinkAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: fetchedInward.length,
                          itemBuilder: (context, index) {
                            int itemNumber = index + 1;
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              elevation: 1,
                              child: ListTile(
                                title: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.04,
                                      child: Text(
                                        itemNumber.toString(),
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.145,
                                      child: Text(
                                        fetchedInward[index].date,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.135,
                                      child: Text(
                                        fetchedInward[index].dcNo,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.135,
                                      child: Text(
                                        fetchedInward[index].type,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.265,
                                      child: Text(
                                        fetchedInward[index].type,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    StatefulBuilder(
                                      builder: (context, setState) {
                                        return SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.16,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              // IconButton(
                                              //   icon: const Icon(
                                              //     Icons.edit,
                                              //     color: Colors.green,
                                              //     size: 15,
                                              //   ),
                                              //   onPressed: () {
                                              //     // Navigator.of(context).push(
                                              //     //   MaterialPageRoute(
                                              //     //     builder: (context) =>
                                              //     //         SalesEditScreen(
                                              //     //       salesEntryId:
                                              //     //           fetchedDelivery[index]
                                              //     //               .id,
                                              //     //     ),
                                              //     //   ),
                                              //     // );
                                              //   },
                                              // ),

                                              const Spacer(),
                                              // IconButton(
                                              //   icon: const Icon(
                                              //     Icons.delete,
                                              //     color: Colors.pinkAccent,
                                              //     size: 15,
                                              //   ),
                                              //   onPressed: () {
                                              //     showDialog(
                                              //       context: context,
                                              //       builder: (context) {
                                              //         return AlertDialog(
                                              //           title: const Text(
                                              //               'Delete Purchase'),
                                              //           content: const Text(
                                              //               'Are you sure you want to delete this sales?'),
                                              //           actions: [
                                              //             TextButton(
                                              //               onPressed: () {
                                              //                 Navigator.of(
                                              //                         context)
                                              //                     .pop();
                                              //               },
                                              //               child: const Text(
                                              //                   'No'),
                                              //             ),
                                              //             TextButton(
                                              //               onPressed: () {},
                                              //               child: const Text(
                                              //                   'Yes'),
                                              //             ),
                                              //           ],
                                              //         );
                                              //       },
                                              //     );
                                              //   },
                                              // ),

                                              const Spacer(),
                                              IconButton(
                                                icon: const Icon(Icons.print,
                                                    size: 15,
                                                    color: Colors.blue),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ICReceipt(
                                                        'Print Inward Challan',
                                                        inwardChallan:
                                                            fetchedInward[index]
                                                                .id,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
