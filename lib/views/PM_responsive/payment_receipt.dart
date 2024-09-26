import 'dart:ui';

import 'package:billingsphere/data/repository/ledger_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/payment/payment_model.dart';
import '../../data/repository/payment_respository.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  Payment? fetchedPayments;
  PaymentService paymentService = PaymentService();
  LedgerService ledgerService = LedgerService();
  String? selectedId;
  bool isLoading = false;
  String? companyCode;
  Future<String?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('companyCode');
  }

  Future<void> setCompanyCode() async {
    String? code = await getCompanyCode();
    setState(() {
      companyCode = code;
    });
  }

  Future<void> fetchPayments() async {
    setState(() {
      isLoading = true;
    });
    try {
      final List<Payment> payments = await paymentService.fetchPayments();
      final filteredPayments = payments
          .where((payment) => payment.companyCode == companyCode)
          .toList();

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        fetchedPayments = filteredPayments.last;
        selectedId = fetchedPayments?.id;
        isLoading = false;
      });

      print('Fetched payment name: ${fetchedPayments?.date}');
    } catch (error) {
      print('Failed to fetch payment name: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    setCompanyCode().then((_) {
      fetchPayments();
    });
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
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: SizedBox(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'From: ',
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text('Hardik Expo',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 15)),
                                          Text('Gujarat, India',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 15)),
                                          Text('Phone: 1234567890',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 15)),
                                          Text('johngospel003@gmail.com',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 15)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: SizedBox(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Invoice #:  ${fetchedPayments!.no}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
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
                                        0.018,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      color: Colors.grey.shade400,
                                    ),
                                    child: Text(
                                      ' Sr.',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.383,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      color: Colors.grey.shade400,
                                    ),
                                    child: Text(
                                      '  Ledger Name',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.051,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      color: Colors.grey.shade400,
                                    ),
                                    child: Text(
                                      '  Dr.',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.0451,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      color: Colors.grey.shade400,
                                    ),
                                    child: Text(
                                      '  Cr.',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // DataTable
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.53,
                              height: MediaQuery.of(context).size.height * 0.58,
                              child: ListView.builder(
                                itemCount: fetchedPayments!.entries.length,
                                itemBuilder: (context, index) => Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.019,
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                      ),
                                      child: Text(
                                        ' ${index + 1}',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.383,
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                        ),
                                        child: FutureBuilder(
                                          future: ledgerService.fetchLedgerById(
                                              fetchedPayments!
                                                  .entries[index].ledger),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                child: Text(''),
                                              );
                                            }
                                            return Text(
                                              snapshot.data!.name.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          },
                                        )),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.051,
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                      ),
                                      child: Text(
                                        fetchedPayments!.entries[index].debit!
                                            .toStringAsFixed(2)
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.0451,
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                      ),
                                      child: Text(
                                        fetchedPayments!.entries[index].credit!
                                            .toStringAsFixed(2)
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: SizedBox(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total Debit: ',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Total Credit: ',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Overral Balance: ',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '₹${fetchedPayments!.entries.fold<double>(0, (previousValue, element) => previousValue + (element.debit!)).toStringAsFixed(2)}',
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '₹${fetchedPayments!.entries.fold<double>(0, (previousValue, element) => previousValue + (element.credit!)).toStringAsFixed(2)}',
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '₹${fetchedPayments!.totalamount}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                            Text('Thanks for your business!',
                                style: GoogleFonts.poppins(fontSize: 15)),
                          ],
                        ),
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
                          // Navigator.of(context).pop();
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
                ],
              ),
            ),
          );
  }

  String amountToWords(double amount) {
    final NumberFormat formatter = NumberFormat.compact(locale: 'en_IN');
    final String amountInWords = formatter.format(amount);

    print('Amount in words: $amountInWords');

    return amountInWords == '0' ? 'Zero Rupees Only' : amountInWords;
  }
}
