import 'package:billingsphere/data/models/purchase/purchase_model.dart';
import 'package:billingsphere/data/models/user/user_group_model.dart';
import 'package:billingsphere/data/repository/ledger_repository.dart';
import 'package:billingsphere/data/repository/user_group_repository.dart';
import 'package:billingsphere/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/ledger/ledger_model.dart';
import '../../data/repository/purchase_repository.dart';
import '../SE_responsive/SE_master.dart';
import '../SE_responsive/SE_receipt_2.dart';
import 'PE_desktop_body.dart';
import 'PE_edit_desktop_body.dart';
import 'PE_receipt_print.dart';

class PEMasterBody extends StatefulWidget {
  const PEMasterBody({super.key});

  @override
  State<PEMasterBody> createState() => _PEMasterBodyState();
}

class _PEMasterBodyState extends State<PEMasterBody> {
  late SharedPreferences _prefs;

  PurchaseServices purchaseServices = PurchaseServices();
  LedgerService ledgerService = LedgerService();
  List<Purchase> fetchedPurchase = [];
  List<Purchase> fetchedPurchase2 = [];
  String? selectedId;
  bool isLoading = false;
  int? activeIndex;
  String? activeid;
  String? userGroup = '';
  UserGroupServices userGroupServices = UserGroupServices();
  int index = 0;
  bool isChecked = false;
  List<UserGroup> userGroupM = [];
  List<Ledger> fetchedLedger = [];
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
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

  Future<void> fetchPurchaseEntries() async {
    setState(() {
      isLoading = true;
    });
    try {
      final List<Purchase> purchase = await purchaseServices.getPurchase();

      setState(() {
        fetchedPurchase = purchase;
        fetchedPurchase2 = purchase;
        if (fetchedPurchase.isNotEmpty) {
          selectedId = fetchedPurchase[0].id;
        }
        isLoading = false;
      });
    } catch (error) {
      print('Failed to fetch purchase name: $error');
    }
  }

  Future<void> fetchUserGroup() async {
    final List<UserGroup> userGroupFetch =
        await userGroupServices.getUserGroups();

    setState(() {
      userGroupM = userGroupFetch;
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

  void _initializeData() async {
    try {
      setState(() {
        isLoading = true;
      });

      await Future.wait([
        _initPrefs().then((value) => {
              userGroup = _prefs.getString('usergroup'),
            }),
        fetchUserGroup().then((value) => {}),
        fetchPurchaseEntries(),
        fetchLedger(),
      ]);
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handleTap(int index) {
    setState(() {
      activeIndex = index;
    });
  }

  // TextEditingConntrollers
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

  // FocusNodes
  final FocusNode _dateFocusNode = FocusNode();
  final FocusNode _noFocusNode = FocusNode();
  final FocusNode _typeFocusNode = FocusNode();
  final FocusNode _printFocusNode = FocusNode();
  final FocusNode _refNoFocusNode = FocusNode();
  final FocusNode _refNo2FocusNode = FocusNode();
  final FocusNode _particularsFocusNode = FocusNode();
  final FocusNode _remarksFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();

  // Search Functionality for each cell
  // For Date
  void searchDate(String value) {
    setState(() {
      fetchedPurchase = fetchedPurchase2
          .where(
              (sales) => sales.date.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  // For No
  void searchNo(String value) {
    setState(() {
      fetchedPurchase = fetchedPurchase2
          .where((sales) =>
              sales.billNumber.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  // For Type
  void searchType(String value) {
    setState(() {
      fetchedPurchase = fetchedPurchase2
          .where(
              (sales) => sales.type.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  // For Print
  void searchPrint(String value) {
    setState(() {
      fetchedPurchase = fetchedPurchase2
          .where(
              (sales) => sales.id.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  // For RefNo
  void searchRefNo(String value) {
    setState(() {
      fetchedPurchase = fetchedPurchase2
          .where((sales) =>
              sales.billNumber.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void searchParticulars(String value) {
    setState(() {
      // Get the ledger name from the fetchedLedger list
      fetchedPurchase = fetchedPurchase2.where((sales) {
        final ledger =
            fetchedLedger.firstWhere((ledger) => ledger.id == sales.ledger,
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
      fetchedPurchase = fetchedPurchase2
          .where((sales) =>
              sales.remarks.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void searchAmount(String value) {
    setState(() {
      fetchedPurchase = fetchedPurchase2
          .where((sales) =>
              sales.totalamount.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (mounted) {
      FocusScope.of(context).requestFocus(_dateFocusNode);
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  // dispose
  @override
  void dispose() {
    _dateSearchController.dispose();
    _noSearchController.dispose();
    _typeSearchController.dispose();
    _printSearchController.dispose();
    _refNoSearchController.dispose();
    _refNo2SearchController.dispose();
    _particularsSearchController.dispose();
    _remarksSearchController.dispose();
    _amountSearchController.dispose();

    // Dispose all the focus nodes
    _dateFocusNode.dispose();
    _noFocusNode.dispose();
    _typeFocusNode.dispose();
    _printFocusNode.dispose();
    _refNoFocusNode.dispose();
    _refNo2FocusNode.dispose();
    _particularsFocusNode.dispose();
    _remarksFocusNode.dispose();
    _amountFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'List of Retail Purchase Vouchers',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 232, 159, 132),
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
        body: isLoading
            ? Center(
                child: Constants.loadingIndicator,
              )
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      '${fetchedPurchase.length} Records',
                                      style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromARGB(
                                              255, 0, 24, 43)),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        children: [
                                          // CheckBox and then text for 'Auto Refresh'
                                          Checkbox(
                                            value: isChecked,
                                            fillColor:
                                                MaterialStateProperty.all(
                                                    const Color.fromARGB(
                                                        255, 0, 24, 43)),
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
                                      )),
                                ],
                              ),
                            ),
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
                                    TableCell(
                                      child: Text(
                                        "Date",
                                        style: GoogleFonts.poppins(
                                          color: const Color.fromARGB(
                                              255, 0, 36, 66),
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
                                          color: const Color.fromARGB(
                                              255, 0, 36, 66),
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
                                          color: const Color.fromARGB(
                                              255, 0, 36, 66),
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
                                          color: const Color.fromARGB(
                                              255, 0, 36, 66),
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
                                          color: const Color.fromARGB(
                                              255, 0, 36, 66),
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
                                          color: const Color.fromARGB(
                                              255, 0, 36, 66),
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
                                          color: const Color.fromARGB(
                                              255, 0, 36, 66),
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
                                          color: const Color.fromARGB(
                                              255, 0, 36, 66),
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
                                          color: const Color.fromARGB(
                                              255, 0, 36, 66),
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
                                      searchController:
                                          _remarksSearchController,
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
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.60,
                              child: SingleChildScrollView(
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
                                      border: const TableBorder.symmetric(
                                        inside: BorderSide(color: Colors.black),
                                        outside:
                                            BorderSide(color: Colors.black),
                                      ),
                                      children: [
                                        // Iterate over fetchedPurchase list and display each sales entry
                                        for (int i = 0;
                                            i < fetchedPurchase.length;
                                            i++)
                                          TableRow(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedId =
                                                        fetchedPurchase[i].id;
                                                    index = i;
                                                  });
                                                },
                                                onDoubleTap: () {
                                                  print('Double Tapped');
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PurchaseEditD(
                                                        data: fetchedPurchase[i]
                                                            .id,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  color: selectedId ==
                                                          fetchedPurchase[i].id
                                                      ? Colors.blue[500]
                                                      : Colors.white,
                                                  child: Text(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fetchedPurchase[i].date,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: selectedId ==
                                                              fetchedPurchase[i]
                                                                  .id
                                                          ? Colors.white
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
                                                        fetchedPurchase[i].id;
                                                    index = i;
                                                  });
                                                },
                                                onDoubleTap: () {
                                                  print('Double Tapped');
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PurchaseEditD(
                                                        data: fetchedPurchase[i]
                                                            .id,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  color: selectedId ==
                                                          fetchedPurchase[i].id
                                                      ? Colors.blue[500]
                                                      : Colors.white,
                                                  child: Text(
                                                    fetchedPurchase[i]
                                                        .billNumber,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: selectedId ==
                                                              fetchedPurchase[i]
                                                                  .id
                                                          ? Colors.white
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
                                                        fetchedPurchase[i].id;
                                                    index = i;
                                                  });
                                                },
                                                onDoubleTap: () {
                                                  print('Double Tapped');
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PurchaseEditD(
                                                        data: fetchedPurchase[i]
                                                            .id,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  color: selectedId ==
                                                          fetchedPurchase[i].id
                                                      ? Colors.blue[500]
                                                      : Colors.white,
                                                  child: Text(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fetchedPurchase[i].type,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: selectedId ==
                                                              fetchedPurchase[i]
                                                                  .id
                                                          ? Colors.white
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
                                                        fetchedPurchase[i].id;
                                                    index = i;
                                                  });
                                                },
                                                onDoubleTap: () {
                                                  print('Double Tapped');
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PurchaseEditD(
                                                        data: fetchedPurchase[i]
                                                            .id,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  color: selectedId ==
                                                          fetchedPurchase[i].id
                                                      ? Colors.blue[500]
                                                      : Colors.white,
                                                  child: Text(
                                                    '0',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: selectedId ==
                                                              fetchedPurchase[i]
                                                                  .id
                                                          ? Colors.white
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
                                                        fetchedPurchase[i].id;
                                                    index = i;
                                                  });
                                                },
                                                onDoubleTap: () {
                                                  print('Double Tapped');
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PurchaseEditD(
                                                        data: fetchedPurchase[i]
                                                            .id,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  color: selectedId ==
                                                          fetchedPurchase[i].id
                                                      ? Colors.blue[500]
                                                      : Colors.white,
                                                  child: Text(
                                                    fetchedPurchase[i]
                                                        .billNumber,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: selectedId ==
                                                              fetchedPurchase[i]
                                                                  .id
                                                          ? Colors.white
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
                                                        fetchedPurchase[i].id;
                                                    index = i;
                                                  });
                                                },
                                                onDoubleTap: () {
                                                  print('Double Tapped');
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PurchaseEditD(
                                                        data: fetchedPurchase[i]
                                                            .id,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  color: selectedId ==
                                                          fetchedPurchase[i].id
                                                      ? Colors.blue[500]
                                                      : Colors.white,
                                                  child: Text(
                                                    fetchedPurchase[i]
                                                        .billNumber,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: selectedId ==
                                                              fetchedPurchase[i]
                                                                  .id
                                                          ? Colors.white
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
                                                        fetchedPurchase[i].id;
                                                    index = i;
                                                  });
                                                },
                                                onDoubleTap: () {
                                                  print('Double Tapped');
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PurchaseEditD(
                                                        data: fetchedPurchase[i]
                                                            .id,
                                                      ),
                                                    ),
                                                  );
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
                                                          fetchedPurchase[i].id
                                                      ? Colors.blue[500]
                                                      : Colors.white,
                                                  child: fetchedLedger
                                                          .isNotEmpty
                                                      ? Text(
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fetchedLedger
                                                              .firstWhere((ledger) =>
                                                                  ledger.id ==
                                                                  fetchedPurchase[
                                                                          i]
                                                                      .ledger)
                                                              .name,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: selectedId ==
                                                                    fetchedPurchase[
                                                                            i]
                                                                        .id
                                                                ? Colors.white
                                                                : Colors.black,
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
                                                        fetchedPurchase[i].id;
                                                    index = i;
                                                  });
                                                },
                                                onDoubleTap: () {
                                                  print('Double Tapped');
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PurchaseEditD(
                                                        data: fetchedPurchase[i]
                                                            .id,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  color: selectedId ==
                                                          fetchedPurchase[i].id
                                                      ? Colors.blue[500]
                                                      : Colors.white,
                                                  child: Text(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fetchedPurchase[i].remarks,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: selectedId ==
                                                              fetchedPurchase[i]
                                                                  .id
                                                          ? Colors.white
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
                                                        fetchedPurchase[i].id;
                                                    index = i;
                                                  });
                                                },
                                                onDoubleTap: () {
                                                  print('Double Tapped');
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PurchaseEditD(
                                                        data: fetchedPurchase[i]
                                                            .id,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  color: selectedId ==
                                                          fetchedPurchase[i].id
                                                      ? Colors.blue[500]
                                                      : Colors.white,
                                                  child: Text(
                                                    fetchedPurchase[i]
                                                        .totalamount,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: selectedId ==
                                                              fetchedPurchase[i]
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
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 0.0),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                const PEMyDesktopBody(),
                                          ),
                                        );
                                      },
                                    ),
                                    Visibility(
                                      visible: (userGroup == "Admin" ||
                                          userGroup == "Owner"),
                                      child: BottomButtons(
                                        title: 'Edit',
                                        subtitle: 'F3',
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PurchaseEditD(
                                                data: fetchedPurchase[index].id,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
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
                                        // I need to get the items from the sales screen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PurchasePrintBigReceipt(
                                              purchaseID:
                                                  fetchedPurchase[index].id,
                                              'Print Receipt',
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const BottomButtons(
                                      title: 'Prn (Range)',
                                      subtitle: 'R',
                                    ),
                                    StatefulBuilder(
                                      builder: (context, setState) {
                                        return Visibility(
                                          visible: (userGroup == "Admin" ||
                                              userGroup == "Owner"),
                                          child: BottomButtons(
                                            title: 'DEL(Range)',
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Delete Sales'),
                                                    content: const Text(
                                                        'Are you sure you want to delete this sales?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text('No'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {},
                                                        child:
                                                            const Text('Yes'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
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
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

// class List1 extends StatelessWidget {
//   final String? name;
//   final String? Skey;
//   final Function onPressed;
//   const List1({Key? key, this.name, this.Skey, required this.onPressed});

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
//               top: BorderSide(width: 2, color: Color(0xFF00C853)),
//               right: BorderSide(width: 2, color: Color(0xFF00C853)),
//               left: BorderSide(width: 2, color: Color(0xFF00C853)),
//               bottom: BorderSide(width: 2, color: Color(0xFF00C853)),
//             ),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 5),
//                     child: Text(
//                       Skey ?? "",
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: Text(
//                     name ?? " ",
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       color: Color(0xFF00C853),
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
