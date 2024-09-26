import 'package:billingsphere/data/models/receiptVoucher/receipt_voucher_model.dart';
import 'package:billingsphere/data/repository/payment_respository.dart';
import 'package:billingsphere/data/repository/receipt_voucher_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/payment/payment_model.dart';
import '../../data/models/purchase/purchase_model.dart';
import '../../data/models/salesEntries/sales_entrires_model.dart';
import '../../data/repository/purchase_repository.dart';
import '../../data/repository/sales_enteries_repository.dart';
import '../sumit_screen/voucher _entry.dart/voucher_list_widget.dart';
import 'Quick_Entries/quick_entry_payment.dart';
import 'Quick_Entries/quick_entry_receipt.dart';
import 'ledger_statment_print.dart';

class LedgerShow extends StatefulWidget {
  final Ledger selectedLedger;
  final DateTime? startDate;
  final DateTime? endDate;

  const LedgerShow(
      {super.key, required this.selectedLedger, this.startDate, this.endDate});

  @override
  State<LedgerShow> createState() => _LedgerShowState();
}

class _LedgerShowState extends State<LedgerShow> {
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  // Fetch Purchase
  List<Purchase> suggestionPurchase = [];
  String? selectedPurchase;
  PurchaseServices purchaseService = PurchaseServices();

  // Fetch Sales
  List<SalesEntry> suggestionSales = [];
  String? selectedSales;
  SalesEntryService salesService = SalesEntryService();

  // Fetch Receipt
  List<ReceiptVoucher> suggestionReceipt = [];
  String? selectedReceipt;
  ReceiptVoucherService receiptService = ReceiptVoucherService();

  //Fetch Payment
  List<Payment> suggestionPayment = [];
  String? selectedPayment;
  PaymentService paymentService = PaymentService();

  List<String>? companyCode;
  Future<List<String>?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('companies');
  }

  Future<void> setCompanyCode() async {
    List<String>? code = await getCompanyCode();
    setState(() {
      companyCode = code;
      print(companyCode);
    });
  }

  List<dynamic> combinedData = [];

  double totalAmountSumSales = 0.00;
  double totalAmountSumReceipt = 0.00;
  double totalAmountSumPurchase = 0.00;
  double totalAmountSumPayment = 0.00;
  double totalDebit = 0.00;
  double totalCredit = 0.00;
  double totalBalance = 0.00;
  double displayedBalance = 0.00;
  double balance = 0.0;

  Future<void> fetchSalesAndPurchase() async {
    try {
      final List<SalesEntry> sales = await salesService.fetchSalesEntries();
      final List<Purchase> purchase = await purchaseService.getPurchase();
      final List<ReceiptVoucher> receipt =
          await receiptService.fetchReceiptVoucherEntries();
      final List<Payment> payment = await paymentService.fetchPayments();

      final filteredSalesEntry = sales
          .where((salesentry) =>
              // salesentry.companyCode == companyCode!.first &&
              salesentry.party == widget.selectedLedger.id &&
              (DateFormat('d/M/y')
                      .parse(salesentry.date)
                      .isAfter(widget.startDate!) ||
                  DateFormat('d/M/y').parse(salesentry.date) ==
                      widget.startDate!) &&
              (DateFormat('d/M/y')
                      .parse(salesentry.date)
                      .isBefore(widget.endDate!) ||
                  DateFormat('d/M/y').parse(salesentry.date) ==
                      widget.endDate!))
          .toList();
      double totalAmountSumSales = filteredSalesEntry.fold(
          0, (sum, item) => sum + double.parse(item.totalamount));
      print('filteredSalesEntry $filteredSalesEntry');

      final filteredReceiptEntry = receipt
          .where((receiptentry) =>
              // receiptentry.companyCode == companyCode!.first &&
              receiptentry.entries.first.ledger == widget.selectedLedger.id &&
              (DateFormat('d/M/y')
                      .parse(receiptentry.date)
                      .isAfter(widget.startDate!) ||
                  DateFormat('d/M/y').parse(receiptentry.date) ==
                      widget.startDate!) &&
              (DateFormat('d/M/y')
                      .parse(receiptentry.date)
                      .isBefore(widget.endDate!) ||
                  DateFormat('d/M/y').parse(receiptentry.date) ==
                      widget.endDate!))
          .toList();
      double totalAmountSumReceipt = filteredReceiptEntry.fold(
          0,
          (sum, item) =>
              sum + double.parse((item.totalamount).toStringAsFixed(2)));
      print('filteredReceiptEntry $filteredReceiptEntry');

      final filteredPurchase = purchase
          .where((purchaseentry) =>
              // purchaseentry.companyCode == companyCode!.first &&
              purchaseentry.ledger == widget.selectedLedger.id &&
              (DateFormat('d/M/y')
                      .parse(purchaseentry.date)
                      .isAfter(widget.startDate!) ||
                  DateFormat('d/M/y').parse(purchaseentry.date) ==
                      widget.startDate!) &&
              (DateFormat('d/M/y')
                      .parse(purchaseentry.date)
                      .isBefore(widget.endDate!) ||
                  DateFormat('d/M/y').parse(purchaseentry.date) ==
                      widget.endDate!))
          .toList();
      double totalAmountSumPurchase = filteredPurchase.fold(
          0, (sum, item) => sum + double.parse(item.totalamount));

      final filteredPayment = payment
          .where((paymenteentry) =>
              // paymenteentry.companyCode == companyCode!.first &&
              paymenteentry.entries.first.ledger == widget.selectedLedger.id &&
              (DateFormat('d/M/y')
                      .parse(paymenteentry.date)
                      .isAfter(widget.startDate!) ||
                  DateFormat('d/M/y').parse(paymenteentry.date) ==
                      widget.startDate!) &&
              (DateFormat('d/M/y')
                      .parse(paymenteentry.date)
                      .isBefore(widget.endDate!) ||
                  DateFormat('d/M/y').parse(paymenteentry.date) ==
                      widget.endDate!))
          .toList();
      double totalAmountSumPayment = filteredPayment.fold(
          0,
          (sum, item) =>
              sum + double.parse((item.totalamount).toStringAsFixed(2)));

      combinedData = [
        ...filteredSalesEntry,
        ...filteredReceiptEntry,
        ...filteredPurchase,
        ...filteredPayment
      ];
      combinedData.sort((a, b) => a.date.compareTo(b.date));
      print('combinedData $combinedData');
      setState(() {
        suggestionSales = filteredSalesEntry;
        suggestionPurchase = filteredPurchase;
        this.totalAmountSumSales = totalAmountSumSales;
        this.totalAmountSumReceipt = totalAmountSumReceipt;
        this.totalAmountSumPurchase = totalAmountSumPurchase;
        this.totalAmountSumPayment = totalAmountSumPayment;
        totalDebit = totalAmountSumSales + totalAmountSumPayment;
        totalCredit = totalAmountSumPurchase + totalAmountSumReceipt;
        totalBalance = totalDebit - totalCredit;
        displayedBalance = totalBalance.abs();
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

  Future<void> _initliazeData() async {
    // await setCompanyCode();
    await fetchSalesAndPurchase();
  }

  @override
  void initState() {
    super.initState();
    _initliazeData();
    balance = widget.selectedLedger.openingBalance;

    print(widget.selectedLedger.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ledger Statement',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 33, 65, 243),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Ledger: ${widget.selectedLedger.name}',
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 555,
                    decoration: BoxDecoration(border: Border.all()),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Table(
                            columnWidths: const {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(4),
                              2: FlexColumnWidth(4),
                              3: FlexColumnWidth(4),
                              4: FlexColumnWidth(4),
                              5: FlexColumnWidth(4),
                              6: FlexColumnWidth(4),
                            },
                            border: TableBorder.all(color: Colors.black),
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Text(
                                      "Date",
                                      style: GoogleFonts.poppins(
                                        color: Colors.deepPurple,
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
                                        color: Colors.deepPurple,
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
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  TableCell(
                                    child: Text(
                                      "No/Ref",
                                      style: GoogleFonts.poppins(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  TableCell(
                                    child: Text(
                                      "Debit",
                                      style: GoogleFonts.poppins(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  TableCell(
                                    child: Text(
                                      "Credit",
                                      style: GoogleFonts.poppins(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  TableCell(
                                    child: Text(
                                      "Balance",
                                      style: GoogleFonts.poppins(
                                        color: Colors.deepPurple,
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
                          Table(
                            border: TableBorder.all(),
                            columnWidths: const {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(4),
                              2: FlexColumnWidth(4),
                              3: FlexColumnWidth(4),
                              4: FlexColumnWidth(4),
                              5: FlexColumnWidth(4),
                              6: FlexColumnWidth(4),
                            },
                            children: [
                              TableRow(
                                children: [
                                  const TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Text(
                                        '',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Text(
                                        'Opening Balance',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  const TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Text(
                                        '',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Text(
                                        '',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Text(
                                        '',
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                  const TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Text(
                                        '',
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        (widget.selectedLedger.openingBalance)
                                            .toStringAsFixed(2),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 500,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              itemCount: combinedData.length,
                              itemBuilder: (BuildContext context, int index) {
                                dynamic item = combinedData[index];
                                String date = '';
                                String particulars = '';
                                String type = '';
                                String noRef = '';
                                double debit = 0.0;
                                double credit = 0.0;

                                // Check the type of entry and update values accordingly
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

                                return InkWell(
                                  onTap: () {
                                    // Navigate to edit screen if needed
                                  },
                                  child: Table(
                                    border: TableBorder.all(),
                                    columnWidths: const {
                                      0: FlexColumnWidth(2),
                                      1: FlexColumnWidth(4),
                                      2: FlexColumnWidth(4),
                                      3: FlexColumnWidth(4),
                                      4: FlexColumnWidth(4),
                                      5: FlexColumnWidth(4),
                                      6: FlexColumnWidth(4),
                                    },
                                    children: [
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(date,
                                                  textAlign: TextAlign.center),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(particulars),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(type,
                                                  textAlign: TextAlign.center),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(noRef,
                                                  textAlign: TextAlign.center),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                debit == 0
                                                    ? ''
                                                    : debit.toStringAsFixed(2),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                credit == 0
                                                    ? ''
                                                    : credit.toStringAsFixed(2),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                balance
                                                    .abs()
                                                    .toStringAsFixed(2),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(4),
                      2: FlexColumnWidth(4),
                      3: FlexColumnWidth(4),
                      4: FlexColumnWidth(4),
                      5: FlexColumnWidth(4),
                      6: FlexColumnWidth(4),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                'Total (${combinedData.length})',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(''),
                            ),
                          ),
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(
                                '',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(
                                '',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                totalDebit.toStringAsFixed(2),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                totalCredit.toStringAsFixed(2),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                displayedBalance.toStringAsFixed(2),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                height: 700,
                child: Column(
                  children: [
                    CustomList(Skey: "F2", name: "Report", onTap: () {}),
                    CustomList(
                        Skey: "P",
                        name: "Print",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LedgerStatmentPrint(
                                id: widget.selectedLedger,
                                '',
                                startDate: widget.startDate,
                                endDate: widget.endDate,
                                combinedData: combinedData,
                                totalAmountSumSales: totalAmountSumSales,
                                totalAmountSumReceipt: totalAmountSumReceipt,
                                totalAmountSumPurchase: totalAmountSumPurchase,
                                totalAmountSumPayment: totalAmountSumPayment,
                              ),
                            ),
                          );
                        }),
                    CustomList(Skey: "V", name: "AdvView", onTap: () {}),
                    CustomList(Skey: "", name: "", onTap: () {}),
                    CustomList(Skey: "X", name: "Export-Excel", onTap: () {}),
                    CustomList(
                        Skey: "Q",
                        name: "Quick Entry",
                        onTap: () {
                          if (widget.selectedLedger.ledgerGroup ==
                              '662f97d2a07ec73369c237b0') {
                            openDialog1(context);
                          } else {
                            openDialog2(context);
                          }
                        }),
                    CustomList(Skey: "E", name: "Edit Ledger", onTap: () {}),
                    CustomList(Skey: "Z", name: "Prnt Vchers", onTap: () {}),
                    CustomList(Skey: "M", name: "Monthly", onTap: () {}),
                    CustomList(Skey: "D", name: "ConDensed", onTap: () {}),
                    CustomList(Skey: "T", name: "Show Stock", onTap: () {}),
                    CustomList(Skey: "N", name: "Neg. Bal.", onTap: () {}),
                    CustomList(Skey: "D", name: "Del. Vchers", onTap: () {}),
                    CustomList(Skey: "B", name: "Bal. Conf.", onTap: () {}),
                    CustomList(Skey: "", name: "", onTap: () {}),
                    CustomList(Skey: "F3", name: "Find", onTap: () {}),
                    CustomList(Skey: "F3", name: "Find Next", onTap: () {}),
                    CustomList(Skey: "U", name: "Summary", onTap: () {}),
                    CustomList(Skey: "", name: "", onTap: () {}),
                    CustomList(Skey: "M", name: "MultiPrint", onTap: () {}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openDialog1(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => QuickEntryPayment(
        lid: widget.selectedLedger,
        amount: displayedBalance,
        startDate: widget.startDate,
        endDate: widget.endDate,
      ),
    );
  }

  void openDialog2(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => QuickEntryReceipt(
        lid: widget.selectedLedger,
        amount: displayedBalance,
        startDate: widget.startDate,
        endDate: widget.endDate,
      ),
    );
  }
}
