import 'package:billingsphere/data/models/payment/payment_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/ledger/ledger_model.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/payment_respository.dart';
import 'payment_desktop.dart';
import 'payment_receipt2.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class PaymentHome extends StatefulWidget {
  const PaymentHome({super.key});

  @override
  State<PaymentHome> createState() => _PaymentHomeState();
}

class _PaymentHomeState extends State<PaymentHome> {
  void _initializeData() async {
    await fetchPayments();
    await fetchLedger();
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
    _horizontalControllersGroup = LinkedScrollControllerGroup();
    _horizontalController1 = _horizontalControllersGroup.addAndGet();
    _horizontalController2 = _horizontalControllersGroup.addAndGet();
    _horizontalController3 = _horizontalControllersGroup.addAndGet();
  }

  // dispose
  @override
  void dispose() {
    _dateSearchController.dispose();
    _vchNoSearchController.dispose();
    _particularsSearchController.dispose();
    _amountSearchController.dispose();
    _horizontalController1.dispose();
    _horizontalController2.dispose();
    _horizontalController3.dispose();

    super.dispose();
  }

  List<Payment> fetchedPayments = [];
  List<Payment> fetchedPayments2 = [];
  List<Ledger> fetchedLedger = [];

  PaymentService paymentService = PaymentService();
  LedgerService ledgerService = LedgerService();
  String? selectedId;
  bool isLoading = false;
  bool isChecked = false;
  int index = 0;

  final TextEditingController _dateSearchController = TextEditingController();
  final TextEditingController _vchNoSearchController = TextEditingController();
  final TextEditingController _particularsSearchController =
      TextEditingController();
  final TextEditingController _amountSearchController = TextEditingController();
  late ScrollController _horizontalController1;
  late ScrollController _horizontalController2;
  late ScrollController _horizontalController3;
  late LinkedScrollControllerGroup _horizontalControllersGroup;

  Future<void> fetchPayments() async {
    final List<Payment> payments = await paymentService.fetchPayments();

    setState(() {
      fetchedPayments = payments;
      fetchedPayments2 = payments;

      if (fetchedPayments.isNotEmpty) {
        selectedId = fetchedPayments[0].id;
      }
    });
  }

  // Fetch Ledger
  Future<void> fetchLedger() async {
    try {
      final List<Ledger> ledger = await ledgerService.fetchLedgers();
      setState(() {
        fetchedLedger = ledger;
      });
    } catch (error) {
      print('Failed to fetch ledger name: $error');
    }
  }

  void searchDate(String value) {
    setState(() {
      fetchedPayments = fetchedPayments2
          .where((receipt) =>
              receipt.date.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void searchVchNo(String value) {
    setState(() {
      fetchedPayments = fetchedPayments2
          .where((receipt) => receipt.no.toString().contains(value))
          .toList();
    });
  }

  void searchParticulars(String value) {
    setState(() {
      // Get the ledger name from the fetchedLedger list
      fetchedPayments = fetchedPayments2.where((receipt) {
        final ledger = fetchedLedger.firstWhere(
            (ledger) => ledger.id == receipt.entries.first.ledger,
            orElse: () => Ledger(
                  id: '',
                  name: '',
                  ledgerGroup: '',
                  printName: '',
                  aliasName: '',
                  date: '',
                  bilwiseAccounting: '',
                  creditDays: 0,
                  openingBalance: 0,
                  debitBalance: 0,
                  ledgerType: '',
                  priceListCategory: '',
                  remarks: '',
                  status: '',
                  ledgerCode: 0,
                  mailingName: '',
                  address: '',
                  city: '',
                  region: '',
                  state: '',
                  pincode: 0,
                  tel: 0,
                  fax: 0,
                  mobile: 0,
                  sms: 0,
                  email: '',
                  contactPerson: '',
                  bankName: '',
                  branchName: '',
                  ifsc: '',
                  accName: '',
                  accNo: '',
                  panNo: '',
                  gst: '',
                  gstDated: '',
                  cstNo: '',
                  cstDated: '',
                  lstNo: '',
                  lstDated: '',
                  serviceTaxNo: '',
                  serviceTaxDated: '',
                  registrationType: '',
                  registrationTypeDated: '',
                ));
        return ledger.name.toLowerCase().contains(value.toLowerCase());
      }).toList();
    });
  }

  void searchAmount(String value) {
    setState(() {
      fetchedPayments = fetchedPayments2
          .where((receipt) => receipt.totalamount.toString().contains(value))
          .toList();
    });
  }

  String getLedgerName(String ledgerName) {
    for (var ledger in fetchedLedger) {
      if (ledger.id == ledgerName) {
        return ledger.name.toString();
      }
    }
    return '';
  }

  Future<void> deletePayment(String id) async {
    try {
      await paymentService.deletePayment(id, context);
      await fetchPayments();
    } catch (error) {
      print('Failed to delete payment: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          return _buildTabletWidget();
        } else if (constraints.maxWidth >= 600 && constraints.maxWidth < 1200) {
          return _buildTabletWidget();
        } else {
          return _buildDesktopWidget();
        }
      },
    );
  }

  Widget _buildTabletWidget() {
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xffB8860B),
              ),
            ),
          )
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(35.0),
              child: AppBar(
                title: Text(
                  'List of Payment Voucher',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xffB8860B),
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
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(),
                          const Spacer(),
                          Text(
                            '${fetchedPayments.length} Records',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF4B0082)),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                fillColor:
                                    MaterialStateProperty.all(Colors.black),
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                              ),
                              const Text(
                                'Auto Refresh Mode',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _horizontalController1,
                            child: Table(
                              columnWidths: const {
                                0: FixedColumnWidth(200),
                                1: FixedColumnWidth(200),
                                2: FixedColumnWidth(400),
                                3: FixedColumnWidth(200),
                              },
                              border: TableBorder.all(color: Colors.black),
                              children: [
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Container(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          "Date",
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF4B0082),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          "Vch. No",
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF4B0082),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          "Particulars",
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF4B0082),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          "Amount",
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF4B0082),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _horizontalController2,
                            child: Table(
                              columnWidths: const {
                                0: FixedColumnWidth(200),
                                1: FixedColumnWidth(200),
                                2: FixedColumnWidth(400),
                                3: FixedColumnWidth(200),
                              },
                              border: TableBorder.all(color: Colors.black),
                              children: [
                                TableRow(
                                  children: [
                                    SearchCell(
                                        searchController: _dateSearchController,
                                        onChanged: searchDate),
                                    SearchCell(
                                        searchController:
                                            _vchNoSearchController,
                                        onChanged: searchVchNo),
                                    SearchCell(
                                      searchController:
                                          _particularsSearchController,
                                      onChanged: searchParticulars,
                                      textAlign: TextAlign.left,
                                    ),
                                    SearchCell(
                                      searchController: _amountSearchController,
                                      onChanged: searchAmount,
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            // decoration: BoxDecoration(border: Border.all()),
                            height: 700,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    controller: _horizontalController3,
                                    child: Table(
                                      columnWidths: const {
                                        0: FixedColumnWidth(200),
                                        1: FixedColumnWidth(200),
                                        2: FixedColumnWidth(400),
                                        3: FixedColumnWidth(200),
                                      },
                                      border: const TableBorder.symmetric(
                                        inside: BorderSide(color: Colors.black),
                                        outside:
                                            BorderSide(color: Colors.black),
                                      ),
                                      children: [
                                        // Iterate over fetchedSales list and display each sales entry
                                        for (int i = 0;
                                            i < fetchedPayments.length;
                                            i++)
                                          TableRow(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedId =
                                                        fetchedPayments[i].id;
                                                    index = i;
                                                  });
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  color: selectedId ==
                                                          fetchedPayments[i].id
                                                      ? const Color(0xFF4169E1)
                                                      : Colors.white,
                                                  child: Text(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fetchedPayments[i].date,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: selectedId ==
                                                              fetchedPayments[i]
                                                                  .id
                                                          ? const Color(
                                                              0xFFFEFC08)
                                                          : Colors.black,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedId =
                                                        fetchedPayments[i].id;
                                                    index = i;
                                                  });
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  color: selectedId ==
                                                          fetchedPayments[i].id
                                                      ? const Color(0xFF4169E1)
                                                      : Colors.white,
                                                  child: Text(
                                                    fetchedPayments[i]
                                                        .no
                                                        .toString(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: selectedId ==
                                                              fetchedPayments[i]
                                                                  .id
                                                          ? const Color(
                                                              0xFFFEFC08)
                                                          : Colors.black,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedId =
                                                        fetchedPayments[i].id;
                                                    index = i;
                                                  });
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  // width
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  color: selectedId ==
                                                          fetchedPayments[i].id
                                                      ? const Color(0xFF4169E1)
                                                      : Colors.white,
                                                  child: Text(
                                                    maxLines: 1,
                                                    getLedgerName(
                                                        fetchedPayments[i]
                                                            .entries
                                                            .first
                                                            .ledger),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: selectedId ==
                                                              fetchedPayments[i]
                                                                  .id
                                                          ? const Color(
                                                              0xFFFEFC08)
                                                          : Colors.black,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedId =
                                                        fetchedPayments[i].id;
                                                    index = i;
                                                  });
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  color: selectedId ==
                                                          fetchedPayments[i].id
                                                      ? const Color(0xFF4169E1)
                                                      : Colors.white,
                                                  child: Text(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fetchedPayments[i]
                                                        .totalamount
                                                        .toStringAsFixed(2),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: selectedId ==
                                                              fetchedPayments[i]
                                                                  .id
                                                          ? const Color(
                                                              0xFFFEFC08)
                                                          : Colors.black,
                                                    ),
                                                    textAlign: TextAlign.right,
                                                  ),
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
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0),
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const BottomButtonMobile(
                              icon: CupertinoIcons.list_dash,
                            ),
                            BottomButtonMobile(
                              icon: CupertinoIcons.add,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PMMyPaymentDesktopBody(),
                                  ),
                                );
                              },
                            ),
                            const BottomButtonMobile(
                              icon: CupertinoIcons.pencil,
                            ),
                            const BottomButtonMobile(
                              icon: CupertinoIcons.square_on_square,
                            ),
                            BottomButtonMobile(
                              icon: CupertinoIcons.printer,
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PaymentVoucherPrint(
                                      'Print Payment Voucher',
                                      receiptID: fetchedPayments[index].id,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const BottomButtonMobile(
                              icon: CupertinoIcons.doc,
                            ),
                            const BottomButtonMobile(
                              icon: CupertinoIcons.trash,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildDesktopWidget() {
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xffB8860B),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'List of Payment Voucher',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xffB8860B),
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
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      // height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(),
                          const Spacer(),
                          Text(
                            '${fetchedPayments.length} Records',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF4B0082)),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                fillColor:
                                    MaterialStateProperty.all(Colors.black),
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                              ),
                              const Text(
                                'Auto Refresh Mode',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Table(
                            columnWidths: const {
                              0: FlexColumnWidth(1),
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(4),
                              3: FlexColumnWidth(1),
                            },
                            border: TableBorder.all(color: Colors.black),
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Container(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        "Date",
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF4B0082),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        "Vch. No",
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF4B0082),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        "Particulars",
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF4B0082),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        "Amount",
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF4B0082),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Table(
                            columnWidths: const {
                              0: FlexColumnWidth(1),
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(4),
                              3: FlexColumnWidth(1),
                            },
                            border: TableBorder.all(color: Colors.black),
                            children: [
                              TableRow(
                                children: [
                                  SearchCell(
                                      searchController: _dateSearchController,
                                      onChanged: searchDate),
                                  SearchCell(
                                      searchController: _vchNoSearchController,
                                      onChanged: searchVchNo),
                                  SearchCell(
                                    searchController:
                                        _particularsSearchController,
                                    onChanged: searchParticulars,
                                    textAlign: TextAlign.left,
                                  ),
                                  SearchCell(
                                    searchController: _amountSearchController,
                                    onChanged: searchAmount,
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(border: Border.all()),
                            height: 700,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  Table(
                                    columnWidths: const {
                                      0: FlexColumnWidth(1),
                                      1: FlexColumnWidth(1),
                                      2: FlexColumnWidth(4),
                                      3: FlexColumnWidth(1),
                                    },
                                    border: const TableBorder.symmetric(
                                      inside: BorderSide(color: Colors.black),
                                      outside: BorderSide(color: Colors.black),
                                    ),
                                    children: [
                                      // Iterate over fetchedSales list and display each sales entry
                                      for (int i = 0;
                                          i < fetchedPayments.length;
                                          i++)
                                        TableRow(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedId =
                                                      fetchedPayments[i].id;
                                                  index = i;
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.20,
                                                color: selectedId ==
                                                        fetchedPayments[i].id
                                                    ? const Color(0xFF4169E1)
                                                    : Colors.white,
                                                child: Text(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fetchedPayments[i].date,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: selectedId ==
                                                            fetchedPayments[i]
                                                                .id
                                                        ? const Color(
                                                            0xFFFEFC08)
                                                        : Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedId =
                                                      fetchedPayments[i].id;
                                                  index = i;
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                color: selectedId ==
                                                        fetchedPayments[i].id
                                                    ? const Color(0xFF4169E1)
                                                    : Colors.white,
                                                child: Text(
                                                  fetchedPayments[i]
                                                      .no
                                                      .toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: selectedId ==
                                                            fetchedPayments[i]
                                                                .id
                                                        ? const Color(
                                                            0xFFFEFC08)
                                                        : Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedId =
                                                      fetchedPayments[i].id;
                                                  index = i;
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                // width
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.20,
                                                color: selectedId ==
                                                        fetchedPayments[i].id
                                                    ? const Color(0xFF4169E1)
                                                    : Colors.white,
                                                child: Text(
                                                  maxLines: 1,
                                                  getLedgerName(
                                                      fetchedPayments[i]
                                                          .entries
                                                          .first
                                                          .ledger),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: selectedId ==
                                                            fetchedPayments[i]
                                                                .id
                                                        ? const Color(
                                                            0xFFFEFC08)
                                                        : Colors.black,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedId =
                                                      fetchedPayments[i].id;
                                                  index = i;
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.20,
                                                color: selectedId ==
                                                        fetchedPayments[i].id
                                                    ? const Color(0xFF4169E1)
                                                    : Colors.white,
                                                child: Text(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fetchedPayments[i]
                                                      .totalamount
                                                      .toStringAsFixed(2),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: selectedId ==
                                                            fetchedPayments[i]
                                                                .id
                                                        ? const Color(
                                                            0xFFFEFC08)
                                                        : Colors.black,
                                                  ),
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
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color.fromARGB(255, 0, 24, 43),
                            width: 3,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const BottomButtons(),
                            const BottomButtons(
                              title: 'List Prn',
                              subtitle: 'L',
                            ),
                            BottomButtons(
                              title: 'New',
                              subtitle: 'F2',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PMMyPaymentDesktopBody(),
                                  ),
                                );
                              },
                            ),
                            BottomButtons(
                              title: 'Edit',
                              subtitle: 'F3',
                              onPressed: () {},
                            ),
                            BottomButtons(
                              title: 'XLS',
                              subtitle: 'X',
                              onPressed: () {},
                            ),
                            BottomButtons(
                              title: 'Print',
                              subtitle: 'P',
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PaymentVoucherPrint(
                                      'Print Payment Voucher',
                                      receiptID: fetchedPayments[index].id,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const BottomButtons(
                              title: 'Prn (Range)',
                              subtitle: 'R',
                            ),
                            const BottomButtons(
                              title: 'DEL(Range)',
                            ),
                            const BottomButtons(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}

class SearchCell extends StatelessWidget {
  const SearchCell({
    super.key,
    required TextEditingController searchController,
    this.textAlign,
    this.onChanged,
  }) : _searchController = searchController;

  final TextEditingController _searchController;
  final TextAlign? textAlign;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: TextField(
        textAlign: textAlign ?? TextAlign.center,
        cursorColor: Colors.black,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        controller: _searchController,
        onChanged: onChanged,
        decoration: const InputDecoration(
          fillColor: Color(0xFFDB7093),
          filled: true,
          hintText: 'Search Here',
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(0),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomButtons extends StatelessWidget {
  const BottomButtons({
    super.key,
    this.title,
    this.subtitle,
    this.onPressed,
  });

  final String? title;
  final String? subtitle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: InkWell(
        onTap: onPressed,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                subtitle ?? '',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  color: Colors.red,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Color.fromARGB(255, 0, 24, 43),
                    width: 3,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  title ?? '',
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF4B0082)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomButtonMobile extends StatelessWidget {
  const BottomButtonMobile({
    super.key,
    this.onPressed,
    this.icon,
  });

  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color.fromARGB(255, 0, 24, 43),
            width: 1,
          ),
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon ?? Icons.add,
            color: const Color(0xFF4B0082),
            size: 20,
          ),
        ),
      ),
    );
  }
}
