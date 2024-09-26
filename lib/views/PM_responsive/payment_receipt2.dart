import 'dart:typed_data';
import 'package:billingsphere/data/models/purchase/purchase_model.dart';
import 'package:billingsphere/data/repository/purchase_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/newCompany/new_company_model.dart';
import '../../data/models/payment/payment_model.dart';
import '../../data/models/user/user_group_model.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/new_company_repository.dart';
import '../../data/repository/payment_respository.dart';
import '../../data/repository/user_group_repository.dart';

class PaymentVoucherPrint extends StatefulWidget {
  const PaymentVoucherPrint(this.title, {super.key, required this.receiptID});
  final String receiptID;

  final String title;

  @override
  State<PaymentVoucherPrint> createState() => _PaymentVoucherPrintState();
}

class _PaymentVoucherPrintState extends State<PaymentVoucherPrint> {
  late SharedPreferences _prefs;

  List<NewCompany> selectedComapny = [];
  List<Ledger> fectedLedgers = [];
  List<Uint8List> _selectedImages = [];
  List<String>? companyCode;
  List<Purchase> fectedPurchase = [];
  String? fullName = '';
  UserGroupServices userGroupServices = UserGroupServices();
  List<UserGroup> userGroupM = [];

  NewCompanyRepository newCompanyRepo = NewCompanyRepository();
  LedgerService ledgerService = LedgerService();
  PaymentService paymentVchService = PaymentService();
  PurchaseServices purchaseService = PurchaseServices();

  Payment? paymentVch;
  bool isLoading = false;

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

  Future<void> fetchNewCompany() async {
    try {
      final newcom = await newCompanyRepo.getAllCompanies();

      final filteredCompany = newcom
          .where((company) =>
              company.stores!.any((store) => store.code == companyCode!.first))
          .toList();
      setState(() {
        selectedComapny = filteredCompany;
        _selectedImages =
            filteredCompany.first.logo1!.map((e) => e.data).toList();
      });
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

  Future<void> fetchPaymentById() async {
    final payment = await paymentVchService.fetchPaymentById(widget.receiptID);
    print(widget.receiptID);

    setState(() {
      paymentVch = payment;
    });
  }

  Future<void> fetchPurchase() async {
    try {
      final List<Purchase> purchase =
          await purchaseService.fetchPurchaseEntries();
      setState(() {
        fectedPurchase = purchase;
      });
    } catch (error) {
      print('Failed to fetch purchase: $error');
    }
  }

  Future<void> fetchLedger() async {
    try {
      final List<Ledger> ledgers = await ledgerService.fetchLedgers();
      setState(() {
        fectedLedgers = ledgers;
      });
    } catch (error) {
      print('Failed to fetch ledger name: $error');
    }
  }

  Future<void> fetchUserGroup() async {
    final List<UserGroup> userGroupFetch =
        await userGroupServices.getUserGroups();

    setState(() {
      userGroupM = userGroupFetch;
    });
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> initialize() async {
    setState(() {
      isLoading = true;
    });
    await Future.wait([
      _initPrefs().then((value) => {
            fullName = _prefs.getString('fullName'),
          }),
      fetchUserGroup().then((value) => {}),
    ]);
    print(fullName);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _initializeData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Future.wait([
        setCompanyCode(),
        fetchNewCompany(),
        fetchLedger(),
        fetchPurchase(),
        initialize(),
        fetchPaymentById(),
      ]);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _initializeData();
    // print(widget.receiptID);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isLoading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(widget.title),
                centerTitle: true,
              ),
              body: PdfPreview(
                build: (format) => _generatePdf(format, widget.title),
              ),
            ),
      debugShowCheckedModeBanner:
          false, // Set to false to hide the debug banner
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    // final font = await PdfGoogleFonts.nunitoExtraLight();
    final customFormat = PdfPageFormat.a4.copyWith(
      marginLeft: 20,
      marginRight: 20,
      marginTop: 20,
      marginBottom: 20,
    );
    String ledgerName = '';
    String ledgerName2 = '';
    int ledgerMobile = 0;
    String ledgerState = '';
    String companyName = '';
    String companyAddress = '';
    String companyEmail = '';
    String companyPhone = '';
    String companyGST = '';
    String companyState = '';
    String companyPan = '';
    double ledgerBalance = 0;

    // Check if selectedComapny is not empty and get the first company's name
    if (selectedComapny.isNotEmpty) {
      companyName = selectedComapny.first.companyName ?? 'Unknown';
      companyAddress = selectedComapny
          .firstWhere((company) => company.stores!
              .any((store) => store.code == paymentVch!.companyCode))
          .stores!
          .firstWhere((store) => store.code == paymentVch!.companyCode)
          .address;
      companyEmail = selectedComapny
          .firstWhere((company) => company.stores!
              .any((store) => store.code == paymentVch!.companyCode))
          .stores!
          .firstWhere((store) => store.code == paymentVch!.companyCode)
          .email;
      companyPhone = selectedComapny
          .firstWhere((company) => company.stores!
              .any((store) => store.code == paymentVch!.companyCode))
          .stores!
          .firstWhere((store) => store.code == paymentVch!.companyCode)
          .phone;
      companyGST = selectedComapny.first.gstin ?? '';
      companyState = selectedComapny
          .firstWhere((company) => company.stores!
              .any((store) => store.code == paymentVch!.companyCode))
          .stores!
          .firstWhere((store) => store.code == paymentVch!.companyCode)
          .state;
      companyPan = selectedComapny.first.pan ?? '';
    }
    // Check if paymentVch and its entries are not null and not empty
    if (paymentVch != null && paymentVch!.entries.isNotEmpty) {
      var ledgerId = paymentVch!.entries.first.ledger;
      var ledgerId2 = paymentVch!.entries.last.ledger;

      // Get the ledger name, mobile, and state with firstWhere and handle cases where no match is found
      ledgerName =
          fectedLedgers.firstWhere((ledger) => ledger.id == ledgerId).name;
      ledgerName2 =
          fectedLedgers.firstWhere((ledger) => ledger.id == ledgerId2).name;
      ledgerMobile =
          fectedLedgers.firstWhere((ledger) => ledger.id == ledgerId).mobile;

      ledgerState =
          fectedLedgers.firstWhere((ledger) => ledger.id == ledgerId).state;
      ledgerBalance = fectedLedgers
          .firstWhere((ledger) => ledger.id == ledgerId)
          .debitBalance;
    }

    bool isChequeDetailsNotEmpty(chequeDetails) {
      if (chequeDetails == null) return false;

      return (chequeDetails.chequeNo?.isNotEmpty ?? false) ||
          (chequeDetails.chequeDate?.isNotEmpty ?? false) ||
          (chequeDetails.depositDate?.isNotEmpty ?? false) ||
          (chequeDetails.batchNo?.isNotEmpty ?? false) ||
          (chequeDetails.bank?.isNotEmpty ?? false) ||
          (chequeDetails.branch?.isNotEmpty ?? false);
    }

    String displayledgerMobile = 'Mo. $ledgerMobile';
    String displayledgerName = ledgerName;
    String displayledgerName2 = ledgerName2;
    String displayledgerState = ledgerState;
    String displaycompanyName = companyName;
    String displaycompanyAddress = companyAddress;
    String displaycompanyEmail = companyEmail;
    String displaycompanyPhone = companyPhone;
    String displaycompanyGST = companyGST;
    String displaycompanyState = companyState;
    String displaycompanyPan = companyPan;
    double displayledgerBalance = ledgerBalance;

    pdf.addPage(
      pw.Page(
        pageFormat: customFormat,
        build: (context) {
          return pw.Column(
            children: [
              pw.Container(
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    border: pw.Border.all(color: PdfColors.black)),
                child: pw.Column(
                  children: [
                    pw.Row(
                      children: [
                        pw.SizedBox(width: 2),
                        pw.Container(
                          width: 40,
                          child: _selectedImages.isNotEmpty
                              ? pw.Image(pw.MemoryImage(_selectedImages[0]))
                              : pw.SizedBox(width: 50),
                        ),
                        pw.Spacer(),
                        pw.Container(
                          width: 300,
                          child: pw.Center(
                            child: pw.Column(
                              children: [
                                pw.Text(
                                  displaycompanyName,
                                  style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold),
                                  textAlign: pw.TextAlign.right,
                                ),
                                // pw.Text(
                                //   '"${selectedComapny.first.tagline}"',
                                //   style: pw.TextStyle(
                                //       fontSize: 12,
                                //       fontWeight: pw.FontWeight.normal),
                                // ),
                                pw.SizedBox(height: 5),
                                pw.Text(
                                  displaycompanyAddress,
                                  maxLines: 3,
                                  textAlign: pw.TextAlign.center,
                                  softWrap: true,
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.SizedBox(height: 2),

                                pw.Text(
                                  'E-mail: $displaycompanyEmail, Mo. $displaycompanyPhone',
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.SizedBox(width: 2),
                              ],
                            ),
                          ),
                        ),
                        pw.Spacer(),
                        pw.Container(
                          width: 40,
                          child: _selectedImages.isNotEmpty
                              ? pw.Image(pw.MemoryImage(_selectedImages[0]))
                              : pw.SizedBox(width: 50),
                        ),
                        pw.SizedBox(width: 2),
                      ],
                    ),
                    pw.SizedBox(width: 2),
                    pw.SizedBox(
                      width: customFormat.availableWidth,
                      child: pw.Row(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              'GSTIN : $displaycompanyGST',
                              style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Spacer(),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              'State : $displaycompanyState',
                              style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Spacer(),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              'PAN : $displaycompanyPan',
                              style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              pw.Container(
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Center(
                  child: pw.Text(
                    'PAYMENT VOUCHER',
                    style: pw.TextStyle(
                        fontSize: 10, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),
              //Payment No and Date
              pw.Container(
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Row(
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(2.0),
                      width: 80,
                      child: pw.Text(
                        'Payment No. : ',
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(2.0),
                      width: 70,
                      child: pw.Text(
                        paymentVch!.no.toString(),
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Spacer(),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(2.0),
                      width: 50,
                      child: pw.Text(
                        'Date : ',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(2.0),
                      width: 80,
                      child: pw.Text(
                        paymentVch!.date,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              //Party
              pw.Container(
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Column(
                  children: [
                    pw.Row(
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(2.0),
                          width: 50,
                          child: pw.Text(
                            'Party : ',
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(2.0),
                          width: 200,
                          child: pw.Text(
                            displayledgerName,
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(2.0),
                          width: 50,
                          child: pw.Text(
                            '',
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(2.0),
                          width: 200,
                          child: pw.Text(
                            displayledgerMobile,
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(2.0),
                          width: 50,
                          child: pw.Text(
                            '',
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(2.0),
                          width: 200,
                          child: pw.Text(
                            displayledgerState,
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //Table
              pw.Container(
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(2.0),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        ' Please be informed that we have made payment of Rs. ${paymentVch!.totalamount.toStringAsFixed(2)}',
                        style: pw.TextStyle(
                            fontSize: 8, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Container(
                        width: 350,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Container(
                              width: 87.5,
                              height: 18,
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text(
                                'Adjusted Bills',
                                textAlign: pw.TextAlign.start,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 8.5),
                              ),
                            ),
                            pw.Container(
                              width: 87.5,
                              height: 18,
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'Date',
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 8.5),
                              ),
                            ),
                            pw.Container(
                              width: 87.5,
                              height: 18,
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'Ref. Amount',
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 8.5),
                              ),
                            ),
                            pw.Container(
                              width: 87.5,
                              height: 18,
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                'Adj. Amount',
                                textAlign: pw.TextAlign.end,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 8.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.Container(
                        width: 350,
                        child: pw.ListView(
                          children: paymentVch!.billwise.map((payment) {
                            Purchase? purchase = fectedPurchase.firstWhere(
                              (purchase) => purchase.id == payment.purchase,
                            );
                            return pw.Table(
                              children: [
                                pw.TableRow(
                                  children: [
                                    pw.SizedBox(
                                      width: 87.5,
                                      child: pw.Padding(
                                        padding: const pw.EdgeInsets.all(2.0),
                                        child: pw.Text(
                                          payment.billNo,
                                          textAlign: pw.TextAlign.start,
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              fontSize: 8),
                                        ),
                                      ),
                                    ),
                                    pw.SizedBox(
                                      width: 87.5,
                                      child: pw.Padding(
                                        padding: const pw.EdgeInsets.all(2.0),
                                        child: pw.Text(
                                          payment.date,
                                          textAlign: pw.TextAlign.center,
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              fontSize: 8),
                                        ),
                                      ),
                                    ),
                                    pw.SizedBox(
                                      width: 87.5,
                                      child: pw.Padding(
                                        padding: const pw.EdgeInsets.all(2.0),
                                        child: pw.Text(
                                          purchase != null
                                              ? (double.parse(
                                                      purchase.totalamount)
                                                  .toStringAsFixed(2))
                                              : '0.00',
                                          textAlign: pw.TextAlign.center,
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              fontSize: 8),
                                        ),
                                      ),
                                    ),
                                    pw.SizedBox(
                                      width: 87.5,
                                      child: pw.Padding(
                                        padding: const pw.EdgeInsets.all(2.0),
                                        child: pw.Text(
                                          payment.amount.toStringAsFixed(2),
                                          textAlign: pw.TextAlign.end,
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              fontSize: 8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      pw.Container(
                        child: isChequeDetailsNotEmpty(
                                paymentVch?.chequeDetails)
                            ? pw.Column(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Container(
                                    width: 100,
                                    child: pw.Text(
                                      'Cheque Details : ',
                                      style: pw.TextStyle(
                                        fontSize: 8,
                                        fontWeight: pw.FontWeight.bold,
                                        decoration: pw.TextDecoration.underline,
                                        decorationThickness: 2,
                                      ),
                                    ),
                                  ),
                                  pw.SizedBox(height: 2),
                                  pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Container(
                                        width: 60,
                                        child: pw.Text(
                                          'Cheque No : ',
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      pw.Container(
                                        width: 120,
                                        child: pw.Text(
                                          '${paymentVch!.chequeDetails!.chequeNo}',
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      pw.Container(
                                        width: 60,
                                        child: pw.Text(
                                          'Cheque Date : ',
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      pw.Container(
                                        width: 120,
                                        child: pw.Text(
                                          '${paymentVch!.chequeDetails!.chequeDate}',
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  pw.SizedBox(height: 2),
                                  pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Container(
                                        width: 60,
                                        child: pw.Text(
                                          'Deposit Date : ',
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      pw.Container(
                                        width: 120,
                                        child: pw.Text(
                                          '${paymentVch!.chequeDetails!.depositDate}',
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      pw.Container(
                                        width: 60,
                                        child: pw.Text(
                                          'Batch No : ',
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      pw.Container(
                                        width: 120,
                                        child: pw.Text(
                                          '${paymentVch!.chequeDetails!.batchNo}',
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  pw.SizedBox(height: 2),
                                  pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Container(
                                        width: 60,
                                        child: pw.Text(
                                          'Bank : ',
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      pw.Container(
                                        width: 120,
                                        child: pw.Text(
                                          '${paymentVch!.chequeDetails!.bank}',
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      pw.Container(
                                        width: 60,
                                        child: pw.Text(
                                          'Branch : ',
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      pw.Container(
                                        width: 120,
                                        child: pw.Text(
                                          '${paymentVch!.chequeDetails!.branch}',
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : pw.SizedBox(),
                      ),
                      paymentVch!.narration!.isNotEmpty
                          ? pw.Container(
                              child: pw.Column(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Container(
                                        width: 60,
                                        child: pw.Text(
                                          'Payment Ref : ',
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      pw.Container(
                                        child: pw.Text(
                                          '${paymentVch!.narration} ',
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : pw.SizedBox(),
                    ],
                  ),
                ),
              ),

              // Total Amount
              pw.Container(
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Row(
                  children: [
                    pw.Container(
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(5.0),
                        child: pw.Text(
                          'Rs.       ${paymentVch!.totalamount.toStringAsFixed(2)} ',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            decoration: pw.TextDecoration.underline,
                            decorationThickness:
                                2.0, // Adjust the thickness as needed
                          ),
                        ),
                      ),
                    ),
                    pw.Container(
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(
                                width: 60,
                                child: pw.Text(
                                  'Payment A/c:',
                                  style: pw.TextStyle(
                                    fontSize: 8,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                              pw.Container(
                                child: pw.Text(
                                  displayledgerName2,
                                  style: pw.TextStyle(
                                    fontSize: 8,
                                    fontWeight: pw.FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(
                                width: 60,
                                child: pw.Text(
                                  'Balance: ',
                                  style: pw.TextStyle(
                                    fontSize: 8,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                              pw.Container(
                                child: pw.Text(
                                  displayledgerBalance.toStringAsFixed(2),
                                  style: pw.TextStyle(
                                    fontSize: 8,
                                    fontWeight: pw.FontWeight.normal,
                                    color: PdfColors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              pw.Container(
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // pw.Container(
                        //   padding: const pw.EdgeInsets.all(2.0),
                        //   child: pw.Text(
                        //     '(Cheque Payment subject to Realization)',
                        //     style: const pw.TextStyle(fontSize: 6),
                        //   ),
                        // ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(2.0),
                          child: pw.Text(
                            '$fullName: $formattedDate $formattedTime',
                            style: pw.TextStyle(
                                fontSize: 8, fontWeight: pw.FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                    pw.Spacer(),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(2.0),
                      child: pw.Text(
                        ' Received By, $displaycompanyName',
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }
}
