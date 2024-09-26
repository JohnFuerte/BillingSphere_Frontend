// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/newCompany/new_company_model.dart';
import '../../data/models/purchase/purchase_model.dart';
import '../../data/repository/item_repository.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/new_company_repository.dart';
import '../../data/repository/purchase_repository.dart';

class PurchaseReceiptByID extends StatefulWidget {
  const PurchaseReceiptByID({super.key, required this.purchaseId});
  final String purchaseId;

  @override
  State<PurchaseReceiptByID> createState() => _PurchaseReceiptByIDState();
}

class _PurchaseReceiptByIDState extends State<PurchaseReceiptByID> {
  //Services
  LedgerService ledgerService = LedgerService();
  ItemsService itemsService = ItemsService();
  PurchaseServices purchaseService = PurchaseServices();
  //Model
  Purchase? _PurchaseEntry;
  bool isLoading = false;

  void fetchPurchaseById() async {
    setState(() {
      isLoading = true;
    });
    final sales = await purchaseService.fetchPurchaseById(widget.purchaseId);
    setState(() {
      _PurchaseEntry = sales;
      isLoading = false;
    });
  }

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

  List<NewCompany> selectedComapny = [];
  NewCompanyRepository newCompanyRepo = NewCompanyRepository();

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

  @override
  void initState() {
    super.initState();
    setCompanyCode();
    fetchPurchaseById();
    fetchNewCompany();
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
            body: SingleChildScrollView(
              child: Center(
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
                              selectedComapny.first.companyName!,
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
                            '',
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Receipt No:         ${_PurchaseEntry!.billNumber}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'Date:               ${_PurchaseEntry!.date}',
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  child: Row(
                                    children: [
                                      FutureBuilder<Ledger?>(
                                        future: ledgerService.fetchLedgerById(
                                            _PurchaseEntry!.ledger),
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
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'M/s. ${snapshot.data!.name}',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  snapshot.data!.address,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                                Text(
                                                  'GSTIN: ${snapshot.data!.gst}',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                                Text(
                                                  '${snapshot.data!.city}, India',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ));
                                          }
                                        },
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
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
                                        'Rs. ${_PurchaseEntry!.totalamount}.00',
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
                                            'Rate',
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
                                            'Tax',
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
                                        rows: _PurchaseEntry!.entries
                                            .map((entry) {
                                          return DataRow(
                                            cells: [
                                              DataCell(
                                                Text(
                                                  '${_PurchaseEntry!.date}',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              DataCell(
                                                // Give me future builder example
                                                FutureBuilder(
                                                  future: itemsService
                                                      .fetchItemById(
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
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  entry.rate.toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
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
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  '${entry.tax.toString()}%',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
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
                                                    fontWeight:
                                                        FontWeight.normal,
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
            ),
          );
  }
}
