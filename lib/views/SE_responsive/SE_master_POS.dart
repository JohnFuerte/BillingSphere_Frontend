import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/salesPos/sales_pos_model.dart';
import '../../data/repository/ledger_repository.dart';
import '../../data/repository/sales_pos_repository.dart';
import 'SE_desktop_body_POS.dart';
import 'SE_master.dart';
import 'SE_pos_receipt.dart';
import 'SE_pos_receipt_halfPage.dart';
import 'SE_pos_receipt_notA4.dart';
import 'Sales_pos_edit_screen.dart';

class PosMaster extends StatefulWidget {
  const PosMaster({
    super.key,
    required this.fetchedLedger,
  });

  final List<Ledger> fetchedLedger;

  @override
  State<PosMaster> createState() => _PosMasterState();
}

class _PosMasterState extends State<PosMaster> {
  SalesPosRepository salesPosRepository = SalesPosRepository();
  LedgerService ledgerService = LedgerService();
  List<SalesPos> fetchedSalesPos = [];
  List<SalesPos> fetchedSalesPos2 = [];

  Future<void> fetchSalesPos() async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedSalesPos = await salesPosRepository.fetchSalesPos();
      setState(() {
        this.fetchedSalesPos = fetchedSalesPos;
        fetchedSalesPos2 = fetchedSalesPos;
        selectedId = fetchedSalesPos[0].id;
      });
      print(fetchedSalesPos.length);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Controllers for search fields
  final TextEditingController _dateSearchController = TextEditingController();
  final TextEditingController _noSearchController = TextEditingController();
  final TextEditingController _typeSearchController = TextEditingController();
  final TextEditingController _printSearchController = TextEditingController();
  final TextEditingController _refNoSearchController = TextEditingController();
  final TextEditingController _refNo2SearchController = TextEditingController();
  final TextEditingController _particularsSearchController =
      TextEditingController();
  final TextEditingController _remarksSearchController =
      TextEditingController();
  final TextEditingController _amountSearchController = TextEditingController();
  final TextEditingController _sManSearchController = TextEditingController();

  // FocusNodes for search fields
  final FocusNode _dateFocusNode = FocusNode();
  final FocusNode _noFocusNode = FocusNode();
  final FocusNode _typeFocusNode = FocusNode();
  final FocusNode _printFocusNode = FocusNode();
  final FocusNode _refNoFocusNode = FocusNode();
  final FocusNode _refNo2FocusNode = FocusNode();
  final FocusNode _particularsFocusNode = FocusNode();
  final FocusNode _remarksFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _sManFocusNode = FocusNode();

  // Variables to store selected id and index
  String selectedId = '';
  int index = 0;
  bool isLoading = false;

  // For Date
  void searchDate(String value) {
    setState(() {
      fetchedSalesPos = fetchedSalesPos2
          .where(
              (sales) => sales.date.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  // For No
  void searchNo(String value) {
    setState(() {
      fetchedSalesPos = fetchedSalesPos2
          .where((sales) =>
              sales.no.toString().toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  // For Type
  void searchType(String value) {
    setState(() {
      fetchedSalesPos = fetchedSalesPos2
          .where(
              (sales) => sales.type.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  // For Print
  void searchPrint(String value) {
    setState(() {
      fetchedSalesPos = fetchedSalesPos2
          .where(
              (sales) => sales.id.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  // For RefNo
  void searchRefNo(String value) {
    setState(() {
      fetchedSalesPos = fetchedSalesPos2
          .where((sales) =>
              sales.no.toString().toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  // For Particulars
  void searchParticulars(String value) {
    setState(() {
      // Get the ledger name from the fetchedLedger list
      fetchedSalesPos = fetchedSalesPos2.where((sales) {
        final ledger =
            widget.fetchedLedger.firstWhere((ledger) => ledger.id == sales.ac,
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

  // For Remarks
  void searchRemarks(String value) {
    setState(() {
      fetchedSalesPos = fetchedSalesPos2
          .where((sales) =>
              sales.remarks!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  // For Amount
  void searchAmount(String value) {
    setState(() {
      fetchedSalesPos = fetchedSalesPos2
          .where((sales) => sales.totalAmount
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  initState() {
    super.initState();
    fetchSalesPos();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.escape): const ActivateIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (ActivateIntent intent) {
              Navigator.of(context).pop();
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFF008000),
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
                          'List of Tax INVOICE Voucher',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Table(
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                            4: FlexColumnWidth(1),
                            5: FlexColumnWidth(1),
                            6: FlexColumnWidth(3),
                            7: FlexColumnWidth(2),
                            8: FlexColumnWidth(1),
                            9: FlexColumnWidth(1),
                          },
                          border: TableBorder.all(color: Colors.black),
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Text(
                                    "Date",
                                    style: GoogleFonts.poppins(
                                      color:
                                          const Color.fromARGB(255, 0, 36, 66),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    "No",
                                    style: GoogleFonts.poppins(
                                      color:
                                          const Color.fromARGB(255, 0, 36, 66),
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
                                      color:
                                          const Color.fromARGB(255, 0, 36, 66),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    "Print",
                                    style: GoogleFonts.poppins(
                                      color:
                                          const Color.fromARGB(255, 0, 36, 66),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    "RefNo",
                                    style: GoogleFonts.poppins(
                                      color:
                                          const Color.fromARGB(255, 0, 36, 66),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    "RefNo2",
                                    style: GoogleFonts.poppins(
                                      color:
                                          const Color.fromARGB(255, 0, 36, 66),
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
                                      color:
                                          const Color.fromARGB(255, 0, 36, 66),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    "Remarks",
                                    style: GoogleFonts.poppins(
                                      color:
                                          const Color.fromARGB(255, 0, 36, 66),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    "Amount",
                                    style: GoogleFonts.poppins(
                                      color:
                                          const Color.fromARGB(255, 0, 36, 66),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    "S. Man",
                                    style: GoogleFonts.poppins(
                                      color:
                                          const Color.fromARGB(255, 0, 36, 66),
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
                        const SizedBox(height: 10),
                        Table(
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                            4: FlexColumnWidth(1),
                            5: FlexColumnWidth(1),
                            6: FlexColumnWidth(3),
                            7: FlexColumnWidth(2),
                            8: FlexColumnWidth(1),
                          },
                          border: TableBorder.all(color: Colors.black),
                          children: [
                            TableRow(
                              children: [
                                SearchCell(
                                  searchController: _dateSearchController,
                                  onChanged: searchDate,
                                  // focusNode: _dateFocusNode,
                                ),
                                SearchCell(
                                  searchController: _noSearchController,
                                  onChanged: searchNo,
                                  // focusNode: _noFocusNode,
                                ),
                                SearchCell(
                                  searchController: _typeSearchController,
                                  onChanged: searchType,
                                  // focusNode: _typeFocusNode,
                                ),
                                SearchCell(
                                  searchController: _printSearchController,
                                  onChanged: searchPrint,
                                  // focusNode: _printFocusNode,
                                ),
                                SearchCell(
                                  searchController: _refNoSearchController,
                                  onChanged: searchRefNo,
                                  // focusNode: _refNoFocusNode,
                                ),
                                SearchCell(
                                  searchController: _refNo2SearchController,
                                  onChanged: searchRefNo,
                                  // focusNode: _refNo2FocusNode,
                                ),
                                SearchCell(
                                  searchController:
                                      _particularsSearchController,
                                  textAlign: TextAlign.start,
                                  onChanged: searchParticulars,
                                  // focusNode: _particularsFocusNode,
                                ),
                                SearchCell(
                                  searchController: _remarksSearchController,
                                  textAlign: TextAlign.start,
                                  onChanged: searchRemarks,
                                  // focusNode: _remarksFocusNode,
                                ),
                                SearchCell(
                                  searchController: _amountSearchController,
                                  textAlign: TextAlign.end,
                                  onChanged: searchAmount,
                                  // focusNode: _amountFocusNode,
                                ),
                                SearchCell(
                                  searchController: _sManSearchController,
                                  textAlign: TextAlign.center,
                                  onChanged: (p0) {},
                                  // focusNode: _sManFocusNode,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.60,
                          child: isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF008000),
                                    ),
                                  ),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      Table(
                                        columnWidths: const {
                                          0: FlexColumnWidth(1),
                                          1: FlexColumnWidth(1),
                                          2: FlexColumnWidth(1),
                                          3: FlexColumnWidth(1),
                                          4: FlexColumnWidth(1),
                                          5: FlexColumnWidth(1),
                                          6: FlexColumnWidth(3),
                                          7: FlexColumnWidth(2),
                                          8: FlexColumnWidth(1),
                                        },
                                        border: TableBorder.symmetric(
                                          inside:
                                              BorderSide(color: Colors.black),
                                          outside:
                                              BorderSide(color: Colors.black),
                                        ),
                                        children: [
                                          // Iterate over fetchedSalesPos list and display each sales entry
                                          for (int i = 0;
                                              i < fetchedSalesPos.length;
                                              i++)
                                            TableRow(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedId =
                                                          fetchedSalesPos[i].id;
                                                      index = i;
                                                    });
                                                  },
                                                  onDoubleTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SalesPosEditScreen(
                                                          salesPos:
                                                              fetchedSalesPos[
                                                                  i],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.20,
                                                    color: selectedId ==
                                                            fetchedSalesPos[i]
                                                                .id
                                                        ? Colors.blue[500]
                                                        : Colors.white,
                                                    child: Text(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fetchedSalesPos[i].date,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: selectedId ==
                                                                fetchedSalesPos[
                                                                        i]
                                                                    .id
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedId =
                                                          fetchedSalesPos[i].id;
                                                      index = i;
                                                    });
                                                  },
                                                  onDoubleTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SalesPosEditScreen(
                                                          salesPos:
                                                              fetchedSalesPos[
                                                                  i],
                                                        ),
                                                      ),
                                                    );
                                                    print('Double Tapped');
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    color: selectedId ==
                                                            fetchedSalesPos[i]
                                                                .id
                                                        ? Colors.blue[500]
                                                        : Colors.white,
                                                    child: Text(
                                                      fetchedSalesPos[i]
                                                          .no
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: selectedId ==
                                                                fetchedSalesPos[
                                                                        i]
                                                                    .id
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedId =
                                                          fetchedSalesPos[i].id;
                                                      index = i;
                                                    });
                                                  },
                                                  onDoubleTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SalesPosEditScreen(
                                                          salesPos:
                                                              fetchedSalesPos[
                                                                  i],
                                                        ),
                                                      ),
                                                    );
                                                    print('Double Tapped');
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.20,
                                                    color: selectedId ==
                                                            fetchedSalesPos[i]
                                                                .id
                                                        ? Colors.blue[500]
                                                        : Colors.white,
                                                    child: Text(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fetchedSalesPos[i].type,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: selectedId ==
                                                                fetchedSalesPos[
                                                                        i]
                                                                    .id
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedId =
                                                          fetchedSalesPos[i].id;
                                                      index = i;
                                                    });
                                                  },
                                                  onDoubleTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SalesPosEditScreen(
                                                          salesPos:
                                                              fetchedSalesPos[
                                                                  i],
                                                        ),
                                                      ),
                                                    );
                                                    print('Double Tapped');
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    color: selectedId ==
                                                            fetchedSalesPos[i]
                                                                .id
                                                        ? Colors.blue[500]
                                                        : Colors.white,
                                                    child: Text(
                                                      '0',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: selectedId ==
                                                                fetchedSalesPos[
                                                                        i]
                                                                    .id
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedId =
                                                          fetchedSalesPos[i].id;
                                                      index = i;
                                                    });
                                                  },
                                                  onDoubleTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SalesPosEditScreen(
                                                          salesPos:
                                                              fetchedSalesPos[
                                                                  i],
                                                        ),
                                                      ),
                                                    );
                                                    print('Double Tapped');
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    color: selectedId ==
                                                            fetchedSalesPos[i]
                                                                .id
                                                        ? Colors.blue[500]
                                                        : Colors.white,
                                                    child: Text(
                                                      fetchedSalesPos[i]
                                                          .no
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: selectedId ==
                                                                fetchedSalesPos[
                                                                        i]
                                                                    .id
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedId =
                                                          fetchedSalesPos[i].id;
                                                      index = i;
                                                    });
                                                  },
                                                  onDoubleTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SalesPosEditScreen(
                                                          salesPos:
                                                              fetchedSalesPos[
                                                                  i],
                                                        ),
                                                      ),
                                                    );
                                                    print('Double Tapped');
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    color: selectedId ==
                                                            fetchedSalesPos[i]
                                                                .id
                                                        ? Colors.blue[500]
                                                        : Colors.white,
                                                    child: Text(
                                                      fetchedSalesPos[i]
                                                          .no
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: selectedId ==
                                                                fetchedSalesPos[
                                                                        i]
                                                                    .id
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedId =
                                                          fetchedSalesPos[i].id;
                                                      index = i;
                                                    });
                                                  },
                                                  onDoubleTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SalesPosEditScreen(
                                                          salesPos:
                                                              fetchedSalesPos[
                                                                  i],
                                                        ),
                                                      ),
                                                    );
                                                    print('Double Tapped');
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    // width
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.20,
                                                    color: selectedId ==
                                                            fetchedSalesPos[i]
                                                                .id
                                                        ? Colors.blue[500]
                                                        : Colors.white,
                                                    child: widget.fetchedLedger
                                                            .isNotEmpty
                                                        ? Text(
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            widget.fetchedLedger
                                                                .firstWhere((ledger) =>
                                                                    ledger.id ==
                                                                    fetchedSalesPos[
                                                                            i]
                                                                        .ac)
                                                                .name,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: selectedId ==
                                                                      fetchedSalesPos[
                                                                              i]
                                                                          .id
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                            textAlign:
                                                                TextAlign.start,
                                                          )
                                                        : const Text('No Data'),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedId =
                                                          fetchedSalesPos[i].id;
                                                      index = i;
                                                    });
                                                  },
                                                  onDoubleTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SalesPosEditScreen(
                                                          salesPos:
                                                              fetchedSalesPos[
                                                                  i],
                                                        ),
                                                      ),
                                                    );
                                                    print('Double Tapped');
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.20,
                                                    color: selectedId ==
                                                            fetchedSalesPos[i]
                                                                .id
                                                        ? Colors.blue[500]
                                                        : Colors.white,
                                                    child: Text(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fetchedSalesPos[i]
                                                          .remarks!,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: selectedId ==
                                                                fetchedSalesPos[
                                                                        i]
                                                                    .id
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedId =
                                                          fetchedSalesPos[i].id;
                                                      index = i;
                                                    });
                                                  },
                                                  onDoubleTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SalesPosEditScreen(
                                                          salesPos:
                                                              fetchedSalesPos[
                                                                  i],
                                                        ),
                                                      ),
                                                    );
                                                    print('Double Tapped');
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    color: selectedId ==
                                                            fetchedSalesPos[i]
                                                                .id
                                                        ? Colors.blue[500]
                                                        : Colors.white,
                                                    child: Text(
                                                      fetchedSalesPos[i]
                                                          .totalAmount
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: selectedId ==
                                                                fetchedSalesPos[
                                                                        i]
                                                                    .id
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                      textAlign: TextAlign.end,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedId =
                                                          fetchedSalesPos[i].id;
                                                      index = i;
                                                    });
                                                  },
                                                  onDoubleTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SalesPosEditScreen(
                                                          salesPos:
                                                              fetchedSalesPos[
                                                                  i],
                                                        ),
                                                      ),
                                                    );
                                                    print('Double Tapped');
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    color: selectedId ==
                                                            fetchedSalesPos[i]
                                                                .id
                                                        ? Colors.blue[500]
                                                        : Colors.white,
                                                    child: Text(
                                                      fetchedSalesPos[i]
                                                          .totalAmount
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: selectedId ==
                                                                fetchedSalesPos[
                                                                        i]
                                                                    .id
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                      textAlign: TextAlign.end,
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
                        // Bottom Buttons..
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
                                            const SalesReturn(),
                                      ),
                                    );
                                  },
                                ),
                                BottomButtons(
                                  title: 'Edit',
                                  subtitle: 'F3',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SalesPosEditScreen(
                                          salesPos: fetchedSalesPos[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                BottomButtons(
                                  title: 'XLS',
                                  subtitle: 'X',
                                  onPressed: () {
                                    // exportToExcel();
                                  },
                                ),
                                BottomButtons(
                                  title: 'Print',
                                  subtitle: 'P',
                                  onPressed: () {
                                    showImageDialog(context);
                                    // I need to get the items from the sales screen
                                  },
                                ),
                                const BottomButtons(
                                  title: 'Prn (Range)',
                                  subtitle: 'R',
                                ),
                                StatefulBuilder(
                                  builder: (context, setState) {
                                    return BottomButtons(
                                      title: 'DEL(Range)',
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Delete Sales'),
                                              content: const Text(
                                                  'Are you sure you want to delete this sales?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('No'),
                                                ),
                                                TextButton(
                                                  onPressed: () {},
                                                  child: const Text('Yes'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                                const BottomButtons(
                                  title: 'Email/SMS',
                                  subtitle: 'E',
                                ),
                                const BottomButtons(),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          alignment: Alignment.center,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SELECT PRINTER TYPE',
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // Align images
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SePosReceiptNota4(
                                sales: fetchedSalesPos[index],
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/pos.jpg', // Left image
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                              // Text
                              Text(
                                'POS',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SALESPOSReceipt(
                                sales: fetchedSalesPos[index],
                                ledger: widget.fetchedLedger.firstWhere(
                                    (ledger) =>
                                        ledger.id == fetchedSalesPos[index].ac),
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/a4.jpg', // Right image
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                'A4',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SALESPOSReceiptHalfPage(
                                sales: fetchedSalesPos[index],
                                ledger: widget.fetchedLedger.firstWhere(
                                    (ledger) =>
                                        ledger.id == fetchedSalesPos[index].ac),
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/a3.jpg', // Right image
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                'HALF PAGE',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )
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
        );
      },
    );
  }
}
