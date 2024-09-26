import 'dart:typed_data';
import 'package:billingsphere/data/models/ledger/ledger_model.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/newCompany/new_company_model.dart';
import '../../data/models/payment/payment_model.dart';
import '../../data/models/purchase/purchase_model.dart';
import '../../data/models/receiptVoucher/receipt_voucher_model.dart';
import '../../data/models/salesEntries/sales_entrires_model.dart';
import '../../data/models/user/user_group_model.dart';
import '../../data/repository/new_company_repository.dart';
import '../../data/repository/user_group_repository.dart';

class LedgerStatmentPrint extends StatefulWidget {
  const LedgerStatmentPrint(
    this.title, {
    super.key,
    required this.id,
    this.startDate,
    this.endDate,
    required this.combinedData,
    required this.totalAmountSumSales,
    required this.totalAmountSumPurchase,
    required this.totalAmountSumReceipt,
    required this.totalAmountSumPayment,
  });
  final Ledger id;
  final String title;

  final DateTime? startDate;
  final DateTime? endDate;
  final List<dynamic> combinedData;
  final double totalAmountSumSales;
  final double totalAmountSumPurchase;
  final double totalAmountSumReceipt;
  final double totalAmountSumPayment;

  @override
  State<LedgerStatmentPrint> createState() => _LedgerStatmentPrintState();
}

class _LedgerStatmentPrintState extends State<LedgerStatmentPrint> {
  bool isLoading = false;

  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());

  late String formattedStartDate;
  late String formattedEndDate;

  late SharedPreferences _prefs;
  String? fullName = '';

  Future<void> _initializeData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Future.wait([
        setCompanyCode(),
        fetchNewCompany(),
      ]);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  double balance = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeData();
    initialize();

    DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    // Format the start and end dates
    formattedStartDate =
        widget.startDate != null ? dateFormat.format(widget.startDate!) : 'N/A';
    formattedEndDate =
        widget.endDate != null ? dateFormat.format(widget.endDate!) : 'N/A';
    balance = widget.id.openingBalance;
  }

  List<NewCompany> selectedComapny = [];
  NewCompanyRepository newCompanyRepo = NewCompanyRepository();
  List<String>? companyCode;
  UserGroupServices userGroupServices = UserGroupServices();
  List<UserGroup> userGroupM = [];

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
    await Future.wait([
      _initPrefs().then((value) => {
            fullName = _prefs.getString('fullName'),
          }),
      fetchUserGroup().then((value) => {}),
    ]);
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
    String companyName = '';
    String companyAddress = '';
    String companyBankName = '';
    String companyBranchName = '';
    String companyIFSCCOde = '';
    String companyAccNumber = '';
    String companyAccName = '';
    double totalDebit = 0.00;
    double totalCredit = 0.00;
    double totalBalance = 0.00;
    totalDebit = widget.totalAmountSumSales + widget.totalAmountSumPayment;
    totalCredit = widget.totalAmountSumPurchase + widget.totalAmountSumReceipt;
    totalBalance = totalDebit - totalCredit;

    if (selectedComapny.isNotEmpty) {
      companyName = selectedComapny.first.companyName ?? 'Unknown';
      companyAddress = selectedComapny.first.stores!.first.address;
      companyBankName = selectedComapny.first.stores!.first.bankName;
      companyBranchName = selectedComapny.first.stores!.first.branch;
      companyIFSCCOde = selectedComapny.first.stores!.first.ifsc;
      companyAccNumber = selectedComapny.first.stores!.first.accountNo;
      companyAccName = selectedComapny.first.stores!.first.accountName;
    }

    pdf.addPage(
      pw.Page(
        pageFormat: customFormat,
        build: (context) {
          return pw.Column(
            children: [
              pw.Container(
                width: customFormat.availableWidth,
                child: pw.Text(
                  '$fullName: $formattedDate $formattedTime',
                  style: pw.TextStyle(
                      fontSize: 8, fontWeight: pw.FontWeight.normal),
                  textAlign: pw.TextAlign.start,
                ),
              ),
              pw.Container(
                width: customFormat.availableWidth,
                height: 35,
                child: pw.Text(
                  companyName,
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                width: customFormat.availableWidth,
                height: 50,
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                        color: PdfColors.black, style: pw.BorderStyle.dotted)),
                child: pw.Text(
                  companyAddress,
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Divider(),
              pw.Container(
                width: customFormat.availableWidth,
                height: 35,
                child: pw.Text(
                  'ACCOUNT LEDGER',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    decoration: pw.TextDecoration.underline,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                width: customFormat.availableWidth,
                decoration: const pw.BoxDecoration(
                  color: PdfColors.white,
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 375,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 2.0),
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.SizedBox(height: 5),
                            pw.Row(
                              children: [
                                pw.Container(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text('Ledger :  ${widget.id.name}',
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 2),
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: 45,
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text('',
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Container(
                                  width: 320,
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text(widget.id.address,
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              children: [
                                pw.Container(
                                  padding: const pw.EdgeInsets.all(2.0),
                                  child: pw.Text('Phone :  ${widget.id.mobile}',
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.Container(
                      width: 180,
                      alignment: pw.Alignment.bottomRight,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(2.0),
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.Container(
                                  width: 180,
                                  child: pw.Text(
                                    'From $formattedStartDate to $formattedEndDate  ',
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.bold),
                                    textAlign: pw.TextAlign.end,
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
              pw.Container(
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Expanded(
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Container(
                        width: 50,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Date',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 155,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Particulars',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 50,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Type',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 50,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'No',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 83,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Debit',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 83,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Credit',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 83,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Balance',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.Container(
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Expanded(
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Container(
                        width: 50,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          '',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 155,
                        height: 18,
                        alignment: pw.Alignment.centerLeft,
                        padding: const pw.EdgeInsets.all(2.0),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Opening Balance',
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 50,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          '',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 50,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          '',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 83,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          '',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 83,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          '',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 83,
                        height: 18,
                        alignment: pw.Alignment.centerRight,
                        padding: const pw.EdgeInsets.all(2.0),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          (widget.id.openingBalance).toStringAsFixed(2),
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.Container(
                // height: 215,
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.ListView.builder(
                  itemCount: widget.combinedData.length,
                  itemBuilder: (context, index) {
                    final item = widget.combinedData[index];
                    String date = '';
                    String particulars = '';
                    String type = '';
                    String noRef = '';
                    double debit = 0.0;
                    double credit = 0.0;

                    if (item is SalesEntry) {
                      date = item.date;
                      particulars = 'Sales Entry';
                      type = 'TI';
                      noRef = item.dcNo;
                      debit = double.parse(item.totalamount);
                      balance -= debit;
                    } else if (item is ReceiptVoucher) {
                      date = item.date;
                      particulars = 'Receipt Entry';
                      type = 'RCPT';
                      noRef = item.no.toString();
                      credit = item.totalamount;
                      balance += credit;
                    } else if (item is Purchase) {
                      date = item.date;
                      particulars = 'Purchase Entry';
                      type = 'RP';
                      noRef = item.no.toString();
                      credit = double.parse(item.totalamount);
                      balance += credit;
                    } else if (item is Payment) {
                      date = item.date;
                      particulars = 'Payment Entry';
                      type = 'PYM';
                      noRef = item.no.toString();
                      debit = item.totalamount;
                      balance -= debit;
                    }

                    return pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: 50.5,
                          height: 18,
                          alignment: pw.Alignment.centerLeft,
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(
                              bottom: pw.BorderSide(),
                              top: pw.BorderSide(),
                              left: pw.BorderSide(),
                            ),
                          ),
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              date,
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 8.5),
                            ),
                          ),
                        ),
                        pw.Container(
                          width: 155,
                          height: 18,
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(
                              bottom: pw.BorderSide(),
                              top: pw.BorderSide(),
                              left: pw.BorderSide(),
                            ),
                          ),
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              particulars,
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 8.5),
                            ),
                          ),
                        ),
                        pw.Container(
                          width: 50,
                          height: 18,
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(
                              bottom: pw.BorderSide(),
                              top: pw.BorderSide(),
                              left: pw.BorderSide(),
                            ),
                          ),
                          alignment: pw.Alignment.center,
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              type,
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 8.5),
                            ),
                          ),
                        ),
                        pw.Container(
                          width: 50,
                          height: 18,
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(
                              bottom: pw.BorderSide(),
                              top: pw.BorderSide(),
                              left: pw.BorderSide(),
                            ),
                          ),
                          alignment: pw.Alignment.center,
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              noRef,
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 8.5),
                            ),
                          ),
                        ),
                        pw.Container(
                          width: 83,
                          height: 18,
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(
                              bottom: pw.BorderSide(),
                              top: pw.BorderSide(),
                              left: pw.BorderSide(),
                            ),
                          ),
                          alignment: pw.Alignment.centerRight,
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              debit == 0 ? '' : debit.toStringAsFixed(2),
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 8.5),
                            ),
                          ),
                        ),
                        pw.Container(
                          width: 83,
                          height: 18,
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(
                              bottom: pw.BorderSide(),
                              top: pw.BorderSide(),
                              left: pw.BorderSide(),
                            ),
                          ),
                          alignment: pw.Alignment.centerRight,
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              credit == 0 ? '' : credit.toStringAsFixed(2),
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 8.5),
                            ),
                          ),
                        ),
                        pw.Container(
                          width: 83,
                          height: 18,
                          alignment: pw.Alignment.centerRight,
                          decoration: pw.BoxDecoration(border: pw.Border.all()),
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.all(2.0),
                            child: pw.Text(
                              balance.abs().toStringAsFixed(2),
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 8.5),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              pw.Container(
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Expanded(
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Container(
                        width: 50,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          '',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 155,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Opening Balance : ',
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 50,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          '',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 50,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          '',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 83,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          '',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 83,
                        height: 18,
                        alignment: pw.Alignment.centerRight,
                        padding: const pw.EdgeInsets.all(2.0),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          (widget.id.openingBalance).toStringAsFixed(2),
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 83,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          '',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.Container(
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Expanded(
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Container(
                        width: 50,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          '',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 155,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Transaction Total : ',
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 50,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          '',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 50,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          '',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 83,
                        height: 18,
                        alignment: pw.Alignment.centerRight,
                        padding: const pw.EdgeInsets.all(2.0),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          (totalDebit).toStringAsFixed(2),
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 83,
                        height: 18,
                        alignment: pw.Alignment.centerRight,
                        padding: const pw.EdgeInsets.all(2.0),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          (totalCredit).toStringAsFixed(2),
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 83,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          '',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.Container(
                width: customFormat.availableWidth,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Expanded(
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Container(
                        width: 50,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          '',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 155,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          'Closing Balance : ',
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 50,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          '',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 50,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          '',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 83,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          '',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 83,
                        height: 18,
                        alignment: pw.Alignment.centerRight,
                        padding: const pw.EdgeInsets.all(2.0),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          (totalBalance).toStringAsFixed(2),
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                      pw.Container(
                        width: 83,
                        height: 18,
                        alignment: pw.Alignment.center,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(),
                          ),
                        ),
                        child: pw.Text(
                          '',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Container(
                width: customFormat.availableWidth,
                // height: 35,
                child: pw.Text(
                  'Our Bank Account Details',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    decoration: pw.TextDecoration.underline,
                  ),
                  textAlign: pw.TextAlign.start,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Row(
                children: [
                  pw.Container(
                    width: 80,
                    padding: const pw.EdgeInsets.all(2.0),
                    child: pw.Text('Bank Name : ',
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Container(
                    width: 200,
                    padding: const pw.EdgeInsets.all(2.0),
                    child: pw.Text(companyBankName,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                ],
              ),
              pw.Row(
                children: [
                  pw.Container(
                    width: 80,
                    padding: const pw.EdgeInsets.all(2.0),
                    child: pw.Text('Branch Name : ',
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Container(
                    width: 200,
                    padding: const pw.EdgeInsets.all(2.0),
                    child: pw.Text(companyBranchName,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                ],
              ),
              pw.Row(
                children: [
                  pw.Container(
                    width: 80,
                    padding: const pw.EdgeInsets.all(2.0),
                    child: pw.Text('IFSC Code : ',
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Container(
                    width: 200,
                    padding: const pw.EdgeInsets.all(2.0),
                    child: pw.Text(companyIFSCCOde,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                ],
              ),
              pw.Row(
                children: [
                  pw.Container(
                    width: 80,
                    padding: const pw.EdgeInsets.all(2.0),
                    child: pw.Text('A/c Number  : ',
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Container(
                    width: 200,
                    padding: const pw.EdgeInsets.all(2.0),
                    child: pw.Text(companyAccNumber,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                ],
              ),
              pw.Row(
                children: [
                  pw.Container(
                    width: 80,
                    padding: const pw.EdgeInsets.all(2.0),
                    child: pw.Text('A/c Name : ',
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Container(
                    width: 200,
                    padding: const pw.EdgeInsets.all(2.0),
                    child: pw.Text(companyAccName,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }
}
